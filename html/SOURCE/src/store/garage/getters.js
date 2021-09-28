
export function GetGaragesVehicles (state) {
  return state.Vehicles.filter(item => item.state == 1)
}

export function GetImpoundedVehicles (state) {
  return state.Vehicles.filter(item => item.state == 2)
}
export function GetGarageName (state) {
  return state.GarageTitle
}
export function GetType (state) {
  return state.type
}
export function Garage (state) {
  return state.Garage
}

