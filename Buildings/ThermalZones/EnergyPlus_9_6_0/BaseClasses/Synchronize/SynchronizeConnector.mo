within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.Synchronize;
connector SynchronizeConnector
  "Connector to synchronize Spawn objects"
  Real do
    "Potential variable";
  flow Real done
    "Flow variable";
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
Connector that is used to synchronize the calls to the Spawn objects.
</p>
</html>",
      revisions="<html>
<ul><li>
February 17, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SynchronizeConnector;
