within Buildings.Fluid.Humidifiers.EvaporativePads.Data;
record Generic "Generic data record for evaporative pads"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiencyParameters
    efficiency(v={0}, eta={0.7}) "Saturation efficiency vs. air speed";

  parameter
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.pressureParameters
    pressure(v={0}, dp={20}) "Pressure drop vs. air speed";

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
such as
</p>
<pre>
  Buildings.Fluid.Humidifiers.EvaporativePads.Direct dirEvaCoo(
    redeclare package Medium = MediumA,
      per(efficiency(v={0,v_nominal,2*v_nominal},
                   eta={1.1*eta_nominal,eta_nominal,0.9*eta_nominal})
          pressure(v={0,v_nominal,2*v_nominal},
                   dp={0,dp_nominal,3.5*dp_nominal}))) \"Direct evaporative cooler\";
</pre>
<p>
where independent variable <i>v</i> is the air velocity flowing through the
evaporative pad, dependent variable <i>eta</i> is the saturation efficiency,
and dependent variable <i>dp</i> is the air pressure drop through the
evaporative pad. Saturation efficiency is defined as <i>eta = (TDryBulIn -
TDryBulOut) / (TDryBulIn - TWetBulIn)</i>.
</p>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Direct\">
Buildings.Fluid.Humidifiers.EvaporativePads.Direct</a>.
</p>
</html>"));
end Generic;
