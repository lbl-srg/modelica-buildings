within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.Data;
record Generic "Generic data record for IT rack"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate PIT_nominal(min=0)
    "IT power consumption at u=1, also called Thermal Design Power (TDP)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Data record for IT racks.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
