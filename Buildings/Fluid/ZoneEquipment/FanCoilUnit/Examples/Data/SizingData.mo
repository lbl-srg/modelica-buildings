within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Examples.Data;
record SizingData "Sizing calculations and values for component parameters"

  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal = 0.207
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal = 0.137
    "Nominal hot water mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal = 1.225 * 0.422684
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

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal = 2.25*146.06
    "Thermal conductance at nominal flow, used to compute heating capacity"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Pressure pAir = 101325
    "Assumed pressure of air"
    annotation (Dialog(group="Assumed values"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirIn_nominal = 273.15 + 24.46
    "Nominal cooling coil inlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirIn_nominal(
    final unit="1",
    displayUnit="1") = 0.009379
    "Inlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirOut_nominal = 273.15 + 14
    "Nominal cooling coil outlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirOut_nominal(
    final unit="1",
    displayUnit="1") = 0.009
    "Outlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

// protected
  parameter Modelica.Units.SI.SpecificEnthalpy hAirIn_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirIn_nominal, [humRatAirIn_nominal/(1+humRatAirIn_nominal), 1/(1+humRatAirIn_nominal)]))
    "Specific enthalpy of inlet air"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.SpecificEnthalpy hAirOut_nominal = sum(Modelica.Media.Air.MoistAir.h_pTX(pAir, TCooCoiAirOut_nominal, [humRatAirOut_nominal/(1+humRatAirOut_nominal), 1/(1+humRatAirOut_nominal)]))
    "Specific enthalpy of outlet air"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.Power qCooCoi_nominal = mAir_flow_nominal * (hAirIn_nominal - hAirOut_nominal)
    "Heat transferred in cooling coil"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Media.Water.ConstantPropertyLiquidWater.ThermodynamicState stateChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.setState_pTX(pAir, TChiWatSup_nominal)
    "Thermodynamic state for chilled water at coil inlet"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.SpecificEnthalpy hChiWatIn_nominal = Modelica.Media.Water.ConstantPropertyLiquidWater.specificEnthalpy(stateChiWatIn_nominal)
    "Chilled water inlet specific enthalpy"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.SpecificEnthalpy hChiWatOut_nominal = (mChiWat_flow_nominal * hChiWatIn_nominal + qCooCoi_nominal)/mChiWat_flow_nominal
    "Chilled water outlet specific enthalpy"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.SpecificEnthalpy delH_lmd = -((hAirIn_nominal - hChiWatOut_nominal) - (hAirOut_nominal - hChiWatIn_nominal)/log(abs((hAirIn_nominal - hChiWatOut_nominal)/(hAirOut_nominal - hChiWatIn_nominal))))
    "Log mean enthalpy difference"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_air = 1000
    "Assumed specific heat capacity of air"
    annotation (Dialog(group="Assumed values"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoiExt_nominal = cp_air * qCooCoi_nominal/delH_lmd
    "Calculated value of external UA for the cooling coil"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Real UACorrectionFactor(
    final unit="1",
    displayUnit="1") = 3.5
    "Correction factor for cooling-coil UA value to make the coil outlet temperature
    and energy consumption match"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoiTot_nominal = UACorrectionFactor*1/(1/UACooCoiExt_nominal + 1/(3.3*UACooCoiExt_nominal))
    "Calculated value of total UA for the cooling coil"
    annotation(Dialog(enable=false, tab="Calculated parameters"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
      <p>
      Sizing data record based on EnergyPlus example file available in the Buildings library
      (modelica-buildings/Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.idf).
      The calculations for the UA values are derived from the EnergyPlus 
      Engineering Reference document.
      <br>
      The record is currently being used as an example for the UA calculations 
      required to translate the EnergyPlus cooling coil parameters to the Modelica 
      parameters. The exposed parameters for the cooling coil are the inputs used 
      for the EnergyPlus component and <code>UACooCoiTot_nominal</code> is the parameter
      being used on the Modelica component.
      <br>
      A correction factor <code>UACorrectionFactor</code> is currently being used
      to make the cooling coil outlet temperature and energy consumption match 
      with the reference value form Modelica.
      </p>
      </html>",   revisions="<html>
      <ul>
      <li>
      September 06, 2022, by Karthik Devaprasad:
      <br/>
      Initial version
      </li>
      </ul>
      </html>"));

end SizingData;
