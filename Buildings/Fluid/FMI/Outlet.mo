within Buildings.Fluid.FMI;
model Outlet "Model for exposing a fluid outlet to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Buildings.Fluid.FMI.Interfaces.Outlet outlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal) "Fluid outlet"
                   annotation (Placement(transformation(extent={{
            100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Fluid port"
                annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}),
          iconTransformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput p(unit="Pa") if
       use_p_in "Pressure to be sent to outlet"
              annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Modelica.Blocks.Interfaces.RealOutput p_in_internal(unit="Pa")
    "Internal connector for pressure";

equation
  port_a.m_flow = outlet.m_flow;

  inStream(port_a.h_outflow)  = outlet.forward.h;
  inStream(port_a.Xi_outflow) = outlet.forward.Xi;
  inStream(port_a.C_outflow)  = outlet.forward.C;

  // Conditional connector for flow reversal
  connect(outlet.backward, bacPro_internal);
  if not allowFlowReversal then
    bacPro_internal.h  = Medium.h_default;
    bacPro_internal.Xi = Medium.X_default[1:Medium.nXi];
    bacPro_internal.C  = fill(0, Medium.nC);
  end if;
  bacPro_internal.h  = port_a.h_outflow;
  bacPro_internal.Xi = port_a.Xi_outflow;
  bacPro_internal.C  = port_a.C_outflow;

  // Conditional connectors for pressure
  outlet.p = p_in_internal;
  port_a.p = p_in_internal;
  if use_p_in then
     connect(p_in_internal, p);
  else
     p_in_internal = Medium.p_default;
  end if;

    annotation (defaultComponentName="bouOut",
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
          points={{60,0},{100,0}},
          color={0,0,255}),
        Rectangle(
          extent={{-100,20},{-60,-21}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{66,40},{100,0}},
          lineColor={0,0,255},
          textString="outlet"),
        Line(
          points={{0,-60},{0,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{10,-64},{44,-104}},
          lineColor={0,0,255},
          textString="p")}),
    Documentation(info="<html>
<p>
Model that is used to connect a fluid port with an output signal.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.Inlet\">
Buildings.Fluid.FMI.Inlet</a> in order for
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
January 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Outlet;
