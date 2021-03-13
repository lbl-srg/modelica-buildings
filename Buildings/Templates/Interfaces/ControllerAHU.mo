within Buildings.Templates.Interfaces;
partial block ControllerAHU

  outer parameter Types.Coil typCoiCoo "Type of cooling coil"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.Valve typActCoiCoo "Type of cooling coil actuator"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.HeatExchanger typHexCoiCoo
    "Type of cooling coil heat exchanger"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.Coil typCoiHea "Type of heating coil"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.Valve typActCoiHea "Type of heating coil actuator"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.HeatExchanger typHexCoiHea
    "Type of heating coil heat exchanger"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  outer parameter Types.Fan typFanSup "Type of supply fan"
    annotation (Evaluate=true, Dialog(group="Supply fan"));
  outer parameter Integer nZon
    "Number of served zones";

  BaseClasses.Connectors.BusAHU busAHU "AHU control bus" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  BaseClasses.Connectors.BusAHU busTer[nZon] "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={220,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end ControllerAHU;
