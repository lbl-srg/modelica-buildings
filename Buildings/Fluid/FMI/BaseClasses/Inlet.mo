within Buildings.Fluid.FMI.BaseClasses;
model Inlet "Model for exposing a fluid inlet to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  Buildings.Fluid.FMI.Interfaces.FluidPort_a inlet(
    redeclare final package Medium = Medium) "Fluid inlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Fluid port"
                annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));
  Modelica.Blocks.Interfaces.RealOutput p(unit="Pa") "Pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
equation
  // To locally balance the model, the pressure is only imposed at the
  // oulet model.
  port_b.m_flow     = inlet.m_flow;
  //port_b.p          = inlet.inflow.p;

  port_b.h_outflow  = inlet.forward.h;
  port_b.Xi_outflow = inlet.forward.Xi;
  port_b.C_outflow  = inlet.forward.C;

  inStream(port_b.h_outflow)  = inlet.backward.h;
  inStream(port_b.Xi_outflow) = inlet.backward.Xi;
  inStream(port_b.C_outflow)  = inlet.backward.C;

  // Send inlet pressure to signal port p
  p = inlet.p;

  annotation (defaultComponentName="boundary",
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
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
Note that boundary specific enthalpy,
mass fractions and trace substances have only an effect if mass flows
from the boundary into the port. If mass flows from
the port into the boundary, the boundary definitions,
with exception of the boundary pressure, do not have an effect.
</p>
<p>
This model can be used to send input signals from the FMI interface
to a fluid flow component model.
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
end Inlet;
