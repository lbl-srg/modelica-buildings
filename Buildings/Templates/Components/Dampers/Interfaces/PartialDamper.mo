within Buildings.Templates.Components.Dampers.Interfaces;
partial model PartialDamper
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Buildings.Templates.Components.Types.Damper typ "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Location loc
    "Equipment location"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "Entering air"
    annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "Leaving air"
    annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Buildings.Templates.Components.Interfaces.Bus bus if typ <> Buildings.Templates.Components.Types.Damper.None
     and typ <> Buildings.Templates.Components.Types.Damper.Barometric and typ
     <> Buildings.Templates.Components.Types.Damper.NoPath
    "Control bus"
    annotation (Placement(
      visible=DynamicSelect(true, typ <> Types.Damper.None and typ <> Types.Damper.NoPath),
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
        Text(
          visible=DynamicSelect(true, typ <> Types.Damper.None and
            typ <> Types.Damper.NoPath),
          extent={{-151,-116},{149,-156}},
          lineColor={0,0,255},
          textString="%name"),                                Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialDamper;
