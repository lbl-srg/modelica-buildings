within Buildings.Templates.AHUs.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Templates.BaseClasses.AhuBus ahuBus if typ<>Types.Fan.None
    "AHU control bus"
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
