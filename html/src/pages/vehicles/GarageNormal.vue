<template>
  <q-card
    :dark="SetDark"
    bordered
    @click="Notify(veh.plate)"
  >
    <q-card-section class="q-mt-sm">
      <q-item>
        <Vehicle :vehicleName="veh.vehicle" />
        <q-separator
          spaced
          inset
          vertical
          :dark="SetDark"
        />

        <Plate :vehiclePlate="veh.plate" />
        <q-separator
          spaced
          inset
          vertical
          :dark="SetDark"
        />
        <Fuel :vehicleFuel="veh.fuel" />
        <q-separator
          spaced
          inset
          vertical
          :dark="SetDark"
        />
        <Engine :vehicleEngine="veh.engine" />
        <q-separator
          spaced
          inset
          vertical
          :dark="SetDark"
        />

        <Body :vehicleBody="veh.body" />
      </q-item>
    </q-card-section>
    <q-separator
      spaced
      inset
      vertical
      :dark="SetDark"
    />
  </q-card>
</template>

<script>
import Vehicle from '../info/Vehicle.vue'
import Fuel from '../info/Fuel.vue'
import Engine from '../info/Engine.vue'
import Body from '../info/Body.vue'
import Plate from '../info/Plate.vue'
import { inject, computed } from 'vue';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n'
import { useStore } from 'vuex'
import axios from 'axios';
export default {
  components: { Vehicle, Fuel, Engine, Body, Plate },
  name: "GarageNormal",
  props: {
    veh: {
      body: 0,
      fuel: 0,
      vehicle: 0,
      plate: 0,
      engine: 0
    },
    SetDark: {
      type: Boolean
    }
  },
  setup (props) {
    const $q = useQuasar()
    const { locale, t } = useI18n({ useScope: 'global' })
    const Store = useStore()
    const type = computed(() => Store.getters['garage/GetType'])

    const DeleteVehicle = (plate) => {
      axios.post(`https://${GetCurrentResourceName()}/OutVehicle`, JSON.stringify({ plate: plate, type: type.value })).then(function (Spawned) {
        if (Spawned.data) {
          Noti()
          Store.dispatch('garage/DeleteVeh', plate)
        } else {
          $q.notify({
            color: 'warning',
            textColor: 'white',
            icon: 'mdi-check-decagram',
            message: t('error'),
            position: 'right',
            multiLine: true,
            timeout: 2000
          })

        }
      })
    }
    const Noti = () => {
      $q.notify({
        color: 'primary',
        textColor: 'white',
        icon: 'mdi-check-decagram',
        message: t('out'),
        position: 'right',
        multiLine: true,
        timeout: 2000
      })
    }
    const Notify = (plate) => {
      $q.dialog({
        title: 'Confirm',
        style: "border: 2px solid black;color:black;",
        message: t('sure', { plate: plate }),
        cancel: true,
        persistent: true
      }).onOk(() => {
        DeleteVehicle(plate)
      }).onCancel(() => {
        // //console.log('>>>> Cancel')
      }).onDismiss(() => {
        // //console.log('I am triggered on both OK and Cancel')
      })
    }
    const SetDark = inject("SetDark")
    const veh = {
      body: props.veh.body,
      engine: props.veh.engine,
      vehicle: props.veh.vehicle,
      plate: props.veh.plate,
      fuel: props.veh.fuel
    }
    return {
      Notify,
      veh,
      SetDark,
      DeleteVehicle
    }
  }
}
</script>

<style>
</style>
