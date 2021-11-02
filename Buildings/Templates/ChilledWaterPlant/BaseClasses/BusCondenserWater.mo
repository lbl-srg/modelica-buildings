within Buildings.Templates.ChilledWaterPlant.BaseClasses;
expandable connector BusCondenserWater
  "Generic control bus for condenser water classes"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.BaseClasses.Bus cooTow
    annotation (HideResult=false);
  Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.BaseClasses.Bus pum
    annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusCondenserWater;
