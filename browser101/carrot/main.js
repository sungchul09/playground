const btn = document.querySelector('.btn');

btn.addEventListener('click', (e) => {
  const status = e.target.dataset.status;
  console.log(status);
});
