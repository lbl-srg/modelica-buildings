within Buildings.Fluid.BuriedPipes.Examples;
model SingleBuriedPipe "Example model of a single buried pipe"
  extends Modelica.Icons.Example;

  replaceable parameter Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston cliCon "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  FixedResistances.PlugFlowPipe pip(
    redeclare package Medium=Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    nPorts=1) "Buried pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    len=1000,
    dep={1.5},
    pos={0},
    rad={0.05 + 0.032 + 0.01}) "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,50})));

  Modelica.Blocks.Sources.Sine Tin(
    amplitude=5,
    freqHz=1/180/24/60/60,
    offset=273.15 + 20) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{98,-10},{78,10}})));
  Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));

equation
  connect(Tin.y,sou. T_in)
    annotation (Line(points={{-79,0},{-72,0},{-72,4},{-68,4}},
                                               color={0,0,127}));
  connect(sou.ports[1],senTemIn. port_a)
    annotation (Line(points={{-46,0},{-36,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{66,0},{78,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-16,0},{0,0}}, color={0,127,255}));
  connect(pip.ports_b[1], senTemOut.port_a)
    annotation (Line(points={{20,0},{46,0}}, color={0,127,255}));
  connect(pip.heatPort, gro.ports[1]) annotation (Line(points={{10,10},{10,30},{
          10,40},{10,40}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=63072000, __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a single uninsulated buried pipe operating
around ambient temperature (20degC).
</p>
</html>"));
end SingleBuriedPipe;
