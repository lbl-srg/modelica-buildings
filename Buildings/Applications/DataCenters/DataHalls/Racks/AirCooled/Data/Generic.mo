within Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Data;
record Generic "Generic data record for air cooled rack"
  extends
    Buildings.Applications.DataCenters.DataHalls.Racks.BaseClasses.Data.Generic(
      m_flow_nominal=PIT_nominal/(dTSet*cp_default));

  parameter Modelica.Units.SI.Power PFan_nominal = 0.04*PIT_nominal
    "Fan power at full IT load PIT_nominal"
    annotation(Dialog(group="Fan power"));

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan fanRelPow(
       r_V = {0, 0.1,   0.3,   0.6,   1},
       r_P = {0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (
    Placement(transformation(extent={{22,70},{42,90}})),
    Dialog(group="Fan"));

  constant Modelica.Units.SI.SpecificHeatCapacity cp_default = 1014.54
    "Specific heat capacity";

  parameter Modelica.Units.SI.TemperatureDifference dTSet(min=1) = 10
    "Set point for temperature raise across rack";

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
