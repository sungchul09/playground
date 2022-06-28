const button = document.querySelector('.button');
const rabbit = document.querySelector('#rabbit');

button.addEventListener('click', () => {
    rabbit.scrollIntoView({
        behavior: "smooth",
        block: "center"
    });
})