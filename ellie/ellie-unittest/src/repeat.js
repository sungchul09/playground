function repeat(word, times) {
  // 반복문만에서 times 횟수로 word 내용을 words 배열에 push
  let words = [];
  for (let i = 0; i < times; i++) {
    words.push(word);
  }
  return words;
}


module.exports = repeat;