<template>
  <div class="inputBox shadow">
    <input type="text" v-model="newTodoItem" />
    <span class="addContainer" v-on:click="addtodo">
      <i class="fas fa-plus addBtn"></i>

      <modal v-if="showModal" @close="showModal = false">
        <template v-slot:header>경고🛑</template>
        <template v-slot:body
          >입력된 데이터가 없습니다.<br />
          데이터를 입력해주세요</template
        >
        <template v-slot:footer>
          <button class="modal-default-button" v-on:click="showModal = false">
            ❌
          </button>
        </template>
      </modal>
    </span>
  </div>
</template>

<script>
import Modal from "./common/Modal.vue";
export default {
  components: {
    Modal: Modal,
  },
  data: function () {
    return {
      newTodoItem: "",
      showModal: false,
    };
  },
  methods: {
    addtodo: function () {
      if (this.newTodoItem === "") {
        this.showModal = true;
        return;
      }
      this.showModal = false;
      this.$store.commit("addItem", this.newTodoItem);
      this.clearInput();
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
