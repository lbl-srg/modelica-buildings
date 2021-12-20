within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialDistribution
  "Partial model for distribution network"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(
      choice(redeclare package Medium=Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Integer nCon
    "Number of connections"
    annotation (Dialog(tab="General"),Evaluate=true);
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aCon[nCon](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection return ports"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,origin={80,100}),
      iconTransformation(extent={{-20,-80},{20,80}},rotation=90,origin={120,100})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bCon[nCon](
    redeclare each package Medium=Medium,
    each m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection supply ports"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,origin={-80,100}),
      iconTransformation(extent={{-20,-80},{20,80}},rotation=90,origin={-120,100})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisSup(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution supply inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-220,-20},{-180,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisSup(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution supply outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{180,-20},{220,20}})));
  annotation (
    defaultComponentName="dis",
    Documentation(
      info="
<html>
<p>
Partial model to be used for modeling various distribution networks e.g. 
one-pipe or two-pipe hydraulic distribution.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-100},{200,100}}),
      graphics={
        Text(
          extent={{-149,-104},{151,-144}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-200,-100},{200,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})));
end PartialDistribution;
