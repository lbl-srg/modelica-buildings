within Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize;
model SynchronizeModel "Model to synchronize the Spawn objects"
  Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.SynchronizeConnector
    synchronize "Connector that is used to synchronize objects";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model that is used to synchronize the calls to the Spawn objects.
</p>
</html>", revisions="<html>
<ul><li>
February 17, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SynchronizeModel;
