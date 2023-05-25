within Buildings.Fluid.DXSystems.BaseClasses.Types;
type DefrostTimeMethods = enumeration(
    timed
      "Timed defrost",
    onDemand
      "On-demand defrost")
    "Enumeration defining two methods for defrost time fraction calculation."
annotation (Documentation(info="<html>
<p>
Enumeration for the calculation methods for defrost time fraction.
The possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>timed</code></td>
<td>
Run the defrost operation for a fixed time duration fraction of the timestep.
</td></tr>
<tr><td><code>onDemand</code></td>
<td>
Run the defrost operation for on a time duration fraction for the timestep, that 
is calculated from the outdoor air temperature and humidity ratio.
</td></tr>
</table>
</html>"));
