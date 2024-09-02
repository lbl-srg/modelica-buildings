within Buildings.Fluid.AirFilters.BaseClasses.Characteristics;
record filtrationEfficiencyParameters
  "Record for filteration efficiency vs. relative mass of the contaminant captured by the filter"
  extends Modelica.Icons.Record;
  parameter Real rat[:,:](each max=1, each min=0)
    "Relative mass of the contaminant captured by the filter";
  parameter Real eps[:,:](each max=1, each min=0)
    "Filteration efficiency";

  annotation (Documentation(info="<html>
<p>
Data record that describes the relative mass of the contaminant captured by the filter <code>rat</code> versus
the filteration efficiency <code>eps</code>.
The elements of the vector <code>rat</code> should be in ascending order, 
i.e.,<code>rat[i] &lt; rat[i+1]</code>.
Both vectors, <code>rat</code> and <code>eps</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
June 27, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end filtrationEfficiencyParameters;
