<template >
  <div class="non-selectable non-events">

    <q-card
      :dark="SetDark"
      bordered
      flat
      rounded
    >
      <q-card-section class="q-mt-sm">
        <q-item>
          <Vehicle :vehicleName="veh.vehicle" />
          >
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
          <q-separator
            spaced
            inset
            vertical
            :dark="SetDark"
          />

          <Notes
            :notes="veh.notes"
            :pics="veh.pics"
            :plate="veh.plate"
          />
        </q-item>
        <q-card-actions
          vertical
          align="center"
        >
          <q-btn
            :disable="IsOut"
            flat
            @click="CheckForMoney(veh.plate)"
            label="Take Vehicle"
          />
        </q-card-actions>
      </q-card-section>
      <q-separator
        spaced
        inset
        vertical
        :dark="SetDark"
      />
    </q-card>

  </div>

</template>

<script>
import Vehicle from '../info/Vehicle.vue'
import Fuel from '../info/Fuel.vue'
import Engine from '../info/Engine.vue'
import Body from '../info/Body.vue'
import Plate from '../info/Plate.vue'
import Notes from '../info/Notes.vue'
import axios from 'axios'
import { inject, ref, computed, onBeforeUnmount } from 'vue';
import { useQuasar } from 'quasar'
import { useStore } from 'vuex'
export default {
  components: { Vehicle, Fuel, Engine, Body, Plate, Notes },
  name: "GarageImpound",
  props: {
    veh: {
      body: 0,
      fuel: 0,
      vehicle: 0,
      plate: 0,
      engine: 0,
      notes: "",
      pics: ""
    },
    SetDark: {
      type: Boolean
    }
  },
  setup (props) {

    const $q = useQuasar()
    const Store = useStore()
    let timer

    onBeforeUnmount(() => {
      if (timer !== void 0) {
        clearTimeout(timer)
        $q.loading.hide()
      }
    })


    const IsOut = ref(false)

    const SetDark = inject("SetDark")

    const type = computed(() => Store.getters['garage/GetType'])

    const CheckForMoney = (plate) => {
      axios.post(`https://${GetCurrentResourceName()}/PayImpound`).then(function (HasMoney) { // GETTING THE MONEY FROM THE PLAYER
        if (HasMoney.data) {
          $q.notify({
            color: 'primary',
            textColor: 'white',
            icon: 'mdi-check-decagram',
            message: 'You pay $2000 for your car',
            position: 'top',
            multiLine: true,
            timeout: 2000
          })
          Store.dispatch('garage/DeleteVeh', plate) //DELETING THE VEHICLE WITH THE PLATE....
          axios.post('https://fx-garage/OutVehicle', JSON.stringify({ plate: plate, type: type.value })) // SENDING THE INFORMATION TO LUA
        } else {
          $q.notify({
            color: 'primary',
            textColor: 'white',
            icon: 'mdi-check-decagram',
            message: 'Not Enought Money',
            position: 'top',
            multiLine: true,
            timeout: 2000
          })
        }
      })




   
    }


    const veh = {
      body: props.veh.body,
      engine: props.veh.engine,
      vehicle: props.veh.vehicle,
      plate: props.veh.plate,
      fuel: props.veh.fuel,
      notes: props.veh.notes,
      pics: props.veh.pics
    }

    return {
      veh,
      SetDark,
      IsOut,
      CheckForMoney,
    }
  }
}
</script>

<style>
</style>
