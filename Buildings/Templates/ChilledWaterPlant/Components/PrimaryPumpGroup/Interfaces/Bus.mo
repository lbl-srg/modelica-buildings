within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces;
expandable connector Bus
  "Generic control bus for chilled water return section"
  extends Modelica.Icons.SignalBus;

  parameter Integer nPum "Number of pumps";

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end Bus;
