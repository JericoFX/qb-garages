<template>
  <div class="body">
    <GHeader />
    <Index />
  </div>

</template>

<script>
import { defineComponent } from 'vue'

import Index from '../pages/Index.vue'
import GHeader from '../pages/GHeader.vue'
export default defineComponent({
  name: 'MainLayout',
  components: { Index, GHeader },
  setup () {
    return {
    }
  }
})
</script>
<style scoped>
.body {
  position: relative;
  width: 1362px;
  height: 773px;
  left: 269px;
  top: 99px;

  background-color: rgba(25, 25, 25, 80%);
  border-radius: 10px;
}
* {
  font-family: "Poppins", sans-serif;
}
</style>