within Buildings.Templates.ZoneEquipment.Interfaces;
expandable connector Bus "Control bus for zone equipment"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.Components.Interfaces.Bus damVAV
    "VAV damper points"
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus coiHea
    "Heating coil points"
    annotation (HideResult=false);

  annotation (
    defaultComponentName="bus", Documentation(info="<html>
<p>
This expandable connector provides a standard interface for
all control signals required by a terminal unit controller.
</p>
</html>"));
end Bus;
