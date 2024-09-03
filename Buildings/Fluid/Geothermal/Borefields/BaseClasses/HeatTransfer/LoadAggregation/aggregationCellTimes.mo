within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
function aggregationCellTimes
  "Function which builds the time and cell width vectors for aggregation"
  extends Modelica.Icons.Function;

  input Integer i "Size of time vector";
  input Real lvlBas "Base for growth between each level, e.g. 2";
  input Integer nCel "Number of cells of same size per level";
  input Modelica.Units.SI.Time tLoaAgg(final min=Modelica.Constants.small)
    "Time resolution of load aggregation";
  input Modelica.Units.SI.Time timFin "Total simulation max length";

  output Modelica.Units.SI.Time nu[i] "Time vector nu of size i";
  output Real rCel[i](each unit="1") "Cell width vector of size i";

protected
  Real width_j;

algorithm
  width_j := 0;

  for j in 1:i loop
    width_j := width_j + tLoaAgg*lvlBas^floor((j-1)/nCel);
    nu[j] := width_j;

    rCel[j] := lvlBas^floor((j-1)/nCel);
  end for;

  if nu[i]>timFin then
    nu[i] := timFin;
    rCel[i] := (nu[i]-nu[i-1])/tLoaAgg;
  end if;

  annotation (Documentation(info="<html>
<p>Simultaneously constructs both the <code>nu</code> vector, which is the
aggregation time of each cell, and the <code>rCel</code> vector, which
is the temporal size of each cell normalized with the time resolution of load
aggregation <code>tLoaAgg</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Added <code>min=Modelica.Constants.small</code> to <code>tLoaAgg</code>
so that a tool can infer that this quantity is non-zero.
</li>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end aggregationCellTimes;
