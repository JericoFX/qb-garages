<template>
  <q-item-section class="">
    <div class="text-h5">
      <q-item-label>
        <q-tooltip>
          {{vehicleFuel + "%"}}
        </q-tooltip>
        <q-item-label>
          <q-icon
            name="mdi-gas-station"
            style="font-size:2rem"
          />{{$t('fuel')}}:
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
          :value="vehicleFuel /100"
          color="warning"
        />

      </q-item-label>
    </div>
  </q-item-section>

</template>

<script>
import { computed } from 'vue';
export default {
  props: {
    vehicleFuel: Number
  },
  name: "Fuel",
  setup (props) {
    computed
    return { vehicleFuel: props.vehicleFuel }
  }
}
</script>

<style>
</style>