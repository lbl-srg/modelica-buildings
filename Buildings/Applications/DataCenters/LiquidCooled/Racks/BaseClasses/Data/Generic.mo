within Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.Data;
record Generic "Generic data record for IT rack"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate P_nominal(min=0)
    "Design heat flow rate at u=1, also called Thermal Design Power (TDP)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  // Flow resistance
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Real n(min=1, max=2) "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation(Evaluate=true,
      Dialog(group = "Flow resistance"));
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
      Dialog(group = "Flow resistance"));
  annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Data record for IT racks.
<p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
