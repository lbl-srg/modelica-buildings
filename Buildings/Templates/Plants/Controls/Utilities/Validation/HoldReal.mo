within Buildings.Templates.Plants.Controls.Utilities.Validation;
model HoldReal "Validation model"
  Buildings.Templates.Plants.Controls.Utilities.HoldReal hol(dtHol=0)
    "Hold signal – No minimum hold time"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.2, period=30)
    "Source signal for hold trigger"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(freqHz=1/60)
    "Source signal for value to hold"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Templates.Plants.Controls.Utilities.HoldReal holTim(dtHol=20)
    "Hold signal – With minimum hold time"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(booPul.y, hol.u1)
    annotation (Line(points={{-58,0},{-20,0},{-20,40},{18,40}},
                                                color={255,0,255}));
  connect(sin.y, hol.u) annotation (Line(points={{-58,60},{0,60},{0,34},{18,34}},
        color={0,0,127}));
  connect(booPul.y, holTim.u1)
    annotation (Line(points={{-58,0},{18,0}}, color={255,0,255}));
  connect(sin.y, holTim.u) annotation (Line(points={{-58,60},{0,60},{0,-6},{18,
          -6}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/HoldReal.mos"
        "Simulate and plot"),
    experiment(
      StopTime=60.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation model for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.HoldReal\">
Buildings.Templates.Plants.Controls.Utilities.HoldValue</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
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
end HoldReal;
