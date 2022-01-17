'use strict';

// 1. async
async function fetchUser() {
    return 'ellie';
}

const user = fetchUser();
console.log(user);


// 2. await
function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time))
}

async function getApple() {
    await delay(1000);
    return '사과';
}

async function getBanana() {
    await delay(1000);
    return '바나나';
}


async function pickFruits() {
    const applePromise = getApple();
    const bananaPromise = getBanana();
    const apple = await applePromise;
    const banana = await bananaPromise;
    return `${apple} + ${banana}`;
}

pickFruits().then(console.log);

// 3. useful Promise APIs
function pickAllFruits() {
    return Promise.all([getApple(), getBanana()])
        .then(fruits => fruits.join('+'));

}
pickFruits().then(console.log);

function pcikOnlyOne() {
    return Promise.race([getApple(), getBanana()]);
}
pcikOnlyOne().then(console.log);