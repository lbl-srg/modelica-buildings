partial model PartialFourPortTransformer 
  "Partial element transporting two fluid streams between four ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialDoubleFluidParameters;
  import Modelica.Constants;
  
  Modelica_Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium = 
        Medium_1, m_flow(start=0, min=if allowFlowReversal_1 then -Constants.inf else 
                0)) 
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (extent=[-110,50; -90,70]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = 
        Medium_1, m_flow(start=0, max=if allowFlowReversal_1 then +Constants.inf else 
                0)) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,50; 90,70]);
  Modelica_Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium = 
        Medium_2, m_flow(start=0, min=if allowFlowReversal_2 then -Constants.inf else 
                0)) 
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (extent=[90,-70; 110,-50]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium = 
        Medium_2, m_flow(start=0, max=if allowFlowReversal_2 then +Constants.inf else 
                0)) 
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-90,-70; -110,-50]);
  Medium_1.BaseProperties medium_a1(T(start = Medium_1.T_default), h(start=Medium_1.h_default),
                   p(start=Medium_1.p_default)) "Medium properties in port_a1";
  Medium_1.BaseProperties medium_b1(T(start = Medium_1.T_default), h(start=Medium_1.h_default),
                   p(start=Medium_1.p_default)) "Medium properties in port_b1";
  Medium_1.MassFlowRate m_flow_1(start=0) 
    "Mass flow rate from port_a1 to port_b1 (m_flow_1 > 0 is design flow direction)";
  
  Medium_2.BaseProperties medium_a2(T(start = Medium_2.T_default), h(start=Medium_2.h_default),
                   p(start=Medium_2.p_default)) "Medium properties in port_a2";
  Medium_2.BaseProperties medium_b2(T(start = Medium_2.T_default), h(start=Medium_2.h_default),
                   p(start=Medium_2.p_default)) "Medium properties in port_b2";
  Medium_2.MassFlowRate m_flow_2(start=0) 
    "Mass flow rate from port_a2 to port_b2 (m_flow_2 > 0 is design flow direction)";
  
  Modelica.SIunits.HeatFlowRate Q_flow_1 "Heat transfered into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2 "Heat transfered into medium 2";
  
  Modelica.SIunits.VolumeFlowRate V_flow_a1 = port_a1.m_flow/medium_a1.d 
    "Volume flow rate at port_a1";
  Modelica.SIunits.Pressure dp1(start=0) 
    "Pressure difference between port_a1 and port_b1";
  
  Modelica.SIunits.VolumeFlowRate V_flow_a2 = port_a2.m_flow/medium_a2.d 
    "Volume flow rate at port_a2";
  Modelica.SIunits.Pressure dp2(start=0) 
    "Pressure difference between port_a2 and port_b2";
  
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
  
equation 
  // Properties in the ports
  // Medium 1
  port_a1.p   = medium_a1.p;
  port_a1.h   = medium_a1.h;
  port_a1.Xi = medium_a1.Xi;
  port_b1.p   = medium_b1.p;
  port_b1.h   = medium_b1.h;
  port_b1.Xi = medium_b1.Xi;
  // Medium 2
  port_a2.p   = medium_a2.p;
  port_a2.h   = medium_a2.h;
  port_a2.Xi = medium_a2.Xi;
  port_b2.p   = medium_b2.p;
  port_b2.h   = medium_b2.h;
  port_b2.Xi = medium_b2.Xi;
  /* Handle reverse and zero flow */
/*    port_a1.H_flow   = if port_a1.m_flow > 0 then port_a1.m_flow * port_a1.h else 
                            -port_b1.H_flow - Q_flow_1;
    port_b1.H_flow   = if port_a1.m_flow > 0 then -port_a1.H_flow - Q_flow_1 else 
                            -port_a1.m_flow * port_b1.h;
  
  port_a1.mXi_flow = semiLinear(port_a1.m_flow, port_a1.Xi, port_b1.Xi);
  port_a2.H_flow   = if port_a2.m_flow > 0 then port_a2.m_flow * port_a2.h else 
                            -port_b2.H_flow - Q_flow_2;
  port_b2.H_flow   = if port_a2.m_flow > 0 then -port_b2.H_flow - Q_flow_2 else 
                            -port_a2.m_flow * port_b2.h;
  
  port_a2.mXi_flow = semiLinear(port_a2.m_flow, port_a2.Xi, port_b2.Xi);
*/
  /* Energy, mass and substance mass balance */
  // to be added by child classes port_a1.H_flow   + port_b1.H_flow = 0;
  //                              port_a1.m_flow   + port_b1.m_flow = 0;
  //                              port_a1.mXi_flow + port_b1.mXi_flow = zeros(Medium_1.nXi);
  //                              port_a2.H_flow   + port_b2.H_flow = 0;
  //                              port_a2.m_flow   + port_b2.m_flow = 0;
  //                              port_a2.mXi_flow + port_b2.mXi_flow = zeros(Medium_2.nXi);
  
  // Design direction of mass flow rate
  m_flow_1 = port_a1.m_flow;
  m_flow_2 = port_a2.m_flow;
  
  // Pressure difference between ports
  dp1 = port_a1.p - port_b1.p;
  dp2 = port_a2.p - port_b2.p;
  
end PartialFourPortTransformer;
