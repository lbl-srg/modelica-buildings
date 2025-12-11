within Buildings.Fluid.AirFilters.Data;
record Generic "Generic data record for air filters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    displayUnit="Pa") = 200
    "Nominal pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real m(min=0.5, max=1) = 0.85
    "Flow exponent, so that m_flow_nominal/ dp_nominal^m = m_flow/ dp^m. Set m=0.5 for turbulent, m=1 for laminar";
  parameter Modelica.Units.SI.Mass mCon_max
    "Maximum mass of the contaminant that can be captured by the filter"
    annotation (Dialog(group="Filter accumulated mass"));
  parameter Modelica.Units.SI.Mass mCon_start(final min=0) = 0
    "Initial contaminant mass of the filter after replacement"
    annotation (Dialog(group="Filter accumulated mass"));
  parameter String namCon[:]={"CO2"}
    "Contaminant names";
  parameter Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters filEffPar
    "Filtration efficiency versus relative mass of the contaminant";
  parameter Real b=1.1
    "Resistance coefficient (multiplier for pressure drop if filter is fully dirty)";
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
<p>
It is used as a template of performance data for the filter models in
<a href=\"modelica://Buildings.Fluid.AirFilters\">Buildings.Fluid.AirFilters</a>.
</p>
<p>
The default value for the flow exponent is set to <code>m=0.85</code>, which is the average of
the inverse of the value <code>a</code> in Li et al., 2022.
</p>
<p>
The filter flow resistance model is increasing the pressure drop based
on the mass accumulated in the filter. This is computed in
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.PressureDropWithVaryingFlowCoefficient\">
Buildings.Fluid.AirFilters.BaseClasses.PressureDropWithVaryingFlowCoefficient</a>
using the input <code>dpCor = b^M</code>, where <code>M</code> is the dimensionless ratio of the mass that is accumulated,
with <code>M=0</code> for a clean filter and <code>M=1</code> for a filter that accumulated the mass <code>mCon_max</code>.
If <code>dpCor=2</code>,
at the nominal mass flow rate <code>m_flow_nominal</code>,
there will be twice the pressure drop
compared to <code>dp_nominal</code>.
Hence, the achieve this, set <code>b=2</code>.
</p>
<h4>References</h4>
<p>
Qiang Li ta al., (2022). Experimental study on the synthetic dust loading characteristics
of air filters. Separation and Purification Technology 284 (2022), 120209.
</p>
</html>"));
end Generic;
