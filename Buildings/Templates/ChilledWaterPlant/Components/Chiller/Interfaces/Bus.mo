within Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces;
expandable connector Bus "Generic control bus for chiller classes"
  extends Modelica.Icons.SignalBus;

  Real TSet;
  Boolean on;

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end Bus;
