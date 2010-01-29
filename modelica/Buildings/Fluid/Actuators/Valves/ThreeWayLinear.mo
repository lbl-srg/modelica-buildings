within Buildings.Fluid.Actuators.Valves;
model ThreeWayLinear "Three way valve with linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayLinear res1(
      redeclare package Medium = Medium,
      l=l[1],
      deltaM=deltaM,
      dp_nominal=dp_nominal,
      from_dp=from_dp,
      linearized=linearized[1],
      m_flow_nominal=m_flow_nominal,
      CvData=CvData,
      Kv_SI=Kv_SI,
      Kv=Kv,
      Cv=Cv,
      Av=Av),
      redeclare TwoWayLinear res3(
      redeclare package Medium = Medium,
      l=l[2],
      deltaM=deltaM,
      dp_nominal=dp_nominal,
      from_dp=from_dp,
      linearized=linearized[2],
      m_flow_nominal=m_flow_nominal,
      CvData=CvData,
      Kv_SI=fraK*Kv_SI,
      Kv=fraK*Kv,
      Cv=fraK*Cv,
      Av=fraK*Av));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                            graphics),
    Documentation(info="<html>
<p>
Three way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve models 
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a> and
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. 
See
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
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
  connect(inv.y, res3.y) annotation (Line(points={{-35,72},{20,72},{20,-72},{8,
          -72},{8,-62}}, color={0,0,127}));
  connect(y, inv.u2) annotation (Line(points={{-120,80},{-92,80},{-92,40},{-44,
          40},{-44,64}}, color={0,0,127}));
  connect(y, res1.y) annotation (Line(points={{-120,80},{-92,80},{-92,8},{-62,8}},
        color={0,0,127}));
end ThreeWayLinear;
