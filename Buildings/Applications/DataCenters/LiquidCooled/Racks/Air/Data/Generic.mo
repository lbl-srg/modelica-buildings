within Buildings.Applications.DataCenters.LiquidCooled.Racks.Air.Data;
record Generic "Generic data record for air cooled rack"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow[:](each min=0)
    "Volume flow rate at user-selected points";
  parameter Modelica.Units.SI.ThermalResistance R[size(V_flow, 1)](
    each min=0) "Case-to-inlet thermal resistance";
  parameter Integer n(min=1) = 1
    "Order of desired polynomial that fits the data points (V_flow, R*V_flow)";
  annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
fixme.
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
