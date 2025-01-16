within Buildings.Fluid.AirFilters.Data;
record Generic "Generic data record for air filters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real mCon_nominal(
    final unit = "kg")
    "Maximum mass of the contaminant that can be captured by the filter";
  parameter String namCon[:]={"CO2"}
    "Contaminant names";
  parameter
    Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters
    filEffPar
    "Filtration efficiency versus relative mass of the contaminant";
  parameter Real b=1.1
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
<p>
Record that contains performance parameters for air filters.
</p>
<p>It is used as a template of performance data for the filter models in
<a href=\"modelica://Buildings.Fluid.AirFilters\">Buildings.Fluid.AirFilters</a>.
</p>
<p>
This record include the nominal air flow rate and the nominal pressure drop value.
</p>
<p>
Additionally, it features a curve that represents the relationship between the mass of captured contaminants 
and filtration efficiency
(see <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>).
</p>
<p>
Finally, it contains a parameter that defines how the pressure drop changes
with the mass of the captured contaminants
(see <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection\">
Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection</a>). </p>
</html>"));
end Generic;
