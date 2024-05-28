within Buildings.Templates.Plants.Controls.MinimumFlow.Validation;
model Setpoint
  "Validation model for the minimum flow setpoint calculation"
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Equ(
    table=[
      0, 0, 0;
      1, 1, 0;
      2, 1, 1;
      3, 0, 1;
      4, 0, 0],
    timeScale=200,
    period=900)
    "Source signal for equipment enable command"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint setFloMin(
    V_flow_nominal={0.02, 0.05},
    V_flow_min={0.01, 0.03},
    nEqu=2)
    "Minimum flow setpoint calculation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(u1Equ.y[1:2], setFloMin.u1[1:2])
    annotation (Line(points={{-58,0},{-36,0},{-36,0.5},{-12,0.5}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/MinimumFlow/Validation/Setpoint.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000.0,
      Tolerance=1e-06),
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
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint\">
Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint</a>
in a configuration with two equipment with different minimum flow ratios.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoint;
