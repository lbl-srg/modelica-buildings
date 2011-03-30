within Buildings.Fluid.Actuators.Valves;
model ThreeWayEqualPercentageLinear
  "Three way valve with equal percentage and linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayEqualPercentage res1(
      redeclare package Medium = Medium,
      l=l[1],
      deltaM=deltaM,
      dp_nominal=dp_nominal,
      from_dp=from_dp,
      linearized=linearized[1],
      useHomotopy=useHomotopy,
      R=R,
      delta0=delta0,
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
      useHomotopy=useHomotopy,
      m_flow_nominal=m_flow_nominal,
      CvData=CvData,
      Kv_SI=fraK*Kv_SI,
      Kv=fraK*Kv,
      Cv=fraK*Cv,
      Av=fraK*Av));
  parameter Real R = 50 "Rangeability, R=50...100 typically";
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law";

equation
  connect(inv.y, res3.y) annotation (Line(points={{69,60},{74,60},{80,60},{80,
          -50},{20,-50},{8,-50}},
                         color={0,0,127}));
  connect(y, inv.u2) annotation (Line(points={{1.11022e-15,80},{0,80},{0,30},{
          60,30},{60,52}},
                         color={0,0,127}));
  connect(y, res1.y) annotation (Line(points={{1.11022e-15,80},{0,80},{0,30},{
          -50,30},{-50,8}},
        color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-72,24},{-34,-20}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}),
defaultComponentName="val",
Documentation(info="<html>
<p>
Three way valve with equal percentage characteristics
between <code>port_1</code> and <code>port_2</code> 
and linear opening characteristic between <code>port_1</code> and <code>port_2</code>.
Such opening characteristics were typical for valves from Landis &amp; Gyr (now
Siemens).
</p><p>
This model is based on the partial valve models 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a> and
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. 
See
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>
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
end ThreeWayEqualPercentageLinear;
