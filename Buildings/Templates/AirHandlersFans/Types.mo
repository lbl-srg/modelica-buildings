within Buildings.Templates.AirHandlersFans;
package Types "Package with type definitions"
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
  type ControlFanReturn = enumeration(
      AirflowMeasured
      "Airflow tracking with airflow measurement stations",
      BuildingPressure
      "Building pressure (via discharge static pressure)")
    "Enumeration to configure the return fan control";
  // RFE: Add support for heat recovery.
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
  type OutdoorReliefReturnSection = enumeration(
      HundredPctOutdoorAir
      "100 % outdoor air system",
      MixedAirWithDamper
      "Mixed air system with return air damper - Optional economizer function",
      MixedAirNoDamper
      "Mixed air system without return air damper - No economizer function",
      MixedAirNoRelief
      "Mixed air system without relief branch - Optional economizer function")
    "Enumeration to configure the outdoor/relief/return air section";
  /* RFE: Add support for the following configurations.
      Barometric
        "Barometric relief damper without fan",
  */
  type ReliefReturnSection = enumeration(
      NoRelief
      "No relief branch",
      NoReturn
      "No return branch",
      ReliefDamper
      "Modulating relief damper without fan",
      ReliefFan
      "Relief fan with two-position relief damper",
      ReturnFan
      "Return fan with modulating relief damper")
    "Enumeration to configure the relief/return air section";
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
