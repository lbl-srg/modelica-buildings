within Buildings.Fluid.CHPs.Rankine.Examples;
model ORCWithHeatExchangers
  "Example model with an ORC between two heat exchangers"
  extends Modelica.Icons.Example;
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Water "Medium in the condenser";

  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 0.4
    "Medium flow rate in the evaporator";
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
  Buildings.Fluid.CHPs.Rankine.BaseClasses.HeatSink heaSin "Heat sink"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = MediumEva,
    final allowFlowReversal=false,
    final m_flow_nominal=mEva_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final linearizeFlowResistance=true,
    final T_start=souEva.T,
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
    nPorts=1)
    "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
equation
  connect(cyc.port_b, heaSin.port) annotation (Line(points={{0,-10},{0,-46},{30,
          -46},{30,-40}}, color={191,0,0}));
  connect(eva.port_ref, cyc.port_a) annotation (Line(points={{-1.27676e-15,44},{
          -1.27676e-15,27},{0,27},{0,10}}, color={191,0,0}));
  connect(souEva.ports[1], eva.port_a)
    annotation (Line(points={{-60,50},{-10,50}}, color={0,127,255}));
  connect(sinEva.ports[1], eva.port_b)
    annotation (Line(points={{60,50},{10,50}}, color={0,127,255}));
end ORCWithHeatExchangers;
