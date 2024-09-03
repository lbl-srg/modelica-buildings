within Buildings.Fluid.HeatExchangers;
model DryCoilDiscretized
  "Coil with discretization along the flow paths and no humidity condensation"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=true,
    from_dp1 = false,
    from_dp2 = false);

  constant Boolean initialize_p1 = not Medium1.singleState
    "Set to true to initialize the pressure of volume 1"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));
  constant Boolean initialize_p2 = not Medium2.singleState
    "Set to true to initialize the pressure of volume 2"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));

  constant Boolean airSideTemperatureDependent = false
    "Set to false to make air-side hA independent of temperature"
    annotation(Dialog(tab="Heat transfer"));

  parameter Modelica.Units.SI.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(tab="General", group="Nominal condition"));
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
  parameter Boolean use_dh1 = false
    "Set to true to specify hydraulic diameter for pipe pressure drop"
       annotation(Evaluate=true, Dialog(enable = not linearizeFlowResistance1, tab="Advanced"));
  parameter Boolean use_dh2 = false
    "Set to true to specify hydraulic diameter for duct pressure drop)"
       annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Length dh1=0.025
    "Hydraulic diameter for a single pipe" annotation (Dialog(group="Geometry",
        enable=use_dh1 and not linearizeFlowResistance1));
  parameter Real ReC_1=4000
    "Reynolds number where transition to turbulence starts inside pipes"
     annotation(Dialog(enable = use_dh1 and not linearizeFlowResistance1, tab="Advanced"));
  parameter Real ReC_2=4000
    "Reynolds number where transition to turbulence starts inside ducts"
     annotation(Dialog(enable = use_dh2 and not linearizeFlowResistance2, tab="Advanced"));
  parameter Modelica.Units.SI.Length dh2=1 "Hydraulic diameter for duct"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Time tau1=20
    "Time constant at nominal flow for medium 1" annotation (Dialog(group=
          "Nominal condition", enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Units.SI.Time tau2=10
    "Time constant at nominal flow for medium 2" annotation (Dialog(group=
          "Nominal condition", enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Units.SI.Time tau_m=20
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean waterSideFlowDependent = false
    "Set to false to make water-side hA independent of mass flow rate"
    annotation(Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent = false
    "Set to false to make air-side hA independent of mass flow rate"
    annotation(Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent = false
    "Set to false to make water-side hA independent of temperature"
    annotation(Dialog(tab="Heat transfer"));
  parameter Modelica.Units.SI.MassFlowRate mStart_flow_a1=m1_flow_nominal
    "Guess value for mass flow rate at port_a1"
    annotation (Dialog(tab="General", group="Initialization"));
  parameter Modelica.Units.SI.MassFlowRate mStart_flow_a2=m2_flow_nominal
    "Guess value for mass flow rate at port_a2"
    annotation (Dialog(tab="General", group="Initialization"));

  Modelica.Units.SI.HeatFlowRate Q1_flow=sum(hexReg[i].Q1_flow for i in 1:nReg)
    "Heat transferred from solid into medium 1";
  Modelica.Units.SI.HeatFlowRate Q2_flow=sum(hexReg[i].Q2_flow for i in 1:nReg)
    "Heat transferred from solid into medium 2";

  Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister hexReg[nReg](
    redeclare each package Medium1 = Medium1,
    redeclare each package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final nPipPar=nPipPar,
    each final nPipSeg=nPipSeg,
    each final m1_flow_nominal=m1_flow_nominal/nPipPar,
    each final m2_flow_nominal=m2_flow_nominal/nPipPar/nPipSeg,
    each tau1=tau1,
    each tau2=tau2,
    each tau_m=tau_m,
    each final energyDynamics=energyDynamics,
    initialize_p1 = {(i == 1 and (not Medium1.singleState)) for i in 1:nReg},
    initialize_p2 = {(i == 1 and (not Medium2.singleState)) for i in 1:nReg},
    each from_dp1=from_dp1,
    each linearizeFlowResistance1=linearizeFlowResistance1,
    each deltaM1=deltaM1,
    each from_dp2=from_dp2,
    each linearizeFlowResistance2=linearizeFlowResistance2,
    each deltaM2=deltaM2,
    each dp1_nominal=0,
    each dp2_nominal=0,
    each final UA_nominal=UA_nominal/nReg) "Heat exchanger register"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldFixedResistance
    pipMan_a(
    redeclare package Medium = Medium1,
    final nPipPar=nPipPar,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1_nominal,
    final dh=dh1,
    final ReC=ReC_1,
    final mStart_flow_a=mStart_flow_a1,
    final linearized=linearizeFlowResistance1,
    final use_dh=use_dh1,
    final deltaM=deltaM1,
    final from_dp=from_dp1,
    final allowFlowReversal=allowFlowReversal1) "Pipe manifold at port a"
    annotation (Placement(transformation(extent={{-38,18},{-18,38}})));

  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldNoResistance pipMan_b(
    redeclare package Medium = Medium1,
    final nPipPar=nPipPar,
    final mStart_flow_a=-mStart_flow_a1,
    final allowFlowReversal=allowFlowReversal1) "Pipe manifold at port b"
    annotation (Placement(transformation(extent={{52,50},{32,70}})));

  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldNoResistance ducMan_b(
    redeclare package Medium = Medium2,
    final nPipPar=nPipPar,
    final nPipSeg=nPipSeg,
    final mStart_flow_a=-mStart_flow_a2,
    final allowFlowReversal=allowFlowReversal2) "Duct manifold at port b"
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));

  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    ducMan_a(
    redeclare package Medium = Medium2,
    final nPipPar = nPipPar,
    final nPipSeg = nPipSeg,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal,
    final dh=dh2,
    final ReC=ReC_2,
    final mStart_flow_a=mStart_flow_a2,
    final linearized=linearizeFlowResistance2,
    final use_dh=use_dh2,
    final deltaM=deltaM2,
    final from_dp=from_dp2,
    final allowFlowReversal=allowFlowReversal2) "Duct manifold at port a"
    annotation (Placement(transformation(extent={{40,-26},{20,-6}})));

  BaseClasses.HADryCoil hA(
    final UA_nominal=UA_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final waterSideTemperatureDependent=waterSideTemperatureDependent,
    final waterSideFlowDependent=waterSideFlowDependent,
    final airSideTemperatureDependent=airSideTemperatureDependent,
    final airSideFlowDependent=airSideFlowDependent)
    "Model for convective heat transfer coefficient"
        annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

protected
  constant Boolean allowCondensation = false
    "Set to false to compute sensible heat transfer only"
    annotation(Dialog(tab="Heat transfer"));

  final parameter Boolean use_temSen_1=
    waterSideTemperatureDependent and allowFlowReversal1 and
    (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, set to true if the temperature sensor 1 is used"
    annotation(Evaluate=true);

  final parameter Boolean use_temSen_2=
    airSideTemperatureDependent and allowFlowReversal2 and
    (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, set to true if the temperature sensor 2 is used"
    annotation(Evaluate=true);

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_1(
   redeclare package Medium = Medium1,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    tau=if use_temSen_1 then 1 else 0)
    "Temperature sensor, used to obtain temperature for convective heat transfer calculation"
    annotation (Placement(transformation(
          extent={{-58,54},{-46,66}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_1(
    redeclare package Medium = Medium1) "Mass flow rate sensor"
    annotation (Placement(transformation(
          extent={{-80,54},{-68,66}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    m_flow_nominal=m2_flow_nominal,
    tau=if use_temSen_2 then 1 else 0)
    "Temperature sensor, used to obtain temperature for convective heat transfer calculation"
    annotation (Placement(transformation(extent={{58,-66},{44,-54}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_2(
    redeclare package Medium = Medium2)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{82,-66},{70,-54}})));

  BaseClasses.CoilHeader hea1[div(nReg,2)](
      redeclare each final package Medium = Medium1,
      each final nPipPar = nPipPar,
      each final mStart_flow_a=mStart_flow_a1,
      each allowFlowReversal=allowFlowReversal1)
   if nReg > 1 "Pipe header to redirect flow into next register"
    annotation (Placement(transformation(
        origin={50,6},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  BaseClasses.CoilHeader hea2[div(nReg,2)-1](
      redeclare each final package Medium = Medium1,
      each final nPipPar = nPipPar,
      each final mStart_flow_a=mStart_flow_a1,
      each allowFlowReversal=allowFlowReversal1)
   if nReg > 2 "Pipe header to redirect flow into next register"
      annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Modelica.Blocks.Math.Gain gai_1(k=1/nReg)
    "Gain medium-side 1 to take discretization into account"
    annotation (Placement(transformation(extent={{-14,84},{-2,98}})));
  Modelica.Blocks.Math.Gain gai_2(k=1/nReg)
    "Gain medium-side 2 to take discretization into account"
    annotation (Placement(transformation(extent={{-14,60},{-2,74}})));

  Modelica.Blocks.Sources.RealExpression THA1(
    y=if waterSideTemperatureDependent then
        if allowFlowReversal1 then
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
            temSen_1.T
          else
            hexReg[1].ele[1,1].vol1.T
        else
          Medium1.temperature(
            state=Medium1.setState_phX(p=port_a1.p, h=inStream(port_a1.h_outflow), X=inStream(port_a1.Xi_outflow)))
        else
          Medium1.T_default)
    "Temperature used for convective heat transfer calculation for medium 1 (water-side)"
    annotation (Placement(transformation(extent={{-80,78},{-66,88}})));

  Modelica.Blocks.Sources.RealExpression THA2(
    y=if airSideTemperatureDependent then
        if allowFlowReversal1 then
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
            temSen_2.T
          else
            hexReg[1].ele[1,1].vol2.T
        else
          Medium2.temperature(
            state=Medium2.setState_phX(p=port_a2.p, h=inStream(port_a2.h_outflow), X=inStream(port_a2.Xi_outflow)))
        else
          Medium2.T_default)
    "Temperature used for convective heat transfer calculation for medium 2 (air-side)"
    annotation (Placement(transformation(extent={{-80,72},{-66,82}})));

  parameter Modelica.Units.SI.ThermalConductance GDif1=1E-2*UA_nominal/(nPipPar
      *max(1, nPipSeg - 1)*nReg)
    "Thermal conductance to approximate diffusion (which improves model at near-zero flow rates)"
    annotation (Dialog(tab="Experimental"));

  parameter Modelica.Units.SI.ThermalConductance GDif2=1E-2*UA_nominal/(nPipPar
      *nPipSeg*max(1, nReg - 1))
    "Thermal conductance to approximate diffusion (which improves model at near-zero flow rates)"
    annotation (Dialog(tab="Experimental"));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon1[nReg, nPipPar, nPipSeg-1](
    each final G=GDif1)
    "Thermal connector between the pipe segements to approximate diffusion in water (diffusion through the header is neglected)"
    annotation (Placement(transformation(extent={{-12,32},{8,52}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon2[nReg-1, nPipPar, nPipSeg](
    each final G=GDif2)
    "Thermal connector to approximate diffusion in air"
    annotation (Placement(transformation(extent={{10,-32},{-10,-12}})));

initial equation
  assert(UA_nominal>0, "Parameter UA_nominal is negative. Check heat exchanger parameters.");
equation

  // air stream connections
  for i in 2:nReg loop
    connect(hexReg[i].port_a2, hexReg[i-1].port_b2) annotation (Line(points={{10,4},{
            10,-4},{-10,-4},{-10,3.8}},        color={0,127,255}));
  end for;
  connect(ducMan_a.port_b, hexReg[1].port_a2) annotation (Line(points={{20,-16},
          {16,-16},{16,4},{10,4}}, color={0,127,255}));
  connect(hexReg[nReg].port_b2, ducMan_b.port_b) annotation (Line(points={{-10,
          3.8},{-26,3.8},{-26,-60},{-32,-60}}, color={0,127,255}));
  connect(pipMan_a.port_b, hexReg[1].port_a1) annotation (Line(points={{-18,28},
          {-12,28},{-12,16},{-10,16}}, color={0,127,255}));
  connect(hexReg[nReg].port_a1, pipMan_b.port_b) annotation (Line(points={{-10,16},
          {26,16},{26,60},{32,60}},     color={0,127,255}));
  connect(pipMan_b.port_a, port_b1)
    annotation (Line(points={{52,60},{100,60}}, color={0,127,255}));
  connect(ducMan_b.port_a, port_b2) annotation (Line(points={{-52,-60},{-100,
          -60}}, color={0,127,255}));
  for i in 1:2:nReg loop

  // header after first hex register
    connect(hexReg[i].port_b1, hea1[div((i+1),2)].port_a)
                                          annotation (Line(points={{10,16},{70,
            16},{70,6},{60,6}}, color={0,127,255}));
    connect(hea1[div((i+1),2)].port_b, hexReg[i+1].port_b1)
        annotation (Line(points={{40,6},{36,6},{36,10},{10,10},{10,16}}, color=
            {0,127,255}));
  end for;
  // header after 2nd hex register
  for i in 2:2:(nReg-1) loop
    connect(hexReg[i].port_a1, hea2[div(i,2)].port_a)
      annotation (Line(points={{-10,16},{-64,16},{-64,8},{-60,8}}, color={0,127,
            255}));
    connect(hea2[div(i,2)].port_b, hexReg[i+1].port_a1)
      annotation (Line(points={{-40,8},{-34,8},{-34,12},{-10,12},{-10,16}},
          color={0,127,255}));
  end for;
  connect(masFloSen_1.m_flow, hA.m1_flow)             annotation (Line(points={{-74,
          66.6},{-74,70},{-90,70},{-90,92},{-64,92},{-64,87},{-61,87}},
                                                            color={0,0,127}));
  connect(port_a2, masFloSen_2.port_a) annotation (Line(points={{100,-60},{82,
          -60}}, color={0,127,255}));
  connect(masFloSen_2.port_b, temSen_2.port_a) annotation (Line(points={{70,-60},
          {58,-60}}, color={0,127,255}));
  connect(temSen_2.port_b, ducMan_a.port_a) annotation (Line(points={{44,-60},{
          40,-60},{40,-16}}, color={0,127,255}));
  connect(masFloSen_2.m_flow, hA.m2_flow)             annotation (Line(points={{76,
          -53.4},{76,-44},{-86,-44},{-86,73},{-61,73}},      color={0,0,127}));
  connect(hA.hA_1, gai_1.u)
    annotation (Line(points={{-39,87},{-28,87},{-28,91},{-15.2,91}}, color={0,0,
          255}));
  connect(hA.hA_2, gai_2.u)             annotation (Line(points={{-39,73},{-27.5,
          73},{-27.5,67},{-15.2,67}},       color={0,0,255}));
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
      points={{-46,60},{-38,60},{-38,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(THA1.y, hA.T_1) annotation (Line(points={{-65.3,83},{-65.3,83},{-61,83}},
        color={0,0,127}));
  connect(THA2.y, hA.T_2) annotation (Line(points={{-65.3,77},{-65.3,77},{-61,77}},
        color={0,0,127}));

  // Heat diffusion approximation inside pipes
  for iReg in 1:nReg loop
    for iPipPar in 1:nPipPar loop
      for iPipSeg in 1:nPipSeg-1 loop
          connect(hexReg[iReg].heaPor1[iPipPar,iPipSeg],  theCon1[iReg, iPipPar,iPipSeg].port_a) annotation (Line(points={{0,20},{0,30},
          {-14,30},{-14,42},{-12,42}}, color={191,0,0}));
          connect(theCon1[iReg, iPipPar,iPipSeg].port_b, hexReg[iReg].heaPor1[iPipPar,iPipSeg+1]) annotation (Line(points={{8,42},{10,42},
          {10,30},{0,30},{0,20}}, color={191,0,0}));
      end for;
    end for;
  end for;

  // Heat diffusion approximation along air path
  for iReg in 1:nReg-1 loop
    for iPipPar in 1:nPipPar loop
      for iPipSeg in 1:nPipSeg loop
         connect(hexReg[iReg].heaPor2[iPipPar, iPipSeg], theCon2[iReg, iPipPar, iPipSeg].port_a) annotation (Line(points={{0,0},{0,-10},
          {12,-10},{12,-22},{10,-22}}, color={191,0,0}));
         connect(theCon2[iReg, iPipPar, iPipSeg].port_b, hexReg[iReg+1].heaPor2[iPipPar, iPipSeg]) annotation (Line(points={{-10,-22},{-14,
          -22},{-14,-10},{0,-10},{0,0}}, color={191,0,0}));
      end for;
    end for;
  end for;


 annotation (
defaultComponentName="heaCoi",
    Documentation(info="<html>
<p>
Model of a discretized coil with no water vapor condensation.
The coil consists of <code>nReg</code> registers
that are perpendicular to the air flow path. Each register consists of <code>nPipPar</code>
parallel pipes, and each pipe can be divided into <code>nPipSeg</code> pipe segments along
the pipe length. Thus, the smallest element of the coil consists of a pipe
segment. Each pipe segment is modeled by an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible</a>.
Each element has a state variable for the metal.
</p>
<p>
If the parameter <code>energyDynamics</code> is different from
<code>Modelica.Fluid.Types.Dynamics.SteadyState</code>, then
a mixing volume of length <code>dl</code> is added to the duct connection. This can
help reducing the dimension of the nonlinear system of equations.
</p>
<p>
The convective heat transfer coefficients can, for each fluid individually, be
computed as a function of the flow rate and/or the temperature,
or assigned to a constant. This computation is done using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
</p>
<p>
In this model, the water (or liquid) flow path
needs to be connected to <code>port_a1</code> and <code>port_b1</code>, and
the air flow path need to be connected to the other two ports.
</p>
<p>
To model humidity condensation, use the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilDiscretized\">
Buildings.Fluid.HeatExchangers.WetCoilDiscretized</a> instead of this model, as
this model computes only sensible heat transfer.
</p>
<h4>Implementation</h4>
<p>
At very small flow rates, which may be caused when the fan is off but there is wind pressure
on the building that entrains outside air through the HVAC system, large temperature differences
could occur if diffusion were neglected.
This model therefore approximates a small diffusion between the elements to have more uniform
medium temperatures if the flow is near zero.
The approximation is done using the heat conductors <code>heaCon1</code> and <code>heaCon2</code>.
As this is a rough approximation, neighboring elements are connected through these heat conduction
elements, ignoring the actual geometrical configuration.
Also, radiation between the coil surfaces on the air side is not modelled explicitly, but
rather may be considered as approximated by these heat conductors.
</p>
</html>", revisions="<html>
<ul>
<li>
June 22, 2023 by Hongxiang Fu:<br/>
Corrected the modification of <code>hexReg[nReg].m2_flow_nominal</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3441\">#3441</a>.
</li>
<li>
November 4, 2017, by Michael wetter:<br/>
Added approximation of diffusion.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1038\">Buildings, #1038</a>.
</li>
<li>
October 19, 2017, by Michael Wetter:<br/>
Changed initialization of pressure from a <code>constant</code> to a <code>parameter</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
September 8, 2017, by Michael Wetter:<br/>
Changed computation of temperature used for <i>hA</i> calculation
to avoid a state variable with small time constant for some model parameterizations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/678\">Buildings, #678</a>.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected wrong annotation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Changed <code>initalize_p</code> from a <code>parameter</code> to a
<code>constant</code>. This is only required in finite volume models
of heat exchangers (to avoid consistent but redundant initial conditions)
and hence it should be set as a <code>constant</code>.
</li>
<li>
August 10, 2014, by Michael Wetter:<br/>
Removed parameter <code>m1_flow_nominal</code>, as this parameter is already
declared in its base class
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPortInterface\">
Buildings.Fluid.Interfaces.PartialFourPortInterface</a>.
This change avoids an error in OpenModelica as the two declarations
had a different value for the <code>min</code> attribute, which is not valid
in Modelica.<br/>
This change also reorganizes the order of the declaration of constants,
parameters and models.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Added parameters <code>initialize_p1</code> and <code>initialize_p2</code>.
This is required to enable the coil models to initialize the pressure in the
first volume, but not in the downstream volumes. Otherwise,
the initial equations will be overdetermined, but consistent.
This change was done to avoid a long information message that appears
when translating models.
</li>
<li>
June 29, 2014, by Michael Wetter:<br/>
Removed parameter <code>dl</code> which is no longer needed.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Removed parameters <code>energyDynamics1</code>,
<code>energyDynamics2</code> and <code>ductConnectionDynamics</code>,
and used instead of these parameters the new parameter
<code>energyDynamics</code>.
This was done as this complexity is not required.
</li>
<li>
December 13, 2013, by Michael Wetter:<br/>
Corrected wrong connection
<code>connect(hexReg[nReg].port_b1, pipMan_b.port_b)</code>
to
<code>connect(hexReg[nReg].port_a1, pipMan_b.port_b)</code>.
This closes issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">
https://github.com/lbl-srg/modelica-buildings/issues/194</a>,
which caused the last register to have no liquid flow.
</li>
<li>
October 8, 2010, by Michael Wetter:<br/>
Set <code>show_T=false</code> to avoid state events near zero flow.
</li>
<li>
March 24, 2011, by Michael Wetter:<br/>
Replaced integer division <code>nReg/2</code> by <code>div(nReg,2)</code>
when instantiating an array of models as the former leads to a syntax error
in Dymola 7.4 FD01.
</li>
<li>
May 28, 2010, by Michael Wetter:<br/>
Fixed bug in assigning pressure drops that led to too high a resistances.
</li><li>
September 10, 2008, by Michael Wetter:<br/>
Added additional parameters.
</li>
<li>
September 9, 2008 by Michael Wetter:<br/>
Propagated more parameters.
</li>
<li>
August 12, 2008 by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
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
        grid={2,2}), graphics={Text(
          extent={{60,72},{84,58}},
          textColor={0,0,255},
          textString="water-side"), Text(
          extent={{42,-22},{66,-36}},
          textColor={0,0,255},
          textString="air-side")}));
end DryCoilDiscretized;
