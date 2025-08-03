within Buildings.Fluid.Dehumidifiers.Desiccant.Data;
record Generic "Generic data record for desiccant dehumidifiers"
  extends Modelica.Icons.Record;
  parameter Boolean have_varSpe=true
   "Set to true for the wheel with a variable speed drive";
  parameter Boolean use_defaultMotorEfficiencyCurve=true
   "Set to true to use default motor efficiency curve"
    annotation (Dialog(enable=have_varSpe));
  parameter Real uSpe_min=0.1
    "Minimum allowable wheel speed ratio"
    annotation (Dialog(enable=have_varSpe));
  parameter Modelica.Units.SI.MassFlowRate mPro_flow_nominal
    "Nominal process air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mReg_flow_nominal
    "Nominal regeneration air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpPro_nominal(
    displayUnit="Pa")=250
    "Nominal process air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpReg_nominal(
    displayUnit="Pa")=250
    "Nominal regeneration air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Velocity vPro_nominal=2.5
    "Nominal velocity of the process air"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TRegEnt_nominal
    "Nominal temperature of the regeneration air entering the dehumidifier"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TProEnt_max
    "Maximum allowable temperature of the process air entering the dehumidifier"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TProEnt_min
    "Minimum allowable temperature of the process air entering the dehumidifier"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFraction X_w_ProEnt_max
    "Maximum allowable humidity ratio of the process air entering the dehumidifier"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFraction X_w_ProEnt_min(
     final min=0)
    "Minimum allowable humidity ratio of the process air entering the dehumidifier"
    annotation (Dialog(group="Nominal condition"));
  parameter Real a[16]
    "Coefficients for calculating the temperature of the process air leaving the dehumidifier";
  parameter Real b[16]
    "Coefficients for calculating the humidity ratio of the process air leaving the dehumidifier";
  parameter Real c[16]
    "Coefficients for calculating the velocity of the regeneration air";
  parameter Real d[16]
    "Coefficients for calculating the regeneration heat flow";
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness senEff(
     uSpe={0},
     epsCor={0.7})
    "Multiplication factor for sensible heat exchange effectiveness due to wheel speed ratio between 0 and 1"
    annotation (Dialog(group="Heat exchange effectiveness", enable=have_varSpe));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness latEff(
     uSpe={0},
     epsCor={0.7})
    "Multiplication factor for latent heat exchange effectiveness due to wheel speed ratio between 0 and 1"
    annotation (Dialog(group="Heat exchange effectiveness", enable=have_varSpe));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.MotorEfficiency relMotEff(
    uSpe={0},
    eta={0.7})
    "Ratio of the motor efficiency at give speed to the one when the speed is 1"
    annotation (Dialog(group="Power computation", enable=have_varSpe));
  final parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    relMotEff_default=Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
      P_nominal=P_nominal,
      eta_max=1)
    "Default relative motor efficiency"
    annotation (Dialog(group="Power computation"));
  parameter Real P_nominal(final unit="W")=10
    "Power consumption at the design condition"
    annotation (Dialog(group="Nominal condition"));

  annotation (Documentation(info="<html>
<p>This record is used as a template for performance data
for the desiccant dehumidifier models in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant\">
Buildings.Fluid.Dehumidifiers.Desiccant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
