within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model ElectricityDemand
  "Validation model for the electricity demand check"

  Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand eleDem(
      final PBuiRedDifMin=100, final PBuiRed_nominal=5000)
    "Electricity demand check"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant PBuiRedTar(final k=1000)
    "Target electricity demand reduction"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiRed(
    final amplitude=500,
    final freqHz=1/3600,
    final offset=900)
    "Actual electricity demand reduction"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(PBuiRedTar.y, eleDem.PBuiRedTar)
    annotation (Line(points={{-38,40},{0,40},{0,12},{36,12}}, color={0,0,127}));
  connect(PBuiRed.y, eleDem.PBuiRed)
    annotation (Line(points={{-38,-40},{0,-40},{0,-12},{36,-12}}, color={0,0,127}));

annotation (experiment(StopTime=7200, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/ElectricityDemand.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand\">
Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang, Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end ElectricityDemand;
