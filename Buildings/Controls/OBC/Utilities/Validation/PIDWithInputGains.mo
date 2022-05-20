within Buildings.Controls.OBC.Utilities.Validation;
model PIDWithInputGains
  "Test model for PIDWithInputGains"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pulse(
    period=0.25)
    "Setpoint"
    annotation (Placement(transformation(extent={{-30,14},{-10,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(
    k=0.5)
    "Measured value"
    annotation (Placement(transformation(extent={{-30,-22},{-10,-2}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains PIDWithInputGains(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
    "PID controller with input gains"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1)
    "PID controller with constant gains"
     annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse resSig(period=1)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse k(
    amplitude=0.2,
    width=0.4,
    period=1,
    shift=0.6,
    offset=1)
    "Control gain signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse Ti(
    amplitude=0.2,
    width=0.4,
    period=1,
    shift=0.6,
    offset=0.5)
    "Time constant signal for the integral term"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse Td(
    amplitude=0.1,
    width=0.4,
    period=1,
    shift=0.6,
    offset=0.1)
    "Time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,50},{0,50},{0,10},
          {24,10},{24,18}}, color={255,0,255}));
  connect(PIDWithInputGains.trigger, PID.trigger) annotation (Line(points={{24,
          -32},{24,-60},{0,-60},{0,10},{24,10},{24,18}}, color={255,0,255}));
  connect(pulse.y, PID.u_s) annotation (Line(points={{-8,24},{14,24},{14,30},{
          18,30}}, color={0,0,127}));
  connect(PIDWithInputGains.u_s, PID.u_s) annotation (Line(points={{18,-20},{14,
          -20},{14,30},{18,30}}, color={0,0,127}));
  connect(const.y, PID.u_m) annotation (Line(points={{-8,-12},{8,-12},{8,0},{30,
          0},{30,18}}, color={0,0,127}));
  connect(PIDWithInputGains.u_m, PID.u_m) annotation (Line(points={{30,-32},{30,
          -40},{8,-40},{8,0},{30,0},{30,18}}, color={0,0,127}));
  connect(k.y, PIDWithInputGains.k) annotation (Line(points={{-58,10},{-40,10},{
          -40,4},{12,4},{12,-12},{18,-12}}, color={0,0,127}));
  connect(PIDWithInputGains.Ti, Ti.y) annotation (Line(points={{18,-16},{2,-16},
          {2,-30},{-58,-30}}, color={0,0,127}));
  connect(PIDWithInputGains.Td, Td.y) annotation (Line(points={{18,-24},{14,-24},
          {14,-70},{-58,-70}}, color={0,0,127}));
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
This model tests if this block can generate the same output as <a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PIDWithReset\">
Buildings.Controls.OBC.CDL.Continuous.PIDWithReset</a> when the gains are the same.
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end PIDWithInputGains;
