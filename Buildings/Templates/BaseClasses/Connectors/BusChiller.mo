within Buildings.Templates.BaseClasses.Connectors;
expandable connector BusChiller
  "Generic control bus for chiller classes"
  extends Buildings.Templates.BaseClasses.Connectors.BusInterface;

  Buildings.Templates.BaseClasses.Connectors.BusValve val_1
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.BusPump pum_1
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.BusValve val_2
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.BusPump pum_2
    annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusChiller;
