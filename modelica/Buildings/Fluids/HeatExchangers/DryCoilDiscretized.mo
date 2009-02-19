within Buildings.Fluids.HeatExchangers;
model DryCoilDiscretized
  "Heat exchanger with discretization along the flow path"
  extends Fluids.Interfaces.PartialStaticFourPortInterface;

 annotation (
    Documentation(info="<html>
<p>
Model of a discretized coil with no water vapor condensation.
The coil consists of <tt>nReg</tt> registers
that are perpendicular to the air flow path. Each register consists of <tt>nPipPar</tt>
parallel pipes, and each pipe can be divided into <tt>nPipSeg</tt> pipe segments along
the pipe length. Thus, the smallest element of the coil consists of a pipe 
segment. These pipe segments are modeled by the instance <tt>ele</tt>.
Each element has a state variable for the metal. Depending
on the value of the boolean parameters <tt>steadyState_1</tt> and
<tt>steadyState_2</tt>, the fluid states are modeled dynamically or in steady
state.
If the parameter <tt>steadyStateDuctConnection</tt> is set the <tt>false</tt> then
a mixing volume of length <tt>dl</tt> is added to the duct connection. This can
help reducing the dimension of the nonlinear system of equations.
</p>
<p>
The convective heat transfer coefficients can, for each fluid individually, be 
computed as a function of the flow rate and/or the temperature,
or assigned to a constant. This computation is done in the instance
<tt>hA</tt>.
</p>
<p>
In this model, the water (or liquid) flow path
needs to be connected to <tt>port_a1</tt> and <tt>port_b1</tt>, and
the air flow path need to be connected to the other two ports.
</p>
<p>
To model humidity condensation, use the model 
<a href=\"Modelica:Buildings.Fluids.HeatExchangers.WetCoilDiscretized\">
Buildings.Fluids.HeatExchangers.WetCoilDiscretized</a> instead of this model, as
this model computes only sensible heat transfer.
</p>
</html>", revisions="<html>
<ul><li>
September 10, 2008, by Michael Wetter:<br>
Added additional parameters.
</li>
<li>
September 9, 2008 by Michael Wetter:<br>
Propagated more parameters.
</li>
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,4},{70,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString="water-side"), Text(
          extent={{42,-22},{66,-36}},
          lineColor={0,0,255},
          textString="air-side")}));

  parameter Modelica.SIunits.TemperatureDifference dT0(min=0) = 10
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
  parameter Boolean from_dp_1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean from_dp_2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Real deltaM_1(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to laminar occurs" 
       annotation(Dialog(enable = not use_dh_1 and not linearized_1, tab="Advanced"));
  parameter Real deltaM_2(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to laminar occurs" 
       annotation(Dialog(enable = not use_dh_2 and not linearized_2, tab="Advanced"));
  parameter Boolean linearized_1 = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  parameter Boolean linearized_2 = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  parameter Boolean use_dh_1 = false
    "Set to true to specify hydraulic diameter for pipe pressure drop" 
       annotation(Evaluate=true, Dialog(enable = not linearized, tab="Advanced"));
  parameter Boolean use_dh_2 = false
    "Set to true to specify hydraulic diameter for duct pressure drop)" 
       annotation(Evaluate=true, Dialog(enable = not linearized, tab="Advanced"));

  parameter Modelica_Fluid.Types.Dynamics energyDynamics_1=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica_Fluid.Types.Dynamics energyDynamics_2=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  Buildings.Fluids.HeatExchangers.BaseClasses.CoilRegister hexReg[nReg](
    redeclare each package Medium_1 = Medium_1,
    redeclare each package Medium_2 = Medium_2,
    each final allowFlowReversal_1=allowFlowReversal_1,
    each final allowFlowReversal_2=allowFlowReversal_2,
    each final nPipPar=nPipPar,
    each final nPipSeg=nPipSeg,
    each final UA0=Q0_flow/dT0/nReg,
    each final m0_flow_1=m0_flow_1/nPipPar,
    each final m0_flow_2=m0_flow_1/nPipPar/nPipSeg,
    each tau_1=tau_1,
    each tau_2=tau_2,
    each tau_m=tau_m,
    each final energyDynamics_1=energyDynamics_1,
    each final energyDynamics_2=energyDynamics_2,
    each allowCondensation=allowCondensation) "Heat exchanger register" 
    annotation (Placement(transformation(extent={{-10,0},{10,20}}, rotation=0)));
  Buildings.Fluids.HeatExchangers.BaseClasses.PipeManifoldFixedResistance pipMan_a(
    redeclare package Medium = Medium_1,
    final nPipPar=nPipPar,
    final m0_flow=m0_flow_1,
    final dp0=dp0_1,
    final dh=dh_1,
    final ReC=ReC_1,
    final mStart_flow_a=mStart_flow_a1,
    final linearized=linearized_1,
    final use_dh=use_dh_1,
    final deltaM=deltaM_1,
    final from_dp=from_dp_1,
    final allowFlowReversal=allowFlowReversal_1) "Pipe manifold at port a" 
                                               annotation (Placement(
        transformation(extent={{-38,18},{-18,38}}, rotation=0)));
  Buildings.Fluids.HeatExchangers.BaseClasses.PipeManifoldNoResistance pipMan_b(
    redeclare package Medium = Medium_1,
    final nPipPar=nPipPar,
    final mStart_flow_a=-mStart_flow_a1,
    final allowFlowReversal=allowFlowReversal_1) "Pipe manifold at port b" 
                                         annotation (Placement(transformation(
          extent={{52,50},{32,70}}, rotation=0)));
  Buildings.Fluids.HeatExchangers.BaseClasses.DuctManifoldNoResistance ducMan_b(
    redeclare package Medium = Medium_2,
    final nPipPar=nPipPar,
    final nPipSeg=nPipSeg,
    final mStart_flow_a=-mStart_flow_a2,
    final allowFlowReversal=allowFlowReversal_2) "Duct manifold at port b" 
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}}, rotation=
           0)));
  Buildings.Fluids.HeatExchangers.BaseClasses.DuctManifoldFixedResistance ducMan_a(
    redeclare package Medium = Medium_2,
    final nPipPar = nPipPar,
    final nPipSeg = nPipSeg,
    final m0_flow=m0_flow_2,
    final dp0=dp0_2,
    final dh=dh_2,
    final ReC=ReC_2,
    final dl=dl,
    final mStart_flow_a=mStart_flow_a2,
    final linearized=linearized_2,
    final use_dh=use_dh_2,
    final deltaM=deltaM_2,
    final from_dp=from_dp_2,
    final allowFlowReversal=allowFlowReversal_2,
    final energyDynamics=ductConnectionDynamics) "Duct manifold at port a" 
    annotation (Placement(transformation(extent={{40,-26},{20,-6}}, rotation=0)));
public
  parameter Modelica.SIunits.Length dh_1=0.025
    "Hydraulic diameter for a single pipe" 
     annotation(Dialog(group = "Geometry",
                enable = use_dh_1 and not linearized_1));
  parameter Real ReC_1=4000
    "Reynolds number where transition to laminar starts inside pipes" 
     annotation(Dialog(enable = use_dh_1 and not linearized_1, tab="Advanced"));
  parameter Real ReC_2=4000
    "Reynolds number where transition to laminar starts inside ducts" 
     annotation(Dialog(enable = use_dh_2 and not linearized_2, tab="Advanced"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_1
    "Mass flow rate at port_a1 for all pipes" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0_1 "Pressure drop for all pipes" 
      annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Length dh_2=1 "Hydraulic diameter for duct" 
      annotation(Dialog(group = "Geometry"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_2
    "Mass flow rate at port_a_2 for duct" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0_2 "Pressure drop inside duct" 
     annotation(Dialog(group = "Nominal condition"));
  Modelica.SIunits.HeatFlowRate Q_flow_1
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2
    "Heat transfered from solid into medium 2";
  parameter Modelica.SIunits.Time tau_1=20
    "Time constant at nominal flow for medium 1" 
    annotation (Dialog(group="Nominal condition", enable=not steadyState_1));
  parameter Modelica.SIunits.Time tau_2=1
    "Time constant at nominal flow for medium 2" 
    annotation (Dialog(group="Nominal condition", enable=not steadyState_2));
  parameter Modelica.SIunits.Time tau_m=20
    "Time constant of metal at nominal UA value" 
    annotation (Dialog(group="Nominal condition"));

protected
  BaseClasses.CoilHeader hea1[nReg/2](
      redeclare each final package Medium = Medium_1,
      each final nPipPar = nPipPar,
      each final mStart_flow_a=mStart_flow_a1,
      each allowFlowReversal=allowFlowReversal_1) if 
      nReg > 1 "Pipe header to redirect flow into next register" 
    annotation (Placement(transformation(
        origin={50,6},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  BaseClasses.CoilHeader hea2[nReg/2-1](
      redeclare each final package Medium = Medium_1,
      each final nPipPar = nPipPar,
      each final mStart_flow_a=mStart_flow_a1,
      each allowFlowReversal=allowFlowReversal_1) if 
      nReg > 2 "Pipe header to redirect flow into next register" 
      annotation (Placement(transformation(extent={{-60,-2},{-40,18}}, rotation=
           0)));
  Modelica.Blocks.Math.Gain gai_1(k=1/nReg)
    "Gain medium-side 1 to take discretization into account" 
    annotation (Placement(transformation(extent={{-14,84},{-2,98}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai_2(k=1/nReg)
    "Gain medium-side 2 to take discretization into account" 
    annotation (Placement(transformation(extent={{-14,60},{-2,74}}, rotation=0)));
public
  parameter Boolean waterSideFlowDependent = false
    "Set to false to make water-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent = false
    "Set to false to make air-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent = false
    "Set to false to make water-side hA independent of temperature" 
    annotation(Dialog(tab="Heat transfer"));
  constant Boolean airSideTemperatureDependent = false
    "Set to false to make air-side hA independent of temperature" 
    annotation(Dialog(tab="Heat transfer"));
  BaseClasses.HADryCoil hA(
    final UA0=UA0,
    final m0_flow_a=m0_flow_2,
    final m0_flow_w=m0_flow_1,
    final waterSideTemperatureDependent=waterSideTemperatureDependent,
    final waterSideFlowDependent=waterSideFlowDependent,
    final airSideTemperatureDependent=airSideTemperatureDependent,
    final airSideFlowDependent=airSideFlowDependent)
    "Model for convective heat transfer coefficient" 
        annotation (Placement(transformation(extent={{-60,80},{-40,100}},
          rotation=0)));
protected
  constant Boolean allowCondensation = false
    "Set to false to compute sensible heat transfer only" 
    annotation(Dialog(tab="Heat transfer"));

protected
  Modelica_Fluid.Sensors.TemperatureTwoPort temSen_1(
                                              redeclare package Medium = 
        Medium_1) "Temperature sensor" annotation (Placement(transformation(
          extent={{-58,54},{-48,66}}, rotation=0)));
  Modelica_Fluid.Sensors.MassFlowRate masFloSen_1(redeclare package Medium = 
        Medium_1) "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{-80,54},{-68,66}}, rotation=0)));
  Modelica_Fluid.Sensors.TemperatureTwoPort temSen_2(
                                              redeclare package Medium = 
        Medium_2) "Temperature sensor" annotation (Placement(transformation(
          extent={{58,-66},{44,-54}}, rotation=0)));
  Modelica_Fluid.Sensors.MassFlowRate masFloSen_2(redeclare package Medium = 
        Medium_2) "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{82,-66},{70,-54}}, rotation=0)));
public
  parameter Modelica_Fluid.Types.Dynamics ductConnectionDynamics=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for duct connection" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica.SIunits.Length dl=0.3
    "Length of mixing volume for duct connection" 
    annotation (Dialog(tab = "Assumptions", group="Dynamics", enable=not steadyStateDuctConnection));
  parameter Modelica.SIunits.MassFlowRate mStart_flow_a1=m0_flow_1
    "Guess value for mass flow rate at port_a1" 
    annotation(Dialog(tab="General", group="Initialization"));
  parameter Modelica.SIunits.MassFlowRate mStart_flow_a2=m0_flow_2
    "Guess value for mass flow rate at port_a2" 
    annotation(Dialog(tab="General", group="Initialization"));
initial equation
  assert(dT0>0,     "Parameter dT0 is negative. Check heat exchanger parameters.");
  assert(Q0_flow>0, "Parameter Q0_flow is negative. Check heat exchanger parameters.");
equation
  Q_flow_1 = sum(hexReg[i].Q_flow_1 for i in 1:nReg);
  Q_flow_2 = sum(hexReg[i].Q_flow_2 for i in 1:nReg);

  // air stream connections
  for i in 2:nReg loop
    connect(hexReg[i].port_a2, hexReg[i-1].port_b2) annotation (Line(points={{
            10,4},{10,-4},{-10,-4},{-10,3.8}}, color={0,127,255}));
  end for;
  connect(ducMan_a.port_b, hexReg[1].port_a2) annotation (Line(points={{20,-16},
          {16,-16},{16,4},{10,4}}, color={0,127,255}));
  connect(hexReg[nReg].port_b2, ducMan_b.port_b) annotation (Line(points={{-10,
          3.8},{-26,3.8},{-26,-60},{-32,-60}}, color={0,127,255}));
  connect(pipMan_a.port_b, hexReg[1].port_a1) annotation (Line(points={{-18,28},
          {-12,28},{-12,16},{-10,16}}, color={0,127,255}));
  connect(hexReg[nReg].port_b1, pipMan_b.port_b) annotation (Line(points={{10,
          16},{26,16},{26,60},{32,60}}, color={0,127,255}));
  connect(pipMan_b.port_a, port_b1) 
    annotation (Line(points={{52,60},{100,60}}, color={0,127,255}));
  connect(ducMan_b.port_a, port_b2) annotation (Line(points={{-52,-60},{-100,
          -60}}, color={0,127,255}));
  for i in 1:2:nReg loop

  // header after first hex register
    connect(hexReg[i].port_b1, hea1[(i+1)/2].port_a) 
                                          annotation (Line(points={{10,16},{70,
            16},{70,6},{60,6}}, color={0,127,255}));
    connect(hea1[(i+1)/2].port_b, hexReg[i+1].port_b1) 
        annotation (Line(points={{40,6},{36,6},{36,10},{10,10},{10,16}}, color=
            {0,127,255}));
  end for;
  // header after 2nd hex register
  for i in 2:2:(nReg-1) loop
    connect(hexReg[i].port_a1, hea2[i/2].port_a) 
      annotation (Line(points={{-10,16},{-64,16},{-64,8},{-60,8}}, color={0,127,
            255}));
    connect(hea2[i/2].port_b, hexReg[i+1].port_a1) 
      annotation (Line(points={{-40,8},{-34,8},{-34,12},{-10,12},{-10,16}},
          color={0,127,255}));
  end for;
  connect(masFloSen_1.m_flow, hA.m_flow_1)             annotation (Line(points={{-74,
          66.6},{-74,72},{-82,72},{-82,97},{-61,97}},       color={0,0,127}));
  connect(port_a2, masFloSen_2.port_a) annotation (Line(points={{100,-60},{82,
          -60}}, color={0,127,255}));
  connect(masFloSen_2.port_b, temSen_2.port_a) annotation (Line(points={{70,-60},
          {58,-60}}, color={0,127,255}));
  connect(temSen_2.port_b, ducMan_a.port_a) annotation (Line(points={{44,-60},{
          40,-60},{40,-16}}, color={0,127,255}));
  connect(temSen_2.T, hA.T_2)             annotation (Line(points={{51,-53.4},{
          51,-46},{-88,-46},{-88,87},{-61,87}}, color={0,0,127}));
  connect(masFloSen_2.m_flow, hA.m_flow_2)             annotation (Line(points={{76,
          -53.4},{76,-44},{-86,-44},{-86,83},{-61,83}},      color={0,0,127}));
  connect(hA.hA_1, gai_1.u) 
    annotation (Line(points={{-39,97},{-28,97},{-28,91},{-15.2,91}}, color={0,0,
          255}));
  connect(hA.hA_2, gai_2.u)             annotation (Line(points={{-39,83},{
          -27.5,83},{-27.5,67},{-15.2,67}}, color={0,0,255}));
  for i in 1:nReg loop
    connect(gai_1.y, hexReg[i].Gc_1) annotation (Line(points={{-1.4,91},{12,91},
            {12,30},{-4,30},{-4,20}}, color={0,0,127}));
    connect(gai_2.y, hexReg[i].Gc_2) annotation (Line(points={{-1.4,67},{14,67},
            {14,-6},{4,-6},{4,0}},             color={0,0,127}));
  end for;
  connect(port_a1, masFloSen_1.port_a) annotation (Line(
      points={{-100,60},{-80,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSen_1.port_b, temSen_1.port_a) annotation (Line(
      points={{-68,60},{-58,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen_1.port_b, pipMan_a.port_a) annotation (Line(
      points={{-48,60},{-38,60},{-38,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen_1.T, hA.T_1) annotation (Line(
      points={{-53,66.6},{-53,74},{-78,74},{-78,93},{-61,93}},
      color={0,0,127},
      smooth=Smooth.None));
end DryCoilDiscretized;
