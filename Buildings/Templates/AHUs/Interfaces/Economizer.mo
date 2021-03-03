within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Economizer
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium";
  constant Types.Economizer typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  /*
  Does not work with OCT. 
  The specialized record must be declared in each specialized class.
  */
  replaceable parameter Economizers.Data.None dat
    constrainedby Economizers.Data.None
    "Economizer data"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare package Medium = Medium)
    "Outdoor air intake"
    annotation (Placement(transformation(
      extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-110,-80},{-90,-60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare package Medium = Medium)
    "Return air" annotation (Placement(transformation(extent={{90,50},
            {110,70}}), iconTransformation(extent={{90,62},{110,82}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
    redeclare package Medium = Medium)
    "Supply air" annotation (Placement(transformation(extent={{90,-70},
            {110,-50}}), iconTransformation(extent={{90,-80},{110,-60}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Exh(
    redeclare package Medium = Medium) if typ <> Types.Economizer.CommonDamperFreeNoRelief
    "Exhaust/relief air" annotation (Placement(transformation(
          extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,60},{-90,
            80}})));
  // Conditional
  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = Medium) if typ == Types.Economizer.DedicatedDamperTandem
    "Minimum outdoor air intake"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));

  Templates.BaseClasses.AhuBus ahuBus if typ<>Types.Economizer.None
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),    iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-116},{149,-156}},
          lineColor={0,0,255},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Economizer;
