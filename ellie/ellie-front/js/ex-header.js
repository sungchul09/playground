let toggleBtn = document.querySelector(".navbar__toggle");
let menu = document.querySelector(".navbar__menu");
let contact = document.querySelector(".navbar__contact");
toggleBtn.addEventListener('click', () => {
    menu.classList.toggle('active');
    contact.classList.toggle('active');
})

document.documentElement.setAttribute('color-theme', 'light');
let colorTheme = document.querySelector(".navbar__color");
colorTheme.addEventListener('click', () => {
    if (colorTheme.innerText === '라이트모드') {
        document.documentElement.setAttribute('color-theme', 'dark');
        colorTheme.innerText = '다크모드';
    } else {
        document.documentElement.setAttribute('color-theme', 'light');
        colorTheme.innerText = '라이트모드';
    }
})