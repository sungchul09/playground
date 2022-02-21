const horizontal = document.querySelector('.horizontal');
const vertical = document.querySelector('.vertical');
const target = document.querySelector('.target');
const tag = document.querySelector('.tag');
const container = document.querySelector('.container');
let cnt = 0;


window.addEventListener('mousemove', (e) => {
    let x = e.clientX;
    let y = e.clientY;
    tag.innerHTML = `${x}, ${y}`;

    vertical.style.left = `${x}px`;
    horizontal.style.top = `${y}px`;
    target.style.left = `${x}px`;
    target.style.top = `${y}px`;
    tag.style.left = `${x}px`;
    tag.style.top = `${y}px`;
})

window.addEventListener('click', (e) => {
    let x = e.clientX;
    let y = e.clientY;
    container.innerHTML += `
    <div class="dot${cnt}"></div>
    <div class="coordinate${cnt}"></div>
    `;
    let dot = document.querySelector(`.dot${cnt}`);
    let coordinate = document.querySelector(`.coordinate${cnt}`);
    dot.style.position = `absolute`;
    dot.style.left = `${x}px`;
    dot.style.top = `${y}px`;
    dot.style.width = `15px`;
    dot.style.height = `15px`;
    dot.style.background = `red`;
    dot.style.borderRadius = `50%`;
    dot.style.transform = `translate(-50%, -50%)`;

    coordinate.innerHTML = `${x}, ${y}`;
    coordinate.style.color = `white`;
    coordinate.style.fontSize = `10px`;
    coordinate.style.position = `absolute`;
    coordinate.style.left = `${x}px`;
    coordinate.style.top = `${y}px`;
    coordinate.style.transform = `translate(5px, 5px)`;
    cnt++;
})