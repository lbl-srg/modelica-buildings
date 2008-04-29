partial model PartialDynamicFourPortTransformer 
  "Partial element transporting two fluid streams between four ports with storing mass or energy" 
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortInterface;
  import Modelica.Constants;
  
  annotation (
    Coordsys(grid=[1, 1], component=[20, 20]),
    Diagram,
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports. 
It provides the basic model for implementing a dynamic heat exchanger.
It is used by <tt>HeatExchangers.BaseClasses.SensibleHexElement<tt>.
The variable names follow the conventions used in 
<tt>Modelica_Fluid.HeatExchangers.BasicHX</tt>.
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
