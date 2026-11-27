within Buildings.Fluid.DataCenters.Racks.Liquid.Data;
record Generic
  "Generic data record for liquid-cooled single-phase rack"
  extends Buildings.Fluid.DataCenters.Racks.BaseClasses.Data.Generic;

  parameter Modelica.Units.SI.Power PColPla_nominal(min=0) = 0
    "Nominal heat flow rate of one cold plate (if 0, nColPla is computed from VColPla_flow_nominal)"
    annotation (Dialog(group="Nominal condition"));

  // Flow resistance
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") = 50000
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Real n(min=1, max=2) = 1.85 "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation(Evaluate=true,
      Dialog(group = "Flow resistance"));
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
      Dialog(group = "Flow resistance"));

  parameter BaseClasses.Generic_R_m_flow theRes "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for a liquid-cooled single-phase IT rack.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2026, by Michael Wetter:<br/>
Added optional parameter <code>PColPla_nominal</code> to specify the nominal
heat flow rate of one cold plate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
