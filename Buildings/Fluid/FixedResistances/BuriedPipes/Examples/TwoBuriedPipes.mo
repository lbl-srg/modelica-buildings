within Buildings.Fluid.FixedResistances.BuriedPipes.Examples;
model TwoBuriedPipes "Example model of two buried pipes in close proximity"
  extends Modelica.Icons.Example;

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Buildings.Fluid.FixedResistances.BuriedPipes.GroundCoupling gro(
    nPip=2,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=1,
    len={1000},
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
    m_flow_nominal=10,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    T_start_in=TChW,
    T_start_out=TChW) "Buried chilled water pipe"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.Sine TinChW(
    amplitude=2,
    f=1/180/24/60/60,
    offset=TChW) "Chilled water pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Sources.MassFlowSource_T souChW(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Chilled water flow source"
    annotation (Placement(transformation(extent={{-66,10},{-46,30}})));
  Sensors.TemperatureTwoPort senTemChWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=pipChW.m_flow_nominal,
    T_start=TChW) "Chilled water pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Sources.Boundary_pT sinChW(
    redeclare package Medium = Medium,
    T=TChW,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Chilled water pressure boundary condition"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Sensors.TemperatureTwoPort senTemChWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=pipChW.m_flow_nominal,
    T_start=TChW) "Chilled water pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));

  FixedResistances.PlugFlowPipe pipHotW(
    redeclare package Medium = Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=10,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    T_start_in=THotW,
    T_start_out=THotW) "Buried hot water pipe"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Sources.Sine TinHotW(
    amplitude=5,
    f=1/90/24/60/60,
    phase=3.1415926535898,
    offset=THotW) "Hot water pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Sources.MassFlowSource_T souHotW(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3,
    nPorts=1) "Hot water flow source"
    annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
  Sensors.TemperatureTwoPort senTemHotWIn(
    redeclare package Medium = Medium,
    m_flow_nominal=pipHotW.m_flow_nominal,
    T_start=THotW) "Hot water pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Sources.Boundary_pT sinHotW(
    redeclare package Medium = Medium,
    T=THotW,
    p(displayUnit="Pa") = 101325,
    nPorts=1)                     "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  Sensors.TemperatureTwoPort senTemHotWOut(
    redeclare package Medium = Medium,
    m_flow_nominal=pipHotW.m_flow_nominal,
    T_start=THotW) "Hot water pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));

protected
  parameter Modelica.Units.SI.Temperature TChW=273.15 + 10
    "Chilled water mean supply temperature";
  parameter Modelica.Units.SI.Temperature THotW=273.15 + 80
    "Hot water mean supply temperature";

equation
  connect(TinChW.y, souChW.T_in) annotation (Line(points={{-79,20},{-72,20},{
          -72,24},{-68,24}},
                    color={0,0,127}));
  connect(souChW.ports[1], senTemChWIn.port_a)
    annotation (Line(points={{-46,20},{-30,20}},
                                               color={0,127,255}));
  connect(senTemChWOut.port_b, sinChW.ports[1])
    annotation (Line(points={{70,20},{80,20}},
                                             color={0,127,255}));
  connect(senTemChWIn.port_b, pipChW.port_a)
    annotation (Line(points={{-10,20},{0,20}},
                                             color={0,127,255}));
  connect(pipChW.heatPort, gro.ports[1,1])
    annotation (Line(points={{10,30},{10,40},{30,40},{30,60},{30,59.75},{30,
          59.75}},                                     color={191,0,0}));
  connect(TinHotW.y, souHotW.T_in) annotation (Line(points={{-79,-40},{-72,-40},
          {-72,-36},{-68,-36}}, color={0,0,127}));
  connect(pipHotW.heatPort, gro.ports[2,1])
    annotation (Line(points={{10,-30},{10,-20},{30,-20},{30,30},{30,60.25},{30,
          60.25}},                                       color={191,0,0}));
  connect(souHotW.ports[1], senTemHotWIn.port_a)
    annotation (Line(points={{-46,-40},{-30,-40}}, color={0,127,255}));
  connect(senTemHotWIn.port_b, pipHotW.port_a)
    annotation (Line(points={{-10,-40},{0,-40}}, color={0,127,255}));
  connect(senTemHotWOut.port_b, sinHotW.ports[1])
    annotation (Line(points={{70,-40},{80,-40}}, color={0,127,255}));
  connect(pipChW.port_b, senTemChWOut.port_a)
    annotation (Line(points={{20,20},{50,20}}, color={0,127,255}));
  connect(pipHotW.port_b, senTemHotWOut.port_a) annotation (Line(points={{20,
          -40},{36,-40},{36,-40},{50,-40}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    experiment(StopTime=63072000, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a network of two
uninsulated buried pipes that are in close proximity. One pipe carries
chilled water oscillating around <i>10</i>°C whereas the other carries hot water
oscillating around <i>80</i>°C.
</p>
</html>", revisions="<html>
<ul>
<li>
December 7, 2023, by Ettore Zanetti:<br/>
Moved <code>BuriedPipes</code> package<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
September 14, 2021, by Michael Wetter:<br/>
Updated example for new pipe model.
</li>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/BuriedPipes/Examples/TwoBuriedPipes.mos"
        "Simulate and plot"));
end TwoBuriedPipes;
