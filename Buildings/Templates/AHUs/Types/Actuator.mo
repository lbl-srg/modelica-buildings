within Buildings.Experimental.Templates.AHUs.Types;
type Actuator = enumeration(
    None
    "No actuator",
    TwoWayValve
    "Two-way valve",
    ThreeWayValve
    "Three-way valve",
    PumpedCoilTwoWayValve
    "Pumped coil with two-way valve",
    PumpedCoilThreeWayValve
    "Pumped coil with three-way valve") "Enumeration to configure the actuator";
