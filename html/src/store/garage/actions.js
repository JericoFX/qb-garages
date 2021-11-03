export function DeleteVeh (context, payload) {
  context.commit('DeleteVehicle', payload)
}
export function GarageTitle (context, payload) {
  context.commit('ChangeGarageName', payload)
}
export function ChangeImpoundState (context, payload) {
  context.commit('ChangeImpoundState', payload)
}
export function SetVehicles (context, payload) {
  context.commit('SetVehicles', payload)
}

export function SetType (context, payload) {
  context.commit('SetType', payload)
}
export function Garage (context, payload) {
  context.commit('Garage', payload)
}




