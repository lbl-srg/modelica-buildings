within Buildings.Fluid.HeatExchangers.ThermalWheels.Data;
record ASHRAE = Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic(
  senHeatExchangeEffectiveness(
    uSpe={0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1},
    epsCor={0,0.40,0.71,0.83,0.90,0.93,0.96,0.97,0.98,0.99,1}),
  latHeatExchangeEffectiveness(
    uSpe={0,0.15,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1},
    epsCor={0,0.26,0.37,0.58,0.72,0.81,0.86,0.90,0.96,1}))
      "ASHRAE data record for variable-speed thermal wheels"
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
ASHRAE performance dataset for the variable-speed wheel model.
</p>
<p>
It is developed based on Figure 7 in ASHRAE (2024).
However, the original data set was extrapolated to cover lower values 
of speed ratio, i.e. <code> &lt;= 0.2</code>, by setting the heat exchange effectiveness 
corrections to 0 when the speed ratio is 0.
</p>
<h4>References</h4>
<p>
ASHRAE (2024).
<i>Chapter 26, Air-to-Air Energy Recovery Equipment, ASHRAE Handbook—HVAC Systems and Equipment.</i>
</p>
</html>"));
