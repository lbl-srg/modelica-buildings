within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
function countAggregationCells
  "Function which returns the number of aggregation cells in the aggregation vector"
  extends Modelica.Icons.Function;

  input Real lvlBas "Base for growth between each level, e.g. 2";
  input Integer nCel(min=1) "Number of cells of same size per level";
  input Modelica.Units.SI.Time timFin "Total simulation max length";
  input Modelica.Units.SI.Time tLoaAgg "Time resolution of load aggregation";

  output Integer i(min=1) "Size of aggregation vectors";

protected
  Modelica.Units.SI.Duration width_i "Width of current aggregation cell";
  Modelica.Units.SI.Time nu_i "End time of current aggregation cell";

algorithm
  assert(timFin > 0, "Total simulation time must be bigger than 0.");
  width_i := 0;
  nu_i := 0;
  i := 0;

  while nu_i<timFin loop
    i := i+1;
    width_i := tLoaAgg*lvlBas^floor((i-1)/nCel);
    nu_i := nu_i + width_i;
  end while;

annotation (Documentation(info="<html>
<p>
Function that counts the required length of the aggregation time vector
<code>nu</code> and of the weighting factor vectors <code>kappa</code> based on
the maximum time for calculations related to the ground temperature response.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Added <code>min=1</code> to <code>nCel</code>
so that a tool can infer that this quantity is non-zero.
</li>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end countAggregationCells;
