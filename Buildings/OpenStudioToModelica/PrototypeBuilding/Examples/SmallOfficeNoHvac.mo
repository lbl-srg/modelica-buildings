within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model SmallOfficeNoHvac
  "Example of a small office building without HVAC systems"
  extends Buildings.OpenStudioToModelica.Interfaces.SimulationExample(
      nRooms = 6,
      redeclare
      Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeBuilding           building,
      redeclare
      Buildings.OpenStudioToModelica.InternalHeatGains.ZeroInternalHeatGain           ihg);
end SmallOfficeNoHvac;
