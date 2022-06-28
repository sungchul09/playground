const config = {
  baseUrl: 'http://localhost:5050',
};

// move (status/wkrtyp, )
function getMoveDataByStatusAndWrktyp({ status, wrktyp }) {
  return axios.get(
    `${config.baseUrl}/getMoveDataByStatusAndWrktyp/${status}/${wrktyp}`
  );
}

// LOAD (locatn, loadid)
function getLoadDataByLocatn({ locatn }) {
  return axios.get(`${config.baseUrl}/getLoadDataByLocatn/${locatn}`);
}

function getLoadDataByLoadid({ loadid }) {
  return axios.get(`${config.baseUrl}/getLoadDataByLoadid/${loadid}`);
}

// LOCN (locatn, loadid)
function getLocnDataByLocatn({ locrow }, { locbay }, { loclev }) {
  return axios.get(
    `${config.baseUrl}/getLocnDataByLocatn/${locrow}/${locbay}/${loclev}`
  );
}

function getLocnDataByLoadid({ loadid }) {
  return axios.get(`${config.baseUrl}/getLocnDataByLoadid/${loadid}`);
}

// LOMX (loadid, lomxid)
function getLomxDataByLoadid({ loadid }) {
  return axios.get(`${config.baseUrl}/getLomxDataByLoadid/${loadid}`);
}

function getLomxDataByLomxid({ lomxid }) {
  return axios.get(`${config.baseUrl}/getLomxDataByLomxid/${lomxid}`);
}

// HIST, XLOG, EROR
function getHistData() {
  return axios.get(`${config.baseUrl}/getHistData`);
}

function getXlogData() {
  return axios.get(`${config.baseUrl}/getXlogData`);
}

function getErorData() {
  return axios.get(`${config.baseUrl}/getErorData`);
}
