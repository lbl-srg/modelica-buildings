within Buildings.Templates.Interfaces;
partial model Chiller
  extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare final package Medium1=Buildings.Media.Water,
    redeclare final package Medium2=Buildings.Media.Water,
    final hasMedium1=true,
    final hasMedium2=not is_airCoo);

  parameter Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // ToDo: Other Chiller parameters

  parameter Boolean is_airCoo = false "Is chiller air cooled";

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.BaseClasses.Connectors.BusChiller busCon "Control bus"
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
end Chiller;
