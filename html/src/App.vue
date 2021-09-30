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

export default defineComponent({
  name: 'App',
  setup () {
    const Store = useStore()
    const show = ref(false)
    const Jerico = (e) => {
      e.preventDefault();
      const Data = e.data
      show.value = Data.show
      Store.dispatch('garage/SetVehicles', Data.Vehicles)
      Store.dispatch('garage/ChangeImpoundState', Data.IsImpound)
      Store.dispatch('garage/GarageTitle', Data.Garagelabel)
      Store.dispatch('garage/SetType', Data.type)
      Store.dispatch('garage/Garage', Data.garageType)
    };
    onMounted(() => {
      window.addEventListener('message', Jerico);
    });
    onUnmounted(() => {
      window.removeEventListener('message', Jerico);
    });
    const ByeBye = () => {
      Store.dispatch('garage/GarageTitle', "")
      axios.post(`https://${GetCurrentResourceName()}/ExitApp`);
      show.value = false;
    };
    return {
      show,
      ByeBye
    }
  }
})
</script>
