import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);
const ls = localStorage;
const storage = {
    fetch() {
        let arr = [];
        if (ls.length > 0) {
            for (let i = 0; i < ls.length; i++) {
                const key = ls.key(i);
                const item = ls.getItem(key);
                if (key !== 'loglevel:webpack-dev-server') {
                    arr.push(JSON.parse(item));
                }
            }
        }
        return arr;
    },
};

export const store = new Vuex.Store({
    state: {
        headerText: 'ToDoList!',
        todoItems: storage.fetch(),
    },
    getters: {
        storedTodoItems(state) {
            return state.todoItems;
        },
    },
    mutations: {
        addItem(state, payload) {
            const obj = { completed: false, item: payload };
            ls.setItem(payload, JSON.stringify(obj));
            state.todoItems.push(obj);
        },
        removeOneItem(state, payload) {
            const item = payload.todoItem.item;
            const index = payload.index;
            ls.removeItem(item);
            state.todoItems.splice(index, 1);
        },
        claerAllItems(state) {
            ls.clear();
            state.todoItems = [];
        },
        toggleOneItem(state, todoItem) {
            if (todoItem.completed) {
                todoItem.completed = false;
            } else if (!todoItem.completed) {
                todoItem.completed = true;
            }
            ls.removeItem(todoItem.item);
            ls.setItem(todoItem.item, JSON.stringify(todoItem));
        },
    },
});
