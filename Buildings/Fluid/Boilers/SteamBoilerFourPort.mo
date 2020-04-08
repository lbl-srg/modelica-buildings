within Buildings.Fluid.Boilers;
model SteamBoilerFourPort
  "Model for a steam boiler with four ports for air and water flows, including medium changes"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialSteamBoiler;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SteamBoilerFourPort;
