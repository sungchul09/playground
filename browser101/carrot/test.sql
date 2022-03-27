CREATE PROCEDURE [dbo].[SP_JOB_COMPLETE] @V_RESULT int OUTPUT,
@V_ERRMSG varchar(max) OUTPUT AS BEGIN DECLARE @L_LOADID varchar(12),
@L_STATUS VARCHAR(10),
@L_LOMXCNT varchar(4),
@L_LOMXID varchar(14),
@L_SERIAL varchar(4) BEGIN TRY
SET
    @V_RESULT = NULL
SET
    @V_ERRMSG = NULL
SET
    @V_ERRMSG = '0' DECLARE @MOVE_REC$MV_SERIAL varchar(max),
    @MOVE_REC$MV_LOADID varchar(max),
    @MOVE_REC$MV_FRSTTN varchar(max),
    @MOVE_REC$MV_TOSTTN varchar(max),
    @MOVE_REC$MV_SAISLE varchar(max),
    @MOVE_REC$MV_LOCATN varchar(max),
    @MOVE_REC$MV_WRKTYP varchar(max),
    @MOVE_REC$MV_JOBTYP varchar(max),
    @MOVE_REC$MV_ORDTYP varchar(max),
    @MOVE_REC$MV_STATUS varchar(max),
    --@MOVE_REC$LD_ENGCOD varchar(max), 
    @MOVE_REC$LD_SERIAL varchar(max),
    @MOVE_REC$LD_LOADST varchar(max),
    @MOVE_REC$LD_BCRCOD varchar(max),
    --@MOVE_REC$LD_PLTID varchar(max), 
    --@MOVE_REC$LD_PNAME varchar(max), 
    @MOVE_REC$LD_MATNR varchar(max),
    @MOVE_REC$LD_PDTQTY varchar(max),
    @MOVE_REC$LD_LOCATN varchar(max),
    @MOVE_REC$LD_PLTID varchar(max) DECLARE DB_IMPLICIT_CURSOR_FOR_MOVE_REC CURSOR LOCAL FORWARD_ONLY FOR
SELECT
    MV_SERIAL,
    MV_LOADID,
    MV_FRSTTN,
    MV_TOSTTN,
    MV_SAISLE,
    MV_LOCATN,
    MV_WRKTYP,
    MV_JOBTYP,
    MV_ORDTYP,
    MV_STATUS,
    --[LOAD].LD_ENGCOD, 
    [LOAD].LD_SERIAL,
    [LOAD].LD_LOADST,
    [LOAD].LD_PLTID --[LOAD].LD_BCRDAT, 
    --[LOAD].LD_PNAME, 
    --[LOAD].LD_MATNR, 
    --[LOAD].LD_PDTQTY,
    --[LOAD].LD_LOCATN
FROM
    dbo.[MOVE]
    LEFT OUTER JOIN dbo.[LOAD] ON MOVE.MV_LOADID = [LOAD].LD_LOADID
WHERE
    MOVE.MV_STATUS IN ('작업완료', '작업취소')
ORDER BY
    CASE
        WHEN MV_WRKTYP = '이동' THEN 1
        ELSE 2
    END ASC OPEN DB_IMPLICIT_CURSOR_FOR_MOVE_REC WHILE 1 = 1 BEGIN FETCH DB_IMPLICIT_CURSOR_FOR_MOVE_REC INTO @MOVE_REC$MV_SERIAL,
    @MOVE_REC$MV_LOADID,
    @MOVE_REC$MV_FRSTTN,
    @MOVE_REC$MV_TOSTTN,
    @MOVE_REC$MV_SAISLE,
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    @MOVE_REC$MV_JOBTYP,
    @MOVE_REC$MV_ORDTYP,
    @MOVE_REC$MV_STATUS,
    --@MOVE_REC$LD_ENGCOD, 
    @MOVE_REC$LD_SERIAL,
    @MOVE_REC$LD_LOADST,
    @MOVE_REC$LD_PLTID --@MOVE_REC$LD_PLTID  
    --@MOVE_REC$LD_BCRCOD, 
    --@MOVE_REC$LD_PNAME, 
    --@MOVE_REC$LD_MATNR,
    --@MOVE_REC$LD_PDTQTY,
    --@MOVE_REC$LD_LOCATN
    IF @ @FETCH_STATUS = -1 BREAK
SET
    @L_SERIAL = @MOVE_REC$MV_SERIAL
    /*
     *   -----------------------------------------------------------------------------------------------
     *   		  								작업완료 처리
     *   		 -----------------------------------------------------------------------------------------------
     */
    IF @MOVE_REC$MV_STATUS = '작업완료' IF @MOVE_REC$MV_WRKTYP IN ('입고', '재입') BEGIN
    /*
     *   **********************************************************************
     *   			 * 1. 입고실행작업을 삭제한다.
     *   			 * 2. 보관위치에 재고정보를 등록하고 상태를 '정상'으로 변경한다.
     *   			 * 3. 재고정보에 보관위치를 등록하고 상태를 '정상'으로 변경한다.
     *   **********************************************************************
     */
    DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL -- IF @MOVE_REC$MV_LOCATN IS NOT NULL
    IF (@MOVE_REC$MV_LOCATN IS NOT NULL)
    AND (@MOVE_REC$MV_LOCATN <> '') BEGIN
    /*비정상(Storedout 프로시저에서 mv_locatn은 null로 됨*/
UPDATE
    dbo.LOCN
SET
    LO_LOADID = @MOVE_REC$MV_LOADID,
    LO_STATUS = '정상',
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN
UPDATE
    dbo.[LOAD]
SET
    LD_SAISLE = @MOVE_REC$MV_SAISLE,
    LD_LOCATN = @MOVE_REC$MV_LOCATN,
    LD_STATUS = '정상'
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
SELECT
    @L_LOMXCNT = COUNT(*)
FROM
    LOMX
WHERE
    LX_LOADID = @MOVE_REC$MV_LOADID WHILE(0 < @L_LOMXCNT) BEGIN
SET
    @L_LOMXID = @MOVE_REC$MV_LOADID + RIGHT('00' + CAST(@L_LOMXCNT AS NVARCHAR), 2)
INSERT
    XLOG(
        XL_LOCATN,
        XL_WRKTYP,
        XL_STATUS,
        XL_LOADID,
        XL_LOMXID,
        XL_PDTCOD,
        XL_NUM,
        XL_PDTNAM,
        XL_SITENAME,
        XL_PDTQTY,
        XL_OUTDATE,
        XL_OAN,
        XL_KINDS,
        XL_X,
        XL_Y,
        XL_Z,
        XL_PATTERN,
        XL_XPOS,
        XL_YPOS,
        XL_PDTLOT,
        XL_PDTUNT,
        XL_SETDAT,
        XL_PDTPRJ,
        XL_XDIM,
        XL_WDIM,
        XL_FLOOR,
        XL_PRJNAM,
        XL_DDIM,
        XL_WEIGHT,
        XL_THICK,
        XL_ID,
        XL_QRCODE,
        XL_TYPE,
        XL_TAG_TYPE,
        XL_QR_NUM,
        XL_MATNR,
        XL_MATNR_NM,
        XL_SPEC,
        XL_ITEM_SIZE,
        XL_SERIAL,
        XL_POSID,
        XL_CONSNAM,
        XL_MENGE,
        XL_MATNR_ITN,
        XL_INST_DATE,
        XL_INVNR,
        XL_PLAN_NO,
        XL_PARTNER_COM,
        XL_INVITEM,
        XL_D_ID,
        XL_D_ID_DE,
        XL_D_ID_M,
        XL_D_TYPE,
        XL_D_TAG_TYPE,
        XL_D_QR_NUM,
        XL_D_QR_NUM_M,
        XL_D_CONSNAM,
        XL_D_POSID,
        XL_D_MATNR,
        XL_D_MATNR_NM,
        XL_D_SERIAL,
        XL_D_MENGE,
        XL_D_MATNR_ITN,
        XL_D_INST_DATE,
        XL_D_PARTNER_COM,
        XL_D_CRT_LIFNR,
        XL_CRT_LIFNR_NM,
        XL_D_SPEC,
        XL_D_ITEM_SIZE,
        XL_LOMXNUM
    )
SELECT
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    '작업완료',
    LX_LOADID,
    LX_LOMXID,
    LX_PDTCOD,
    LX_NUM,
    LX_PDTNAM,
    LX_SITENAME,
    LX_PDTQTY,
    LX_OUTDATE,
    LX_OAN,
    LX_KINDS,
    LX_X,
    LX_Y,
    LX_Z,
    LX_PATTERN,
    LX_XPOS,
    LX_YPOS,
    LX_PDTLOT,
    LX_PDTUNT,
    sysdatetime(),
    LX_PDTPRJ,
    LX_XDIM,
    LX_WDIM,
    LX_FLOOR,
    LX_PRJNAM,
    LX_DDIM,
    LX_WEIGHT,
    LX_THICK,
    LX_ID,
    LX_QRCODE,
    LX_TYPE,
    LX_TAG_TYPE,
    LX_QR_NUM,
    LX_MATNR,
    LX_MATNR_NM,
    LX_SPEC,
    LX_ITEM_SIZE,
    LX_SERIAL,
    LX_POSID,
    LX_CONSNAM,
    LX_MENGE,
    LX_MATNR_ITN,
    LX_INST_DATE,
    LX_INVNR,
    LX_PLAN_NO,
    LX_PARTNER_COM,
    LX_INVITEM,
    LX_D_ID,
    LX_D_ID_DE,
    LX_D_ID_M,
    LX_D_TYPE,
    LX_D_TAG_TYPE,
    LX_D_QR_NUM,
    LX_D_QR_NUM_M,
    LX_D_CONSNAM,
    LX_D_POSID,
    LX_D_MATNR,
    LX_D_MATNR_NM,
    LX_D_SERIAL,
    LX_D_MENGE,
    LX_D_MATNR_ITN,
    LX_D_INST_DATE,
    LX_D_PARTNER_COM,
    LX_D_CRT_LIFNR,
    LX_CRT_LIFNR_NM,
    LX_D_SPEC,
    LX_D_ITEM_SIZE,
    LX_LOMXNUM
FROM
    LOMX
WHERE
    [LOMX].LX_LOMXID = @L_LOMXID;

SET
    @L_LOMXCNT = @L_LOMXCNT -1;

END
END
ELSE BEGIN
SELECT
    @L_LOMXCNT = COUNT(*)
FROM
    LOMX
WHERE
    LX_LOADID = @MOVE_REC$MV_LOADID WHILE(0 < @L_LOMXCNT) BEGIN
SET
    @L_LOMXID = @MOVE_REC$MV_LOADID + RIGHT('00' + CAST(@L_LOMXCNT AS NVARCHAR), 2)
INSERT
    XLOG(
        XL_LOCATN,
        XL_WRKTYP,
        XL_STATUS,
        XL_LOADID,
        XL_LOMXID,
        XL_PDTCOD,
        XL_NUM,
        XL_PDTNAM,
        XL_SITENAME,
        XL_PDTQTY,
        XL_OUTDATE,
        XL_OAN,
        XL_KINDS,
        XL_X,
        XL_Y,
        XL_Z,
        XL_PATTERN,
        XL_XPOS,
        XL_YPOS,
        XL_PDTLOT,
        XL_PDTUNT,
        XL_SETDAT,
        XL_PDTPRJ,
        XL_XDIM,
        XL_WDIM,
        XL_FLOOR,
        XL_PRJNAM,
        XL_DDIM,
        XL_WEIGHT,
        XL_THICK,
        XL_ID,
        XL_QRCODE,
        XL_TYPE,
        XL_TAG_TYPE,
        XL_QR_NUM,
        XL_MATNR,
        XL_MATNR_NM,
        XL_SPEC,
        XL_ITEM_SIZE,
        XL_SERIAL,
        XL_POSID,
        XL_CONSNAM,
        XL_MENGE,
        XL_MATNR_ITN,
        XL_INST_DATE,
        XL_INVNR,
        XL_PLAN_NO,
        XL_PARTNER_COM,
        XL_INVITEM,
        XL_D_ID,
        XL_D_ID_DE,
        XL_D_ID_M,
        XL_D_TYPE,
        XL_D_TAG_TYPE,
        XL_D_QR_NUM,
        XL_D_QR_NUM_M,
        XL_D_CONSNAM,
        XL_D_POSID,
        XL_D_MATNR,
        XL_D_MATNR_NM,
        XL_D_SERIAL,
        XL_D_MENGE,
        XL_D_MATNR_ITN,
        XL_D_INST_DATE,
        XL_D_PARTNER_COM,
        XL_D_CRT_LIFNR,
        XL_CRT_LIFNR_NM,
        XL_D_SPEC,
        XL_D_ITEM_SIZE,
        XL_LOMXNUM
    )
SELECT
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    '작업완료',
    LX_LOADID,
    LX_LOMXID,
    LX_PDTCOD,
    LX_NUM,
    LX_PDTNAM,
    LX_SITENAME,
    LX_PDTQTY,
    LX_OUTDATE,
    LX_OAN,
    LX_KINDS,
    LX_X,
    LX_Y,
    LX_Z,
    LX_PATTERN,
    LX_XPOS,
    LX_YPOS,
    LX_PDTLOT,
    LX_PDTUNT,
    sysdatetime(),
    LX_PDTPRJ,
    LX_XDIM,
    LX_WDIM,
    LX_FLOOR,
    LX_PRJNAM,
    LX_DDIM,
    LX_WEIGHT,
    LX_THICK,
    LX_ID,
    LX_QRCODE,
    LX_TYPE,
    LX_TAG_TYPE,
    LX_QR_NUM,
    LX_MATNR,
    LX_MATNR_NM,
    LX_SPEC,
    LX_ITEM_SIZE,
    LX_SERIAL,
    LX_POSID,
    LX_CONSNAM,
    LX_MENGE,
    LX_MATNR_ITN,
    LX_INST_DATE,
    LX_INVNR,
    LX_PLAN_NO,
    LX_PARTNER_COM,
    LX_INVITEM,
    LX_D_ID,
    LX_D_ID_DE,
    LX_D_ID_M,
    LX_D_TYPE,
    LX_D_TAG_TYPE,
    LX_D_QR_NUM,
    LX_D_QR_NUM_M,
    LX_D_CONSNAM,
    LX_D_POSID,
    LX_D_MATNR,
    LX_D_MATNR_NM,
    LX_D_SERIAL,
    LX_D_MENGE,
    LX_D_MATNR_ITN,
    LX_D_INST_DATE,
    LX_D_PARTNER_COM,
    LX_D_CRT_LIFNR,
    LX_CRT_LIFNR_NM,
    LX_D_SPEC,
    LX_D_ITEM_SIZE,
    LX_LOMXNUM
FROM
    LOMX
WHERE
    [LOMX].LX_LOMXID = @L_LOMXID;

SET
    @L_LOMXCNT = @L_LOMXCNT -1;

END DELETE dbo.[LOMX]
WHERE
    [LOMX].LX_LOADID = @MOVE_REC$MV_LOADID DELETE dbo.[LOAD]
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
    /*정상 : LOCN은 이미 UPDA됬으므로 LOAD만 정리*/
END
END
ELSE IF @MOVE_REC$MV_WRKTYP IN ('이동') BEGIN
/*
 *   **********************************************************************
 *   			 * 1. 이동실행작업을 삭제한다.
 *   			 * 2. 보관위치에 재고정보를 수정한다.
 *   			 * 3. 재고정보에 보관위치를 수정한다.
 *   **********************************************************************
 */
DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL --재고정보의 보관위치 수정
UPDATE
    dbo.[LOAD]
SET
    LD_SAISLE = @MOVE_REC$MV_SAISLE,
    LD_LOCATN = @MOVE_REC$MV_LOCATN
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
SELECT
    @L_STATUS = LD_STATUS
FROM
    [LOAD]
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID --기존 보관위치의 재고정보 제거
UPDATE
    dbo.[LOCN]
SET
    LO_LOADID = NULL,
    LO_STATUS = '정상',
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$LD_LOCATN --변경 보관위치의 재고정보 추가
UPDATE
    dbo.[LOCN]
SET
    LO_LOADID = @MOVE_REC$MV_LOADID,
    LO_STATUS = @L_STATUS,
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN
END
ELSE IF @MOVE_REC$MV_WRKTYP IN ('출고') BEGIN
/*
 * **********************************************************************
 *   			 * 1. 출고실행작업을 삭제한다.
 *   			 * 2. 재고정보(LOAD)를 삭제한다.
 *   			 - LOAD에 LOADID 있는 경우, 없는 경우 처리.
 *   **********************************************************************
 */
DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL
UPDATE
    dbo.[LOCN]
SET
    LO_LOADID = NULL,
    LO_STATUS = '정상',
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN PRINT ISNULL(@MOVE_REC$MV_SAISLE, '') + ',' + ISNULL(@MOVE_REC$MV_LOCATN, '') + ':' + ISNULL(@MOVE_REC$MV_LOADID, '')
SELECT
    @L_LOMXCNT = COUNT(*)
FROM
    LOMX
WHERE
    LX_LOADID = @MOVE_REC$MV_LOADID WHILE(0 < @L_LOMXCNT) BEGIN
SET
    @L_LOMXID = @MOVE_REC$MV_LOADID + RIGHT('00' + CAST(@L_LOMXCNT AS NVARCHAR), 2)
INSERT
    XLOG(
        XL_LOCATN,
        XL_WRKTYP,
        XL_STATUS,
        XL_LOADID,
        XL_LOMXID,
        XL_PDTCOD,
        XL_NUM,
        XL_PDTNAM,
        XL_SITENAME,
        XL_PDTQTY,
        XL_OUTDATE,
        XL_OAN,
        XL_KINDS,
        XL_X,
        XL_Y,
        XL_Z,
        XL_PATTERN,
        XL_XPOS,
        XL_YPOS,
        XL_PDTLOT,
        XL_PDTUNT,
        XL_SETDAT,
        XL_PDTPRJ,
        XL_XDIM,
        XL_WDIM,
        XL_FLOOR,
        XL_PRJNAM,
        XL_DDIM,
        XL_WEIGHT,
        XL_THICK,
        XL_ID,
        XL_QRCODE,
        XL_TYPE,
        XL_TAG_TYPE,
        XL_QR_NUM,
        XL_MATNR,
        XL_MATNR_NM,
        XL_SPEC,
        XL_ITEM_SIZE,
        XL_SERIAL,
        XL_POSID,
        XL_CONSNAM,
        XL_MENGE,
        XL_MATNR_ITN,
        XL_INST_DATE,
        XL_INVNR,
        XL_PLAN_NO,
        XL_PARTNER_COM,
        XL_INVITEM,
        XL_D_ID,
        XL_D_ID_DE,
        XL_D_ID_M,
        XL_D_TYPE,
        XL_D_TAG_TYPE,
        XL_D_QR_NUM,
        XL_D_QR_NUM_M,
        XL_D_CONSNAM,
        XL_D_POSID,
        XL_D_MATNR,
        XL_D_MATNR_NM,
        XL_D_SERIAL,
        XL_D_MENGE,
        XL_D_MATNR_ITN,
        XL_D_INST_DATE,
        XL_D_PARTNER_COM,
        XL_D_CRT_LIFNR,
        XL_CRT_LIFNR_NM,
        XL_D_SPEC,
        XL_D_ITEM_SIZE,
        XL_LOMXNUM
    )
SELECT
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    '작업완료',
    LX_LOADID,
    LX_LOMXID,
    LX_PDTCOD,
    LX_NUM,
    LX_PDTNAM,
    LX_SITENAME,
    LX_PDTQTY,
    LX_OUTDATE,
    LX_OAN,
    LX_KINDS,
    LX_X,
    LX_Y,
    LX_Z,
    LX_PATTERN,
    LX_XPOS,
    LX_YPOS,
    LX_PDTLOT,
    LX_PDTUNT,
    sysdatetime(),
    LX_PDTPRJ,
    LX_XDIM,
    LX_WDIM,
    LX_FLOOR,
    LX_PRJNAM,
    LX_DDIM,
    LX_WEIGHT,
    LX_THICK,
    LX_ID,
    LX_QRCODE,
    LX_TYPE,
    LX_TAG_TYPE,
    LX_QR_NUM,
    LX_MATNR,
    LX_MATNR_NM,
    LX_SPEC,
    LX_ITEM_SIZE,
    LX_SERIAL,
    LX_POSID,
    LX_CONSNAM,
    LX_MENGE,
    LX_MATNR_ITN,
    LX_INST_DATE,
    LX_INVNR,
    LX_PLAN_NO,
    LX_PARTNER_COM,
    LX_INVITEM,
    LX_D_ID,
    LX_D_ID_DE,
    LX_D_ID_M,
    LX_D_TYPE,
    LX_D_TAG_TYPE,
    LX_D_QR_NUM,
    LX_D_QR_NUM_M,
    LX_D_CONSNAM,
    LX_D_POSID,
    LX_D_MATNR,
    LX_D_MATNR_NM,
    LX_D_SERIAL,
    LX_D_MENGE,
    LX_D_MATNR_ITN,
    LX_D_INST_DATE,
    LX_D_PARTNER_COM,
    LX_D_CRT_LIFNR,
    LX_CRT_LIFNR_NM,
    LX_D_SPEC,
    LX_D_ITEM_SIZE,
    LX_LOMXNUM
FROM
    LOMX
WHERE
    [LOMX].LX_LOMXID = @L_LOMXID;

SET
    @L_LOMXCNT = @L_LOMXCNT -1;

END IF @MOVE_REC$MV_LOADID IS NOT NULL
/*LOADID가 있을 때만 LOAD삭제(지정출고인경우 LOADID가 없을 수 도 있다.)*/
DELETE dbo.[LOMX]
WHERE
    [LOMX].LX_LOADID = @MOVE_REC$MV_LOADID DELETE dbo.[LOAD]
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID PRINT '5'
END
/*
 *   -----------------------------------------------------------------------------------------------
 *   		  								작업취소 처리
 *   -----------------------------------------------------------------------------------------------
 */
IF @MOVE_REC$MV_STATUS = '작업취소' IF @MOVE_REC$MV_WRKTYP IN ('입고', '재입') BEGIN
/*
 *   **********************************************************************
 *   			 * 1. 입고실행작업을 삭제한다.
 *   			 * 2. 보관위치가 등록되어 있으면 보관위치의 재고정보를 초기화하고, 상태를 재고'확인'으로 변경한다.
 *   			 * 3. 재고정보를 삭제한다.
 *   **********************************************************************
 */
DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL IF @MOVE_REC$MV_LOCATN IS NOT NULL
UPDATE
    dbo.LOCN
SET
    LO_LOADID = NULL,
    LO_STATUS = '확인',
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN
SELECT
    @L_LOMXCNT = COUNT(*)
FROM
    LOMX
WHERE
    LX_LOADID = @MOVE_REC$MV_LOADID WHILE(0 < @L_LOMXCNT) BEGIN
SET
    @L_LOMXID = @MOVE_REC$MV_LOADID + RIGHT('00' + CAST(@L_LOMXCNT AS NVARCHAR), 2)
INSERT
    XLOG(
        XL_LOCATN,
        XL_WRKTYP,
        XL_STATUS,
        XL_LOADID,
        XL_LOMXID,
        XL_PDTCOD,
        XL_NUM,
        XL_PDTNAM,
        XL_SITENAME,
        XL_PDTQTY,
        XL_OUTDATE,
        XL_OAN,
        XL_KINDS,
        XL_X,
        XL_Y,
        XL_Z,
        XL_PATTERN,
        XL_XPOS,
        XL_YPOS,
        XL_PDTLOT,
        XL_PDTUNT,
        XL_SETDAT,
        XL_PDTPRJ,
        XL_XDIM,
        XL_WDIM,
        XL_FLOOR,
        XL_PRJNAM,
        XL_DDIM,
        XL_WEIGHT,
        XL_THICK,
        XL_ID,
        XL_QRCODE,
        XL_TYPE,
        XL_TAG_TYPE,
        XL_QR_NUM,
        XL_MATNR,
        XL_MATNR_NM,
        XL_SPEC,
        XL_ITEM_SIZE,
        XL_SERIAL,
        XL_POSID,
        XL_CONSNAM,
        XL_MENGE,
        XL_MATNR_ITN,
        XL_INST_DATE,
        XL_INVNR,
        XL_PLAN_NO,
        XL_PARTNER_COM,
        XL_INVITEM,
        XL_D_ID,
        XL_D_ID_DE,
        XL_D_ID_M,
        XL_D_TYPE,
        XL_D_TAG_TYPE,
        XL_D_QR_NUM,
        XL_D_QR_NUM_M,
        XL_D_CONSNAM,
        XL_D_POSID,
        XL_D_MATNR,
        XL_D_MATNR_NM,
        XL_D_SERIAL,
        XL_D_MENGE,
        XL_D_MATNR_ITN,
        XL_D_INST_DATE,
        XL_D_PARTNER_COM,
        XL_D_CRT_LIFNR,
        XL_CRT_LIFNR_NM,
        XL_D_SPEC,
        XL_D_ITEM_SIZE,
        XL_LOMXNUM
    )
SELECT
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    '작업취소',
    LX_LOADID,
    LX_LOMXID,
    LX_PDTCOD,
    LX_NUM,
    LX_PDTNAM,
    LX_SITENAME,
    LX_PDTQTY,
    LX_OUTDATE,
    LX_OAN,
    LX_KINDS,
    LX_X,
    LX_Y,
    LX_Z,
    LX_PATTERN,
    LX_XPOS,
    LX_YPOS,
    LX_PDTLOT,
    LX_PDTUNT,
    sysdatetime(),
    LX_PDTPRJ,
    LX_XDIM,
    LX_WDIM,
    LX_FLOOR,
    LX_PRJNAM,
    LX_DDIM,
    LX_WEIGHT,
    LX_THICK,
    LX_ID,
    LX_QRCODE,
    LX_TYPE,
    LX_TAG_TYPE,
    LX_QR_NUM,
    LX_MATNR,
    LX_MATNR_NM,
    LX_SPEC,
    LX_ITEM_SIZE,
    LX_SERIAL,
    LX_POSID,
    LX_CONSNAM,
    LX_MENGE,
    LX_MATNR_ITN,
    LX_INST_DATE,
    LX_INVNR,
    LX_PLAN_NO,
    LX_PARTNER_COM,
    LX_INVITEM,
    LX_D_ID,
    LX_D_ID_DE,
    LX_D_ID_M,
    LX_D_TYPE,
    LX_D_TAG_TYPE,
    LX_D_QR_NUM,
    LX_D_QR_NUM_M,
    LX_D_CONSNAM,
    LX_D_POSID,
    LX_D_MATNR,
    LX_D_MATNR_NM,
    LX_D_SERIAL,
    LX_D_MENGE,
    LX_D_MATNR_ITN,
    LX_D_INST_DATE,
    LX_D_PARTNER_COM,
    LX_D_CRT_LIFNR,
    LX_CRT_LIFNR_NM,
    LX_D_SPEC,
    LX_D_ITEM_SIZE,
    LX_LOMXNUM
FROM
    LOMX
WHERE
    [LOMX].LX_LOMXID = @L_LOMXID;

SET
    @L_LOMXCNT = @L_LOMXCNT -1;

END IF @MOVE_REC$MV_LOADID IS NOT NULL DELETE dbo.[LOAD]
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
END
ELSE IF @MOVE_REC$MV_WRKTYP IN ('이동') BEGIN
/*
 *   **********************************************************************
 *   			 * 1. 이동실행작업을 삭제한다.
 *   **********************************************************************
 */
DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL
END
ELSE IF @MOVE_REC$MV_WRKTYP IN ('출고') BEGIN
/*
 *   **********************************************************************
 *   			 * 1. 출고실행작업을 삭제한다.
 *   			 * 2. 재고정보가 있고 보관위치의 재고정보와 같으면 보관위치의 상태를 재고'확인'으로 설정한다.
 *   			 *                                     같지 않으면 재고정보를 삭제한다.
 *   **********************************************************************
 */
DELETE dbo.[MOVE]
WHERE
    [MOVE].MV_SERIAL = @MOVE_REC$MV_SERIAL IF @MOVE_REC$MV_LOADID IS NOT NULL BEGIN
SELECT
    @L_LOADID = max(LOCN.LO_LOADID)
FROM
    dbo.[LOCN]
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN
    /* 출고지시된 재고위치의 LOADID와 출고작업 LOADID가 같으면 미출고된 것으로 처리한다.*/
    IF @MOVE_REC$MV_LOADID = @L_LOADID BEGIN
UPDATE
    dbo.LOCN
SET
    LO_STATUS = '정상',
    LO_SETDAT = sysdatetime()
WHERE
    LOCN.LO_SAISLE = @MOVE_REC$MV_SAISLE
    AND ISNULL(LOCN.LO_LOCROW, '') + ISNULL(LOCN.LO_LOCBAY, '') + ISNULL(LOCN.LO_LOCLEV, '') = @MOVE_REC$MV_LOCATN
UPDATE
    dbo.[LOAD]
SET
    LD_STATUS = '정상'
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
END
/* 출고지시된 재고위치의 LOADID와 출고작업 LOADID가 같지 않으면 출고된 것으로 처리한다.*/
ELSE
SELECT
    @L_LOMXCNT = COUNT(*)
FROM
    LOMX
WHERE
    LX_LOADID = @MOVE_REC$MV_LOADID WHILE(0 < @L_LOMXCNT) BEGIN
SET
    @L_LOMXID = @MOVE_REC$MV_LOADID + RIGHT('00' + CAST(@L_LOMXCNT AS NVARCHAR), 2)
INSERT
    XLOG(
        XL_LOCATN,
        XL_WRKTYP,
        XL_STATUS,
        XL_LOADID,
        XL_LOMXID,
        XL_PDTCOD,
        XL_NUM,
        XL_PDTNAM,
        XL_SITENAME,
        XL_PDTQTY,
        XL_OUTDATE,
        XL_OAN,
        XL_KINDS,
        XL_X,
        XL_Y,
        XL_Z,
        XL_PATTERN,
        XL_XPOS,
        XL_YPOS,
        XL_PDTLOT,
        XL_PDTUNT,
        XL_SETDAT,
        XL_PDTPRJ,
        XL_XDIM,
        XL_WDIM,
        XL_FLOOR,
        XL_PRJNAM,
        XL_DDIM,
        XL_WEIGHT,
        XL_THICK,
        XL_ID,
        XL_QRCODE,
        XL_TYPE,
        XL_TAG_TYPE,
        XL_QR_NUM,
        XL_MATNR,
        XL_MATNR_NM,
        XL_SPEC,
        XL_ITEM_SIZE,
        XL_SERIAL,
        XL_POSID,
        XL_CONSNAM,
        XL_MENGE,
        XL_MATNR_ITN,
        XL_INST_DATE,
        XL_INVNR,
        XL_PLAN_NO,
        XL_PARTNER_COM,
        XL_INVITEM,
        XL_D_ID,
        XL_D_ID_DE,
        XL_D_ID_M,
        XL_D_TYPE,
        XL_D_TAG_TYPE,
        XL_D_QR_NUM,
        XL_D_QR_NUM_M,
        XL_D_CONSNAM,
        XL_D_POSID,
        XL_D_MATNR,
        XL_D_MATNR_NM,
        XL_D_SERIAL,
        XL_D_MENGE,
        XL_D_MATNR_ITN,
        XL_D_INST_DATE,
        XL_D_PARTNER_COM,
        XL_D_CRT_LIFNR,
        XL_CRT_LIFNR_NM,
        XL_D_SPEC,
        XL_D_ITEM_SIZE,
        XL_LOMXNUM
    )
SELECT
    @MOVE_REC$MV_LOCATN,
    @MOVE_REC$MV_WRKTYP,
    '작업취소',
    LX_LOADID,
    LX_LOMXID,
    LX_PDTCOD,
    LX_NUM,
    LX_PDTNAM,
    LX_SITENAME,
    LX_PDTQTY,
    LX_OUTDATE,
    LX_OAN,
    LX_KINDS,
    LX_X,
    LX_Y,
    LX_Z,
    LX_PATTERN,
    LX_XPOS,
    LX_YPOS,
    LX_PDTLOT,
    LX_PDTUNT,
    sysdatetime(),
    LX_PDTPRJ,
    LX_XDIM,
    LX_WDIM,
    LX_FLOOR,
    LX_PRJNAM,
    LX_DDIM,
    LX_WEIGHT,
    LX_THICK,
    LX_ID,
    LX_QRCODE,
    LX_TYPE,
    LX_TAG_TYPE,
    LX_QR_NUM,
    LX_MATNR,
    LX_MATNR_NM,
    LX_SPEC,
    LX_ITEM_SIZE,
    LX_SERIAL,
    LX_POSID,
    LX_CONSNAM,
    LX_MENGE,
    LX_MATNR_ITN,
    LX_INST_DATE,
    LX_INVNR,
    LX_PLAN_NO,
    LX_PARTNER_COM,
    LX_INVITEM,
    LX_D_ID,
    LX_D_ID_DE,
    LX_D_ID_M,
    LX_D_TYPE,
    LX_D_TAG_TYPE,
    LX_D_QR_NUM,
    LX_D_QR_NUM_M,
    LX_D_CONSNAM,
    LX_D_POSID,
    LX_D_MATNR,
    LX_D_MATNR_NM,
    LX_D_SERIAL,
    LX_D_MENGE,
    LX_D_MATNR_ITN,
    LX_D_INST_DATE,
    LX_D_PARTNER_COM,
    LX_D_CRT_LIFNR,
    LX_CRT_LIFNR_NM,
    LX_D_SPEC,
    LX_D_ITEM_SIZE,
    LX_LOMXNUM
FROM
    LOMX
WHERE
    [LOMX].LX_LOMXID = @L_LOMXID;

SET
    @L_LOMXCNT = @L_LOMXCNT -1;

END DELETE dbo.[LOAD]
WHERE
    [LOAD].LD_LOADID = @MOVE_REC$MV_LOADID
END
END
/*
 *   -----------------------------------------------------------------------------------------------
 *   		  								실적생성
 *   		  					MV_ORDTYP 대신에 LD_LOADST를 INSERT한다. 임시로...
 *   -----------------------------------------------------------------------------------------------
 *   IF MOVE_REC.LD_ENGCOD <> '0000' THEN
 */
--IF @MOVE_REC$LD_BCRCOD <> '0000'
IF @MOVE_REC$LD_PLTID <> ''
INSERT
    dbo.HIST(
        --HT_LOADID, 
        --HT_ENGCOD, 
        --HT_ENGSER, 
        HT_SERIAL,
        HT_WRKTYP,
        HT_JOBTYP,
        HT_ORDTYP,
        HT_FRSTTN,
        HT_TOSTTN,
        HT_SAISLE,
        HT_LOCATN,
        HT_SETDAT,
        HT_REMARK,
        --HT_BCRDAT, 
        --HT_PNAME, 
        HT_MATNR,
        HT_PDTQTY
    )
VALUES
    (
        --@MOVE_REC$MV_LOADID, 
        --@MOVE_REC$LD_ENGCOD, 
        --@MOVE_REC$LD_SERIAL, 
        @MOVE_REC$MV_SERIAL,
        @MOVE_REC$MV_WRKTYP,
        @MOVE_REC$MV_JOBTYP,
        @MOVE_REC$LD_LOADST,
        @MOVE_REC$MV_FRSTTN,
        @MOVE_REC$MV_TOSTTN,
        @MOVE_REC$MV_SAISLE,
        @MOVE_REC$MV_LOCATN,
        sysdatetime(),
        @MOVE_REC$MV_STATUS,
        --@MOVE_REC$LD_BCRCOD, 
        --@MOVE_REC$LD_PNAME, 
        @MOVE_REC$LD_MATNR,
        @MOVE_REC$LD_PDTQTY
    ) IF @ @TRANCOUNT > 0 COMMIT TRANSACTION
END CLOSE DB_IMPLICIT_CURSOR_FOR_MOVE_REC DEALLOCATE DB_IMPLICIT_CURSOR_FOR_MOVE_REC
SET
    @V_RESULT = 0
END TRY BEGIN CATCH BEGIN
SET
    @V_RESULT = ERROR_NUMBER()
SET
    @V_ERRMSG = 'SP_JOB_COMPLETE> ' + ISNULL(ERROR_MESSAGE(), '') IF @ @TRANCOUNT > 0 ROLLBACK WORK
END
END CATCH
END