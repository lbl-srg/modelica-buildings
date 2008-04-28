model SensibleCoilRegister "Register for a heat exchanger" 
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.Fluids.Interfaces.PartialDoubleFluidParameters;
  import Modelica.Constants;
  
  annotation (
    Documentation(info="<html>
<p>
Register of a heat exchanger with dynamics on the fluids and the solid. 
The register represents one array of pipes that are perpendicular to the
air stream.
The <tt>hA</tt> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid in each heat exchanger element.
</p>
<p>
</p>
</html>",
revisions="<html>
<ul>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
extent=[-20,80; 0,100], Diagram,
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
          fillPattern=1)),
      Rectangle(extent=[36,80; 40,-80], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Rectangle(extent=[-40,80; -36,-80], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Rectangle(extent=[-2,80; 2,-80], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Rectangle(extent=[-70,4; 70,-2], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Text(
        extent=[62,-94; 88,-122],
        style(color=3, rgbcolor={0,0,255}),
        string="h"),
      Text(
        extent=[-80,112; -58,84],
        style(color=3, rgbcolor={0,0,255}),
        string="h")));
  
  parameter Integer nPipPar(min=1)=2 
    "Number of parallel pipes in each register";
  parameter Integer nPipSeg(min=1)=3 
    "Number of pipe segments per register used for discretization";
  final parameter Integer nEle = nPipPar * nPipSeg 
    "Number of heat exchanger elements";
  
  Buildings.HeatExchangers.BaseClasses.SensibleHexElement[
                      nPipPar, nPipSeg] ele(
    redeclare each package Medium_1 = Medium_1,
    redeclare each package Medium_2 = Medium_2,
    each flowDirection_1=flowDirection_1,
    each flowDirection_2=flowDirection_2,
    each tau_1=tau_1/nPipSeg,
    each m0_flow_1=m0_flow_1/nPipPar,
    each tau_2=tau_2,
    each m0_flow_2=m0_flow_2/nPipPar/nPipSeg,
    each tau_m=tau_m,
    each UA0=UA0/nPipPar/nPipSeg) "Element of a heat exchanger" 
    annotation (extent=[-10,20; 10,40]);
  
  Modelica_Fluid.Interfaces.FluidPort_a[nPipPar] port_a1(
        redeclare each package Medium = Medium_1,
        each m_flow(start=0, min=if allowFlowReversal_1 then -Constants.inf else 0)) 
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (extent=[-110,50; -90,70]);
  Modelica_Fluid.Interfaces.FluidPort_b[nPipPar] port_b1(
        redeclare each package Medium = Medium_1,
        each m_flow(start=0, max=if allowFlowReversal_1 then +Constants.inf else 0)) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,50; 90,70]);
  Modelica_Fluid.Interfaces.FluidPort_a[nPipPar,nPipSeg] port_a2(
        redeclare each package Medium = Medium_2,
        each m_flow(start=0, min=if allowFlowReversal_2 then -Constants.inf else 0)) 
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (extent=[90,-70; 110,-50]);
  Modelica_Fluid.Interfaces.FluidPort_b[nPipPar,nPipSeg] port_b2(
        redeclare each package Medium = Medium_2,
        each m_flow(start=0, max=if allowFlowReversal_2 then +Constants.inf else 0)) 
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-90,-72; -110,-52]);
  
  parameter Modelica.SIunits.HeatFlowRate UA0 
    "Thermal conductance at nominal flow, used to compute time constant" 
     annotation(Dialog(group = "Nominal condition"));
  
  parameter Modelica.SIunits.MassFlowRate m0_flow_1 "Mass flow rate medim 1" 
  annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_2 "Mass flow rate medium 2" 
  annotation(Dialog(group = "Nominal condition"));
  
  parameter Modelica.SIunits.Time tau_1=60 
    "Time constant at nominal flow for medium 1" 
  annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Time tau_2=60 
    "Time constant at nominal flow for medium 2" 
  annotation(Dialog(group = "Nominal condition"));
  Modelica.SIunits.HeatFlowRate Q_flow_1 
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2 
    "Heat transfered from solid into medium 2";
  parameter Modelica.SIunits.Time tau_m=60 
    "Time constant of metal at nominal UA value" 
    annotation (Dialog(group="Nominal condition"));
  Modelica.Blocks.Interfaces.RealInput Gc_2(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Signal representing the convective thermal conductance medium 2 in [W/K]" 
    annotation (extent=[20,-120; 60,-80],  rotation=90);
  Modelica.Blocks.Interfaces.RealInput Gc_1(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Signal representing the convective thermal conductance medium 1 in [W/K]" 
    annotation (extent=[-60,80; -20,120],  rotation=270);
protected 
  Modelica.Blocks.Math.Gain gai_1(k=1/nEle) 
    "Gain medium-side 1 to take discretization into account" 
    annotation (extent=[-34,48; -22,62]);
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle) 
    "Gain medium-side 2 to take discretization into account" 
    annotation (extent=[24,-76; 12,-62], rotation=0);
equation 
  Q_flow_1 = sum(ele[i,j].Q_flow_1 for i in 1:nPipPar, j in 1:nPipSeg);
  Q_flow_2 = sum(ele[i,j].Q_flow_2 for i in 1:nPipPar, j in 1:nPipSeg);
  for i in 1:nPipPar loop
    // liquid side (pipes)
    connect(ele[i,1].port_a1,       port_a1[i]) 
       annotation (points=[-10,36; -68,36; -68,60;
          -100,60],
      style(color=69, rgbcolor={0,127,255}));
    connect(ele[i,nPipSeg].port_b1, port_b1[i]) 
       annotation (points=[10,36; 44,36; 44,60; 100,60],
      style(color=69, rgbcolor={0,127,255}));
    for j in 1:nPipSeg-1 loop
      connect(ele[i,j].port_b1, ele[i,j+1].port_a1) 
       annotation (points=[10,36; 10,46; -10,46; -10,36],
          style(color=69, rgbcolor={0,127,255}));
    end for;
    // gas side (duct)                                                                                      //water connections
    for j in 1:nPipSeg loop
      connect(ele[i,j].port_a2, port_a2[i,j]) 
       annotation (points=[10,24; 40,24; 40,-60; 100,-60],
          style(color=69, rgbcolor={0,127,255}));
      connect(ele[i,j].port_b2, port_b2[i,j]) 
       annotation (points=[-10,24; -68,24; -68,
            -62; -100,-62],
          style(color=69, rgbcolor={0,127,255}));
    end for;
  end for;
  
  connect(Gc_1, gai_1.u)  annotation (points=[-40,100; -40,55; -35.2,55], style(
        color=74, rgbcolor={0,0,127}));
  connect(Gc_2, gai_2.u)  annotation (points=[40,-100; 40,-69; 25.2,-69], style(
        color=74, rgbcolor={0,0,127}));
  
  for i in 1:nPipPar loop
     for j in 1:nPipSeg loop
      connect(gai_1.y, ele[i,j].Gc_1)  annotation (points=[-21.4,55; -4,55; -4,
            40],
        style(color=74, rgbcolor={0,0,127}));
      connect(gai_2.y, ele[i,j].Gc_2)  annotation (points=[11.4,-69; 4,-69; 4,
            20],                                                                   style(
          color=74, rgbcolor={0,0,127}));
     end for;
  end for;
  
end SensibleCoilRegister;
