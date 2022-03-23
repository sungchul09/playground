const search = document.querySelector('.button__search');
const findALlUrl = 'http://127.0.0.1:8080/inbound/findAll';

search.addEventListener('click', () => {
  (async () => {
    let response = await fetch(findALlUrl);
    const data = await response.json();
    return data;
  })();
});
