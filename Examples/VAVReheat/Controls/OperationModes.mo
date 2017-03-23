within Buildings.Examples.VAVReheat.Controls;
type OperationModes = enumeration(
    occupied "Occupied",
    unoccupiedOff "Unoccupied off",
    unoccupiedNightSetBack "Unoccupied, night set back",
    unoccupiedWarmUp "Unoccupied, warm-up",
    unoccupiedPreCool "Unoccupied, pre-cool",
    safety "Safety (smoke, fire, etc.)") "Enumeration for modes of operation";
