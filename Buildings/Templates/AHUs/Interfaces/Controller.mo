within Buildings.Experimental.Templates.AHUs.Interfaces;
partial block Controller

  constant Types.Economizer typEco
    "Type of economizer"
    annotation (Evaluate=true,
      Dialog(group="Economizer"));
  constant Types.Coil typCoiCoo
    "Type of cooling coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  constant Types.Actuator typActCoiCoo
    "Type of cooling coil actuator"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  constant Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true,
      Dialog(group="Supply fan"));

  parameter Integer nTer = 0
    "Number of terminal units served by the AHU";

  BaseClasses.AhuBus ahuBus
    "AHU control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  BaseClasses.TerminalBus terBus[nTer]
    "Terminal unit control bus"
    annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={220,0}),                   iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=-90,
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
end Controller;
