within Buildings.Fluid.Humidifiers.EvaporativePads.Data;
record Generic "Generic data record for an evaporative pad"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiencyParameters
    efficiency(v={0,2.5,5}, eta={0.89,0.8,0.72}) "Saturation efficiency vs. air velocity";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")=200
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.Velocity v_nominal=5
    "Nominal air velocity";
  parameter Real n(min=1, max=2)=1.8
    "Flow exponent for the pressure drop of air, n=1 for laminar, n=2 for turbulent";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing parameters for evaporative pads.
</p>
<h4>Typical use</h4>
<p>
This record may be used to assign evaporative pad performance data using declaration
such as:
</p>
<pre>
  Buildings.Fluid.Humidifiers.EvaporativePads.Direct dirEvaCoo(
    redeclare package Medium = MediumA,
    per(efficiency(v={0,v_nominal,2*v_nominal},
                   eta={1.1*eta_nominal,eta_nominal,0.9*eta_nominal}),
        dp_nominal=1*dp_nominal,
        v_nominal=1*v_nominal,
        n=1.8));
</pre>
<p>
This record provides performance data for both the saturation efficiency and the
pressure drop of an evaporative pad. 
</p>
<p>
For saturation efficiency, a discrete list of data points of the air velocity
flowing through the evaporative pad <i>v</i> (independent variable), as well as a
discrete list of corresponding data points of the saturation efficiency <i>eta</i>
(dependent variable), are provided. 
</p>
<p>
For pressure drop, only a single nominal pressure drop value <i>dp_nominal</i>, a
single nominal air velocity value <i>v_nominal</i>, and a single flow exponent value
for pressure drop <i>n</i> are provided.
</p>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Direct\">
Buildings.Fluid.Humidifiers.EvaporativePads.Direct</a>.
</p>
</html>"));
end Generic;
