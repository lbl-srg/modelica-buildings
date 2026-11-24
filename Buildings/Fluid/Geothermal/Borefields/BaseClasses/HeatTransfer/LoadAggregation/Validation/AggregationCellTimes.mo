within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model AggregationCellTimes
  "This validation case shows the construction of the aggregation time and size vectors"
  extends Modelica.Icons.Example;

  parameter Integer i = 6 "Number of aggregation cells";
  parameter Modelica.Units.SI.Time tLoaAgg=10
    "Time resolution of load aggregation";
  final parameter Modelica.Units.SI.Time[i] nu(each fixed=false)
    "Time vector for load aggregation";
  final parameter Real[i] rCel(each unit="1", each fixed=false)
    "Cell widths";

  Modelica.Units.SI.Time nu_error;
  Real rCel_error(unit="1") "Error on chosen values";

initial equation
  (nu,rCel) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.aggregationCellTimes(
    i=i,
    lvlBas=2,
    nCel=2,
    tLoaAgg=tLoaAgg,
    timFin=12*tLoaAgg);

equation
  nu_error = 100.0-nu[i-1];
  rCel_error = 2.0-rCel[i];

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/AggregationCellTimes.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case builds the aggregation vectors (<code>rCel</code> and <code>nu</code>)
for a fictional case with 6 cells, built in 3 layers of 2 cells which double in size
each level. The <code>timFin</code> input to the function called is lower than the aggregation
time of the 6th cell, and the 6th cell must therefore be truncated from a size of 4 to a size of 2.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2026, by Michael Wetter:<br/>
Changed the type of dimensionless normalized cell widths <code>rCel</code> and <code>rCel_error</code> from <a href=\"modelica://Modelica.Units.SI.Time\">Time</a> to <code>Real(unit=\"1\")</code>.
</li>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end AggregationCellTimes;
