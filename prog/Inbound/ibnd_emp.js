const search = document.querySelector('.button__search');
const table = document.querySelector('.packdata table');
const findALlUrl = 'http://127.0.0.1:8080/inbound/findAll';

search.addEventListener('click', () => {
  (async () => {
    let response = await fetch(findALlUrl);
    const object = await response.json();
    const data = object.data;
    console.log(data);
    for (let i = 0; i < data.length; i++) {
      let value = data[i];
      console.log(table);
      table.innerHTML += `
      <tr class="column">
        <td class="column__loadid">${value.loadid}</td>
        <td class="column__serial">${value.serial}</td>
        <td class="column__wrktyp">${value.wrktyp}</td>
        <td class="column__frsttn">${value.frsttn}</td>
        <td class="column__tosttn">${value.tosttn}</td>
        <td class="column__pltsiz">${value.pltsiz}</td>
        <td class="column__setdat">${value.setdat.substring(0, 10)}</td>
        <td class="column__userid">${value.userid}</td>
      </tr>
      `;
    }
    return data;
  })();
});
