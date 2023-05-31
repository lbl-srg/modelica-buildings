within Buildings.Experimental.DHC.Plants.Cooling.BaseClasses;
model ParallelJunctions "A pair of junctions in parallel"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.Temperature T1_start
    "Start temperature of the volume";
  parameter Modelica.Units.SI.Temperature T2_start
    "Start temperature of the volume";

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(
          extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(
          extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(
          extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_c1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{-70,90},{-50,110}}), iconTransformation(
          extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_c2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa")) "Fluid connector" annotation (
    Placement(transformation(extent={{50,90},{70,110}}), iconTransformation(
          extent={{50,90},{70,110}})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=30,
    final T_start=T1_start,
    m_flow_nominal={-1,-1,1},
    final dp_nominal={0,0,0})
    "Junction"
    annotation (Placement(transformation(extent={{-70,70},{-50,50}})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=30,
    final T_start=T2_start,
    m_flow_nominal={1,1,-1},
    final dp_nominal={0,0,0})
    "Junction"
    annotation (Placement(transformation(extent={{50,-50},{70,-70}})));
equation
  connect(port_a1, jun1.port_1)
    annotation (Line(points={{-100,60},{-70,60}}, color={0,127,255}));
  connect(jun1.port_3,port_c1)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(jun1.port_2, port_b1)
    annotation (Line(points={{-50,60},{100,60}}, color={0,127,255}));
  connect(port_b2, jun2.port_1)
    annotation (Line(points={{-100,-60},{50,-60}}, color={0,127,255}));
  connect(jun2.port_2, port_a2)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  connect(jun2.port_3,port_c2)
    annotation (Line(points={{60,-50},{60,100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,-100.5},{1.5,100.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-0.5,59.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,-100.5},{1.5,100.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-0.5,-60.5},
          rotation=90),
        Rectangle(
          extent={{-19.5,-1.5},{19.5,1.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-59.5,79.5},
          rotation=90),
        Rectangle(
          extent={{-17.5,-1.5},{17.5,1.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={60.5,81.5},
          rotation=90),
        Rectangle(
          extent={{-57.5,-1.5},{57.5,1.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={60.5,-2.5},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName = "parJun",
    Documentation(info="<html>
<p>
This model provides junction models in parallel on the distribution pipe lines.
This model is for breaking algebraic loops only and has no pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ParallelJunctions;
