function loadItems() {
    return fetch('data/data.json')
        .then(response => response.json())
        .then(json => json.items);
}

function displayItems(items) {
    const container = document.querySelector('.items')
    container.innerHTML = items.map(item => createHTMLString(item)).join('');
}

function createHTMLString(item) {
    return `<div class="item">
    <img src="${item.image}" alt="${item.type}">
    <div class="info">${item.gender}, ${item.size} size</div>
    </div>`;
}

function onButtonClick(event, items) {
    const datset = event.target.dataset;
    const key = datset.key;
    const value = datset.value;
    if (key == null || value == null) {
        return;
    }
    const filtered = items.filter(item => item[key] === value);
    displayItems(filtered);
}

function setEventListeners(items) {
    const logo = document.querySelector(".logo");
    const buttons = document.querySelector(".buttons");
    logo.addEventListener('click', () => displayItems(items));
    buttons.addEventListener('click', (event) => onButtonClick(event, items));
}

loadItems()
    .then(items => {
        displayItems(items);
        setEventListeners(items);
    })
    .catch(console.log);