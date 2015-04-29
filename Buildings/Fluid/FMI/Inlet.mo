within Buildings.Fluid.FMI;
model Inlet "Model for exposing a fluid inlet to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Buildings.Fluid.FMI.Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid inlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Fluid port"
                annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));
  Modelica.Blocks.Interfaces.RealOutput p(unit="Pa") if
     use_p_in "Pressure"
  annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
    "Internal connector for pressure";

equation
  // To locally balance the model, the pressure is only imposed at the
  // outlet model.
  // The sign is negative because inlet.m_flow > 0
  // means that fluid flows out of this component
  -port_b.m_flow     = inlet.m_flow;

  port_b.h_outflow  = inlet.forward.h;
  port_b.Xi_outflow = inlet.forward.Xi;
  port_b.C_outflow  = inlet.forward.C;

  // Conditional connector for flow reversal
  connect(inlet.backward, bacPro_internal);
  if allowFlowReversal then
    bacPro_internal.h  = inStream(port_b.h_outflow);
    bacPro_internal.Xi = inStream(port_b.Xi_outflow);
    bacPro_internal.C  = inStream(port_b.C_outflow);
  else
    bacPro_internal.h  = Medium.h_default;
    bacPro_internal.Xi = Medium.X_default[1:Medium.nXi];
    bacPro_internal.C  = fill(0, Medium.nC);
  end if;

  // Conditional connectors for pressure
  if use_p_in then
  connect(inlet.p, p_in_internal);
  else
    p_in_internal = Medium.p_default;
  end if;
  connect(p, p_in_internal);

  annotation (defaultComponentName="bouInl",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-100,0},{-60,0}},
          color={0,0,255}),
        Ellipse(
          extent={{-34,30},{26,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,20},{100,-21}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-18,26},{26,0},{-18,-26},{-18,26}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,6},{14,-12}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-6,8},{-2,4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,34},{-98,16}},
          lineColor={0,0,255},
          textString="inlet"),
        Line(
          points={{0,-100},{0,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{2,-76},{24,-94}},
          lineColor={0,0,255},
          textString="p")}),
    Documentation(info="<html>
<p>
Model that is used to connect an input signal to a fluid port.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.Outlet\">
Buildings.Fluid.FMI.Outlet</a> in order for
fluid mass flow rate and pressure to be properly assigned to
the acausal fluid models.
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.FMI.TwoPortComponent\">
Buildings.Fluid.FMI.TwoPortComponent</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.ResistanceVolume\">
Buildings.Fluid.FMI.Examples.FMUs.ResistanceVolume</a>
for how to use this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
January 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Inlet;
