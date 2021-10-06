within Buildings.Templates;
package Types "AHU types"
  extends Modelica.Icons.TypesPackage;
  type Actuator = enumeration(
      None
      "No valve",
      TwoWayValve
      "Two-way valve",
      ThreeWayValve
      "Three-way valve",
      PumpedCoilTwoWayValve
      "Pumped coil with two-way valve",
      PumpedCoilThreeWayValve
      "Pumped coil with three-way valve")
    "Enumeration to configure the actuator";
  type AHU = enumeration(
      SupplyOnly
      "Supply only system",
      ExhaustOnly
      "Exhaust only system",
      DualDuct
      "Dual duct system with supply and return",
      SingleDuct
      "Single duct system with supply and return")
      "Enumeration to configure the AHU";
  type Chiller = enumeration(
      ElectricChiller
      "Electric water cooled chiller",
      AbsorptionChiller
      "Absorption chiller");
  type ChillerGroup = enumeration(
      ChillerParallel
      "Chillers in parallel",
      ChillerSeries
      "Chillers in series");
  type ChilledWaterPlant = enumeration(
      WaterCooledChiller
      "Water cooled chiller plant",
      AirCooledChiller
      "Air cooled chiller plant");
  type ControllerAHU = enumeration(
      Guideline36
      "Guideline 36 control sequence",
      OpenLoop
      "Open loop")
      "Enumeration to configure the AHU controller";
  type ControllerTU = enumeration(
      Guideline36
      "Guideline 36 control sequence",
      OpenLoop
      "Open loop")
      "Enumeration to configure the terminal unit controller";
  type Coil = enumeration(
      DirectExpansion
      "Direct expansion",
      None
      "No coil",
      WaterBased
      "Water-based coil")
    "Enumeration to configure the coil";
  type CoolingTowerGroup = enumeration(
      CoolingTowerParallel
      "Cooling towers in parallel");
  type Damper = enumeration(
      NoPath
      "No fluid path",
      Barometric
      "Barometric damper",
      Modulated
      "Modulated damper",
      None
      "No damper",
      PressureIndependent
      "Pressure independent damper",
      TwoPosition
      "Two-position damper")
    "Enumeration to configure the damper";
  type HeatExchanger = enumeration(
      None
      "No heat exchanger",
      DXMultiStage
      "Direct expansion - Multi-stage",
      DXVariableSpeed
      "Direct expansion - Variable speed",
      WetCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry/wet coil",
      DryCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry coil",
      WetCoilCounterFlow
      "Water based - Discretized")
    "Enumeration to configure the heat exchanger";
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
  type Fan = enumeration(
      None
      "No fan",
      SingleConstant
      "Single fan - Constant speed",
      SingleTwoSpeed
      "Single fan - Two speed",
      SingleVariable
      "Single fan - Variable speed",
      MultipleConstant
      "Multiple fans (identical) - Constant speed",
      MultipleTwoSpeed
      "Multiple fans (identical) - Two speed",
      MultipleVariable
      "Multiple fans (identical) - Variable speed")
    "Enumeration to configure the fan";
  type Location = enumeration(
      OutdoorAir,
      MinimumOutdoorAir,
      Relief,
      Return,
      Supply,
      Terminal,
      CondenserWaterSupply,
      CondenserWaterReturn,
      ChilledWaterSupply,
      ChilledWaterReturn)
    "Enumeration to specify the equipment location";
  type OutdoorSection = enumeration(
      NoEconomizer
      "No economizer",
      SingleCommon
      "Single common OA damper (modulated) with AFMS",
      DedicatedPressure
      "Dedicated minimum OA damper (two-position) with differential pressure sensor",
      DedicatedAirflow
      "Dedicated minimum OA damper (modulated) with AFMS")
    "Enumeration to configure the outdoor air section";
  type OutdoorReliefReturnSection = enumeration(
      Economizer
      "Air economizer",
      HeatRecovery
      "Heat recovery",
      NoRelief
      "No relief branch")
    "Enumeration to configure the outdoor/relief/return air section";
  type Pump = enumeration(
      Pump "Pump");
  type PumpGroup = enumeration(
      HeaderedPump
      "Headered pumps",
      None "None");
  type ReliefReturnSection = enumeration(
      NoEconomizer
      "No economizer",
      NoRelief
      "No relief branch",
      Barometric
      "No relief fan - Barometric relief damper",
      ReliefDamper
      "No relief fan - Modulated relief damper",
      ReliefFan
      "Relief fan - Two-position relief damper",
      ReturnFan
      "Return fan - Modulated relief damper")
    "Enumeration to configure the relief/return air section";
  type ReturnFanControlSensor = enumeration(
      None
      "Not applicable",
      Airflow
      "Airflow tracking",
      Pressure
      "Direct building pressure (via discharge static pressure)")
    "Enumeration to configure the sensor used for return fan control";
  type Sensor = enumeration(
      DifferentialPressure
      "Differential pressure",
      HumidityRatio
      "Humidity ratio",
      None
      "None",
      PPM
      "PPM",
      RelativeHumidity
      "Relative humidity",
      SpecificEnthalpy
      "Specific enthalpy",
      Temperature
      "Temperature",
      VolumeFlowRate
      "Volume flow rate")
    "Enumeration to configure the sensor";
  type TerminalUnit = enumeration(
      SingleDuct
      "Single duct system",
      DualDuct
      "Dual duct system",
      FanPowered
      "Fan-powered system",
      Induction
      "Induction system")
    "Enumeration to configure the terminal unit";
  type Valve = enumeration(
      None "No valve",
      Linear "Linear two-way valve",
      EqualPercentage "Equal percentage two-way valve");
  type ChilledWaterReturnSection = enumeration(
      NoEconomizer "No waterside economizer",
      WatersideEconomizer
      "Waterisde economizer");
end Types;
