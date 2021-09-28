
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
          :value="vehicleEngine /100"
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
    vehicleEngine: Number
  },
  setup (props) {
    return { vehicleEngine: props.vehicleEngine }
  }
}
</script>

<style>
</style>