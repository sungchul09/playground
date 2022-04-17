<template>
  <section class="inputBox shadow">
    <input type="text" v-model="newTodoItem" />
    <!-- <button v-on:click="addTodo">ADD</button> -->
    <span class="addContainer" v-on:click="addTodo">
      <i class="fas fa-plus addBtn"></i>
    </span>
  </section>
</template>

<script>
const ls = localStorage;
export default {
  data: function () {
    return {
      newTodoItem: "",
    };
  },
  methods: {
    addTodo: function () {
      if (this.newTodoItem !== "") {
        const obj = { completed: false, item: this.newTodoItem };
        ls.setItem(this.newTodoItem, JSON.stringify(obj));
        this.clearInput();
      }
    },
    clearInput: function () {
      this.newTodoItem = "";
    },
  },
};
</script>

<style>
input:focus {
  outline: none;
}
.inputBox {
  background: white;
  height: 50px;
  line-height: 50px;
  border-radius: 5px;
}

.inputBox input {
  border-style: none;
  font-size: 0.9rem;
}

.addContainer {
  float: right;
  background: linear-gradient(to right, #6478fb, #8763fb);
  display: block;
  width: 3rem;
  border-radius: 0 5px 5px 0;
}

.addBtn {
  color: white;
  vertical-align: middle;
}
</style>
