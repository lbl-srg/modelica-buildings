within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model DirectActingPIWithFirstOrderAMIGO
  "Test model for an autotuning direct-acting PI controller"
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
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=240)
    "A delay process for control process 1"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant k(k=10)
    "Gain of the first order process"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T(k=10)
    "Time constant of the first order process"
    annotation (Placement(transformation(extent={{10,-66},{30,-46}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "A subtract block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "A subtract block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative1
    "A derivative block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative derivative2
    "A derivative block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse autTunSig(
    width=0.9,
    period=6000,
    shift=500)
    "Signal for enabling the autotuning"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "A subtract block that is used to mimic the direct acting in the first order process 1"
    annotation (Placement(transformation(extent={{20,56},{40,76}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(k=1)
   "constant value 1"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub4
    "A subtract block that is used to mimic the direct acting in the first order process 2"
    annotation (Placement(transformation(extent={{20,-24},{40,-4}})));
equation
  connect(resSig.y, PI.trigger) annotation (Line(points={{-58,70},{-40,70},{-40,
          40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(SetPoint.y, PI.u_s) annotation (Line(points={{-58,10},{-50,10},{-50,
          60},{-22,60}},
                     color={0,0,127}));
  connect(uniDel1.y, sub1.u1) annotation (Line(points={{82,60},{110,60},{110,86},
          {158,86}}, color={0,0,127}));
  connect(k.y, derivative1.k) annotation (Line(points={{82,20},{90,20},{90,28},
          {118,28}},color={0,0,127}));
  connect(derivative1.T, T.y) annotation (Line(points={{118,24},{100,24},{100,
          -56},{32,-56}},
                     color={0,0,127}));
  connect(derivative1.y, sub1.u2) annotation (Line(points={{142,20},{150,20},{
          150,74},{158,74}}, color={0,0,127}));
  connect(sub1.y, PI.u_m) annotation (Line(points={{182,80},{190,80},{190,40},{
          -10,40},{-10,48}},
                         color={0,0,127}));
  connect(sub2.u1, uniDel2.y) annotation (Line(points={{158,-4},{110,-4},{110,
          -20},{82,-20}},
                     color={0,0,127}));
  connect(derivative2.y,sub2. u2) annotation (Line(points={{142,-60},{150,-60},
          {150,-16},{158,-16}}, color={0,0,127}));
  connect(sub2.y, PIWitTun.u_m) annotation (Line(points={{182,-10},{190,-10},{
          190,-40},{-10,-40},{-10,-32}},
                           color={0,0,127}));
  connect(derivative2.T, T.y) annotation (Line(points={{118,-56},{32,-56}},
          color={0,0,127}));
  connect(derivative1.u, sub1.u1) annotation (Line(points={{118,20},{110,20},{
          110,86},{158,86}},
                         color={0,0,127}));
  connect(derivative2.u, uniDel2.y) annotation (Line(points={{118,-60},{110,-60},
          {110,-20},{82,-20}},
                             color={0,0,127}));
  connect(autTunSig.y, PIWitTun.triTun) annotation (Line(points={{-58,-50},{-4,-50},{-4,-32}}, color={255,0,255}));
  connect(k.y, derivative2.k) annotation (Line(points={{82,20},{90,20},{90,-52},
          {118,-52}},color={0,0,127}));
  connect(const.y, sub3.u1) annotation (Line(points={{-18,120},{10,120},{10,72},
          {18,72}},color={0,0,127}));
  connect(PI.y, sub3.u2) annotation (Line(points={{2,60},{18,60}},               color={0,0,127}));
  connect(sub3.y, uniDel1.u)
    annotation (Line(points={{42,66},{50,66},{50,60},{58,60}},
                                               color={0,0,127}));
  connect(PIWitTun.y, sub4.u2) annotation (Line(points={{2,-20},{18,-20}},
                     color={0,0,127}));
  connect(uniDel2.u, sub4.y) annotation (Line(points={{58,-20},{50,-20},{50,-14},
          {42,-14}},                                                      color={0,0,127}));
  connect(sub4.u1, const.y) annotation (Line(points={{18,-8},{10,-8},{10,120},{
          -18,120}},
                 color={0,0,127}));
  connect(resSig.y, PIWitTun.triRes) annotation (Line(points={{-58,70},{-40,70},
          {-40,-40},{-16,-40},{-16,-32}}, color={255,0,255}));
  connect(SetPoint.y, PIWitTun.u_s) annotation (Line(points={{-58,10},{-50,10},
          {-50,-20},{-22,-20}}, color={0,0,127}));
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
However, direct-acting PI controllers are considered.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 1, 2023, by Sen Huang:<br/>
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
