export function DeleteVehicle (state, vehicle) {
  state.Vehicles = state.Vehicles.filter(item => item.plate != vehicle)
}
export function ChangeGarageName (state, name) {
  state.GarageTitle = name
}
export function ChangeImpoundState (state, name) {
  state.Impound = name
}
export function SetVehicles (state, name) {
  state.Vehicles = name
}
export function SetType (state, name) {
  state.type = name
}
export function Garage (state, name) {
  state.Garage = name
}
