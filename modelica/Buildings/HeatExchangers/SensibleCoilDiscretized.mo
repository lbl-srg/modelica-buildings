model SensibleCoilDiscretized 
  "Heat exchanger with discretization along the flow path" 
  extends Fluids.Interfaces.PartialStaticFourPortInterface;
  extends Buildings.BaseClasses.BaseIcon;
  
  annotation (
    Documentation(info="<html>
<p>
Model of a discretized heat exchanger. The heat exchanger is discretized
along the flow path. Each element has a state variable, modeled either using
a lumped mass for the metal interface, or a fluid volume for the
two flow paths.
</p>
<p>
The heat exchanger geometry is configured so that the heat exchanger
has different registers. A register is a collection of parallel pipes
that may be discretized along the pipe length. The pipes are perpendicular
to the air flow path. When using this model, the water (or liquid) flow path
needs to be connected to <tt>port_a1</tt> and <tt>port_b1</tt>, and
the air flow path need to be connected to the other two ports.
</p>
<p>
Currently, only sensible heat transfer is modeled.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=10,
          rgbfillColor={95,95,95})),
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
      Rectangle(extent=[-100,-55; 101,-65], style(
          pattern=0,
          fillColor=58,
          rgbfillColor={0,127,0})),
      Rectangle(extent=[-98,65; 103,55], style(
          pattern=0,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1))),
    Diagram(Text(
        extent=[60,72; 84,58],
        style(color=3, rgbcolor={0,0,255}),
        string="water-side"), Text(
        extent=[42,-22; 66,-36],
        style(color=3, rgbcolor={0,0,255}),
        string="air-side")),
    Coordsys(
      grid=[2,2],
      scale=0.5,
      extent=[-100,-100; 100,100]));
  
  parameter Modelica.SIunits.Temperature dT0(min=0) = 10 
    "Temperature difference" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q0_flow(min=0) = 1000 
    "Heat transfer at dT0" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.ThermalConductance UA0(min=0) = Q0_flow/dT0 
    "Thermal conductance at nominal flow, used to compute heat capacity" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Integer nReg(min=2)=2 "Number of registers" 
     annotation(Dialog(group = "Geometry"),
      Evaluate=true,
      choices( choice=2 " 2 Registers",
               choice=4 " 4 Registers",
               choice=6 " 6 Registers",
               choice=8 " 8 Registers",
               choice=10 "10 Registers"));
  parameter Integer nPipPar(min=1) = 3 
    "Number of parallel pipes in each register" 
     annotation(Dialog(group = "Geometry"));
  parameter Integer nPipSeg(min=1) = 4 
    "Number of pipe segments per register used for discretization" 
     annotation(Dialog(group = "Geometry"));
  
  Buildings.HeatExchangers.BaseClasses.SensibleCoilRegister hexReg[
                                                                  nReg](
    redeclare each package Medium_1 = Medium_1,
    redeclare each package Medium_2 = Medium_2,
    each final nPipPar=nPipPar,
    each final nPipSeg=nPipSeg,
    each final UA0=Q0_flow/dT0/nReg,
    each final m0_flow_1=m0_flow_1/nPipPar,
    each final m0_flow_2=m0_flow_1/nPipPar/nPipSeg,
    each tau_1=tau_1,
    each tau_2=tau_2,
    each tau_m=tau_m) "Heat exchanger register" 
    annotation (extent=[-10,0; 10,20]);
  Buildings.HeatExchangers.BaseClasses.PipeManifoldFixedResistance pipMan_a(
    redeclare package Medium = Medium_1,
    final nPipPar=nPipPar,
    final m0_flow=m0_flow_1,
    final dp0=dp0_1,
    final dh=dh_1,
    final ReC=ReC_1) "Pipe manifold at port a" annotation (extent=[-38,18; -18,
        38]);
  Buildings.HeatExchangers.BaseClasses.PipeManifoldNoResistance pipMan_b(
    redeclare package Medium = Medium_1,
    final nPipPar=nPipPar) "Pipe manifold at port b" 
                                         annotation (extent=[52,50; 32,70]);
  Buildings.HeatExchangers.BaseClasses.DuctManifoldNoResistance ducMan_b(
    redeclare package Medium = Medium_2,
    final nPipPar=nPipPar,
    final nPipSeg=nPipSeg) "Duct manifold at port b" 
    annotation (extent=[-52,-70; -32,-50]);
  Buildings.HeatExchangers.BaseClasses.DuctManifoldFixedResistance ducMan_a(
    redeclare package Medium = Medium_2,
    final nPipPar = nPipPar,
    final nPipSeg = nPipSeg,
    final m0_flow=m0_flow_2,
    final dp0=dp0_2,
    final dh=dh_2,
    final ReC=ReC_2) "Duct manifold at port a" 
    annotation (extent=[40,-26; 20,-6]);
public 
  parameter Modelica.SIunits.Length dh_1=0.025 
    "Hydraulic diameter for a single pipe" 
     annotation(Dialog(group = "Geometry"));
  parameter Real ReC_1=4000 
    "Reynolds number where transition to laminar starts inside pipes";
  parameter Modelica.SIunits.MassFlowRate m0_flow_1 
    "Mass flow rate at port_a1 for all pipes" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0_1 "Pressure drop for all pipes" 
      annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Length dh_2=1 "Hydraulic diameter for duct" 
      annotation(Dialog(group = "Geometry"));
  parameter Real ReC_2=4000 
    "Reynolds number where transition to laminar starts inside ducts";
  parameter Modelica.SIunits.MassFlowRate m0_flow_2 
    "Mass flow rate at port_a_2 for duct" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0_2 "Pressure drop inside duct" 
     annotation(Dialog(group = "Nominal condition"));
  Modelica.SIunits.HeatFlowRate Q_flow_1 
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2 
    "Heat transfered from solid into medium 2";
  parameter Modelica.SIunits.Time tau_1=60 
    "Time constant at nominal flow for medium 1" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau_2=60 
    "Time constant at nominal flow for medium 2" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau_m=60 
    "Time constant of metal at nominal UA value" 
    annotation (Dialog(group="Nominal condition"));
  
protected 
  BaseClasses.RegisterHeader hea1[nReg/2](
      redeclare each final package Medium = Medium_1,
      each final nPipPar = nPipPar) if 
      nReg > 1 "Pipe header to redirect flow into next register" 
    annotation (extent=[40,-4; 60,16],rotation=180);
  BaseClasses.RegisterHeader hea2[nReg/2-1](
      redeclare each final package Medium = Medium_1,
      each final nPipPar = nPipPar) if 
      nReg > 2 "Pipe header to redirect flow into next register" 
      annotation (extent=[-60,-2; -40,18]);
  Modelica.Blocks.Math.Gain gai_1(k=1/nReg) 
    "Gain medium-side 1 to take discretization into account" 
    annotation (extent=[-14,84; -2,98]);
  Modelica.Blocks.Math.Gain gai_2(k=1/nReg) 
    "Gain medium-side 2 to take discretization into account" 
    annotation (extent=[-14,60; -2,74],  rotation=0);
public 
  replaceable BaseClasses.HASensibleCoil hAModel(
               UA0=UA0, m0_flow_a=m0_flow_2, m0_flow_w=m0_flow_1,
               waterSideTemperatureDependent=true,
               waterSideFlowDependent=true,
               airSideTemperatureDependent=true,
               airSideFlowDependent=true) extends BaseClasses.PartialHA 
    "Model for convective heat transfer coefficient" 
        annotation (extent=[-58,74; -38,94],
      Dialog(tab = "Heat transfer"),
      Evaluate=false,
      choices(choice=BaseClasses.HASensibleCoil(UA0=UA0, m0_flow_a=m0_flow_2, m0_flow_w=m0_flow_1,
               waterSideTemperatureDependent=true,
               waterSideFlowDependent=true,
               airSideTemperatureDependent=true,
               airSideFlowDependent=true) 
        "Flow dependent, temperature dependent",
      choice=BaseClasses.HASensibleCoil(UA0=UA0, m0_flow_a=m0_flow_2, m0_flow_w=m0_flow_1,
               waterSideTemperatureDependent=false,
               waterSideFlowDependent=true,
               airSideTemperatureDependent=false,
               airSideFlowDependent=true) 
        "Flow dependent, temperature independent",
      choice=BaseClasses.HASensibleCoil(UA0=UA0, m0_flow_a=m0_flow_2, m0_flow_w=m0_flow_1,
               waterSideTemperatureDependent=false,
               waterSideFlowDependent=true,
               airSideTemperatureDependent=false,
               airSideFlowDependent=false) 
        "Water flow dependent, air flow & temperature independent",
      choice=BaseClasses.HASensibleCoil(UA0=UA0, m0_flow_a=m0_flow_2, m0_flow_w=m0_flow_1,
               waterSideTemperatureDependent=false,
               waterSideFlowDependent=false,
               airSideTemperatureDependent=false,
               airSideFlowDependent=true) 
        "Air flow dependent, water flow & temperature independent",
       choice=BaseClasses.HASensibleCoilConstant() "Constant"));
protected 
  Modelica_Fluid.Sensors.Temperature temSen_1(redeclare package Medium = 
        Medium_1) "Temperature sensor" annotation (extent=[-76,54; -62,66]);
  Modelica_Fluid.Sensors.MassFlowRate masFloSen_1(redeclare package Medium = 
        Medium_1) "Mass flow rate sensor" annotation (extent=[-54,54; -42,66]);
  Modelica_Fluid.Sensors.Temperature temSen_2(redeclare package Medium = 
        Medium_2) "Temperature sensor" annotation (extent=[58,-66; 44,-54]);
  Modelica_Fluid.Sensors.MassFlowRate masFloSen_2(redeclare package Medium = 
        Medium_2) "Mass flow rate sensor" annotation (extent=[82,-66; 70,-54]);
equation 
  Q_flow_1 = sum(hexReg[i].Q_flow_1 for i in 1:nReg);
  Q_flow_2 = sum(hexReg[i].Q_flow_2 for i in 1:nReg);
  
  // air stream connections
  for i in 2:nReg loop
    connect(hexReg[i].port_a2, hexReg[i-1].port_b2) annotation (points=[10,4; 10,
          -4; -10,-4; -10,3.8],
                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
  end for;
  connect(ducMan_a.port_b, hexReg[1].port_a2) annotation (points=[20,-16; 16,
        -16; 16,4; 10,4], style(color=69, rgbcolor={0,127,255}));
  connect(hexReg[nReg].port_b2, ducMan_b.port_b) annotation (points=[-10,3.8;
        -26,3.8; -26,-60; -32,-60],
                                style(color=69, rgbcolor={0,127,255}));
  connect(pipMan_a.port_b, hexReg[1].port_a1) annotation (points=[-18,28; -12,
        28; -12,16; -10,16], style(color=69, rgbcolor={0,127,255}));
  connect(hexReg[nReg].port_b1, pipMan_b.port_b) annotation (points=[10,16; 26,
        16; 26,60; 32,60],
                       style(color=69, rgbcolor={0,127,255}));
  connect(pipMan_b.port_a, port_b1) 
    annotation (points=[52,60; 100,60], style(color=69, rgbcolor={0,127,255}));
  connect(ducMan_b.port_a, port_b2) annotation (points=[-52,-60; -100,-60],
      style(color=69, rgbcolor={0,127,255}));
  for i in 1:2:nReg loop
    
  // header after first hex register
    connect(hexReg[i].port_b1, hea1[(i+1)/2].port_a) 
                                          annotation (points=[10,16; 70,16; 70,
          6; 60,6],
                  style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(hea1[(i+1)/2].port_b, hexReg[i+1].port_b1) 
        annotation (points=[40,6; 36,6; 36,10; 10,10; 10,16],
                    style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
  end for;
  // header after 2nd hex register
  for i in 2:2:(nReg-1) loop
    connect(hexReg[i].port_a1, hea2[i/2].port_a) 
      annotation (points=[-10,16; -64,16; -64,8; -60,8],
                    style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
    connect(hea2[i/2].port_b, hexReg[i+1].port_a1) 
      annotation (points=[-40,8; -34,8; -34,12; -10,12; -10,16],
                    style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
  end for;
  connect(port_a1, temSen_1.port_a) annotation (points=[-100,60; -76,60], style(
        color=69, rgbcolor={0,127,255}));
  connect(temSen_1.port_b, masFloSen_1.port_a) annotation (points=[-62,60; -54,
        60], style(color=69, rgbcolor={0,127,255}));
  connect(masFloSen_1.port_b, pipMan_a.port_a) annotation (points=[-42,60; -40,
        60; -40,28; -38,28], style(color=69, rgbcolor={0,127,255}));
  connect(temSen_1.T, hAModel.T_1)        annotation (points=[-69,53.4; -69,50;
        -80,50; -80,87; -59,87],
                             style(color=74, rgbcolor={0,0,127}));
  connect(masFloSen_1.m_flow, hAModel.m_flow_1)        annotation (points=[-48,53.4;
        -48,48; -82,48; -82,91; -59,91], style(color=74, rgbcolor={0,0,127}));
  connect(port_a2, masFloSen_2.port_a) annotation (points=[100,-60; 82,-60],
      style(color=69, rgbcolor={0,127,255}));
  connect(masFloSen_2.port_b, temSen_2.port_a) annotation (points=[70,-60; 58,
        -60], style(color=69, rgbcolor={0,127,255}));
  connect(temSen_2.port_b, ducMan_a.port_a) annotation (points=[44,-60; 40,-60;
        40,-16], style(color=69, rgbcolor={0,127,255}));
  connect(temSen_2.T, hAModel.T_2)        annotation (points=[51,-66.6; 51,-78;
        -84,-78; -84,81; -59,81],
                              style(color=74, rgbcolor={0,0,127}));
  connect(masFloSen_2.m_flow, hAModel.m_flow_2)        annotation (points=[76,-66.6;
        76,-82; -86,-82; -86,77; -59,77], style(color=74, rgbcolor={0,0,127}));
  connect(hAModel.hA_1, gai_1.u) 
    annotation (points=[-37,91; -15.2,91], style(color=3, rgbcolor={0,0,255}));
  connect(hAModel.hA_2, gai_2.u)        annotation (points=[-37,77; -27.5,77;
        -27.5,67; -15.2,67],
                       style(color=3, rgbcolor={0,0,255}));
  for i in 1:nReg loop
    connect(gai_1.y, hexReg[i].Gc_1) annotation (points=[-1.4,91; 12,91; 12,30; 
          -4,30; -4,20],
                      style(color=74, rgbcolor={0,0,127}));
    connect(gai_2.y, hexReg[i].Gc_2) annotation (points=[-1.4,67; 14,67; 14,-6; 
          4,-6; 4,-5.55112e-16],
                               style(color=74, rgbcolor={0,0,127}));
  end for;
end SensibleCoilDiscretized;
