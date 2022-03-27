const btn = document.querySelector('.btn');
const play = document.querySelector('#play');
const stop = document.querySelector('#stop');
const timer = document.querySelector('.timer');
let time = 10;
btn.addEventListener('click', () => {
  const status = btn.getAttribute('data-status');

  toggleIcon();

  if (status === 'play') {
    timer.innerHTML = `00:${time.toString().padStart(2, '0')}`;
    btn.setAttribute('data-status', 'stop');
    playTimer();
  } else if (status === 'stop') {
    btn.setAttribute('data-status', 'play');
    time = 0;
  }
});

function playTimer() {
  let inerval = setInterval(() => {
    if (time === 0 || time === -1) {
      toggleIcon();
      btn.setAttribute('data-status', 'play');
      clearInterval(inerval);
      return;
    }
    time--;
    timer.innerHTML = `00:${time.toString().padStart(2, '0')}`;
  }, 1000);
}

function toggleIcon() {
  play.classList.toggle('active');
  stop.classList.toggle('active');
}
