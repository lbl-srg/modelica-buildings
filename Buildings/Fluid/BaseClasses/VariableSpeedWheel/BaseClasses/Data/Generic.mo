within Buildings.Fluid.BaseClasses.VariableSpeedWheel.BaseClasses.Data;
record Generic "Generic data record for wheels"
  extends Modelica.Icons.Record;
  import cha = Buildings.Fluid.BaseClasses.VariableSpeedWheel.BaseClasses.Characteristics;
  parameter Real P_nominal(final unit="W")=100
    "Power consumption at the design condition";
  parameter
    cha.effectivenessParameters
    senHeatExchangeEffectiveness(
      uSpe={0},
      epsCor={0.7})
    "Sensible heat exchange effectiveness vs. wheel speed ratio"
    annotation (Dialog(group="Heat exchange effectiveness computation"));
  parameter
    cha.effectivenessParameters
    latHeatExchangeEffectiveness(
      uSpe={0},
      epsCor={0.7})
    "Latent heat exchange effectiveness vs. wheel speed ratio"
    annotation (Dialog(group="Heat exchange effectiveness computation",
                enable=haveLatentHeatExchange));
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_uSpe(y={0}, eta={0.7})
    "Motor efficiency vs. wheel speed ratio"
    annotation (Dialog(group="Power computation", enable=useDefaultMotorEfficiencyCurve ==
      false));
  final parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_default=
    Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
         P_nominal=P_nominal,
         eta_max=1)
    "Motor efficiency vs. default wheel speed ratio"
    annotation (Dialog(group="Power computation", enable=useDefaultMotorEfficiencyCurve ==
      true));
  parameter Boolean haveLatentHeatExchange = true
   "= true, if latent heat exchange occurs";
  parameter Boolean useDefaultMotorEfficiencyCurve = true
   "= true, if default motor efficiency curve is adopted";

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing power and heat exchange parameters for wheels.
</p>
<p>
It is used as a template for performance data
for the variable-speed wheel models in
<a href=\"modelica://Buildings.Fluid.BaseClasses.VariableSpeedWheel\">
Buildings.Fluid.BaseClasses.VariableSpeedWheel</a>.
</p>
<p>
The record contains four curves:
</p>
<ul>
<li>
wheel speed ratio versus motor percent full-load 
efficiency
</li>
<li>
wheel speed ratio versus default motor percent full-load 
efficiency (see <a href=
\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>.)
</li>
<li>
wheel speed ratio versus sensible heat exchange effectiveness 
corrections
</li>
<li>
wheel speed ratio versus latent heat exchange effectiveness 
corrections
</li>
</ul>
<p>
Note that 
</p>
<ul>
<li>
When <code>haveLatentHeatExchange</code> is false,
the curve of wheel speed ratio versus latent heat exchange effectiveness 
corrections is disabled.
</li>
<li>
When <code>useDefaultMotorEfficiencyCurve</code> is true,
the curve of wheel speed ratio versus motor percent full-load 
efficiency is disabled while the curve of wheel speed ratio 
versus default motor percent full-load efficiency is enabled 
</li>
</ul>
</html>"));
end Generic;
