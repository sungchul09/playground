import axios from 'axios';

const config = {
    baseUrl: 'https://api.hnpwa.com/v0/',
};
async function fetchNewsList() {
    try {
        return await axios.get(`${config.baseUrl}/news/1.json`);
    } catch (error) {
        console.log(error);
    }
}

async function fetchJobsList() {
    try {
        return await axios.get(`${config.baseUrl}/jobs/1.json`);
    } catch (error) {
        console.log(error);
    }
}

async function fetchAskList() {
    try {
        return await axios.get(`${config.baseUrl}/ask/1.json}`);
    } catch (error) {
        console.log(error);
    }
}

async function fetchList(pageName) {
    try {
        return await axios.get(`${config.baseUrl}${pageName}/1.json`);
    } catch (error) {
        console.log(error);
    }
}

function fetchUserInfo(username) {
    return axios.get(`${config.baseUrl}user/${username}.json`);
}

function fetchCommentItem(id) {
    return axios.get(`${config.baseUrl}item/${id}.json`);
}

export {
    fetchNewsList,
    fetchJobsList,
    fetchAskList,
    fetchList,
    fetchUserInfo,
    fetchCommentItem,
};
