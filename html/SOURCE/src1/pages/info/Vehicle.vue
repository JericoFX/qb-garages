<template>
  <q-item-section>
    <div class="text-h5 q-mt-sm q-mb-xs">
      <q-item-label>
        <q-tooltip>
          {{vehicleName.toUpperCase()}}
        </q-tooltip>
        <q-item-label>
          <q-icon
            name="mdi-car"
            style="font-size:2rem"
          />{{$t('vehicle')}}:
          <q-separator
            spaced
            inset
            vertical
            dark
          />
        </q-item-label>
        {{vehicleName.toUpperCase()}}
      </q-item-label>
    </div>
  </q-item-section>

</template>

<script>
import { computed } from 'vue';
export default {
  name: "Vehicle",
  props: {
    vehicleName: String
  },
  setup (props) {
    return {
      vehicleName: props.vehicleName
    }
  }
}
</script>

<style>
</style>