within Buildings.Fluid.ZoneEquipment.Data;
record FCUSizing3

  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal = 0.205
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal = 0.137
    "Nominal hot water mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal = 1.225 * 0.419361
    "Nominal supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal = 1.225 * 0.02832
    "Nominal outdoor air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TChiWatSup_nominal = 273.15 + 7.22
    "Nominal chilled water supply temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature THotWatSup_nominal = 273.15 + 82.2
    "Nominal hot water supply temperature"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal = 146.06
    "Thermal conductance at nominal flow, used to compute heating capacity"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal = 146.06
    "Thermal conductance at nominal flow, used to compute cooling capacity"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Pressure pAir = 101325
    "Pressure of air";

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirIn_nominal = 273.15 + 24.46
    "Nominal cooling coil inlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirIn_nominal = 0.009379
    "Inlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirOut_nominal = 273.15 + 7.22
    "Nominal cooling coil inlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirOut_nominal = 0.009
    "Inlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

// protected
  parameter Modelica.Units.SI.SpecificEnthalpy hAirIn_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirIn_nominal, [humRatAirIn_nominal/(1+humRatAirIn_nominal), 1/(1+humRatAirIn_nominal)]))
    "Specific enthalpy of inlet air";

  parameter Modelica.Units.SI.SpecificEnthalpy hAirOut_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirOut_nominal, [humRatAirOut_nominal/(1+humRatAirOut_nominal), 1/(1+humRatAirOut_nominal)]))
    "Specific enthalpy of inlet air";

  parameter Modelica.Units.SI.Power qCooCoi_nominal = mAir_flow_nominal * (hAirIn_nominal - hAirOut_nominal)
    "Heat transferred in cooling coil";

  parameter Modelica.Media.Interfaces.PartialSimpleMedium.ThermodynamicState stateChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.setState_pTX(pAir, TChiWatSup_nominal)
    "Thermodynamic state for chilled water at coil inlet";

  parameter Modelica.Units.SI.SpecificEnthalpy hChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.specificEnthalpy(stateChiWatIn_nominal)
    "Chilled water inlet specific enthalpy";

  parameter Modelica.Units.SI.SpecificEnthalpy hChiWatOut_nominal = (mChiWat_flow_nominal * hChiWatIn_nominal + qCooCoi_nominal)/mChiWat_flow_nominal
    "Chilled water outlet specific enthalpy";

  parameter Real delH_lmd = -((hAirIn_nominal - hChiWatOut_nominal) - (hAirOut_nominal - hChiWatIn_nominal)/log(((hAirIn_nominal - hChiWatOut_nominal)/(hAirOut_nominal - hChiWatIn_nominal))))
    "Log mean enthalpy difference";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_air = 1000;

  parameter Modelica.Units.SI.ThermalConductance UACooCoiExt_nominal = cp_air * qCooCoi_nominal/delH_lmd;

  parameter Modelica.Units.SI.ThermalConductance UACooCoiTot_nominal = 1/(1/UACooCoiExt_nominal + 1/(3.3*UACooCoiExt_nominal));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end FCUSizing3;
