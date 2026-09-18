within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.Validation;
model TemperatureSupplyWeightedAverage
  "Validate block to calculate weighted average of supply temperature"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.TemperatureSupplyWeightedAverage
    TWeiAve(final nBoi=2, final boiDesFlo={0.25,0.5})
    "Supply air weighted average temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse boiSta1(
    final width=0.95,
    final period=3600,
    final shift=1)
    "Boiler-1 status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TBoiSup1(
    final phase=3.1415926535898,
    final offset=8.5,
    final freqHz=1/3600,
    final amplitude=2.5)
    "Boiler-1 supply temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TBoiSup2(
    final phase=3.1415926535898,
    final offset=8,
    final freqHz=1/3600,
    final amplitude=2.5)
    "Boiler-2 supply temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse boiSta2(
    final width=0.5,
    final period=1800,
    final shift=1)
    "Boiler-2 status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

equation

  connect(TBoiSup1.y, TWeiAve.THotWatBoiSup[1]) annotation (Line(points={{-58,0},
          {-50,0},{-50,-18},{34,-18},{34,-6.5},{38,-6.5}}, color={0,0,127}));
  connect(TBoiSup2.y, TWeiAve.THotWatBoiSup[2])
    annotation (Line(points={{-58,-40},{38,-40},{38,-5.5}}, color={0,0,127}));
  connect(boiSta2.y, TWeiAve.uBoiSta[2]) annotation (Line(points={{-58,70},{30,70},
          {30,6.5},{38,6.5}}, color={255,0,255}));

  connect(boiSta1.y, TWeiAve.uBoiSta[1]) annotation (Line(points={{-58,40},{20,40},
          {20,5.5},{38,5.5}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Generic/Subsequences/Validation/TemperatureSupplyWeightedAverage.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.TemperatureSupplyWeightedAverage\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.TemperatureSupplyWeightedAverage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TemperatureSupplyWeightedAverage;
