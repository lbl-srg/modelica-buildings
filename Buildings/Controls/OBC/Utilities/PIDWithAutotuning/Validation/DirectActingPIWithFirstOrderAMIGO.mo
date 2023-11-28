within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model DirectActingPIWithFirstOrderAMIGO
  "Test model for an autotuning reversed PID controller with direct acting"
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant SetPoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO PIWitTun(
      controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID,
      reverseActing=false) "PI controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset PI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1,
    reverseActing=false) "PI controller with constant gains"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2(samplePeriod=240)
    "A delay process for control process 2"
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=240)
    "A delay process for control process 1"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant k(k=10)
    "Gain of the first order process"
    annotation (Placement(transformation(extent={{32,10},{52,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T(k=10)
    "Time constant of the first order process"
    annotation (Placement(transformation(extent={{10,-66},{30,-46}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "A subtract block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{134,70},{154,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "A subtract block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{134,-20},{154,0}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative1
    "A derivative block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative2
    "A derivative block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse autTunSig(
    width=0.9,
    period=6000,
    shift=500)   "Signal for enabling the autotuning"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "A subtract block that is used to mimic the direct acting in the first order process 1"
    annotation (Placement(transformation(extent={{14,50},{34,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(k=1)
   "constant value 1"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub4
    "A subtract block that is used to mimic the direct acting in the first order process 2"
    annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
equation
  connect(resSig.y, PI.trigger) annotation (Line(points={{-58,70},{-30,70},{-30,
          40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIWitTun.triRes, PI.trigger) annotation (Line(points={{-16,-32},{-16,-38},
          {-30,-38},{-30,40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIWitTun.u_s, PI.u_s) annotation (Line(points={{-22,-20},{-48,-20},{-48,
          60},{-22,60}}, color={0,0,127}));
  connect(SetPoint.y, PI.u_s) annotation (Line(points={{-58,10},{-48,10},{-48,60},
          {-22,60}}, color={0,0,127}));
  connect(uniDel1.y, sub1.u1) annotation (Line(points={{72,60},{86,60},{86,86},
          {132,86}},
                   color={0,0,127}));
  connect(k.y, derivative1.k) annotation (Line(points={{54,20},{58,20},{58,28},{
          92,28}},  color={0,0,127}));
  connect(derivative1.T, T.y) annotation (Line(points={{92,24},{74,24},{74,-56},
          {32,-56}},                      color={0,0,127}));
  connect(derivative1.y, sub1.u2) annotation (Line(points={{116,20},{126,20},{
          126,74},{132,74}},
                    color={0,0,127}));
  connect(sub1.y, PI.u_m) annotation (Line(points={{156,80},{164,80},{164,40},{-10,
          40},{-10,48}}, color={0,0,127}));
  connect(sub2.u1, uniDel2.y) annotation (Line(points={{132,-4},{64,-4},{64,-20},
          {60,-20}}, color={0,0,127}));
  connect(derivative2.y,sub2. u2) annotation (Line(points={{102,-60},{110,-60},
          {110,-16},{132,-16}},
                             color={0,0,127}));
  connect(sub2.y, PIWitTun.u_m) annotation (Line(points={{156,-10},{156,-36},{-10,
          -36},{-10,-32}}, color={0,0,127}));
  connect(derivative2.T, T.y) annotation (Line(points={{78,-56},{32,-56}},
                           color={0,0,127}));
  connect(derivative1.u, sub1.u1) annotation (Line(points={{92,20},{86,20},{86,
          86},{132,86}},            color={0,0,127}));
  connect(derivative2.u, uniDel2.y) annotation (Line(points={{78,-60},{64,-60},{
          64,-20},{60,-20}},                    color={0,0,127}));
  connect(autTunSig.y, PIWitTun.triTun)
    annotation (Line(points={{-58,-50},{-4,-50},{-4,-32}}, color={255,0,255}));
  connect(k.y, derivative2.k) annotation (Line(points={{54,20},{68,20},{68,-52},
          {78,-52}}, color={0,0,127}));
  connect(const.y, sub3.u1) annotation (Line(points={{-18,120},{4,120},{4,66},{
          12,66}}, color={0,0,127}));
  connect(PI.y, sub3.u2)
    annotation (Line(points={{2,60},{6,60},{6,54},{12,54}}, color={0,0,127}));
  connect(sub3.y, uniDel1.u)
    annotation (Line(points={{36,60},{48,60}}, color={0,0,127}));
  connect(PIWitTun.y, sub4.u2) annotation (Line(points={{2,-20},{8,-20},{8,-26},
          {10,-26}}, color={0,0,127}));
  connect(uniDel2.u, sub4.y)
    annotation (Line(points={{36,-20},{34,-20}}, color={0,0,127}));
  connect(sub4.u1, const.y) annotation (Line(points={{10,-14},{4,-14},{4,120},{-18,
          120}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Validation/DirectActingPIWithFirstOrderAMIGO.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO</a>.
</p>
<p>
This example is similar as <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation.PIWithFirstOrderAMIGO\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation.PIWithFirstOrderAMIGO</a>.
However, PI controllers with direct acting are considered.
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
    Diagram(coordinateSystem(extent={{-100,-80},{200,140}})));
end DirectActingPIWithFirstOrderAMIGO;
