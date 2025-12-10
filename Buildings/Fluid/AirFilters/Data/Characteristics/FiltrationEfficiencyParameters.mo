within Buildings.Fluid.AirFilters.Data.Characteristics;
record FiltrationEfficiencyParameters
  "Record for filtration efficiency versus relative mass of the contaminant captured by the filter"
  extends Modelica.Icons.Record;

  parameter Real rat[:,:](each final max=1, each final min=0)
    "Relative mass of the contaminant captured by the filter. The row size equals the number of contaminant types";
  parameter Real eps[:,:](each final max=1, each final min=0)
    "Filtration efficiency. The row size equals the number of contaminant types";

  annotation (Documentation(info="<html>
<p>
Data record of the relative mass of the contaminant <code>rat</code>
versus the filtration efficiency <code>eps</code>.
The elements of the vector <code>rat</code> must be in ascending order,
i.e., <code>rat[i] &lt; rat[i+1]</code>.
The vector <code>rat</code> and <code>eps</code> have the same size.
</p>
<p>
Note that the relative mass of the contaminant <code>rat</code> equals the total mass
of all the contaminants captured by the filter divided by the maximum mass of all the
contaminants captured by the filter.
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
