import axios from "axios";
import { IS_DEV } from "./config";
export function SendNuiWithParams (call, data) {
  if (!IS_DEV) {
    if (data) {
      axios.post(`https://qb-garages/${call}`, JSON.stringify(data))
    } else {
      SendNui(call)
    }
  }
}
export function SendNui (call) {
  if (!IS_DEV) axios.post(`https://qb-garages/${call}`)
}

export const SendNuiReturning = (call, data) => {
  if (!IS_DEV) {
    if (data != null || data != undefined || data != "") {
      axios.post(`https://qb-garages/${call}`, JSON.stringify(data)).then(function (respuesta) {
        if (respuesta.status == 200) {
          console.log(`Respuesta IF ${respuesta.data}`);
          return respuesta.data
        }
      })
    } else {
      axios.post(`https://qb-garages/${call}`).then(function (respuesta) {
        if (respuesta.status == 200) {
          console.log(`Respuesta Else ${respuesta.data}`);
          return respuesta.data
        }
      })

    }
  } else {
    return true
  }
}