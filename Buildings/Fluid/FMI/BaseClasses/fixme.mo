within Buildings.Fluid.FMI.BaseClasses;
model fixme
  "Boundary with prescribed pressure, specific enthalpy, composition and trace substances"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

   Modelica.Fluid.Interfaces.FluidPort_a port(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,12},{112,-12}}),
        iconTransformation(extent={{92,8},{112,-12}})));

  parameter Boolean use_Xi_in = false
    "Get the composition from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s")
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}},
          rotation=0), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput p_in(unit="Pa")
    "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput h_in(unit="J/kg")
    "Prescribed boundary specific enthalpy"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput Xi_in[Medium.nXi] if use_Xi_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}},
          rotation=0), iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC] if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
          rotation=0), iconTransformation(extent={{-140,-100},{-100,-60}})));
protected
  Modelica.Blocks.Interfaces.RealInput Xi_in_internal[Medium.nXi]
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC]
    "Needed to connect to conditional connector";
equation
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
    Medium.singleState, true, Xi_in_internal, "Boundary_ph");
  connect(Xi_in, Xi_in_internal);
  connect(C_in, C_in_internal);
  if not use_Xi_in then
    Xi_in_internal = Medium.X_default[1:Medium.nXi];
  end if;
  if not use_C_in then
    C_in_internal = zeros(Medium.nC);
  end if;
  port.p          = p_in;
  port.h_outflow  = h_in;
  port.Xi_outflow = Xi_in_internal;
  port.C_outflow  = C_in_internal;
  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{60,80},{-42,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-100,80},{-42,80}},
          color={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-60,-80}},
          color={0,0,255}),
        Text(
          extent={{-106,126},{-28,86}},
          lineColor={0,0,0},
          textString="p"),
        Text(
          extent={{-120,14},{-42,-10}},
          lineColor={0,0,0},
          textString="h"),
        Text(
          visible=use_Xi_in,
          extent={{-122,-28},{-38,-54}},
          lineColor={0,0,0},
          textString="X"),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          textString="C"),
        Text(
          extent={{-92,62},{-20,22}},
          lineColor={0,0,0},
          textString="m_flow"),
        Text(
          extent={{-120,-68},{-36,-94}},
          lineColor={0,0,0},
          textString="C"),
        Line(
          points={{-100,40},{-42,40}},
          color={0,0,255}),
        Line(
          points={{-100,0},{-42,0}},
          color={0,0,255}),
        Line(
          visible=use_Xi_in,
          points={{-100,-40},{-42,-40}},
          color={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-42,-80}},
          color={0,0,255}),
        Ellipse(
          extent={{-22,30},{38,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,20},{100,-21}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-6,26},{38,0},{-6,-26},{-6,26}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-8,6},{26,-12}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{6,8},{10,4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
If <code>use_Xi_in</code> is false (default option), then
<code>Medium.Xi_default</code> will be used for the mass fraction.
The same applies for <code>use_C_in</code>.
<p>
Note, that boundary specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end fixme;
