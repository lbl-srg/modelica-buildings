within Buildings.Templates.ChilledWaterPlant.BaseClasses;
expandable connector BusChilledWater
  "Generic control bus for chilled water classes"
  extends Modelica.Icons.SignalBus;

  parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nCooTow "Number of cooling tower"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Templates.Components.Interfaces.Bus chi[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCHWChi[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus wse
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumPri
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumSec
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus cooTow[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowInl[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowOut[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumCon
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
end BusChilledWater;
