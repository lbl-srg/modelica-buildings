within Buildings.Templates.AirHandlersFans.Interfaces;
expandable connector Bus "Main control bus"
  extends Modelica.Icons.SignalBus;

    Templates.Components.Interfaces.Bus fanSup
       "Supply fan points"
       annotation (HideResult=false);
    Templates.Components.Interfaces.Bus fanRet
      "Return fan points"
      annotation (HideResult=false);

    Templates.Components.Interfaces.Bus coiHeaPre
      "Heating coil (preheat position)points"
      annotation (HideResult=false);
    Templates.Components.Interfaces.Bus coiCoo
      "Cooling coil points"
      annotation (HideResult=false);
    Templates.Components.Interfaces.Bus coiHeaReh
      "Heating coil (reheat position) points"
      annotation (HideResult=false);

    Templates.Components.Interfaces.Bus damOut
      "OA damper points"
      annotation (HideResult=false);
    Templates.Components.Interfaces.Bus damOutMin
      "Minimum OA damper points"
      annotation (HideResult=false);
    Templates.Components.Interfaces.Bus damRel
      "Relief damper points"
      annotation (HideResult=false);
    Templates.Components.Interfaces.Bus damRet
      "Return damper points"
      annotation (HideResult=false);

  annotation (
    defaultComponentName="bus");
end Bus;
