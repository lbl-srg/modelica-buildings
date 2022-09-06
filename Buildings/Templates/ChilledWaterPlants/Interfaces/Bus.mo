within Buildings.Templates.ChilledWaterPlants.Interfaces;
expandable connector Bus "Control bus for chilled water classes"
  extends Modelica.Icons.SignalBus;

  parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nCooTow "Number of cooling tower"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Templates.Components.Interfaces.Bus chi[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valChiWatChiIso[nChi]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumPri
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumSec
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus cooTow[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowInlIso[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valCooTowOutIso[nCooTow]
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumCon
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valConWatChiIso[nChi]
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus valChiWatEcoByp
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus valConWatEcoIso
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus pumEco
    annotation (HideResult=false);

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end Bus;
