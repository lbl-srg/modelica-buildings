within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    redeclare final package Medium=MediumAir);
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  constant Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Types.FanFunction fun
    "Equipment function"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  inner replaceable parameter Fans.Data.None dat
    constrainedby Fans.Data.None
    "Fan data"
    annotation (
      Placement(transformation(extent={{-10,-78},{10,-58}})));

  Templates.BaseClasses.AhuBus ahuBus if typ<>Types.Fan.None
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),    iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fan;
