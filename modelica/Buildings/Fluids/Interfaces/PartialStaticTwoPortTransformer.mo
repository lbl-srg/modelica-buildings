partial model PartialStaticTwoPortTransformer 
  "Partial element transporting fluid between two ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortInterface;
  import Modelica.Constants;
  
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
  /* Handle reverse and zero flow */
  port_a.H_flow   = semiLinear(port_a.m_flow, port_a.h,  port_b.h);
  port_a.mXi_flow = semiLinear(port_a.m_flow, port_a.Xi, port_b.Xi);
  
  /* Energy, mass and substance mass balance */
  // to be added by child classes port_a.H_flow + port_b.H_flow = 0;
  // to be added by child classes port_a.m_flow + port_b.m_flow = 0;
  // to be added by child classes port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);  
end PartialStaticTwoPortTransformer;
