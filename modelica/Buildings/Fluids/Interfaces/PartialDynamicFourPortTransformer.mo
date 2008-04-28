partial model PartialDynamicFourPortTransformer 
  "Partial element transporting two fluid streams between four ports with storing mass or energy" 
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
  
  Modelica.SIunits.VolumeFlowRate V_flow_a1 = port_a1.m_flow/medium_a1.d 
    "Volume flow rate at port_a1";
  
  Modelica.SIunits.VolumeFlowRate V_flow_a2 = port_a2.m_flow/medium_a2.d 
    "Volume flow rate at port_a2";
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
  
  Delays.DelayFirstOrder vol_1(
    redeclare package Medium = Medium_1,
    allowFlowReversal=allowFlowReversal_1,
    tau=tau_1,
    m0_flow=m0_flow_1) "Volume for fluid 1" 
                               annotation (extent=[-10,70; 10,50]);
  
  Delays.DelayFirstOrder vol_2(
    redeclare package Medium = Medium_2,
    allowFlowReversal=allowFlowReversal_2,
    tau=tau_2,
    m0_flow=m0_flow_2) "Volume for fluid 2" 
 annotation (extent=[-10,-50; 10,-70], rotation=
        180);
  
  parameter Modelica.SIunits.Time tau_1 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_1(min=0) "Mass flow rate" 
     annotation(Dialog(group = "Nominal condition"));
  
  parameter Modelica.SIunits.Time tau_2 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_2(min=0) "Mass flow rate" 
     annotation(Dialog(group = "Nominal condition"));
  
  Modelica.Thermal.HeatTransfer.HeatCapacitor mas(C=C) "Mass of metal" 
    annotation (extent=[-88,-10; -68,10], rotation=90);
  Modelica.Thermal.HeatTransfer.Convection con1 
    "Convection (and conduction) on fluid side 1" 
    annotation (extent=[-56,10; -36,30]);
  parameter Modelica.SIunits.HeatCapacity C=2 "Heat capacity of metal (= cp*m)";
  Modelica.Thermal.HeatTransfer.Convection con2 
    "Convection (and conduction) on fluid side 2" 
    annotation (extent=[-56,-30; -36,-10]);
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temSen_degC 
    annotation (extent=[17,-10; 37,10]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heaFloSen_1 
    "Heat input into fluid 1" annotation (extent=[-20,10; 0,30]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heaFloSen_2 
    "Heat input into fluid 1" annotation (extent=[-20,-30; 0,-10]);
equation 
  Q_flow_1 = heaFloSen_1.Q_flow;
  Q_flow_2 = heaFloSen_2.Q_flow;
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
  
  connect(con1.solid, mas.port) annotation (points=[-56,20; -68,20; -68,
        -1.68051e-18], style(color=42, rgbcolor={191,0,0}));
  connect(con2.solid, mas.port) annotation (points=[-56,-20; -56,-20.5; -68,
        -20.5; -68,-1.68051e-18], style(color=42, rgbcolor={191,0,0}));
  connect(mas.port, temSen_degC.port) annotation (points=[-68,-1.68051e-18; -35,
        -1.68051e-18; -35,6.10623e-16; 17,6.10623e-16], style(color=42,
        rgbcolor={191,0,0}));
  connect(port_a1, vol_1.port_a) annotation (points=[-100,60; -10.2,60], style(
        color=69, rgbcolor={0,127,255}));
  connect(vol_1.port_b, port_b1) 
    annotation (points=[10,60; 100,60], style(color=69, rgbcolor={0,127,255}));
  connect(port_a2, vol_2.port_a) annotation (points=[100,-60; 10.2,-60], style(
        color=69, rgbcolor={0,127,255}));
  connect(vol_2.port_b, port_b2) annotation (points=[-10,-60; -100,-60], style(
        color=69, rgbcolor={0,127,255}));
  connect(con1.fluid, heaFloSen_1.port_a) 
    annotation (points=[-36,20; -20,20], style(color=42, rgbcolor={191,0,0}));
  connect(con2.fluid, heaFloSen_2.port_a) annotation (points=[-36,-20; -20,-20],
      style(color=42, rgbcolor={191,0,0}));
  connect(heaFloSen_2.port_b, vol_2.thermalPort) annotation (points=[
        5.55112e-16,-20; 5.55112e-16,-27.85; -6.66134e-16,-27.85; -6.66134e-16,
        -50.2; -7.56025e-16,-50.2], style(color=42, rgbcolor={191,0,0}));
  connect(heaFloSen_1.port_b, vol_1.thermalPort) annotation (points=[
        5.55112e-16,20; 5.55112e-16,27.6; 6.66134e-16,27.6; 6.66134e-16,50.2],
      style(color=42, rgbcolor={191,0,0}));
end PartialDynamicFourPortTransformer;
