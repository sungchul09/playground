const btn = document.querySelector('.btn');
const play = document.querySelector('#play');
const stop = document.querySelector('#stop');
btn.addEventListener('click', () => {
  play.classList.toggle('active');
  stop.classList.toggle('active');
});
