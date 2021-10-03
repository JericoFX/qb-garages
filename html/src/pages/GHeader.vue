<template>
  <div class="Garage absolute-top text-center text-h1 bg-grey-1 ellipsis non-selectable">
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
    const GarageGame = computed(() => {
      return Store.getters['garage/GetGarageName']
    })
    return {
      GarageGame
    }
  }
}
</script>

<style scoped>
.Garage {
  max-width: 1237px;
  max-height: 114px;
  height: 112px;
  left: 68px;
  top: 46px;
  border-radius: 10px;
}
</style>