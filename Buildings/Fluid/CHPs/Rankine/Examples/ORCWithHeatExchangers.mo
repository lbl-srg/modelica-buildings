within Buildings.Fluid.CHPs.Rankine.Examples;
model ORCWithHeatExchangers
  "Example model with an ORC between two heat exchangers"
  extends Modelica.Icons.Example;
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Air "Medium in the condenser";

  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 0.4
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 1
    "Medium flow rate in the condenser";
/*  parameter Modelica.Units.SI.AbsoluteTemperature TWasHea(
    displayUnit = "C") = 150 + 273.15
    "Temperature of the waste heat source";*/

  Buildings.Fluid.CHPs.Rankine.Cycle cyc(
    pro=pro,
    TEva(displayUnit="degC") = 357.95,
    TCon(displayUnit="degC") = 298.15,
    etaExp=0.7)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.R123 pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = MediumEva,
    final allowFlowReversal=false,
    final m_flow_nominal=mEva_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final linearizeFlowResistance=true,
    final T_start=sinEva.T,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final UA=50) "Evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,50})));
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    redeclare final package Medium = MediumEva,
    m_flow=mEva_flow_nominal,
    T=423.15,
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(
    redeclare final package Medium = MediumEva,
    nPorts=1) "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Buildings.Fluid.CHPs.Rankine.BaseClasses.HeaterCooler_Q con(
    redeclare final package Medium = MediumCon,
    final allowFlowReversal=false,
    final m_flow_nominal=mCon_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final T_start=sinCon.T,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Condenser"
    annotation (Placement(transformation(extent={{10,-60},{-10,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon,
    nPorts=1)
          "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    redeclare final package Medium = MediumCon,
    m_flow=mCon_flow_nominal,
    T=288.15,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
equation
  connect(eva.port_ref, cyc.port_a) annotation (Line(points={{-1.27676e-15,44},{
          -1.27676e-15,27},{0,27},{0,10}}, color={191,0,0}));
  connect(souEva.ports[1], eva.port_a)
    annotation (Line(points={{-60,50},{-10,50}}, color={0,127,255}));
  connect(sinEva.ports[1], eva.port_b)
    annotation (Line(points={{60,50},{10,50}}, color={0,127,255}));
  connect(con.port_a, souCon.ports[1])
    annotation (Line(points={{10,-50},{60,-50}}, color={0,127,255}));
  connect(con.port_b, sinCon.ports[1])
    annotation (Line(points={{-10,-50},{-60,-50}}, color={0,127,255}));
  connect(cyc.QCon_flow, con.Q_flow) annotation (Line(points={{11,-4},{20,-4},{
          20,-44},{12,-44}}, color={0,0,127}));
end ORCWithHeatExchangers;
