within Buildings.Templates.Plants.Controls.Utilities.Validation;
model PlaceholderReal "Validation model"
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal phPar(
    have_inp=false,
      have_inpPh=false, u_internal=1) "Placeholder parameter"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse
                                               pul(period=1)
    "Source signal for value to replace"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal phInp(have_inp=false,
      have_inpPh=true) "Placeholder signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=2) "Constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal phNo(
    have_inp=true,
    have_inpPh=false,
    u_internal=1) "No placeholder: use input signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  connect(pul.y, phNo.u)
    annotation (Line(points={{-58,0},{0,0},{0,60},{18,60}}, color={0,0,127}));
  connect(pul.y, phPar.u)
    annotation (Line(points={{-58,0},{18,0}}, color={0,0,127}));
  connect(pul.y, phInp.u) annotation (Line(points={{-58,0},{0,0},{0,-60},{18,-60}},
        color={0,0,127}));
  connect(con.y, phInp.uPh) annotation (Line(points={{-58,-60},{-20,-60},{-20,-66},
          {18,-66}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/PlaceholderReal.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation model for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal\">
Buildings.Templates.Plants.Controls.Utilities.PlaceholderReal</a>.
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
end PlaceholderReal;
