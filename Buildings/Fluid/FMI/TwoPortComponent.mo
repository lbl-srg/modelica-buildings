within Buildings.Fluid.FMI;
block TwoPortComponent
  "Container to export thermofluid flow models with two ports as an FMU"
  extends TwoPort;
  replaceable Buildings.Fluid.Interfaces.PartialTwoPort com
    constrainedby Buildings.Fluid.Interfaces.PartialTwoPort(
      redeclare final package Medium = Medium,
      final allowFlowReversal=allowFlowReversal)
    "Component that holds the actual model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.RealExpression dpCom(y=com.port_a.p - com.port_b.p) if
       use_p_in "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

protected
  Buildings.Fluid.FMI.InletAdaptor bouIn(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Boundary model for inlet"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.FMI.OutletAdaptor bouOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Boundary component for outlet"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Blocks.Math.Feedback pOut if
       use_p_in "Pressure at component outlet"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(pOut.u1, bouIn.p) annotation (Line(
      points={{-8,-60},{-70,-60},{-70,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(com.port_a, bouIn.port_b) annotation (Line(
      points={{-10,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(com.port_b, bouOut.port_a) annotation (Line(
      points={{10,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dpCom.y, pOut.u2) annotation (Line(
      points={{-19,-80},{0,-80},{0,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pOut.y, bouOut.p) annotation (Line(
      points={{9,-60},{70,-60},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
Block that serves as a container to export a thermofluid flow component.
This block contains a replaceable model <code>com</code> that needs to
be redeclared to export any model that has as its base class
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPort\">
Buildings.Fluid.Interfaces.PartialTwoPort</a>.
This allows exporting a large variety of thermofluid flow models
with a simple redeclare.
</p>
<p>
See for example
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.FixedResistanceDpM\">
Buildings.Fluid.FMI.Examples.FMUs.FixedResistanceDpM</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.HeaterCooler_u\">
Buildings.Fluid.FMI.Examples.FMUs.HeaterCooler_u</a>
for how to use this block.
</p>
<p>
Note that this block must not be used if the instance <code>com</code>
sets a constant pressure. In such a situation, use
<a href=\"modelica://Buildings.Fluid.FMI.TwoPort\">
Buildings.Fluid.FMI.TwoPort</a>
together with
<a href=\"modelica://Buildings.Fluid.FMI.InletAdaptor\">
Buildings.Fluid.FMI.InletAdaptor</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.OutletAdaptor\">
Buildings.Fluid.FMI.OutletAdaptor</a>
and set the pressure to be equal to the port <code>p</code> of
<a href=\"modelica://Buildings.Fluid.FMI.OutletAdaptor\">
Buildings.Fluid.FMI.OutletAdaptor</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoPortComponent;
