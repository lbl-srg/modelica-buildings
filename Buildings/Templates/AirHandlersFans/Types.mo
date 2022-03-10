within Buildings.Templates.AirHandlersFans;
package Types "AHU types"
  extends Modelica.Icons.TypesPackage;
  type Configuration = enumeration(
      SupplyOnly
      "Supply only system",
      ExhaustOnly
      "Exhaust only system",
      DualDuct
      "Dual duct system with supply and return",
      SingleDuct
      "Single duct system with supply and return")
    "Enumeration to configure the AHU";
  type Controller = enumeration(
      G36VAVMultiZone
      "Guideline 36 controller for multiple-zone VAV",
      OpenLoop
      "Open loop controller")
    "Enumeration to configure the AHU controller";
  type ControlEconomizer = enumeration(
      FixedDryBulb
      "Fixed dry bulb",
      DifferentialDryBulb
      "Differential dry bulb",
      FixedDryBulbWithDifferentialDryBulb
      "Fixed dry bulb with differential dry bulb",
      FixedEnthalpyWithFixedDryBulb
      "Fixed enthalpy with fixed dry bulb",
      DifferentialEnthalpyWithFixedDryBulb
      "Differential enthalpy with fixed dry bulb")
    "Enumeration to configure the economizer control";
  type ControlFanReturn = enumeration(
      AirflowCalculated
      "Calculated based on return fan speed (requires constant flow characteristic) and
    VAV box air flow rates",
      AirflowTracking
      "Airflow tracking",
      BuildingPressure
      "Building pressure (via discharge static pressure)")
    "Enumeration to configure the return fan control";
  type HeatRecovery = enumeration(
      None
      "No heat recovery",
      FlatPlate
      "Flat plate heat exchanger",
      EnthalpyWheel
      "Enthalpy wheel",
      RunAroundCoil
      "Run-around coil")
    "Enumeration to configure the heat recovery";
  type Location = enumeration(
      OutdoorAir,
      MinimumOutdoorAir,
      Relief,
      Return,
      Supply,
      Terminal)
  "Enumeration to specify the equipment location";
  type OutdoorSection = enumeration(
      DedicatedDampersAirflow
      "Separate dedicated OA dampers with AFMS",
      DedicatedDampersPressure
      "Separate dedicated OA dampers with differential pressure sensor",
      NoEconomizer
      "No economizer",
      SingleDamper
      "Single common OA damper with AFMS")
    "Enumeration to configure the outdoor air section";
  type OutdoorReliefReturnSection = enumeration(
      Economizer
      "Air economizer",
      EconomizerNoRelief
      "Air economizer without relief branch",
      NoEconomizer
      "No air economizer")
    "Enumeration to configure the outdoor/relief/return air section";
  type ReliefReturnSection = enumeration(
      NoEconomizer
      "No economizer",
      NoRelief
      "No relief branch",
      Barometric
      "Barometric relief damper without fan",
      ReliefDamper
      "Modulating relief damper without fan",
      ReliefFan
      "Relief fan with two-position relief damper",
      ReturnFan
      "Return fan with modulating relief damper")
    "Enumeration to configure the relief/return air section";
end Types;
