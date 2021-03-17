within Buildings.Fluid.BuriedPipes.Examples;
model TwoBuriedPipes
  extends Modelica.Icons.Example;

  replaceable parameter Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston climate;
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soil(
    k=1.58,c=1150,d=1600);
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  FixedResistances.PlugFlowPipe pipChW(
    redeclare package Medium = Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    nPorts=1) annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.BuriedPipes.GroundCoupling ground(
    nPipes=2,
    climate=climate,
    soil=soil,
    len=1000,
    dep={1.5,2},
    pos={0,1},
    rad={0.09,0.09})       annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=270,
        origin={30,70})));

  Modelica.Blocks.Sources.Sine TinChW(
    amplitude=2,
    freqHz=1/180/24/60/60,
    offset=273.15 + 5) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sources.MassFlowSource_T souChW(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Sensors.TemperatureTwoPort senTemChWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Sources.Boundary_pT sinChW(
    redeclare package Medium = Medium,
    T=283.15,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{98,-10},{78,10}})));
  Sensors.TemperatureTwoPort senTemChWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));

  FixedResistances.PlugFlowPipe pipHotW(
    redeclare package Medium = Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    T_start_in=313.15,
    T_start_out=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Sine TinHotW(
    amplitude=10,
    freqHz=1/90/24/60/60,
    phase=3.1415926535898,
    offset=273.15 + 40) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Sources.MassFlowSource_T souHotW(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-66,-60},{-46,-40}})));
  Sensors.TemperatureTwoPort senTemHotWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=313.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-36,-60},{-16,-40}})));
  Sources.Boundary_pT sinHotW(
    redeclare package Medium = Medium,
    T=283.15,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{98,-60},{78,-40}})));
  Sensors.TemperatureTwoPort senTemHotWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=313.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{46,-60},{66,-40}})));
equation
  connect(TinChW.y, souChW.T_in) annotation (Line(points={{-79,0},{-72,0},{-72,
          4},{-68,4}}, color={0,0,127}));
  connect(souChW.ports[1], senTemChWIn.port_a)
    annotation (Line(points={{-46,0},{-36,0}}, color={0,127,255}));
  connect(senTemChWOut.port_b, sinChW.ports[1])
    annotation (Line(points={{66,0},{78,0}}, color={0,127,255}));
  connect(senTemChWIn.port_b, pipChW.port_a)
    annotation (Line(points={{-16,0},{0,0}}, color={0,127,255}));
  connect(pipChW.ports_b[1], senTemChWOut.port_a)
    annotation (Line(points={{20,0},{46,0}}, color={0,127,255}));
  connect(pipChW.heatPort, ground.ports[1])
    annotation (Line(points={{10,10},{10,68},{20,68}}, color={191,0,0}));
  connect(TinHotW.y, souHotW.T_in) annotation (Line(points={{-79,-50},{-72,-50},
          {-72,-46},{-68,-46}}, color={0,0,127}));
  connect(souHotW.ports[1], senTemHotWIn.port_a)
    annotation (Line(points={{-46,-50},{-36,-50}}, color={0,127,255}));
  connect(senTemHotWOut.port_b, sinHotW.ports[1])
    annotation (Line(points={{66,-50},{78,-50}}, color={0,127,255}));
  connect(senTemHotWIn.port_b, pipHotW.port_a)
    annotation (Line(points={{-16,-50},{0,-50}}, color={0,127,255}));
  connect(pipHotW.ports_b[1], senTemHotWOut.port_a)
    annotation (Line(points={{20,-50},{46,-50}}, color={0,127,255}));
  connect(pipHotW.heatPort, ground.ports[2]) annotation (Line(points={{10,-40},
          {30,-40},{30,72},{20,72}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=63072000, __Dymola_Algorithm="Cvode"));
end TwoBuriedPipes;
