within Buildings.Templates.BaseClasses.Connectors;
expandable connector BusTerminalUnit "Terminal unit control bus"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.BaseClasses.Connectors.SubBusInput inp "Input points"
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.SubBusOutput out "Output points"
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.SubBusSoftware sof "Software points"
    annotation (HideResult=false);

  annotation (
  defaultComponentName="busTer",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusTerminalUnit;
