within Buildings.Templates.Components.Dampers.Interfaces;
partial model PartialDamper
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Modelica.SIunits.PressureDifference dpDamper_nominal
    "Damper pressure drop"
    annotation (
      Dialog(group="Nominal condition"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Damper.None
     and typ <> Buildings.Templates.Components.Types.Damper.Barometric and typ
     <> Buildings.Templates.Components.Types.Damper.NoPath
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialDamper;
