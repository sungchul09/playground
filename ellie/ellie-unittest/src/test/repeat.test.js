const repeat = require('../repeat.js');


test("repeats words three times", () => {
  expect(repeat("Test", 4)).toMatchSnapshot();
});