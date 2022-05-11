setInterval(function () {
  requestFileCheck();
}, 1000);

const requestFileCheck = () => {
  let reader = new FileReader();
  if (text.files && text.files[0]) {
    reader.onload = function (e) {
      let output = e.target.result;
      console.log(output);
    };
    reader.readAsText(text.files[0]);
  }
};
