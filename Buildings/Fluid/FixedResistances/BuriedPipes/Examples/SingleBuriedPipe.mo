within Buildings.Fluid.FixedResistances.BuriedPipes.Examples;
model SingleBuriedPipe "Example model of a single buried pipe"
  extends Modelica.Icons.Example;

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Temperature Tin=293.15 "Mean inlet temperature";

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600,
    steadyState=false)           "Soil thermal properties"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  FixedResistances.PlugFlowPipe pip(
    redeclare package Medium=Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=10,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Fluid.FixedResistances.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=1,
    len={pip.length},
    dep={1.5},
    pos={0},
    rad={pip.dh/2 + pip.thickness + pip.dIns}) "Ground coupling" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,90})));

  Modelica.Blocks.Sources.Sine TInlSig(
    amplitude=5,
    f=1/180/24/60/60,
    offset=Tin) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Sensors.TemperatureTwoPort senTemInl(
    redeclare package Medium = Medium,
    m_flow_nominal=pip.m_flow_nominal,
    T_start=Tin) "Pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=Tin,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=pip.m_flow_nominal,
    T_start=Tin) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  FixedResistances.PlugFlowPipe pipRev(
    redeclare package Medium = Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,-30},{10,-50}})));
  GroundCoupling groRev(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=1,
    len={pipRev.length},
    dep={1.5},
    pos={0},
    rad={pipRev.dh / 2 + pipRev.thickness + pipRev.dIns})
    "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,-90})));
  Sensors.TemperatureTwoPort senTemOutRev(
    redeclare package Medium = Medium,
    m_flow_nominal=pipRev.m_flow_nominal,
    T_start=Tin) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Sensors.TemperatureTwoPort senTemInlRev(
    redeclare package Medium = Medium,
    m_flow_nominal=pipRev.m_flow_nominal,
    T_start=Tin) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Sources.MassFlowSource_T souRev(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-40})));
  Sources.Boundary_pT sinRev(
    redeclare package Medium = Medium,
    T=Tin,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-40})));
equation
  connect(TInlSig.y,sou. T_in)
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
  connect(pip.heatPort, gro.ports[1,1]) annotation (Line(points={{0,50},{0,80},
          {0,80}},         color={191,0,0}));
  connect(senTemOutRev.port_b, pipRev.port_a)
    annotation (Line(points={{-30,-40},{-10,-40}},
                                                 color={0,127,255}));
  connect(pipRev.heatPort, groRev.ports[1,1])
    annotation (Line(points={{0,-50},{0,-80},{0,-80}},
                                                 color={191,0,0}));
  connect(souRev.ports[1], senTemInlRev.port_b)
    annotation (Line(points={{60,-40},{50,-40}}, color={0,127,255}));
  connect(sinRev.ports[1], senTemOutRev.port_a)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
  connect(TInlSig.y, souRev.T_in) annotation (Line(points={{-99,0},{100,0},{100,-44},
          {82,-44}}, color={0,0,127}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{10,40},{30,40}}, color={0,127,255}));
  connect(pipRev.port_b, senTemInlRev.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/BuriedPipes/Examples/SingleBuriedPipe.mos"
        "Simulate and plot"));
end SingleBuriedPipe;
