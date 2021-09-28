
<template>
  <q-item-section class="">
    <div class="text-h5">
      <q-item-label>
        <q-tooltip>
          {{vehicleEngine / 10 + "%"}}
        </q-tooltip>
        <q-item-label>
          <q-icon
            name="mdi-engine"
            style="font-size:2rem"
          /> {{$t('engine')}}:
          <q-separator
            spaced
            inset
            vertical
            dark
          />
        </q-item-label>
        <q-linear-progress
          dark
          size="10px"
          :value="GetEngineHealth"
          color="primary"
        />

      </q-item-label>
    </div>
  </q-item-section>

</template>

<script>
  import { computed } from 'vue';
export default {

  name: "Engine",
  props: {
    vehicleEngine: {
      type: Number
    }
  },
  setup (props) {
    const vehicleEngine = props.vehicleEngine
    const GetEngineHealth = computed(() =>{
      return (vehicleEngine/1000).toFixed(0)
    })

    return { vehicleEngine,GetEngineHealth }
  }
}
</script>

<style>
</style>