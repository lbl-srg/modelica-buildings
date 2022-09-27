within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoopDebug "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
     final typ=Buildings.Templates.ChilledWaterPlants.Types.Controller.OpenLoop);

  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoopDebug;
