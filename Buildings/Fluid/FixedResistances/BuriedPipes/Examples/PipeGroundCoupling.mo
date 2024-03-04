within Buildings.Fluid.FixedResistances.BuriedPipes.Examples;
model PipeGroundCoupling "Example model for pipe ground coupling model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);
  parameter Integer nSoi = 4 "Number of probed depths";
  parameter Modelica.Units.SI.Length dep[nSoi] = {0,2,5,9} "Probed depths";
  parameter Modelica.Units.SI.Length length = 100 "Pipe length";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 3 "Mass flow rate";
  parameter Modelica.Units.SI.Temperature Tin = 273.15+11.5 "Mean inlet temperature";

  Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling pipeGroundCoupling(
    lPip=length,
    rPip=0.1,
    thiGroLay=1.1,
    nSta=5,
    nSeg=1,
    TpipSta=Tin,
    TGrouBouSta=Tin,
    cliCon=cliCon,
    soiDat=soiDat)
    annotation (Placement(transformation(extent={{10,60},{32,80}})));
  Fluid.Sources.MassFlowSource_T sou(
  redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=m_flow_nominal,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-62,30},{-42,50}})));
  Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=Tin) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Fluid.FixedResistances.PlugFlowPipe pip(
    redeclare package Medium = Medium,
    dh=0.1,
    length=length,
    dIns=0.0001,
    kIns=1,
    m_flow_nominal=m_flow_nominal,
    cPip=2300,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=m_flow_nominal,
    rhoPip=930,
    T_start_in=Tin,
    T_start_out=Tin) "Pipe"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=Tin) "Temperature sensor"
    annotation (Placement(transformation(extent={{46,30},{66,50}})));
  Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=2,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{94,10},{74,30}})));

  Fluid.Sources.MassFlowSource_T souNoGro(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=m_flow_nominal,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemInNoGro(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=Tin) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Fluid.FixedResistances.PlugFlowPipe pipNoGro(
    redeclare package Medium = Medium,
    dh=0.1,
    length=length,
    dIns=0.0001,
    kIns=1,
    m_flow_nominal=m_flow_nominal,
    cPip=2300,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=m_flow_nominal,
    rhoPip=930,
    T_start_in=293.15,
    T_start_out=293.15) "Pipe"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemOutNoGro(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=Tin) "Temperature sensor"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Modelica.Blocks.Sources.Sine TInlSig(
    amplitude=5.5,
    f=1/600,
    offset=Tin) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
protected
  replaceable parameter
    BoundaryConditions.GroundTemperature.ClimaticConstants.Boston cliCon
    "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600) "Soil thermal properties";
equation
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-42,40},{-30,40}},   color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,40},{10,40}},  color={0,127,255}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{30,40},{46,40}},   color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{66,40},{72,40},{72,19},{74,19}},
                                                 color={0,127,255}));
  connect(pipeGroundCoupling.heatPorts[1], pip.heatPort)
    annotation (Line(points={{20,65},{20,50}}, color={127,0,0}));
  connect(souNoGro.ports[1], senTemInNoGro.port_a)
    annotation (Line(points={{-42,0},{-30,0}}, color={0,127,255}));
  connect(senTemInNoGro.port_b, pipNoGro.port_a)
    annotation (Line(points={{-10,0},{10,0}},color={0,127,255}));
  connect(pipNoGro.port_b, senTemOutNoGro.port_a)
    annotation (Line(points={{30,0},{46,0}}, color={0,127,255}));
  connect(senTemOutNoGro.port_b, sin.ports[2]) annotation (Line(points={{66,0},{
          72,0},{72,21},{74,21}}, color={0,127,255}));
  connect(TInlSig.y, sou.T_in) annotation (Line(points={{-79,20},{-72,20},{-72,44},
          {-64,44}}, color={0,0,127}));
  connect(TInlSig.y, souNoGro.T_in) annotation (Line(points={{-79,20},{-72,20},{
          -72,4},{-64,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example shows how to use model <a href=\"modelica://Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling\">Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling</a>
and compares the fluid output temperature with and without ground layer.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/BuriedPipes/Examples/PipeGroundCoupling.mos"
        "Simulate and plot"));
end PipeGroundCoupling;
