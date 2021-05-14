within Buildings.Fluid.BuriedPipes.Examples;
model MultiSegmentBuriedPipe
  "Example model of a buried pipe with multiple segment"
  extends Modelica.Icons.Example;

  parameter Integer nSeg=50;
  parameter Modelica.SIunits.Length totLen=1000;
  parameter Modelica.SIunits.Length segLen[nSeg] = fill(totLen/nSeg,nSeg);

  parameter Modelica.SIunits.Length  dIns=0.0002;

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  MultiPlugFlowPipe             pip(
    redeclare package Medium=Medium,
    nSeg=nSeg,
    rInt=0.05,
    length=segLen,
    m_flow_nominal=1,
    dIns=dIns,
    kIns=soiDat.k,
    cPip=500,
    rhoPip=8000,
    dPip=0.0032)
              "Buried pipe"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Fluid.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=nSeg,
    len=segLen,
    dep={1.5},
    pos={0},
    rad={pip.rInt + pip.dPip + pip.dIns})
                               "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,90})));

  Modelica.Blocks.Sources.Sine Tin(
    amplitude=5,
    freqHz=1/180/24/60/60,
    offset=273.15 + 20) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Sensors.TemperatureTwoPort senTemInl(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  MultiPlugFlowPipe             pipRev(
    redeclare package Medium = Medium,
    nSeg=1,
    rInt=0.05,
    length={totLen},
    m_flow_nominal=1,
    dIns=dIns,
    kIns=soiDat.k,
    cPip=500,
    rhoPip=8000,
    dPip=0.0032)
              "Buried pipe"
    annotation (Placement(transformation(extent={{-10,-30},{10,-50}})));
  GroundCoupling groRev(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=1,
    len={totLen},
    dep={1.5},
    pos={0},
    rad={pip.rInt + pip.dPip + pip.dIns})
                               "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,-90})));
  Sources.MassFlowSource_T souRev(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=-3) "Flow source"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Sensors.TemperatureTwoPort senTemOutRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Sources.Boundary_pT sinRev(
    redeclare package Medium = Medium,
    use_T_in=true,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Sensors.TemperatureTwoPort senTemInlRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(Tin.y,sou. T_in)
    annotation (Line(points={{-99,0},{-90,0},{-90,44},{-82,44}},
                                               color={0,0,127}));
  connect(sou.ports[1], senTemInl.port_a)
    annotation (Line(points={{-60,40},{-50,40}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{50,40},{60,40}},
                                             color={0,127,255}));
  connect(senTemInl.port_b, pip.port_a)
    annotation (Line(points={{-30,40},{-10,40}},
                                               color={0,127,255}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{10,40},{30,40}},
                                             color={0,127,255}));
  connect(souRev.ports[1], senTemOutRev.port_a)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
  connect(senTemInlRev.port_b, sinRev.ports[1])
    annotation (Line(points={{50,-40},{60,-40}}, color={0,127,255}));
  connect(senTemOutRev.port_b, pipRev.port_a)
    annotation (Line(points={{-30,-40},{-10,-40}},
                                                 color={0,127,255}));
  connect(pipRev.port_b, senTemInlRev.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  connect(Tin.y, sinRev.T_in) annotation (Line(points={{-99,0},{90,0},{90,-36},
          {82,-36}},       color={0,0,127}));
  connect(pip.heatPorts, gro.ports[1, :]) annotation (Line(points={{0,50},{0,66},
          {0,80.1},{-0.1,80.1}}, color={191,0,0}));
  connect(pipRev.heatPorts, groRev.ports[1, :]) annotation (Line(points={{0,-50},
          {0,-66},{0,-80.1},{-0.1,-80.1}}, color={191,0,0}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    experiment(StopTime=63072000, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a single uninsulated 
buried pipe operating around ambient temperature (<i>20</i>°C).
Both design flow direction and reverse flow direction 
(components with suffix <code>Rev</code>) are simulated.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BuriedPipes/Examples/SingleBuriedPipe.mos"
        "Simulate and plot"));
end MultiSegmentBuriedPipe;
