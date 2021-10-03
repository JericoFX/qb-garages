<template>
  <q-item-section class="">
    <div class="text-h5">
      <q-item-label>
        <q-item-label>
          <q-icon
            name="mdi-alpha-p-box"
            style="font-size:2rem"
          />{{$t('plate')}}:
          <q-separator
            spaced
            inset
            vertical
          />
        </q-item-label>
        {{ vehiclePlate }}
      </q-item-label>
    </div>
  </q-item-section>
</template>

<script>
export default {
  name: "Plate",
  props: {
    vehiclePlate: {
      type: String,
    }
  },
  setup (props) {
     /* eslint-disable */
    const vehiclePlate = props.vehiclePlate
    return {
      vehiclePlate
    }
  }
}
</script>

<style>
</style>