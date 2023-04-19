within Buildings.Templates.Components.Boilers;
model HotWaterTable "Hot water boiler"
  extends Buildings.Templates.Components.Interfaces.BoilerHotWater(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table,
    redeclare Buildings.Fluid.Boilers.BoilerTable boi(final per=dat.per));

  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HotWaterTable;
