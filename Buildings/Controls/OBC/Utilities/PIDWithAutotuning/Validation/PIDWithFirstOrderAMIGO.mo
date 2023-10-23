within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model PIDWithFirstOrderAMIGO "Test model for an autotuning PID controller"
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant SetPoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO PIDWitTun(
      controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID)
    "PID controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1) "PID controller with constant gains"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2(samplePeriod=240)
    "A delay process for control process 2"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=240)
    "A delay process for control process 1"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant k(k=1)
    "Gain of the first order process"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T(k=10)
    "Time constant of the first order process"
    annotation (Placement(transformation(extent={{10,-66},{30,-46}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "A subtract block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "A subtract block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative1
    "A derivative block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative2
    "A derivative block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse autTunSig(
    width=0.9,
    period=6000,
    shift=500)   "Signal for enabling the autotuning"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,70},{-30,70},{-30,
          40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIDWitTun.triRes, PID.trigger) annotation (Line(points={{-16,-32},{-16,
          -38},{-30,-38},{-30,40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIDWitTun.u_s, PID.u_s) annotation (Line(points={{-22,-20},{-48,-20},
          {-48,60},{-22,60}}, color={0,0,127}));
  connect(SetPoint.y, PID.u_s) annotation (Line(points={{-58,10},{-48,10},{-48,60},
          {-22,60}}, color={0,0,127}));
  connect(PIDWitTun.y, uniDel2.u)
    annotation (Line(points={{2,-20},{18,-20}},color={0,0,127}));
  connect(uniDel1.u, PID.y)
    annotation (Line(points={{18,60},{2,60}},color={0,0,127}));
  connect(uniDel1.y, sub1.u1) annotation (Line(points={{42,60},{54,60},{54,86},
          {118,86}},
                   color={0,0,127}));
  connect(k.y, derivative1.k) annotation (Line(points={{32,20},{44,20},{44,28},
          {78,28}}, color={0,0,127}));
  connect(derivative1.T, T.y) annotation (Line(points={{78,24},{60,24},{60,-56},
          {32,-56}},                      color={0,0,127}));
  connect(derivative1.y, sub1.u2) annotation (Line(points={{102,20},{112,20},{
          112,74},{118,74}},
                    color={0,0,127}));
  connect(sub1.y, PID.u_m) annotation (Line(points={{142,80},{150,80},{150,40},
          {-10,40},{-10,48}},         color={0,0,127}));
  connect(sub2.u1, uniDel2.y) annotation (Line(points={{118,-4},{64,-4},{64,-20},
          {42,-20}}, color={0,0,127}));
  connect(derivative2.y,sub2. u2) annotation (Line(points={{102,-60},{110,-60},
          {110,-16},{118,-16}},
                             color={0,0,127}));
  connect(sub2.y, PIDWitTun.u_m) annotation (Line(points={{142,-10},{152,-10},{
          152,-36},{-10,-36},{-10,-32}},                   color={0,0,127}));
  connect(derivative2.T, T.y) annotation (Line(points={{78,-56},{32,-56}},
                           color={0,0,127}));
  connect(derivative1.u, sub1.u1) annotation (Line(points={{78,20},{72,20},{72,
          86},{118,86}},            color={0,0,127}));
  connect(derivative2.u, uniDel2.y) annotation (Line(points={{78,-60},{64,-60},
          {64,-20},{42,-20}},                   color={0,0,127}));
  connect(autTunSig.y, PIDWitTun.triTun)
    annotation (Line(points={{-58,-50},{-4,-50},{-4,-32}}, color={255,0,255}));
  connect(k.y, derivative2.k) annotation (Line(points={{32,20},{68,20},{68,-52},
          {78,-52}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Validation/PIDWithFirstOrderAMIGO.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO</a>.
</p>
<p>
This example compares the output of an autotuning PID controller (<code>PIDWitTun</code>)
to that of a normal PID controller (<code>PID</code>) with prescribed gains.
</p>
<p>
Both PID controllers are connected with a first-order control process.
At the beginning (<i>0</i>s-<i>500</i>s), the outputs from those two PID controllers 
are identical as their prescribed gains are the same.
</p>
<p>
Once the autotuning starts at <i>500</i>s, the outputs of the two PID controllers become different.
After the tuning completes, under the control of <code>PIDWitTun</code>, the value of the controlled variable
is close to the setpoint after the tuning period ends (<code>PIDWitTun.resPro.triEnd = true</code>). 
On the contrary, <code>PID</code> has a poor control performance,
i.e., the value of the controlled variable oscillates.
</p>
<p>
The example also shows that the autotunning process can be retriggered
when the input <code>triTun</code> becomes <code>true</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-80},{200,100}})));
end PIDWithFirstOrderAMIGO;
