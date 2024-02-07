within Buildings.Templates.AirHandlersFans.Interfaces;
expandable connector Bus "Control bus for air handler"
  extends Modelica.Icons.SignalBus;

  Buildings.Templates.Components.Interfaces.Bus fanSup
     "Supply fan points"
     annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus fanRel
    "Relief fan points"
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus fanRet
    "Return fan points"
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus coiHea
    "Heating coil (preheat or reheat position, only one coil allowed) points"
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus coiCoo
    "Cooling coil points"
    annotation (HideResult=false);

  Buildings.Templates.Components.Interfaces.Bus damOut
    "OA damper points"
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus damOutMin
    "Minimum OA damper points"
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus damRel
    "Relief damper points"
    annotation (HideResult=false);
  Buildings.Templates.Components.Interfaces.Bus damRet
    "Return damper points"
    annotation (HideResult=false);

  annotation (
    defaultComponentName="bus", Documentation(info="<html>
<p>
This expandable connector provides a standard interface for
all control signals required by an air handler controller.
</p>
</html>"));
end Bus;
