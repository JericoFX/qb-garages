<template>
  <div class="col-12 col-xs-1 self-center q-gutter-xs q-col-gutter-xs 	">
    <q-card
      :dark="SetDrark"
      bordered
      style="min-height: 120px"
    >
      <q-item-section class="">
        <div class="text-h5 text-center absolute-center q-mt-sm q-mb-xs ">
          <q-item-label>
            <q-item-label>
              <q-icon
                left
                color="red"
                name="mdi-alert-circle"
                style="font-size:3rem"
              /> {{$t('noveh')}}
              <q-icon
                right
                color="red"
                name="mdi-alert-circle"
                style="font-size:3rem"
              />
              <q-separator
                spaced
                inset
                vertical
                :dark="SetDrark"
              />
            </q-item-label>
          </q-item-label>
        </div>
        <q-separator
          spaced
          inset
          :dark="SetDrark"
        />
      </q-item-section>

    </q-card>

  </div>
</template>

<script>
import { inject } from "vue"
export default {
  name: 'NoVehicles',
  setup () {
    const SetDrark = inject("SetDark")
    return {
      SetDrark
    }
  }
}
</script>

<style>
</style>