let fruits = ['π', 'π', 'π', 'π', 'π', 'π₯­', 'π'];


// λ€μ λ£κ³ , λ€μ λΉΌκΈ°
fruits.push('π₯');
fruits.pop();

// μμ λ£κ³ , μμ λΉΌκΈ°
fruits.unshift('π');
//fruits.shift();

// splice(start: number, deleteCount?: number): T[];
//fruits.splice(1, 2)
// λͺκ° μ§μΈμ§ μμ±νμ§ μμΌλ©΄ start λΆν° λͺ¨λ λ€ μ§μ΄λ€.
//fruits.splice(0);


fruits.forEach((fruit, index) => {
    const div = document.createElement('div');
    const text = document.createTextNode(fruit + index);
    div.appendChild(text);
    document.body.appendChild(div);
});

//Returns the index of the first occurrence of a value in an array, or -1 if it is not present.
console.log(fruits.indexOf('π'));

// Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.
console.log(fruits.lastIndexOf('π'));

