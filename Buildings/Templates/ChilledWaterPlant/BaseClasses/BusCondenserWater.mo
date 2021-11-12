within Buildings.Templates.ChilledWaterPlant.BaseClasses;
expandable connector BusCondenserWater
  "Generic control bus for condenser water classes"
  extends Modelica.Icons.SignalBus;

  parameter Integer nPum "Number of condenser pumps";
  parameter Integer nCooTow "Number of cooling tower";

  Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.Bus
    cooTow(final nCooTow=nCooTow) annotation (HideResult=false);
  Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.Bus
    pum(final nPum=nPum) annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusCondenserWater;
