within Buildings.Fluid.BaseClasses.VariableSpeedWheel.BaseClasses.Data;
record ASHRAE =
  Buildings.Fluid.BaseClasses.VariableSpeedWheel.BaseClasses.Data.Generic (
    senHeatExchangeEffectiveness(uSpe={0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1},
        epsCor={0.40,0.71,0.83,0.90,0.93,0.96,0.97,0.98,0.99,1}),
    latHeatExchangeEffectiveness(uSpe={0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1},
        epsCor={0.26,0.26,0.37,0.58,0.72,0.81,0.86,0.90,0.96,1}))
      "Default data record for wheels"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Performance dataset for the variable-speed wheel model.
</p>
<p>
It is developed based on Figure 7 in ASHRAE (2024).
Note that nearest-neighbor extrapolations are used to make sure the dataset covers lower values 
of speed ratio, i.e. <code> &lt;= 0.2</code>.
</p>
<h4>References</h4>
<p>
ASHRAE (2024).
<i>Chapter 26, Air-to-Air Energy Recovery Equipment, ASHRAE Handbook—HVAC Systems and Equipment.</i>
</p>
</html>"));
