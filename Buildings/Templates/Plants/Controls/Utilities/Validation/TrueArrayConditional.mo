within Buildings.Templates.Plants.Controls.Utilities.Validation;
model TrueArrayConditional
  Buildings.Templates.Plants.Controls.Utilities.TrueArrayConditional truArrConSam(nin=2)
    "Array with true elements and same size as input vector"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse uIdx1(
    amplitude=1,
    period=4,
    shift=1.5) "Source signal for index of first true element"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse uIdx2(
    amplitude=1,
    period=2.5,
    offset=2) "Source signal for index of second true element"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uTru(table=[0,0; 1,1; 2,
        2], period=4) "Source signal for number of true elements"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Templates.Plants.Controls.Utilities.TrueArrayConditional truArrConGre(nout=4,
      nin=2) "Array with true elements and size greater than input vector"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(uTru.y[1], truArrConSam.u) annotation (Line(points={{-58,40},{-20,40},
          {-20,0},{-2,0}}, color={255,127,0}));
  connect(uIdx1.y, truArrConSam.uIdx[1]) annotation (Line(points={{-58,0},{-40,0},
          {-40,-6.5},{-2,-6.5}}, color={255,127,0}));
  connect(uTru.y[1], truArrConGre.u) annotation (Line(points={{-58,40},{-20,40},
          {-20,-40},{-2,-40}}, color={255,127,0}));
  connect(uIdx1.y, truArrConGre.uIdx[1]) annotation (Line(points={{-58,0},{-40,0},
          {-40,-46.5},{-2,-46.5}}, color={255,127,0}));
  connect(uIdx2.y, truArrConSam.uIdx[2]) annotation (Line(points={{-58,-40},{-50,
          -40},{-50,-7.5},{-2,-7.5},{-2,-5.5}}, color={255,127,0}));
  connect(uIdx2.y, truArrConGre.uIdx[2]) annotation (Line(points={{-58,-40},{-50,
          -40},{-50,-48},{-2,-48},{-2,-45.5}}, color={255,127,0}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/TrueArrayConditional.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation model for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.TrueArrayConditional\">
Buildings.Templates.Plants.Controls.Utilities.TrueArrayConditional</a>.
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
end TrueArrayConditional;
