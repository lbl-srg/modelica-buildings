within Buildings.Fluid.Actuators.Valves;
model ThreeWayLinear "Three way valve with linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayLinear res1(
      redeclare package Medium = Medium,
      l=l[1],
      deltaM=deltaM,
      dp_nominal=dp_nominal,
      dp(start=dp_nominal/2),
      from_dp=from_dp,
      linearized=linearized[1],
      homotopyInitialization=homotopyInitialization,
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
      dp(start=dp_nominal/2),
      from_dp=from_dp,
      linearized=linearized[2],
      homotopyInitialization=homotopyInitialization,
      m_flow_nominal=m_flow_nominal,
      CvData=CvData,
      Kv_SI=fraK*Kv_SI,
      Kv=fraK*Kv,
      Cv=fraK*Cv,
      Av=fraK*Av));

equation
  connect(inv.y, res3.y) annotation (Line(points={{69,60},{80,60},{80,-50},{20,
          -50},{8,-50}}, color={0,0,127}));
  connect(y, inv.u2) annotation (Line(points={{1.11022e-15,80},{0,80},{0,40},{
          60,40},{60,52}},
                         color={0,0,127}));
  connect(y, res1.y) annotation (Line(points={{1.11022e-15,80},{0,80},{0,40},{
          -50,40},{-50,8}},
        color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                            graphics),
defaultComponentName="val",
Documentation(info="<html>
<p>
Three way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve models 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a> and
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>. 
See
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
for the implementation of the leakage flow or 
the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 25, 2011, by Michael Wetter:<br>
Added homotopy method.
</li>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayLinear;
