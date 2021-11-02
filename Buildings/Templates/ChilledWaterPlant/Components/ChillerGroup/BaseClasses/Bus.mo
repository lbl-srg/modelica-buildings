within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.BaseClasses;
expandable connector Bus "Generic control bus for chiller group classes"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.ChilledWaterPlant.Components.Chiller.BaseClasses.Bus chi[
    :] annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end Bus;
