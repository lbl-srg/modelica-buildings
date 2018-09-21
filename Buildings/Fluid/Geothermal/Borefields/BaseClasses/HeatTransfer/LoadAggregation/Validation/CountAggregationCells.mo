within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model CountAggregationCells "This validation case verifies the counting of the required length of aggregation vectors"
  extends Modelica.Icons.Example;

  Integer i "Number of aggregation cells";

equation
  i = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.countAggregationCells(
      lvlBas=2,
      nCel=2,
      timFin=120,
      tLoaAgg=10);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/CountAggregationCells.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case counts the required length of the aggregation vectors for the
same fictional case as in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation.AggregationCellTimes\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation.AggregationCellTimes</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end CountAggregationCells;
