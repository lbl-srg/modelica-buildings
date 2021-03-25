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
      SupplyReturn
      "Supply and return system") "Enumeration to configure the AHU";
  type Coil = enumeration(
      DirectExpansion
      "Direct expansion",
      None
      "No economizer",
      WaterBased
      "Water-based coil")
    "Enumeration to configure the coil";
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
  type ReliefReturn = enumeration(
      NoEconomizer
      "No economizer",
      Barometric
      "No relief fan - Barometric relief damper",
      ReliefDamper
      "No relief fan - Modulated relief damper",
      ReliefFan
      "Relief fan - Two-position relief damper",
      ReturnFanPressure
      "Return fan with pressure control - Modulated relief damper",
      ReturnFanAirflow
      "Return fan with airflow tracking - Modulated relief damper")
    "Enumeration to configure the exhaust/relief/return section";
  type HeatExchanger = enumeration(
      DXMultiStage
      "Direct expansion - Multi-stage",
      DXVariableSpeed
      "Direct expansion - Variable speed",
      WetCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry/wet coil",
      DryCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry coil",
      WetCoilCounterFlow
      "Water based - Discretized",
      None
      "None")
    "Enumeration to configure the HX";
  type HeatExchangerDX = enumeration(
      DXMultiStage
      "Direct expansion - Multi-stage",
      DXVariableSpeed
      "Direct expansion - Variable speed")
    "Enumeration to configure the HX";
  type HeatExchangerWater = enumeration(
      WetCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry/wet coil",
      DryCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry coil",
      WetCoilCounterFlow
      "Water based - Discretized")
    "Enumeration to configure the HX";
  type Economizer = enumeration(
      None
      "No economizer",
      CommonDamperTandem
      "Single common OA damper - Dampers actuated in tandem",
      DedicatedDamperTandem
      "Separate dedicated OA damper - Dampers actuated in tandem",
      CommonDamperFree
      "Single common OA damper - Dampers actuated individually",
      CommonDamperFreeNoRelief
      "Single common OA damper - Dampers actuated individually, no relief")
    "Enumeration to configure the economizer";
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
  type FanSupplyPosition = enumeration(
      BlowThrough
      "Blow-through (upstream position)",
      DrawThrough
      "Draw-through (downstream position)")
    "Enumeration to configure the supply fan position";
  type OutdoorAir = enumeration(
      NoEconomizer
      "No economizer",
      SingleCommon
      "Single common OA damper (modulated) with AFMS",
      DedicatedPressure
      "Dedicated minimum OA damper (two-position) with differential pressure sensor",
      DedicatedAirflow
      "Dedicated minimum OA damper (modulated) with AFMS")
    "Enumeration to configure the outdoor air section";
  type Return = enumeration(
      NoRelief
      "No air relief",
      WithRelief
      "With air relief")
    "Enumeration to configure the return/exhaust branch";
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
  type Supply = enumeration(
      SingleDuct
      "Single duct system",
      DualDuct
      "Dual duct system")
    "Enumeration to configure the supply branch";
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
end Types;
