'use strict';

console.log('1');
setTimeout(() => console.log('2'), 1000);
console.log('2');
console.log('3');

// Synchronous callback 1
function printImmediately(print) {
    print();
}

// Synchronous callback 2
printImmediately(() => console.log('hello'));


// Asynchronous callback 1
function printWithDelay(print, timeout) {
    setTimeout(print, timeout);
}

// Asynchronous callback 2
printWithDelay(() => console.log('async callback'), 2000)