partial model PartialStaticTwoPortInterface 
  "Partial element transporting fluid between two ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialSingleFluidParameters;
  import Modelica.Constants;
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between its two ports. It is based on 
<tt>Modelica_Fluid.Interfaces.PartialTwoPortTransport</tt> but does not 
include the energy, mass and substance balance.
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<tt>PartialStaticTwoPortHeatMassTransfer</tt>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <tt>C</tt> and <tt>mC_flow</tt>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
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
  Medium.BaseProperties medium_a(T(start = Medium.T_default), h(start=Medium.h_default),
                   p(start=Medium.p_default)) "Medium properties in port_a";
  Medium.BaseProperties medium_b(T(start = Medium.T_default), h(start=Medium.h_default),
                   p(start=Medium.p_default)) "Medium properties in port_b";
  Medium.MassFlowRate m_flow(start=0) 
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.VolumeFlowRate V_flow_a "Volume flow rate at port_a";
  Modelica.SIunits.Pressure dp(start=0) 
    "Pressure difference between port_a and port_b";
  
equation 
  // Properties in the ports
  port_a.p   = medium_a.p;
  port_a.h   = medium_a.h;
  port_a.Xi = medium_a.Xi;
  port_b.p   = medium_b.p;
  port_b.h   = medium_b.h;
  port_b.Xi = medium_b.Xi;
  
  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  
  // Volume flow rate
  V_flow_a = port_a.m_flow/medium_a.d;
  
  // Pressure difference between ports
  dp = port_a.p - port_b.p;
  
  ///////////////////////////////////////////////////////////////////////////////////
  // Extra species flow. This may be removed when upgrading to the new Modelica.Fluid.  
  port_a.mC_flow = semiLinear(port_a.m_flow, port_a.C, port_b.C);
  port_a.mC_flow + port_b.mC_flow = zeros(Medium.nC);
  ///////////////////////////////////////////////////////////////////////////////////
  
end PartialStaticTwoPortInterface;
