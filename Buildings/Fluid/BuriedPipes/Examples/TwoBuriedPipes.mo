within Buildings.Fluid.BuriedPipes.Examples;
model TwoBuriedPipes "Example model of two buried pipes in close proximity"
  extends Modelica.Icons.Example;

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  Buildings.Fluid.BuriedPipes.GroundCoupling gro(
    nPip=2,
    cliCon=cliCon,
    soiDat=soiDat,
    len=1000,
    dep={1.5,2.5},
    pos={0,1},
    rad={0.09,0.09}) "Ground coupling" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,70})));

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
    T_start_in=TChW,
    T_start_out=TChW,
    nPorts=1) "Buried chilled water pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Sine TinChW(
    amplitude=2,
    freqHz=1/180/24/60/60,
    offset=TChW) "Chilled water pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sources.MassFlowSource_T souChW(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Chilled water flow source"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Sensors.TemperatureTwoPort senTemChWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=TChW) "Chilled water pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Sources.Boundary_pT sinChW(
    redeclare package Medium = Medium,
    T=TChW,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Chilled water pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Sensors.TemperatureTwoPort senTemChWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=TChW) "Chilled water pipe outlet temperature sensor"
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
    T_start_in=THotW,
    T_start_out=THotW,
    nPorts=1) annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Modelica.Blocks.Sources.Sine TinHotW(
    amplitude=5,
    freqHz=1/90/24/60/60,
    phase=3.1415926535898,
    offset=THotW) "Hot water pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Sources.MassFlowSource_T souHotW(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3,
    nPorts=1) "Hot water flow source"
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));
  Sensors.TemperatureTwoPort senTemHotWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=THotW) "Hot water pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Sources.Boundary_pT sinHotW(
    redeclare package Medium = Medium,
    T=THotW,
    p(displayUnit="Pa") = 101325,
    nPorts=1)                     "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
  Sensors.TemperatureTwoPort senTemHotWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=THotW) "Hot water pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{46,-70},{66,-50}})));

protected
  parameter Modelica.SIunits.Temperature TChW = 273.15 + 10;
  parameter Modelica.SIunits.Temperature THotW = 273.15 + 80;

equation
  connect(TinChW.y, souChW.T_in) annotation (Line(points={{-79,0},{-72,0},{-72,4},
          {-68,4}}, color={0,0,127}));
  connect(souChW.ports[1], senTemChWIn.port_a)
    annotation (Line(points={{-46,0},{-36,0}}, color={0,127,255}));
  connect(senTemChWOut.port_b, sinChW.ports[1])
    annotation (Line(points={{66,0},{80,0}}, color={0,127,255}));
  connect(senTemChWIn.port_b, pipChW.port_a)
    annotation (Line(points={{-16,0},{0,0}}, color={0,127,255}));
  connect(pipChW.ports_b[1], senTemChWOut.port_a)
    annotation (Line(points={{20,0},{46,0}}, color={0,127,255}));
  connect(pipChW.heatPort, gro.ports[1])
    annotation (Line(points={{10,10},{10,60},{28,60}}, color={191,0,0}));
  connect(TinHotW.y, souHotW.T_in) annotation (Line(points={{-79,-60},{-72,-60},
          {-72,-56},{-68,-56}}, color={0,0,127}));
  connect(pipHotW.heatPort, gro.ports[2])
    annotation (Line(points={{10,-50},{32,-50},{32,60}}, color={191,0,0}));
  connect(souHotW.ports[1], senTemHotWIn.port_a)
    annotation (Line(points={{-46,-60},{-36,-60}}, color={0,127,255}));
  connect(senTemHotWIn.port_b, pipHotW.port_a)
    annotation (Line(points={{-16,-60},{0,-60}}, color={0,127,255}));
  connect(pipHotW.ports_b[1], senTemHotWOut.port_a)
    annotation (Line(points={{20,-60},{46,-60}}, color={0,127,255}));
  connect(senTemHotWOut.port_b, sinHotW.ports[1])
    annotation (Line(points={{66,-60},{80,-60}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    experiment(
      StopTime=63072000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a network of two 
uninsulated buried pipes that are in close proximity. One pipe carries 
chilled water oscillating around 10degC whereas the other carries hot water 
oscillating around 80degC.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BuriedPipes/Examples/TwoBuriedPipes.mos"
        "Simulate and plot"));
end TwoBuriedPipes;
