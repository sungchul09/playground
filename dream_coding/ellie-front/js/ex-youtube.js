const morebtn = document.querySelector('.info .metadata .moreButton');
const title = document.querySelector('.info .metadata .title');
morebtn.addEventListener('click', () => {
    morebtn.classList.toggle('clicked');
    title.classList.toggle('clamp');
});