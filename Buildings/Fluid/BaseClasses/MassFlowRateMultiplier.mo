within Buildings.Fluid.BaseClasses;
model MassFlowRateMultiplier "Model that multiplies the mass flow rate"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Boolean use_input=false
    "Set to true for multiplier factor provided as an input instead of a parameter"
    annotation(Evaluate=true);
  parameter Real k=1
    "Gain for mass flow rate"
    annotation(Dialog(enable=not use_input));

  Modelica.Blocks.Interfaces.RealInput u(
    final unit="1",
    final min=Modelica.Constants.small) if use_input
    "Multiplier factor"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput uInv if use_input
    "Inverse of the multiplier factor"
    annotation (Placement(transformation(
          extent={{100,50},{120,70}}), iconTransformation(extent={{100,50},{120,
            70}})));
protected
  Modelica.Blocks.Interfaces.RealInput u_internal
    "Connector for multiplier factor for internal use only"
    annotation (Placement(
    transformation(extent={{-60,20},{-20,60}}),iconTransformation(extent={{100,40},
    {140,80}})));

  Modelica.Blocks.Sources.Constant cst(
    final k=k) if not use_input
    "Constant gain value"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Math.Division div1 if use_input
    "Compute the inverse"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Modelica.Blocks.Sources.Constant one(
    final k=1) if use_input
    "Constant 1"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

initial equation
  assert(k > Modelica.Constants.small,
    "Gain must be strictly positive. Received k = " + String(k));
equation
  assert(u_internal > Modelica.Constants.small,
    "Gain must be strictly positive. Received u = " + String(u_internal));

  // Pressure drop in design flow direction
  port_a.p = port_b.p;

  // Mass balance (mass is not conserved by this model!)
  port_b.m_flow = -u_internal * port_a.m_flow;

  // Specific enthalpy flow rate
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  connect(cst.y, u_internal)
    annotation (Line(points={{-69,40},{-40,40}},color={0,0,127}));
  connect(u_internal, div1.u2)
    annotation (Line(points={{-40,40},{0,40},{0,54},{18,54}}, color={0,0,127}));
  connect(one.y, div1.u1)
    annotation (Line(points={{-19,80},{0,80},{0,66},{18,66}}, color={0,0,127}));
  connect(div1.y, uInv)
    annotation (Line(points={{41,60},{110,60}}, color={0,0,127}));
  connect(u, u_internal) annotation (Line(points={{-120,60},{-60,60},{-60,40},{-40,
          40}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<p>
This model multiplies the mass flow rate so that
<code>0 = port_b.m_flow + gain * port_a.m_flow</code>
where <code>gain &gt; 0</code> is either equal to
the input variable <code>u</code> if <code>use_input</code>
is set to <code>true</code>, or equal to
the parameter <code>k</code> if <code>use_input</code>
is set to <code>false</code>.
</p>
<p>
The specific enthalpy, the species concentration and the trace substance concentration
remain unchanged.
Therefore, this model does not conserve mass or energy.
It is used in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield</a>
and also in the Buildings library
to avoid having to instantiate circuits in parallel, with each
having the same mass flow rate and temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2023, by Antoine Gautier:<br/>
Added option to use input connector as multiplier factor.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1684\">#1684</a>.
</li>
<li>
March 27, 2013, by Michael Wetter:<br/>
Changed implementation to extend from <code>Modelica.Fluid</code>.
</li>
<li>
June 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,237,228},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
                          Polygon(
          points={{-100,8},{100,20},{100,-20},{-100,-8},{-100,8}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end MassFlowRateMultiplier;
