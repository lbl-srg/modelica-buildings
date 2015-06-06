within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model SmallOfficeNoHvac
  "Example of a small office building without HVAC systems"
  extends Buildings.OpenStudioToModelica.Interfaces.SimulationExample(
      nRooms = 6,
      redeclare
      Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeBuilding           building,
      redeclare
      Buildings.OpenStudioToModelica.InternalHeatGains.ZeroInternalHeatGain           ihg(
        redeclare package Medium = Buildings.Media.Specialized.Air.PerfectGas));
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmallOfficeNoHvac;
