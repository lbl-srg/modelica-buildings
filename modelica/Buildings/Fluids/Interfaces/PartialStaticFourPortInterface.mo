partial model PartialStaticFourPortInterface 
  "Partial element transporting fluid between two ports without storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialDoubleFluidParameters;
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transport two fluid streams between four ports. It is based on 
<tt>Modelica_Fluid.Interfaces.PartialTwoPortTransport</tt> but does not 
include the energy, mass and substance balance.
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon);
  
  Modelica_Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium = 
        Medium_1, m_flow(start=0, min=if allowFlowReversal_1 then -Modelica.Constants.inf else 
                0)) 
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (extent=[-110,50; -90,70]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = 
        Medium_1, m_flow(start=0, max=if allowFlowReversal_1 then +Modelica.Constants.inf else 
                0)) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,50; 90,70]);
  Modelica_Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium = 
        Medium_2, m_flow(start=0, min=if allowFlowReversal_2 then -Modelica.Constants.inf else 
                0)) 
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (extent=[90,-70; 110,-50]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium = 
        Medium_2, m_flow(start=0, max=if allowFlowReversal_2 then +Modelica.Constants.inf else 
                0)) 
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-90,-70; -110,-50]);
  Medium_1.BaseProperties medium_a1(T(start = Medium_1.T_default), h(start=Medium_1.h_default),
                   p(start=Medium_1.p_default)) "Medium properties in port_a1";
  Medium_1.BaseProperties medium_b1(T(start = Medium_1.T_default), h(start=Medium_1.h_default),
                   p(start=Medium_1.p_default)) "Medium properties in port_b1";
  
  Medium_2.BaseProperties medium_a2(T(start = Medium_2.T_default), h(start=Medium_2.h_default),
                   p(start=Medium_2.p_default)) "Medium properties in port_a2";
  Medium_2.BaseProperties medium_b2(T(start = Medium_2.T_default), h(start=Medium_2.h_default),
                   p(start=Medium_2.p_default)) "Medium properties in port_b2";
  
  Medium_1.MassFlowRate m_flow_1(start=0) 
    "Mass flow rate from port_a1 to port_b1 (m_flow_1 > 0 is design flow direction)";
  Medium_2.MassFlowRate m_flow_2(start=0) 
    "Mass flow rate from port_a2 to port_b2 (m_flow_2 > 0 is design flow direction)";
  
  Modelica.SIunits.HeatFlowRate Q_flow_1 
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2 
    "Heat transfered from solid into medium 2";
  
  Modelica.SIunits.VolumeFlowRate V_flow_a1 "Volume flow rate at port_a1";
  
  Modelica.SIunits.VolumeFlowRate V_flow_a2 "Volume flow rate at port_a2";
  
  Modelica.SIunits.Pressure dp_1(start=0) 
    "Pressure difference between port_a1 and port_b1";
  Modelica.SIunits.Pressure dp_2(start=0) 
    "Pressure difference between port_a2 and port_b2";
  
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
  
  // Design direction of mass flow rate
  m_flow_1 = port_a1.m_flow;
  m_flow_2 = port_a2.m_flow;
  
  // Volume flow rates
  V_flow_a1 = port_a1.m_flow/medium_a1.d;
  V_flow_a2 = port_a2.m_flow/medium_a2.d;
  
  // Pressure difference between ports
  dp_1 = port_a1.p - port_b1.p;
  dp_2 = port_a2.p - port_b2.p;
  
end PartialStaticFourPortInterface;
