within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model CapacityReductionCurve
  "Validation model for capacity reduction curve"
  Buildings.Templates.Plants.Controls.HeatPumps.CapacityReductionCurve
    curCapRed
    "Capacity reduction curve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sinTOut(
    amplitude=15,
    freqHz=1/3600,
    phase=1.5707963267949,
    offset=273.15 + 5)
    "Outdoor air temperature signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sinTHeaWatSup(
    amplitude=10,
    freqHz=1/3600,
    offset=273.15 + 50)
    "Hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(sinTOut.y, curCapRed.TOut) annotation (Line(points={{-38,20},{-20,20},
          {-20,4},{-2,4}}, color={0,0,127}));
  connect(sinTHeaWatSup.y, curCapRed.THeaWatSup) annotation (Line(points={{-38,-20},
          {-20,-20},{-20,-4},{-2,-4}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/CapacityReductionCurve.mos"
        "Simulate and plot"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
May 31, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.CapacityReductionCurve\">
Buildings.Templates.Plants.Controls.HeatPumps.CapacityReductionCurve</a>
by running the calculations for a few permutations of commonly experienced outdoor air
temperatures and typical hot water supply temperatures.
</p>
<p>
The plot demonstrates how the curve value decreases when the outdoor air temperature
decreases or when the hot water supply temperature increases. 
</p>
</html>"),
    experiment(StopTime=3600, Tolerance=1e-5));
end CapacityReductionCurve;
