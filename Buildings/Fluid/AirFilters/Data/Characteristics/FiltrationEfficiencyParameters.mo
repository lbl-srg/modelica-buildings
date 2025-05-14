within Buildings.Fluid.AirFilters.Data.Characteristics;
record FiltrationEfficiencyParameters
  "Record for filtration efficiency verse relative mass of the contaminant captured by the filter"
  extends Modelica.Icons.Record;

  parameter Real rat[:,:](each final max=1, each final min=0)
    "Relative mass of the contaminant captured by the filter";
  parameter Real eps[:,:](each final max=1, each final min=0)
    "Filtration efficiency";

  annotation (Documentation(info="<html>
<p>
Data record of the relative mass of the contaminant <code>rat</code>
verves the filtration efficiency <code>eps</code>.
The elements of the vector <code>rat</code> should be in ascending order, 
i.e., <code>rat[i] &lt; rat[i+1]</code>.
The vector <code>rat</code> and <code>eps</code> must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
June 27, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiltrationEfficiencyParameters;
