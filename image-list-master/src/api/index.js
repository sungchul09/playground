import axios from 'axios';

const config = {
  API_URL: process.env.VUE_APP_API_URL
}

const instance = axios.create({
  baseURL: config.API_URL,
})

async function fetchImageList(page, limit) {
  try {
    const response = await instance.get(`v2/list?page=${page}&limit=${limit}`);
    return response;
  } catch (error) {
    console.log(error);
  }
}

async function fetchImageInfo(id) {
  try {
    const response = await instance.get(`id/${id}/info`);
    return response;
  } catch (error) {
    console.log(error);
  }
}

export { fetchImageList, fetchImageInfo };
