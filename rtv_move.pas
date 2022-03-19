{********************************************************************
    RTV 대기 작업
********************************************************************}
//One-G에서는 입/출고 공통
procedure TDModule.ar_request_rtv_move2(saisle : Integer);
var
    my_i, my_j, i, k: integer;
    feed_front, feed_back, feed_unuse_front, feed_unuse_back: integer;
    serial, frsttn, tosttn: integer;
    status, locatn, pltsiz, chkst, wrktyp : String;
    g_lstrtv: integer;
    
    rtcode : Integer;
    mySql, mySql2, mySql3, mySql4, moveSql, loadSql, moveerrmsg, loaderrmsg, rtmesg: string;

    saisleCnt, i, k, stkrsaisle, maxPltQty, maxPltQty3100 : Integer;
    saisleArr, saisleArr3100 : array [0..U_MAX_STK_DEV] of Integer;
    movqty  : array [0..U_MAX_STK_DEV] of Word;
    mvsaisle, mvstatus, sqlerrmsg : String;
begin
    tosttn := 0;

    feed_unuse_front := 1;
    feed_unuse_back := 2;
    feed_front := 3;
    feed_back := 4;

    loadid := '';
    saisle := '';
    status := '';
    wrktyp := '';
    ordtyp := '';
    frsttn := '';
    tosttn := '';
    jobtyp := '';
    chkst := '';

    // 1. RTV 적재 스테이션 로테이션 
    for my_i := 1 to U_RTV_IN_CNT do 
    begin

    // 2. 적재 요청 스테이션 체크        
        //같은 DOCK에서만 작업하지 않도록 순환 처리
        //g_lstrtvidx[saisle]: 마지막 작업한 적재 위치 idx
        //g_lstrtv: 마지막 작업한 적재 Sttnid
        Inc(g_lstrtvidx[saisle]);
        if g_lstrtvidx[saisle] > U_RTV_IN_CNT then g_lstrtvidx[saisle] := 1;
        g_lstrtv := rtvin_list[saisle, g_lstrtvidx[saisle]]; //sttnid
    
    // 3. RTV 적재 스테이션 화물, 작번 유무 체크    
        //RTV 적재 STTN에 엔진이 없거나 작업 번호가 미할당 이면 PASS
        if (g_lstrtv >= 1) and (g_lstrtv <= 5) then
            if not cs_exists(cs_dev_sttnno(g_lstrtv)) or (cs_serial(cs_dev_sttnno(g_lstrtv)) = 0)
            then continue
        else if (g_lstrtv >= 6) and (g_lstrtv =< 9) then
            if not cs_exist_salvagnini(g_lstrtv) or (cs_serial_salvagnini(g_lstrtv) = 0)
            then continue
        else if (g_lstrtv >= 10) and (g_lstrtv <= 15) then
            if not cs_exist_daedoWall(g_lstrtv) or (cs_serial_daedoWall(g_lstrtv) = 0)
            then continue;
        
        //적재 위치 sttn의 PLC 정보(목적지sttnno, 작업번호) 참조
        serial := cs_serial(cs_dev_sttnno(g_lstrtv));
        if serial = 0 then continue;
        // tosttn := cs_tosttn(cs_dev_sttnno(g_lstrtv));

    // 4. serial 번호로 DB 데이터 조회
        mySql := 'select top 1 * from MOVE where MV_SERIAL = ' + intToStr(serial);      
        try
            qryCell.close;
            qryCell.SQL.Clear;
            qryCell.SQL.Text := mySql;
            qryCell.Open;
            
            if qryCell.RecordCount = 0 then 
            begin
                showMessage('TDModule.ar_request_rtv_2bed> DB에 해당 작업번호 없음 (작업번호:' + intToStr(serial));
                exit;
            end;
            loadid := qrycell.FieldByName('MV_LOADID').AsString;
            saisle := qrycell.FieldByName('MV_SAISLE').AsString;
            status := qrycell.FieldByName('MV_STATUS').AsString;
            wrktyp := qrycell.FieldByName('MV_WRKTYP').AsString;
            ordtyp := qrycell.FieldByName('MV_ORDTYP').AsString;
            frsttn := qrycell.FieldByName('MV_FRSTTN').AsString;
            tosttn := qrycell.FieldByName('MV_TOSTTN').AsString;
            jobtyp := qrycell.FieldByName('MV_JOBTYP').AsString;
            chkst := qryCell.FieldByName('MV_CHKST').AsString;

    // 5. RTV 이재 스테이션(TOSTTN) 선정 (=호기선정)
            mySql :=  ' SELECT TOP 1 LO_SAISLE AS SAISLE , COUNT(*) AS LOC_CNT ' +
                      ' FROM LOCN ' +
                      ' WHERE LO_LOADID IS NOT NULL ' +
                      ' GROUP BY LO_SAISLE ' +
                      ' ORDER BY LOC_CNT ASC ';

            try
                qryCell.close;
                qryCell.SQL.Clear;
                qryCell.SQL.Text := mySql;
                qryCell.Open;

                for k := 1 to qryCell.RecordCount
                do begin
                    saisleArr[k] := strtoint(qryCell.FieldByName('SAISLE').AsString);
                    qryCell.Next;
                end;

            except on E : Exception do
                begin
                    showMessage('TDModule.ar_create_store_in > 입고호기선정 에러 : ' + E.Message);
                    for k := 1 to U_MAX_STK_DEV do saisleArr[k] := k;
                end;
            end;

            //S/C별 작업 예정 갯수 초기화
            for saisle := 1 to U_MAX_STK_DEV do movqty[saisle] := 0;
            //111,112, 121,122 Station 위의 물체(plt) 별로 111,121 중 어디로 가나 카운트
            for k := 1 to U_MAX_STK_DEV do
            begin
                //cs_exists(111+((my_i-1)*10) + (100*(fb-1)))
                if cs_exists(105+((k-1)*4)) then Inc(movqty[k]);
                if cs_exists(106+((k-1)*4)) then Inc(movqty[k]);
            end;

            saisle := 0;
            //추천 S/C 선택 Process
            for k := 1 to U_MAX_STK_DEV do
            begin
                if (saisleArr[1] <> 0) and (saisleArr[2] <> 0)
                then begin
                    shmptr^.ug_crin := saisleArr[k];
                end else begin
                    Dec(shmptr^.ug_crin);
                    if shmptr^.ug_crin < 1 then shmptr^.ug_crin := U_MAX_STK_DEV;
                end;

                if not (shmptr^.stkr[shmptr^.ug_crin].active) then continue;
                if not (shmptr^.stkr[shmptr^.ug_crin].work[U_WRKTYP_SCSI].enable) then continue;
                // 입고 전후면 사용여부 선택 반영   - 전후면 없음
                //if shmptr^.stkr[shmptr^.ug_crin].dircon[U_WRKTYP_SCSI, frsttnid] = False then continue;

                if (shmptr^.stkr[shmptr^.ug_crin].status) AND U_STAT_MASK
                    in [U_STAT_NONE, U_STAT_CERR, U_STAT_HERR]
                then continue;
                if shmptr^.stkr[shmptr^.ug_crin].commst = U_COMM_EROR then continue;

                if shmptr^.ug_crin = U_MAX_STK_DEV
                then begin
                    if movqty[shmptr^.ug_crin] >= U_MAX_MOV_QTY then continue;
                end;

                saisle := shmptr^.ug_crin;
                break;
            end;
            if (saisle < 1) or (saisle > U_MAX_STK_DEV)
            then begin
                //showMessage('TDModule.ar_create_store_in > 입고가능한 Stacker Crane이 없습니다. (입고금지설정 또는 Stacker Crane Error 확인요망)');
                exit;
            end;
            

    // 6. 공유메모리 rtv 버퍼 피드 위치 선정
            if qryCell.FieldByName('MV_WRKTYP').AsString = '입고' then
            begin
                if saisle = 1 then
                    tosttn :=  cs_dev_sttnno(U_STTN_RTV_IN_UNLD2)
                else if saisle = 2 then
                tosttn :=  cs_dev_sttnno(U_STTN_RTV_IN_UNLD1);
                feed_unuse_front := 1;
                feed_unuse_back := 2;
                feed_front := 3;
                feed_back := 4;
            end
            else if qryCell.FieldByName('MV_WRKTYP').AsString = '출고' then
            begin
                tosttn := 103;
                feed_front := 1;
                feed_back := 2;
                feed_unuse_front := 3;
                feed_unuse_back := 4;
            end;
            qryCell.Next;


    // 7. RTV 이재 스테이션(TOSTTN) 화물, 작번 유무 체크 (tosttn이 RTV DOG번호 기준 1 ~ 5 사이)
            if (tosttn <= 9) or (tosttn >= 21) then
            begin
                if tosttn = 0 then begin
                    showMessage('TDModule.ar_request_rtv_move2bed> RTV 이재 스테이션의 값이 0 입니다.');
                    exit;
                end;
                // tosttn 위치 화물감지, 작번 감지 x 
                // but, 103번(출고대) 도착지는 tosttn 하나만 체킹.  나머지는 다음 sttn도 체킹
                if cs_exists(tosttn) or ((tosttn <> 103) and (cs_exist(tosttn+1))) then 
                begin
                    showMessage('TDModule.ar_request_rtv_2bed> 목적지 위치 화물 존재 (작업번호: ' + intToStr(serial) + ' 목적지:'+ intToStr(tosttn));
                    exit;
                end;
                if (cs_serial(tosttn) <> 0) or ((tosttn <> 103) and (cs_serial(tosttn+1) <> 0)) then 
                begin
                    showMessage('TDModule.ar_request_rtv_2bed> 목적지 위치 작업번호 존재 (작업번호: ' + intToStr(serial) + ' 목적지:'+ intToStr(tosttn));
                    exit;
                end;
            end;
            
        except on E : Exception do
            begin
                showMessage('TDModule.ar_request_rtv_move2bed > RTV 적재 요청 또는 이재 sttn 선정 에러 : ' + E.Message);
                exit;
            end;
        end;
    
    // 8. DB 데이터 업데이트
        //------------------------------------------------------------------
        //              MV_STATUS = 'RTV 대기'
        //------------------------------------------------------------------
        try
            spCreateRtvMove.Parameters[0].Value := serial;
            spCreateRtvMove.ExecProc;
        except
            showMessage('TDModule.ar_request_rtv_move2 > Exception error occured at procedure spCreateRtvMove.');
            exit;
        end;

        rtcode := spCreateRtvMove.Parameters[1].Value;
        rtmesg := cs_nvl(spCreateRtvMove.Parameters[2].Value);

        if (rtcode <> 0)
        then begin
            showMessage('TDModule.ar_request_rtv_move2 > ' + rtmesg);
            exit;
        end;
        break;
    end;

    // 9. 공유메모리 SERIAL, 작업, FROM1/2, TO1/2, STATUS 업데이트
        if chkst = '' then
        begin
            //적재 지시  2 BED 수정 필요
            shmptr^.rtvs[1].work[1].serial := serial;
            shmptr^.rtvs[1].work[1].wrktyp := U_RTV_WORK_NONE;
            shmptr^.rtvs[1].work[1].msgbuf[U_RTV_POS_COMD] := U_RTV_WORK_TRAN;
            shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_front] := 0;//cs_dev_rtvno(g_lstrtv); //cs_dev_rtvno(g_lstrtv);          //from
            shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_back] := 0;//cs_dev_rtvno_by_sttnno(tosttn);//cs_dev_rtvno_by_sttnno(tosttn);  //to
            shmptr^.rtvs[1].work[1].msgbuf[feed_front] := cs_dev_rtvno(g_lstrtv);          //from
            shmptr^.rtvs[1].work[1].msgbuf[feed_back] := cs_dev_rtvno_by_sttnno(tosttn);  //to
            shmptr^.rtvs[1].work[1].status := U_COM_WAIT;
        end
        else if chkst = 'LOADCOMPLETE' then
        begin
            if wrktyp = '입고' then
            begin
                //적재 지시  2 BED 수정 필요
                shmptr^.rtvs[1].work[1].serial := serial;
                shmptr^.rtvs[1].work[1].wrktyp := U_RTV_WORK_NONE;
                shmptr^.rtvs[1].work[1].msgbuf[U_RTV_POS_COMD] := U_RTV_WORK_STOP;
                shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_front] := 0; //cs_dev_rtvno(g_lstrtv); //cs_dev_rtvno(g_lstrtv);          //from
                shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_back] := cs_dev_rtvno_by_sttnno(tosttn); //cs_dev_rtvno_by_sttnno(tosttn);//cs_dev_rtvno_by_sttnno(tosttn);  //to
                shmptr^.rtvs[1].work[1].msgbuf[feed_front] := 0; //from
                shmptr^.rtvs[1].work[1].msgbuf[feed_back] :=  cs_dev_rtvno(g_lstrtv);//to
                shmptr^.rtvs[1].work[1].status := U_COM_WAIT;
            end
            else if wrktyp = '출고' then
            begin
                //적재 지시  2 BED 수정 필요
                shmptr^.rtvs[1].work[1].serial := serial;
                shmptr^.rtvs[1].work[1].wrktyp := U_RTV_WORK_NONE;
                shmptr^.rtvs[1].work[1].msgbuf[U_RTV_POS_COMD] := U_RTV_WORK_AUTO;
                shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_front] := cs_dev_rtvno(g_lstrtv); //cs_dev_rtvno(g_lstrtv); //cs_dev_rtvno(g_lstrtv);          //from
                shmptr^.rtvs[1].work[1].msgbuf[feed_unuse_back] := 0;//cs_dev_rtvno_by_sttnno(tosttn);//cs_dev_rtvno_by_sttnno(tosttn);  //to
                shmptr^.rtvs[1].work[1].msgbuf[feed_front] := cs_dev_rtvno_by_sttnno(tosttn); //from
                shmptr^.rtvs[1].work[1].msgbuf[feed_back] := 0; //to
                shmptr^.rtvs[1].work[1].status := U_COM_WAIT;
            end;
        end;
    end;
end;

