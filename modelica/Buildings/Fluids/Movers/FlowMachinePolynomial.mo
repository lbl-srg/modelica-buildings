model FlowMachinePolynomial 
  "Pump with head and efficiency given by a non-dimensional polynomial" 
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortTransformer;
  
annotation (Icon(
      Rectangle(extent=[-92,4; -54,-4], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[56,2; 94,-6], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Ellipse(extent=[-60,40; 60,-80],   style(gradient=3)),
      Polygon(points=[-30,12; -30,-48; 48,-20; -30,12],   style(
          pattern=0,
          gradient=2,
          fillColor=7)),
      Polygon(points=[-40,-64; -60,-100; 60,-100; 40,-64; -40,-64],
          style(pattern=0, fillColor=74)),
      Line(points=[-100,60; -2,60; 0,60; 0,40], style(color=3, rgbcolor={0,0,
              255}))), Diagram,
    Documentation(revisions="<html>
<ul>
<li>
March 11, 2008 by Michael Wetter:<br>
Changed to new base class <tt>PartialTwoPortTransformer</tt>.
</li>
<li>
October 18, 2007 by Michael Wetter:<br>
Added scaling factors to allow quickly to scale the fan pressure drop and mass flow rate.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
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
</html>"));
  
  Modelica.Blocks.Interfaces.RealInput N_in(redeclare type SignalType = 
        Modelica.SIunits.AngularVelocity) "Prescribed rotational speed" 
    annotation (extent=[-120,50; -100,70], rotation=0);
  
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
 // check slope of polynomial outside the domain [mNorMin_flow, mNorMax_flow]
 pNorMin1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=mNorMin_flow/2, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMin2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=mNorMin_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMax1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=mNorMax_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
 pNorMax2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=mNorMax_flow*2, xMin=mNorMin_flow, xMax=mNorMax_flow);
 assert(pNorMin1>pNorMin2,
    "Slope of pump pressure polynomial is non-negative for mNor_flow < mNorMin_flow. Check parameter a.");
 assert(pNorMax1>pNorMax2,
    "Slope of pump pressure polynomial is non-negative for mNorMax_flow < mNor_flow. Check parameter a.");
equation 
  -dp = scaDp     * pNor      * medium_a.d * D*D   * N_in * N_in;
  m_flow = scaM_flow * mNor_flow * medium_a.d * D*D*D * N_in;
  pNor = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=mNor_flow, xMin=mNorMin_flow, xMax=mNorMax_flow);
  etaSha = max(0.1, Buildings.Fluids.Utilities.polynomial(
                                                      c=b, x=mNor_flow));
                                                                // for OpenModelica 1.4.3 sum(mNor_flow^(i - 1)*b[i] for i in 1:size(b,1));
  etaSha * PSha = -dp * m_flow / medium_a.d; // dp<0 and m_flow>0 for normal operation
  
  // interface ports and state conservation equations
  port_a.H_flow + port_b.H_flow + PSha = 0;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);
end FlowMachinePolynomial;
