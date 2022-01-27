within Buildings.Templates.ChilledWaterPlant.BaseClasses;
expandable connector BusCondenserWater
  "Generic control bus for condenser water classes"
  extends Modelica.Icons.SignalBus;

  parameter Integer nChi "Number of chillers";
  parameter Integer nPum "Number of condenser pumps";
  parameter Integer nCooTow "Number of cooling tower";

  Buildings.Templates.Components.Interfaces.Bus cooTow
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pum
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCWChi[nChi]
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
