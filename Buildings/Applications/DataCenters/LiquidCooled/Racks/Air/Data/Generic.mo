within Buildings.Applications.DataCenters.LiquidCooled.Racks.Air.Data;
record Generic "Generic data record for air cooled rack"
  extends Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.Data.Generic(
    m_flow_nominal = P_nominal/(dTSet*cp_default),
    dp_nominal=200,
    n=2);

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
