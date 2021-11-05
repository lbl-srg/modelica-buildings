within Buildings.Templates.ChilledWaterPlant.BaseClasses;
expandable connector BusChilledWater
  "Generic control bus for chilled water classes"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.Bus
    chi annotation (HideResult=false);
  Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.Bus
    wse annotation (HideResult=false);
  Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.Bus
    pumGro annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusChilledWater;
