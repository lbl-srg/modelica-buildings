within Buildings.Fluid.Geothermal.BuriedPipes.Examples;
model DiscretizedBuriedPipe
  "Example model of a buried pipe with multiple segments"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water "Medium in the pipe"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Length totLen=10000 "Total pipe length";

  parameter Integer nSeg=2 "Number of pipe segments";
  parameter Modelica.Units.SI.Length segLen[nSeg]=fill(totLen/nSeg, nSeg)
    "Pipe segments length";

  parameter Integer nSegRev=10 "Number of pipe segments";
  parameter Modelica.Units.SI.Length segLenRev[nSegRev]=fill(totLen/nSegRev,
      nSegRev) "Pipe segments length";

  parameter Modelica.Units.SI.Length dIns=0.2
    "Virtual insulation layer thickness";

  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston
    cliCon "Surface temperature climatic conditions";

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  FixedResistances.PlugFlowPipeDiscretized pip(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    dh=0.1,
    segLen=segLen,
    m_flow_nominal=1,
    dIns=dIns,
    kIns=soiDat.k,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Fluid.Geothermal.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=pip.nSeg,
    len=pip.segLen,
    dep={1.5},
    pos={0},
    rad={pip.dh/2 + pip.thickness + pip.dIns}) "Ground coupling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,90})));

  Modelica.Blocks.Sources.Sine Tin(
    amplitude=5,
    f=1/180/24/60/60,
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

  FixedResistances.PlugFlowPipeDiscretized pipRev(
    redeclare package Medium = Medium,
    nSeg=nSegRev,
    dh=0.1,
    segLen=segLenRev,
    m_flow_nominal=1,
    dIns=dIns,
    kIns=soiDat.k,
    thickness=0.0032) "Buried pipe"
    annotation (Placement(transformation(extent={{-10,-30},{10,-50}})));
  GroundCoupling groRev(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    nSeg=pipRev.nSeg,
    len=pipRev.segLen,
    dep={1.5},
    pos={0},
    rad={pip.dh / 2 + pip.thickness + pip.dIns})
    "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,-90})));
  Sensors.TemperatureTwoPort senTemOutRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Sensors.TemperatureTwoPort senTemInlRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
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
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-40})));
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
  connect(senTemOutRev.port_b, pipRev.port_a)
    annotation (Line(points={{-30,-40},{-10,-40}},
                                                 color={0,127,255}));
  connect(pipRev.port_b, senTemInlRev.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  connect(pip.heatPorts, gro.ports[1, :]) annotation (Line(points={{0,50},{0,66},
          {0,80},{0,80}},        color={191,0,0}));
  connect(pipRev.heatPorts, groRev.ports[1, :]) annotation (Line(points={{0,-50},
          {0,-66},{0,-80},{0,-80}},        color={191,0,0}));
  connect(souRev.ports[1], senTemInlRev.port_b)
    annotation (Line(points={{60,-40},{50,-40}}, color={0,127,255}));
  connect(senTemOutRev.port_a, sinRev.ports[1])
    annotation (Line(points={{-50,-40},{-60,-40}}, color={0,127,255}));
  connect(Tin.y, souRev.T_in) annotation (Line(points={{-99,0},{100,0},{100,-44},
          {82,-44}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
    experiment(StopTime=63072000, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for two uninsulated 
buried pipes - direct and reverse flow direction - operating around 
ambient temperature (<i>20</i>°C), and separated
in 2 and 10 segments respectively.</p>
<p>
This example illustrates the difference in boundary conditions that
results from different segmentation of the pipes, since both
pipes are representative of the same conditions (see
<a href=\"modelica://Buildings.Fluid.Geothermal.BuriedPipes.Examples.SingleBuriedPipe\">
Buildings.Fluid.Geothermal.BuriedPipes.Examples.SingleBuriedPipe</a> for validation
that direct and reverse flow result in the same modeled operation).
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/BuriedPipes/Examples/DiscretizedBuriedPipe.mos"
        "Simulate and plot"));
end DiscretizedBuriedPipe;
