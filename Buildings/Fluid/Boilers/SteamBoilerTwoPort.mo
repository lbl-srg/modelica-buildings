within Buildings.Fluid.Boilers;
model SteamBoilerTwoPort
  "Steam boiler model with two ports for water flow with phase change"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialSteamBoiler;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SteamBoilerTwoPort;
