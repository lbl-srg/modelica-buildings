within Buildings.Controls.OBC.Utilities.Validation;
model PIDWithInputGains
  "Test model for PIDWithInputGains"
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulse(
    period=0.25)
    "Setpoint"
    annotation (Placement(transformation(extent={{-30,14},{-10,34}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(
    k=0.5)
    "Measured value"
    annotation (Placement(transformation(extent={{-30,-22},{-10,-2}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains PIDWitInpGai(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
    "PID controller with input gains"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1)
    "PID controller with constant gains"
     annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse resSig(period=1)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse k(
    amplitude=0.2,
    width=0.4,
    period=1,
    shift=0.6,
    offset=1)
    "Control gain signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse Ti(
    amplitude=0.2,
    width=0.4,
    period=1,
    shift=0.6,
    offset=0.5)
    "Time constant signal for the integral term"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse Td(
    amplitude=0.1,
    width=0.4,
    period=1,
    shift=0.6,
    offset=0.1)
    "Time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Absolute value of controller output"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference in controller output"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(t=1E-5, h=1E-4)
    "Output true if outputs are bigger than threshold"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message="Control outputs differ more than expected")
    "Make sure outputs are within expected tolerance"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Standard time"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.59)
    "Output true if model time is below 0.6"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Output true either if time is bigger than 0.59, or if tolerance is maintained"
    annotation (Placement(transformation(extent={{170,20},{190,40}})));
equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,50},{0,50},{0,10},
          {24,10},{24,18}}, color={255,0,255}));
  connect(PIDWitInpGai.trigger, PID.trigger) annotation (Line(points={{24,
          -32},{24,-60},{0,-60},{0,10},{24,10},{24,18}}, color={255,0,255}));
  connect(pulse.y, PID.u_s) annotation (Line(points={{-8,24},{14,24},{14,30},{
          18,30}}, color={0,0,127}));
  connect(PIDWitInpGai.u_s, PID.u_s) annotation (Line(points={{18,-20},{14,
          -20},{14,30},{18,30}}, color={0,0,127}));
  connect(const.y, PID.u_m) annotation (Line(points={{-8,-12},{8,-12},{8,0},{30,
          0},{30,18}}, color={0,0,127}));
  connect(PIDWitInpGai.u_m, PID.u_m) annotation (Line(points={{30,-32},{30,
          -40},{8,-40},{8,0},{30,0},{30,18}}, color={0,0,127}));
  connect(k.y, PIDWitInpGai.k) annotation (Line(points={{-58,10},{-40,10},{
          -40,4},{12,4},{12,-12},{18,-12}}, color={0,0,127}));
  connect(PIDWitInpGai.Ti, Ti.y) annotation (Line(points={{18,-16},{2,-16},
          {2,-30},{-58,-30}}, color={0,0,127}));
  connect(PIDWitInpGai.Td, Td.y) annotation (Line(points={{18,-24},{14,-24},
          {14,-70},{-58,-70}}, color={0,0,127}));
  connect(PID.y, sub.u1)
    annotation (Line(points={{42,30},{50,30},{50,6},{78,6}}, color={0,0,127}));
  connect(PIDWitInpGai.y, sub.u2) annotation (Line(points={{42,-20},{50,-20},{50,
          -6},{78,-6}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{102,0},{108,0}}, color={0,0,127}));
  connect(abs1.y, lesThr.u)
    annotation (Line(points={{132,0},{138,0}}, color={0,0,127}));
  connect(modTim.y, greThr.u)
    annotation (Line(points={{102,50},{138,50}}, color={0,0,127}));
  connect(greThr.y, or2.u1) annotation (Line(points={{162,50},{166,50},{166,30},
          {168,30}}, color={255,0,255}));
  connect(lesThr.y, or2.u2) annotation (Line(points={{162,0},{166,0},{166,22},{168,
          22}}, color={255,0,255}));
  connect(or2.y, assMes.u)
    annotation (Line(points={{192,30},{198,30}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/PIDWithInputGains.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
</p>
<p>
For <i>t &isin; [0, 0.6]</i> both PID controllers have the same gains.
During this time, they generate the same output.
Afterwards, the gains, and hence also their outputs, differ.
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 17, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-100,-100},{240,100}}), graphics={
          Rectangle(
          extent={{72,80},{228,-20}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{78,78},{168,68}},
          textColor={0,0,0},
          textString="Trigger an assertion if outputs differ more than threshold")}));
end PIDWithInputGains;
