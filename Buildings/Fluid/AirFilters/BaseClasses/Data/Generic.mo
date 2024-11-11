within Buildings.Fluid.AirFilters.BaseClasses.Data;
record Generic "Generic data record for air filters"
  extends Modelica.Icons.Record;
  parameter Real mCon_nominal(
    final unit = "kg")
    "Maximum mass of the contaminant that can be captured by the filter";
  parameter String substanceName[:] = {"CO2"}
    "Name of trace substance";
  parameter
    Buildings.Fluid.AirFilters.BaseClasses.Characteristics.FiltrationEfficiencyParameters
    filEffPar
    "Filtration efficiency versus relative mass of the contaminant";
  parameter Real b = 1.1
    "Resistance coefficient";
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
June 27, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Record that contains performance parameters for air filters. </p>
<p>It is used as a template of performance data for the filter models in <a href=\"modelica://Buildings.Fluid.AirFilters\">Buildings.Fluid.AirFilters</a>. </p>
<p>The record includes a dataset that relates the mass of the captured contaminants to the filter&apos;s filtration efficiency (see <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>). </p>
<p>The record also contains a parameter that defines how the pressure drop changes with the mass of the captured contaminants (see <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection\">Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection</a>). </p>
</html>"));
end Generic;
