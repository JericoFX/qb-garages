<template>
  <q-item-section class="">
    <div class="text-h6 q-ml-xl">
      <q-item-label>
        <q-item-label>
          <q-btn
            class="q-py-lg"
            flat
            icon="mdi-police-badge"
            label="Notes"
            @click="logthis = !logthis"
          />

          <q-separator
            spaced
            inset
            vertical
            dark
          />
        </q-item-label>

        <q-dialog v-model="logthis">
          <q-card
            flat
            :dark="Plate"
            :style="Url !== '' ? style : ''"
          >
            <q-card-section>
              <div class="text-h6">Notes</div>
            </q-card-section>
            <q-card-section>
              <div v-if="Url2.length">
                <q-img
                  :src="Url2"
                  spinner-color="primary"
                  spinner-size="82px"
                  width="1400px"
                  height="700px"
                >
                  <div class="absolute-bottom text-subtitle1 text-center">
                    {{Notes}}
                  </div>
                </q-img>
              </div>
            </q-card-section>
            <q-card-actions align="center">
              <q-btn
                flat
                label="OK"
                color="primary"
                v-close-popup
                class="q-pa-sm"
              />
            </q-card-actions>
          </q-card>
        </q-dialog>
      </q-item-label>
    </div>
  </q-item-section>
</template>

<script>
import { ref, computed, inject } from 'vue';

export default {
  props: {
    pics: String,
    notes: String
  },
  setup (props) {
    const re = /"/g
    let Url = props.pics
    const Plate = inject("SetDark")
    const logthis = ref(false)
    const style = {
      maxWidth: '1660px',
      maxHeight: '876px'
    }

    const ReturnUrl = computed(() => {
      if (Url !== "") {
        Url = JSON.parse(props.pics)
      }
      return (Url)

    })


    const Url2 = ReturnUrl.value.replace(re, '')
    return {
      Notes: props.notes,
      logthis,
      Url,
      Url2,
      Plate,
      style
    }
  }
}
</script>

<style>
</style>