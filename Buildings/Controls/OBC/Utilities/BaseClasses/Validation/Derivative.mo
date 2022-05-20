within Buildings.Controls.OBC.Utilities.BaseClasses.Validation;
model Derivative
  "Test model for the Derivative block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse k(
    amplitude=0.2,
    width=0.4,
    period=1,
    shift=0.6,
    offset=1)
    "Control gain signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse Td(
    amplitude=0.1,
    width=0.4,
    period=1,
    shift=0.6,
    offset=0.1)
    "Time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine u(
    amplitude=1,
    freqHz=1,
    offset=0,
    startTime(displayUnit="h") = 0)
    "Real input signal"
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  Buildings.Controls.OBC.Utilities.BaseClasses.Derivative derivativeWithInputGains(
    y_start=1)
    "Derivative block with input gains"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Continuous.Derivative derivative(
    k=1*0.1,
    T=0.1/10,
    initType=Modelica.Blocks.Types.Init.InitialState,
    x_start=-0.1)
    "Derivative block with constant gains"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
equation
  connect(u.y, derivativeWithInputGains.u) annotation (Line(points={{-56,0},{-12,0}}, color={0,0,127}));
  connect(k.y, derivativeWithInputGains.k) annotation (Line(points={{-58,50},{-40,
          50},{-40,6},{-12,6}}, color={0,0,127}));
  connect(derivativeWithInputGains.Td, Td.y) annotation (Line(points={{-12,-6},{
          -40,-6},{-40,-50},{-58,-50}}, color={0,0,127}));
  connect(derivative.u, derivativeWithInputGains.u) annotation (Line(points={{-12,
          -50},{-28,-50},{-28,0},{-12,0}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/BaseClasses/Validation/Derivative.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.BaseClasses.Derivative\">
Buildings.Controls.OBC.Utilities.BaseClasses.Derivative</a>.
This model tests if this block can generate the same output as <a href=\"modelica://Modelica.Blocks.Continuous.Derivative\">
Modelica.Blocks.Continuous.Derivative</a> when the gains are the same.
</p>
</html>",
      revisions="<html>
<ul>
<li>May 17, 2022, by Sen Huang:<br>First implementation. </li>
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
end Derivative;
