partial model PartialStaticFourPortHeatMassTransfer 
  "Partial element transporting two fluid streams between four ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortInterface;
  import Modelica.Constants;
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports, without
storing mass or energy. It is based on 
<tt>Modelica_Fluid.Interfaces.PartialTwoPortTransport</tt> but does not 
include the energy, mass and substance balance, and it uses four ports.
Reversal and zero mass flow rate is taken
care of, for details see definition of built-in operator semiLinear().
The variable names follow the conventions used in 
<tt>Modelica_Fluid.HeatExchangers.BasicHX</tt>.
<p>
When using this partial component, equations for the momentum
balance have to be added by specifying a relationship
between the pressure drop <tt>dpi</tt> and the mass flow rate <tt>m_flowi</tt>,
where <tt>i=1, 2</tt> and 
the energy and mass balances, such as
<pre>
  port_a1.H_flow   + port_b1.H_flow = 0;
  port_a1.m_flow   + port_b1.m_flow = 0;
  port_a1.mXi_flow + port_b1.mXi_flow = zeros(Medium_1.nXi);
 
  port_a2.H_flow   + port_b2.H_flow = 0;
  port_a2.m_flow   + port_b2.m_flow = 0;
  port_a2.mXi_flow + port_b2.mXi_flow = zeros(Medium_2.nXi);
</pre>
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=10,
          rgbfillColor={95,95,95})),
      Rectangle(extent=[-100,65; 101,55], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Rectangle(extent=[-100,-55; 101,-65], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1))));
  
  Medium_1.MassFlowRate mXi_flow_1[Medium_1.nXi] 
    "Mass flow rates of independent substances added to the medium 1";
  Medium_2.MassFlowRate mXi_flow_2[Medium_1.nXi] 
    "Mass flow rates of independent substances added to the medium 2";
  
equation 
  /* Handle reverse and zero flow */
  port_a1.H_flow   = if port_a1.m_flow >= 0 then (port_a1.m_flow * port_a1.h) else 
                         -port_b1.m_flow * port_b1.h - Q_flow_1;
  port_a1.mXi_flow = if port_a1.m_flow >= 0 then (port_a1.m_flow * port_a1.Xi) else 
                         -port_b1.m_flow * port_b1.Xi - mXi_flow_1;
  
  port_a2.H_flow   = if port_a2.m_flow >= 0 then (port_a2.m_flow * port_a2.h) else 
                         -port_b2.m_flow * port_b2.h - Q_flow_2;
  port_a2.mXi_flow = if port_a2.m_flow >= 0 then (port_a2.m_flow * port_a2.Xi) else 
                         -port_b2.m_flow * port_b2.Xi - mXi_flow_2;
  
  /* Energy, mass and substance mass balance */
  0 = port_a1.H_flow + port_b1.H_flow     + Q_flow_1;
  0 = port_a1.m_flow + port_b1.m_flow     + sum(mXi_flow_1);
  zeros(Medium_1.nXi) = port_a1.mXi_flow + port_b1.mXi_flow + mXi_flow_1;
  
  0 = port_a2.H_flow + port_b2.H_flow     + Q_flow_2;
  0 = port_a2.m_flow + port_b2.m_flow     + sum(mXi_flow_2);
  zeros(Medium_2.nXi) = port_a2.mXi_flow + port_b2.mXi_flow + mXi_flow_2;
  
end PartialStaticFourPortHeatMassTransfer;
