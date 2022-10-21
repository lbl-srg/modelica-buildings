within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
model PipeEnd "End of the distribution network"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    final h_outflow=Medium.h_default,
    final m_flow=0)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    final h_outflow=Medium.h_default,
    final m_flow=0)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}),
        iconTransformation(extent={{110,50},{90,70}})));

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-51},{2,51}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={48,61},
          rotation=90),
        Rectangle(
          extent={{-2,-51},{2,51}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={48,-61},
          rotation=90),
        Rectangle(
          extent={{-19,-5},{19,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={1,61},
          rotation=90),
        Rectangle(
          extent={{-19,-5},{19,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={1,-61},
          rotation=90)}),
    defaultComponentName = "pipEnd",
    Documentation(info="<html>
<p>
This model represents the end of the distribution pipe lines.
It imposes zero flow rates at both ports.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PipeEnd;
