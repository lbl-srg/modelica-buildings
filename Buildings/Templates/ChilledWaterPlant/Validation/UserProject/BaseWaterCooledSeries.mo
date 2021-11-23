within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseWaterCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledSeries(
    final id="CHW_1");

equation
  connect(pumSec.busCon, chwCon.pumSec) annotation (Line(
      points={{70,20},{70,60.1},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="ahu");
end BaseWaterCooledSeries;
