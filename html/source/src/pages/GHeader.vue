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
    const IsImpounded = computed(() => {
      return Store.state.garage.Impound
    })
    const GarageGame = computed(() => {

      return Store.getters['garage/GetGarageName']
    })
    //console.log("not value "+Store.getters['garage/GetGarageName']);
    //console.log("with value "+Store.getters['garage/GetGarageName']);
    return {
      GarageGame
    }
  }
}
</script>

<style scoped>
.Garage {
  max-width: 1237px;
  max-height: 125px;
  left: 68px;
  top: 46px;
  border-radius: 10px;
}
</style>