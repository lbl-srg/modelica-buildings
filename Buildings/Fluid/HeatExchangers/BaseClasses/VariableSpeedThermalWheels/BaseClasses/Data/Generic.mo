within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Data;
record Generic "Generic data record for variable-speed wheels"
  extends Modelica.Icons.Record;
  import cha = Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
  parameter Real P_nominal(final unit="W")=100
    "Power consumption at the design condition";
  parameter cha.heatExchangerEffectivenessParameters
    senHeatExchangeEffectiveness(uSpe={0}, epsCor={0.7})
    "Sensible heat exchange effectiveness vs. wheel speed ratio"
    annotation (Dialog(group="Heat exchange effectiveness computation"));
  parameter cha.heatExchangerEffectivenessParameters
    latHeatExchangeEffectiveness(uSpe={0}, epsCor={0.7})
    "Latent heat exchange effectiveness vs. wheel speed ratio" annotation (
      Dialog(group="Heat exchange effectiveness computation", enable=
          haveLatentHeatExchange));
  parameter
    cha.motorEfficiencyParameters
    motorEfficiency(uSpe={0}, eta={0.7})
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
Record containing power and heat exchange parameters for variable-speed thermal wheels.
</p>
<p>
It is used as a template of performance data
for the variable-speed wheel models in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels\">
Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels</a>.
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
corrections versus wheel speed ratio,
</li>
<li>
the latent heat exchange effectiveness
corrections versus wheel speed ratio .
</li>
</ul>
<p>
Note that 
</p>
<ul>
<li>
When <code>haveLatentHeatExchange</code> is false,
the dataset of the latent heat exchange effectiveness
corrections versus wheel speed ratio is disabled,
</li>
<li>
When <code>useDefaultMotorEfficiencyCurve</code> is true,
the motor efficiency versus wheel speed ratio is disabled 
while the default motor percent full-load 
efficiency versus wheel speed ratio is enabled. 
</li>
</ul>
</html>"));
end Generic;
