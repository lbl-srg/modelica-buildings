model ThreeWayLinear "Three way valve with linear characteristics" 
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayLinear res1(
      redeclare package Medium = Medium,
      k_SI=k_SI,
      l=l[1],
      deltaM=deltaM,
      dp0=dp0,
      flowDirection=flowDirection,
      from_dp=from_dp,
      linearized=linearized[1]),
      redeclare TwoWayLinear res3(
      redeclare package Medium = Medium,
      k_SI=fraK*k_SI,
      l=l[2],
      deltaM=deltaM,
      dp0=dp0,
      flowDirection=flowDirection,
      from_dp=from_dp,
      linearized=linearized[2]));
  annotation (Diagram, Icon,
    Documentation(info="<html>
<p>
Three way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve models 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a> and
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. 
See
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>
for the implementation of the leakage flow or 
the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
equation 
  connect(inv.y, res3.y) annotation (points=[-35,72; 20,72; 20,-72; 8,-72; 8,
        -62],                                                       style(color=
         74, rgbcolor={0,0,127}));
  connect(y, inv.u2) annotation (points=[-120,80; -92,80; -92,40; -44,40; -44,
        64], style(color=74, rgbcolor={0,0,127}));
  connect(y, res1.y) annotation (points=[-120,80; -92,80; -92,8; -62,8],
      style(color=74, rgbcolor={0,0,127}));
end ThreeWayLinear;
