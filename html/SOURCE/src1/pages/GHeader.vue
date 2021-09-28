<template>
  <div class="Garage  absolute-top text-center text-h1 bg-grey-1 ellipsis">
    {{GarageGame}}
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'
export default {
  name: 'GHeader',
  setup () {
    const Store = useStore()
    const GarageGame = computed(() => Store.getters['garage/GetGarageName'])
    return {
      GarageGame
    }
  }
}
</script>

<style scoped>
.Garage {
  max-width: 1237px;
  max-height: 129px;
  left: 68px;
  top: 46px;
  border-radius: 10px;
}
</style>