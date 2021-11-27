<template>
  <div
    @keyup.esc="ByeBye"
    tabindex="0"
  >
    <div v-if="show">
      <router-view />
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted, onUnmounted } from 'vue';
import { useStore } from 'vuex';
import axios from 'axios'
import Data1 from './assets/Jerico.json'
import {IS_DEV,IS_IMPOUND} from './utils/config'
export default defineComponent({
  name: 'App',
  setup () {
    const Store = useStore()
    const show = ref(false)
    
    const Jerico = (e) => {
      e.preventDefault();
      const Data = e.data
      if(!IS_DEV){
      show.value = Data.show
      Store.dispatch('garage/SetVehicles', Data.Vehicles)
      Store.dispatch('garage/ChangeImpoundState', Data.IsImpound)
      Store.dispatch('garage/GarageTitle', Data.Garagelabel)
      Store.dispatch('garage/SetType', Data.type)
      Store.dispatch('garage/Garage', Data.garageType)
      }else{
        show.value = true
        Store.dispatch('garage/SetVehicles', Data1.rows)
        Store.dispatch('garage/ChangeImpoundState', IS_IMPOUND)
        Store.dispatch('garage/GarageTitle', IS_IMPOUND ? "DEV IMPOUND" : "DEV MODE")
      }
    };

    onMounted(() => {
      window.addEventListener('message', Jerico);
    });

    onUnmounted(() => {
      window.removeEventListener('message', Jerico);
    });

    const ByeBye = () => {
      Store.dispatch('garage/GarageTitle', "")
      axios.post('https://qb-garages/ExitApp');
      show.value = false;
    };

    return {
      show,
      ByeBye
    }
  }
})
</script>
