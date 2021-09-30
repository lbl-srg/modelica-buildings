within Buildings.Templates.BaseClasses.Connectors;
expandable connector BusCondenserWater
  "Generic control bus for condenser water classes"
  extends Buildings.Templates.BaseClasses.Connectors.BusInterface;

  Buildings.Templates.BaseClasses.Connectors.BusInterface cooTow
    annotation (HideResult=false);
  Buildings.Templates.BaseClasses.Connectors.BusInterface conPum
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
