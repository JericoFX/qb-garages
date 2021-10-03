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
          :value="vehicleBody /1000"
          color="brown"
        />

      </q-item-label>
    </div>
  </q-item-section>

</template>

<script>
export default {
  name: "Body",
  props: {
    vehicleBody: {
      type: Number
    }
  },
  setup (props) {
     /* eslint-disable */
    const vehicleBody = props.vehicleBody
    return { vehicleBody }
  }
}
</script>

<style>
</style>