within Buildings.Templates.BaseClasses.Connectors;
expandable connector BusValve
  "Generic control bus for valve classes"
  extends Buildings.Templates.BaseClasses.Connectors.BusInterface;

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end BusValve;
