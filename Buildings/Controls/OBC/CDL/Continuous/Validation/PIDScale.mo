within Buildings.Controls.OBC.CDL.Continuous.Validation;
model PIDScale
  "Test model for PID controller with scaling of the control error"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pulse(
    amplitude=1000,
    period=50)
    "Setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.PID pidSca(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=2,
    Ti=1,
    Td=2,
    r=1000,
    yMin=-1)
    "PID controller with scaling of control input"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset pla1(
    k=1000)
    "Plant model"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Sources.Constant resVal(
    k=0)
    "Reset value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Logical.Sources.Constant resSig(
    k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.PID pidNoSca(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=2,
    Ti=1,
    Td=2,
    yMin=-1)
    "PID controller without scaling of control input"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=1/1000)
    "Gain to scale setpoint"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=1/1000)
    "Gain to scale measured value"
    annotation (Placement(transformation(extent={{52,-90},{32,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset pla2(
    k=1000)
    "Plant model"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(pulse.y,pidSca.u_s)
    annotation (Line(points={{-58,50},{-2,50}},color={0,0,127}));
  connect(pla1.u,pidSca.y)
    annotation (Line(points={{38,50},{22,50}},color={0,0,127}));
  connect(pla1.y,pidSca.u_m)
    annotation (Line(points={{62,50},{82,50},{82,0},{10,0},{10,38}},color={0,0,127}));
  connect(resVal.y,pla1.y_reset_in)
    annotation (Line(points={{-58,10},{30,10},{30,42},{38,42}},color={0,0,127}));
  connect(resSig.y,pla1.trigger)
    annotation (Line(points={{-58,-30},{50,-30},{50,38}},color={255,0,255}));
  connect(gai.y,pidNoSca.u_s)
    annotation (Line(points={{-18,-50},{-2,-50}},color={0,0,127}));
  connect(gai.u,pulse.y)
    annotation (Line(points={{-42,-50},{-50,-50},{-50,50},{-60,50}},color={0,0,127}));
  connect(pidNoSca.y,pla2.u)
    annotation (Line(points={{22,-50},{38,-50}},color={0,0,127}));
  connect(pla2.y,gai1.u)
    annotation (Line(points={{62,-50},{70,-50},{70,-80},{54,-80}},color={0,0,127}));
  connect(gai1.y,pidNoSca.u_m)
    annotation (Line(points={{30,-80},{10,-80},{10,-60}},color={0,0,127}));
  connect(pla2.y_reset_in,resVal.y)
    annotation (Line(points={{38,-58},{30,-58},{30,10},{-60,10}},color={0,0,127}));
  connect(resSig.y,pla2.trigger)
    annotation (Line(points={{-58,-30},{26,-30},{26,-64},{50,-64},{50,-62}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=100.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/PIDScale.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PID\">
Buildings.Controls.OBC.CDL.Continuous.PID</a>
with and without setting of the parameter that scales the control error.
</p>
<p>
The test has two combinations of a PID controller and a plant.
In <code>PIDSca</code>, the control error is scaled inside the controller, whereas
in the configuration that has <code>PIDNoSca</code>, the setpoint signal and the
measurement signal is scaled outside of the controller.
Both controllers and plants have the same trajectory, thereby validating that
the scaling is implemented correctly.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 15, 2020, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2182\">
Buildings, issue 2182</a>.
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
end PIDScale;
