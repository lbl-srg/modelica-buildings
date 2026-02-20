within Buildings.DHC.ETS.Combined.Data.BaseClasses;
function scalePerformanceTable
  "Function that scales the heat pump performance table"
  extends Modelica.Icons.Function;
  input Real x[nR, nC] "Table with performance data";
  input Integer nR "Number of rows in x";
  input Integer nC "Number of columns in x";
  input Real s(min=Modelica.Constants.eps) "Scaling factor";
  output Real y[nR, nC] "Scaled table with performance data";
algorithm
  y[1,:]:=x[1, :];
  for i in 2:nR loop
    y[i,1]:=x[i, 1] "Temperature assignment";
    y[i,2:nC]:=x[i, 2:nC]*s "Scaling of thermal capacity or electricity";
  end for;
  annotation (Documentation(info="<html>
<p>
Function to scale the performance data for the heat pump heat capacity and electrical power use.
</p>
<p>
The data record
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump\">
Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump</a>
contains performance data arrays
<code>tabPEle</code> and
<code>tabQCon_flow</code>
that list for different temperatures the capacity.
This function takes such arrays as input, and returns these arrays after multiplying
the capacity by the input argument <code>s</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 17, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
</ul>
</html>"));
end scalePerformanceTable;
