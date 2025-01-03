within Buildings.Fluid.HeatExchangers.ThermalWheels.Data;
record Generic "Generic data record for variable-speed wheels"
  extends Modelica.Icons.Record;

  parameter Real P_nominal(final unit="W")=100
    "Power consumption at the design condition";
  parameter Characteristics.HeatExchangerEffectiveness senHeatExchangeEffectiveness(
    uSpe={0},
    epsCor={0.7})
    "Multiplication factor for sensible heat exchange effectiveness due to wheel speed ratio between 0 and 1"
    annotation (Dialog(group="Heat exchange effectiveness computation"));
  parameter Characteristics.HeatExchangerEffectiveness latHeatExchangeEffectiveness(
    uSpe={0},
    epsCor={0.7})
    "Multiplication factor for latent heat exchange effectiveness due to wheel speed ratio between 0 and 1" annotation (
      Dialog(group="Heat exchange effectiveness computation", enable=
          haveLatentHeatExchange));
  parameter Characteristics.MotorEfficiency motorEfficiency(
    uSpe={0},
    eta={0.7})
    "Motor efficiency versus wheel speed ratio"
    annotation (Dialog(group="Power computation", enable=useDefaultMotorEfficiencyCurve ==
      false));
  final parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_default=Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
      P_nominal=P_nominal,
      eta_max=1)
    "Motor efficiency versus default wheel speed ratio"
    annotation (Dialog(group="Power computation", enable=useDefaultMotorEfficiencyCurve ==
      true));
  parameter Boolean haveLatentHeatExchange = true
   "Set to true to compute latent heat exchange";
  parameter Boolean useDefaultMotorEfficiencyCurve = true
   "Set to true to use default motor efficiency curve";

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
Record containing power and heat exchange parameters for variable-speed thermal wheels.
</p>
<p>
It is used as a template of performance data
for the variable-speed wheel models in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses</a>.
</p>
<p>
The record contains four datasets:
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
When <code>haveLatentHeatExchange = true</code>,
the dataset of the latent heat exchange effectiveness
corrections versus wheel speed ratio is enabled,
</li>
<li>
When <code>useDefaultMotorEfficiencyCurve = true</code>,
the motor efficiency versus wheel speed ratio is disabled,
and the default motor percent full-load
efficiency versus wheel speed ratio is enabled.
</li>
</ul>
</html>"));
end Generic;
