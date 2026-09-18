within Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data;
record Generic "Generic data record for air cooled rack"
  extends
    Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.Data.Generic(
      m_flow_nominal=PIT_nominal/(dTSet*Buildings.Utilities.Psychrometrics.Constants.cpAir));

  parameter Modelica.Units.SI.Power PFan_nominal = 0.04*PIT_nominal
    "Fan power at full IT load PIT_nominal"
    annotation(Dialog(group="Fan"));

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Units.SI.TemperatureDifference dTSet(min=1) = 10
    "Set point for temperature rise across rack";

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for air-cooled IT rack.
</p>
<p>
The fan power consumption at full IT utilization is by default set to <i>4%</i> of the IT load.
This setting can be changed through the parameter <code>PFan_nominal</code>.
</p>
<p>
The parameter <code>fanRelPow</code> describes the normalized fan power consumption based
on the normalized fan volume flow rate. By default, this is set to a cubic curve.
</p>
<p>
The parameter <code>dTSet</code> is the set point for the air temperature raise across the rack,
which by default is set to <i>10</i> Kelvin.
This value is used, together with <code>PFan_nominal</code>, to compute the fan
design mass flow rate <code>m_flow_nominal</code>.
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
