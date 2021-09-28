
<template>
  <q-item-section class="">
    <div class="text-h5">
      <q-item-label>
        <q-tooltip>
          {{vehicleBody / 10 + "%"}}
        </q-tooltip>
        <q-item-label>
          <q-icon
            name="mdi-bottle-tonic-plus"
            style="font-size:2rem"
          />{{$t('body')}}:
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
          :value="vehicleBody /100"
          color="brown"
        />

      </q-item-label>
    </div>
  </q-item-section>

</template>

<script>
import { computed } from 'vue';
export default {
  name: "Body",
  props: {
    vehicleBody: Number
  },
  setup (props) {
    return { vehicleBody: props.vehicleBody }
  }
}
</script>

<style>
</style>