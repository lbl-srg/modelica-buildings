within Buildings.Obsolete.Fluid.Movers;
model FlowMachinePolynomial
  "Fan or pump with head and efficiency declared by a non-dimensional polynomial"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Modelica.Icons.ObsoleteModel;

  Modelica.Blocks.Interfaces.RealInput N_in "Prescribed rotational speed"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},   rotation=270,
        origin={0,70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));

  parameter Modelica.SIunits.Length D "Diameter";
  parameter Real[:] a "Polynomial coefficients for pressure=p(mNor_flow)";
  parameter Real[:] b "Polynomial coefficients for etaSha=p(mNor_flow)";
  parameter Real mNorMin_flow "Lowest valid normalized mass flow rate";
  parameter Real mNorMax_flow "Highest valid normalized mass flow rate";
  parameter Real scaM_flow = 1
    "Factor used to scale the mass flow rate of the fan (used for quickly adjusting fan size)";
  parameter Real scaDp = 1
    "Factor used to scale the pressure increase of the fan (used for quickly adjusting fan size)";

  Real pNor(min=0) "Normalized pressure";
  Real mNor_flow(start=mNorMax_flow) "Normalized mass flow rate";
  Real etaSha(min=0, max=1) "Efficiency, flow work divided by shaft power";
  Modelica.SIunits.Power PSha "Power input at shaft";

  Medium.Density rho "Medium density";
protected
  parameter Real pNorMin1(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMin2(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax1(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax2(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";

initial equation
 Modelica.Utilities.Streams.print("The model Buildings.Obsolete.Fluid.Movers.FlowMachinePolynomial is deprecated.
 It will be removed in future releases.
 You should use Buildings.Obsolete.Fluid.Movers.FlowMachine_y
 instead of Buildings.Obsolete.Fluid.Movers.FlowMachinePolynomial.");
 // check slope of polynomial outside the domain [mNorMin_flow, mNorMax_flow]
 pNorMin1 = Buildings.Fluid.Utilities.extendedPolynomial(
                                        c=a, x=mNorMin_flow/2, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMin2 = Buildings.Fluid.Utilities.extendedPolynomial(
                                        c=a, x=mNorMin_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMax1 = Buildings.Fluid.Utilities.extendedPolynomial(
                                        c=a, x=mNorMax_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMax2 = Buildings.Fluid.Utilities.extendedPolynomial(
                                        c=a, x=mNorMax_flow*2, xMin=mNorMin_flow, xMax=mNorMax_flow);
 assert(pNorMin1>pNorMin2,
    "Slope of pump pressure polynomial is non-negative for mNor_flow < mNorMin_flow. Check parameter a.");
 assert(pNorMax1>pNorMax2,
    "Slope of pump pressure polynomial is non-negative for mNorMax_flow < mNor_flow. Check parameter a.");

equation
  // For computing the density, we assume that the fan operates in the design flow direction.
  rho = Medium.density(
     Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));

  -dp = scaDp     * pNor      * rho * D*D   * N_in * N_in;
  m_flow = scaM_flow * mNor_flow * rho * D*D*D * N_in;
  pNor = Buildings.Fluid.Utilities.extendedPolynomial(
                                        c=a, x=mNor_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
  etaSha = max(0.1, Buildings.Fluid.Utilities.polynomial(
                                                      c=b, x=mNor_flow));
  etaSha * PSha = -dp * m_flow / rho; // dp<0 and m_flow>0 for normal operation

  // Energy balance (no storage, no heat loss/gain)
  PSha = -m_flow*(port_a.h_outflow-inStream(port_b.h_outflow));
  PSha = m_flow*(port_b.h_outflow-inStream(port_a.h_outflow));

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-92,4},{-54,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,2},{94,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,40},{60,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-30,12},{-30,-48},{48,-20},{-30,12}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Polygon(
          points={{-40,-64},{-60,-100},{60,-100},{40,-64},{-40,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,191},
          fillPattern=FillPattern.Solid),
        Line(points={{0,60},{0,60},{0,60},{0,40}}, color={0,0,255})}),
defaultComponentName="mov",
    Documentation(revisions="<html>
<ul>
<li>
March 27, 2010, by Michael Wetter:<br/>
Changed computation of density, which was needed due to changes in its base class.
</li>
<li>
March 11, 2008, by Michael Wetter:<br/>
Changed to new base class <code>PartialTwoPortTransformer</code>.
</li>
<li>
October 18, 2007, by Michael Wetter:<br/>
Added scaling factors to allow quickly to scale the fan pressure drop and mass flow rate.
</li>
<li>
July 20, 2007, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a flow machine (pump or fan).
</p>
<p>
The normalized pressure difference is computed using a function of the normalized mass flow rate. The function is a polynomial for which a user needs to supply the coefficients and two values that determine for what flow rate the polynomial is linearly extended.
</p>
<p>
<b>Note:</b> This model is here for compatibility with older versions of this library.
For new models, use instead <a href=\"modelica://Buildings.Obsolete.Fluid.Movers.FlowMachine_y\">
Buildings.Obsolete.Fluid.Movers.FlowMachine_y</a>.
</p>
</html>"));
end FlowMachinePolynomial;
