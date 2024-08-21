within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.Synchronize;
model SynchronizeBuilding
  "Model to synchronize the Spawn objects that belong to a building"
  Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.Synchronize.SynchronizeConnector synchronize
    "Connector that is used to synchronize objects";
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
Model that is used to synchronize the calls to the Spawn objects.
</p>
</html>",
      revisions="<html>
<ul><li>
February 17, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SynchronizeBuilding;
