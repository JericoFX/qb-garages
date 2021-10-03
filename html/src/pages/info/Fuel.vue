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
export default {
  name: "Fuel",
  props: {
    vehicleFuel: {
      type: Number
    }
  },
  setup (props) {
     /* eslint-disable */
    const vehicleFuel = props.vehicleFuel
    return { vehicleFuel }
  }
}
</script>

<style>
</style>