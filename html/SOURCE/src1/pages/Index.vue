<template>
  <div>
    <q-badge
      class="q-ml-sm"
      color="blue"
    >
      v1.0 By JericoFX
    </q-badge>
    <div
      class="no-margin absolute-right"
      style="left:90%;"
    >
      <q-btn
        flat
        :color=" SetDark ? 'white':'dark'"
        @click="
      SetDark=!SetDark"
        icon="mdi-brightness-6"
      />
      <q-btn
        flat
        :color=" SetDark ? 'white':'dark'"
        icon="mdi-translate"
        @click="radio"
      />
    </div>

  </div>

  <div
    class="vehbody bg-grey-5 hide-scrollbar"
    style="overflow-y:scroll; "
  >
    <div v-if="IsImpounded">
      <div v-if="Impounded.length > 0">
        <div
          class="Jere  q-pr-lg q-pt-sm q-pb-sm"
          v-for="veh in Impounded"
          :key="veh.plate"
        >
          <VehicleList :veh="veh" />
        </div>
      </div>
      <div v-else>
        <NoVehicle />
      </div>
    </div>
    <div v-else>
      <div v-if="prefetch.length > 0">
        <div
          class="Jere q-pr-lg q-pt-sm q-pb-sm"
          v-for="veh in prefetch"
          :key="veh.plate"
        >
          <VehicleList :veh="veh" />
        </div>
      </div>
      <div v-else>
        <NoVehicle />
      </div>
    </div>
  </div>

</template>

<script>
import { defineComponent, computed, ref, provide } from 'vue';
import { useStore } from 'vuex'
import NoVehicle from './vehicles/NoVehicles.vue'
import VehicleList from './vehicles/VehicleList.vue'

import { useQuasar } from 'quasar'
import { useI18n } from 'vue-i18n'
export default defineComponent({
  name: 'PageIndex',
  components: { NoVehicle, VehicleList },
  setup () {
    const { locale, t } = useI18n({ useScope: 'global' })

    const $q = useQuasar() //Call Quasar

    const SetDark = ref(false)

    const Store = useStore()

    provide("SetDark", SetDark)

    const counter = computed(() => {
      return Store.state.garage.Vehicles
    })

    function radio () {
      $q.dialog({
        title: t('lang'),
        message: t('loption'),
        dark: SetDark.value,
        options: {
          type: 'radio',
          model: locale.value,
          // inline: true
          items: [
            { label: 'English', value: 'en-US', color: 'secondary' },
            { label: 'Spanish', value: 'es' },
          ]
        },
        cancel: true,
        persistent: true
      }).onOk(data => {
        locale.value = data
      }).onCancel(() => {
        // //console.log('>>>> Cancel')
      }).onDismiss(() => {
        // //console.log('I am triggered on both OK and Cancel')
      })
    }

    return {
      counter,
      SetDark,
      prefetch: computed(() => {
        return Store.getters['garage/GetGaragesVehicles']
      }),
      Impounded: computed(() => Store.getters['garage/GetImpoundedVehicles']),
      IsImpounded: computed(() => Store.state.garage.Impound),
      radio
    }
  }
})
</script>
<style scoped>
.vehbody {
  position: absolute;
  width: 1237px;
  height: 553px;
  left: 68px;
  top: 176px;
  border-radius: 10px;
}
</style>