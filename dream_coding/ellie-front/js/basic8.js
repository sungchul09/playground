let fruits = ['🍉', '🍊', '🍋', '🍌', '🍍', '🥭', '🍎'];


// 뒤에 넣고, 뒤에 빼기
fruits.push('🥒');
fruits.pop();

// 앞에 넣고, 앞에 빼기
fruits.unshift('🍉');
//fruits.shift();

// splice(start: number, deleteCount?: number): T[];
//fruits.splice(1, 2)
// 몇개 지울지 작성하지 않으면 start 부터 모두 다 지운다.
//fruits.splice(0);


fruits.forEach((fruit, index) => {
    const div = document.createElement('div');
    const text = document.createTextNode(fruit + index);
    div.appendChild(text);
    document.body.appendChild(div);
});

//Returns the index of the first occurrence of a value in an array, or -1 if it is not present.
console.log(fruits.indexOf('🍉'));

// Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.
console.log(fruits.lastIndexOf('🍉'));

