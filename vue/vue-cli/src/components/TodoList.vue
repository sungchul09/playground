<template>
  <div>
    <ul>
      <li
        v-for="(todoItem, index) in todoItems"
        v-bind:key="todoItem"
        class="shadow"
      >
        <i class="checkBtn fas fa-check" v-on:click="toggleComplete"></i>
        {{ todoItem }}
        <span class="removeBtn" v-on:click="removeTodo(todoItem, index)">
          <i class="fas fa-trash-alt"></i>
        </span>
      </li>
    </ul>
  </div>
</template>

<script>
const ls = localStorage;
export default {
  data: function () {
    return {
      todoItems: [],
    };
  },
  created: function () {
    if (ls.length > 0) {
      for (let i = 0; i < ls.length; i++) {
        if (ls.key(i) !== "" && ls.key(i) !== "loglevel:webpack-dev-server") {
          this.todoItems.push(ls.key(i));
        }
      }
      console.log(this.todoItems);
    }
  },
  methods: {
    removeTodo: function (todoItem, index) {
      ls.removeItem(todoItem);
      this.todoItems.splice(index, 1);
    },

    toggleComplete: function () {},
  },
};
</script>

<style scoped>
ul {
  list-style-type: none;
  padding-left: 0px;
  margin-top: 0px;
  text-align: left;
}

li {
  display: flex;
  min-height: 50px;
  height: 50px;
  line-height: 50px;
  margin: 0.5rem 0;
  padding: 0 0.9rem;
  background: white;
  border-radius: 5px;
}

.checkBtn {
  line-height: 45px;
  color: #62acde;
  margin-right: 5px;
}

.checkBtnCompleted {
  color: #b3adad;
}

.textCompleted {
  text-decoration: line-through;
  color: #b3adad;
}

.removeBtn {
  margin-left: auto;
  color: #de4343;
}

.checkBtn {
  line-height: 45px;
  color: #62acde;
  margin-right: 5px;
}

.checkBtnCompleted {
  color: #b3adad;
}

.textCompleted {
  text-decoration: line-through;
  color: #b3adad;
}
</style>