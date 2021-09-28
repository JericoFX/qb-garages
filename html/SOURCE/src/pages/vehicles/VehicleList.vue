<template>
  <div class="fit row wrap justify-start items-start content-start non-selectable">
    <div
      class="col-12 col-xs-1 self-center q-gutter-xs q-col-gutter-xs cursor-pointer"
      style="margin-left:10px"
    >
      <div v-if="IsImpounded">
        <GarageImpound :veh="veh" />
      </div>
      <div v-else>
        <GarageNormal :veh="veh" />
      </div>

    </div>
  </div>

</template>

<script>
import { inject, computed } from 'vue';
import { useStore } from 'vuex'
import GarageNormal from './GarageNormal.vue'
import GarageImpound from './GarageImpound.vue'

export default {
  components: { GarageNormal, GarageImpound },
  props: {
    veh: {
      body: 0,
      fuel: 0,
      vehicle: 0,
      plate: 0,
      engine: 0,
      notes: "",
      pics: ""
    }
  },
  setup (props) {
    const veh = {
      body: props.veh.body,
      engine: props.veh.engine,
      vehicle: props.veh.vehicle,
      plate: props.veh.plate,
      fuel: props.veh.fuel,
      notes: props.veh.notes,
      pics: props.veh.pics
    }
    const Store = useStore()
    const SetDark = inject("SetDark")
    return {
      veh,
      SetDark,
      IsImpounded: computed(() => Store.state.garage.Impound),
    }
  }
}
</script>

<style>
</style>