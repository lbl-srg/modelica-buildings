partial model PartialTwoPortTransformer 
  "Partial element transporting fluid between two ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialSingleFluidParameters;
  import Modelica.Constants;
  
  Modelica_Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0)) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-110,-10; -90,10]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = 
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else 
                0)) 
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,-10; 90,10]);
  Medium.BaseProperties medium_a "Medium properties in port_a";
  Medium.BaseProperties medium_b "Medium properties in port_b";
  Medium.MassFlowRate m_flow(start=0) 
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.VolumeFlowRate V_flow_a = port_a.m_flow/medium_a.d 
    "Volume flow rate near port_a";
  Modelica.SIunits.Pressure dp(start=0) 
    "Pressure difference between port_a and port_b";
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without
storing mass or energy. It is based on 
<tt>Modelica_Fluid.Interfaces.PartialTwoPortTransport</tt> but does not 
include the energy, mass and substance balance.
Reversal and zero mass flow rate is taken
care of, for details see definition of built-in operator semiLinear().
<p>
When using this partial component, an equation for the momentum
balance has to be added by specifying a relationship
between the pressure drop <tt>dp</tt> and the mass flow rate <tt>m_flow</tt> and 
the energy and mass balances, such as
<pre>
  port_a.H_flow + port_b.H_flow = 0;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);
</pre>
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon);
  
equation 
  // Properties in the ports
  port_a.p   = medium_a.p;
  port_a.h   = medium_a.h;
  port_a.Xi = medium_a.Xi;
  port_b.p   = medium_b.p;
  port_b.h   = medium_b.h;
  port_b.Xi = medium_b.Xi;
  
  /* Handle reverse and zero flow */
  port_a.H_flow   = semiLinear(port_a.m_flow, port_a.h,  port_b.h);
  port_a.mXi_flow = semiLinear(port_a.m_flow, port_a.Xi, port_b.Xi);
  
  /* Energy, mass and substance mass balance */
  // to be added by child classes port_a.H_flow + port_b.H_flow = 0;
  // to be added by child classes port_a.m_flow + port_b.m_flow = 0;
  // to be added by child classes port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);
  
  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  
  // Pressure difference between ports
  dp = port_a.p - port_b.p;
  
end PartialTwoPortTransformer;
