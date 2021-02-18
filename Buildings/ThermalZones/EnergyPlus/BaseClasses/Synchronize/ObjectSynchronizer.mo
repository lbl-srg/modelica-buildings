within Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize;
block ObjectSynchronizer "Model that synchronizes an object"
  outer Buildings.ThermalZones.EnergyPlus.Building building;
  Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.SynchronizeModel
    sync;
equation
  connect(building.synchronize, sync.synchronize);

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Block with <code>outer</code> declaration that is used to synchronize the calls to the Spawn objects.
</p>
</html>", revisions="<html>
<ul><li>
February 17, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ObjectSynchronizer;
