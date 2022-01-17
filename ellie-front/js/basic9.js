/*
배열 함수에 대한 내용
1. join, split, reverse, splice
2. find, filter, map, some, every, reduce, reduceRight
3. 배열 함수 여러개 체이닝
*/

const ball = ['⚽', '⚾', '🥎', '🏀']; //🏐🏈🏉🎱🎳🥌

// Adds all the elements of an array into a string, separated by the specified separator string.
const ballString = ball.join(', ');
console.log(ballString);
// Split a string into substrings using the specified separator and return them as an array.
const result = ballString.split(', ');
// 크기를 지정하면 해당 크기만큼 배열을 만든다.
const result1 = ballString.split(', ', 2);
// 구분자가없으면 하나의 배열에 문장이 다 들어간다.
const result2 = ballString.split();
console.log(result);
console.log(result1);
console.log(result2);


// array 배열을 reverse() 시키면 return 하는 배열뿐만아니라 대상이되는 "array" 배열도 reverse 된다.
const array = [1, 2, 3, 4, 5];
const reverseArray = array.reverse();

console.log(array);
console.log(reverseArray);


// splice: 대상 배열에서 삭제 + 삭제된 요소 배열로 반환
const splice = array.splice(1, 2);

// slice: 대상 배열은 그대로 (해당 요소 배열로 반환)
// start, end 에서 인덱스 번호는 start ~ end-1 까지 해당.
const slice = array.slice(1, 2);
console.log(array, splice);
console.log(array, slice);

class Student {
    constructor(grade, age, enrolled, score) {
        this.grade = grade;
        this.age = age;
        this.enrolled = enrolled;
        this.score = score;
    }
}
const students = [
    new Student('A', 29, true, 45),
    new Student('B', 28, false, 80),
    new Student('C', 30, true, 90),
    new Student('D', 40, false, 66),
    new Student('E', 18, true, 88)
]

//Returns the value of the first element in the array where predicate is true, and undefined
const score90 = students.find((student) => student.score === 90);
console.log(score90);

//Returns the elements of an array that meet the condition specified in a callback function.
const enrolled = students.filter((student) => {
    return student.enrolled;
});
console.log("filter:", enrolled);

// Calls a defined callback function on each element of an array, and returns an array that contains the results.
// map에 지정된 callback 함수를 호출하며 
// 각각의 요소들을 함수를 거쳐 다시 새로운 요소로 변환하는 것
const scoreArr = students.map((student) => student.score);
console.log(scoreArr);

// 배열 요소 중 하나라도 해당 조건을 충족하면 true,  없으면 false
const score50 = students.some((student) => student.score < 50);
console.log(score50);

// 배열 요소 중 모든 요소가 해당 조건을 충족하면 true, 아니면 false
const score60 = students.every((student) => student.score > 60);
console.log(score60)

console.log('------------------------------------')

// 평균 점수 구하기
const studentAvg = students.reduce((prev, curr) => {
    console.log(prev, curr);
    return prev + curr.score;
}, 0);
console.log(studentAvg);

// reduce의 reverse 형태
const studentAvg2 = students.reduceRight((prev, curr) => prev + curr.score, 0);
console.log(studentAvg2);

// 배열 함수 여러개 묶어서 작성
const stuString = students
    .map((student) => student.score)
    .filter(score => score > 80)
    .join();
console.log(stuString)

const stuSorting = students
    .map((student) => student.score)
    .sort((a, b) => b - a)
    .join();
console.log(stuSorting);