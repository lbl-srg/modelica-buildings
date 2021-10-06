within Buildings.Templates.Interfaces;
partial model ChillerGroup
  extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare package Medium1=Buildings.Media.Water,
    redeclare package Medium2=Buildings.Media.Water,
    final hasMedium1=not is_airCoo,
    final hasMedium2=true);

  parameter Types.ChillerGroup typ
    "Type of chiller group"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // ToDo: Other ChillerGroup parameters

  parameter Boolean is_airCoo = false "Are chiller in group air cooled";

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.BaseClasses.Connectors.BusChillerGroup busCon "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerGroup;
