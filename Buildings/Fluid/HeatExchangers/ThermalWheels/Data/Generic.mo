within Buildings.Fluid.HeatExchangers.ThermalWheels.Data;
record Generic "Generic data record for thermal wheels"
  extends Modelica.Icons.Record;

  parameter Boolean have_latHEX=true
   "Set to true to compute latent heat exchange";
  parameter Boolean use_defaultMotorEfficiencyCurve=true
   "Set to true to use default motor efficiency curve"
    annotation (Dialog(enable=have_varSpe));
  parameter Boolean have_varSpe=true
   "Set to true for the heat recovery wheel with a variable speed drive";
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal
    "Nominal supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mExh_flow_nominal
    "Nominal exhaust air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpSup_nominal(displayUnit="Pa")=500
    "Nominal supply air pressure drop across the heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpExh_nominal(displayUnit="Pa")=dpSup_nominal
    "Nominal exhaust air pressure drop across the heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Real P_nominal(final unit="W")=100
    "Power consumption at the design condition"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsSen_nominal(
    final max=1)=0.8
    "Nominal sensible heat exchanger effectiveness"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsSenPL(
    final max=1)=0.75
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsLat_nominal(
    final max=1)=0.8
    "Nominal latent heat exchanger effectiveness"
    annotation (Dialog(group="Nominal condition",
                       enable=have_latHEX));
  parameter Modelica.Units.SI.Efficiency epsLatPL(
    final max=1)=0.75
    "Part load (75% of the nominal supply mass flow rate) latent heat exchanger effectiveness"
    annotation (Dialog(group="Part load effectiveness",
                       enable=have_latHEX));
  parameter Characteristics.HeatExchangerEffectiveness senEff(
    uSpe={0},
    epsCor={0.7})
    "Multiplication factor for sensible heat exchange effectiveness due to wheel speed ratio between 0 and 1"
    annotation (Dialog(group="Heat exchange effectiveness computation",
                       enable=have_varSpe));
  parameter Characteristics.HeatExchangerEffectiveness latEff(
    uSpe={0},
    epsCor={0.7})
    "Multiplication factor for latent heat exchange effectiveness due to wheel speed ratio between 0 and 1"
    annotation (Dialog(group="Heat exchange effectiveness computation",
                       enable=have_latHEX and have_varSpe));
  parameter Characteristics.MotorEfficiency motorEfficiency(
    uSpe={0},
    eta={0.7})
    "Motor efficiency versus wheel speed ratio"
    annotation (Dialog(group="Power computation",
    enable=have_varSpe));
  final parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_default=Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
      P_nominal=P_nominal,
      eta_max=1)
    "Motor efficiency versus default wheel speed ratio"
    annotation (Dialog(group="Power computation"));

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing performance-related parameters for thermal wheels.
</p>
<p>
It is used as a template of performance data
for the thermal wheel models in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses</a>.
</p>
<p>
The record contains the parameters, including the nominal mass flow rates, nominal pressure drops, 
and the heat exchanger effectiveness at part load (75% of the nominal supply flow rate) and at nominal conditions.
</p>
<p>
For the variable-speed thermal wheel (<code>have_varSpe=true</code>), the record also includes the following datasets:
</p>
<ul>
<li>
the motor efficiency versus wheel speed ratio,
</li>
<li>
the default motor percent full-load
efficiency (see <a href=
\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>)
versus wheel speed ratio,
</li>
<li>
the sensible heat exchange effectiveness
corrections versus wheel speed ratio, and
</li>
<li>
the latent heat exchange effectiveness
corrections versus wheel speed ratio.
</li>
</ul>
<p>
Note the following:
</p>
<ul>
<li>
The heat exchange effectiveness
corrections versus wheel speed ratio are correction factors that are multiplied
with the heat exchange effectiveness that the wheel has a full rotational speed.
</li>
<li>
When <code>have_latHEX=true</code>,
the dataset of the latent heat exchange effectiveness
corrections versus wheel speed ratio is enabled,
</li>
<li>
When <code>use_defaultMotorEfficiencyCurve=true</code>,
the motor efficiency versus wheel speed ratio is disabled,
and the default motor percent full-load
efficiency versus wheel speed ratio is enabled.
</li>
</ul>
</html>"));
end Generic;
