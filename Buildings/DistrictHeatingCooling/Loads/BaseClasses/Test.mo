within Buildings.DistrictHeatingCooling.Loads.BaseClasses;
model Test
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";
  Fluid.Sources.Boundary_pT             sinHea(
    redeclare package Medium = Medium,
    nPorts=1,
    p=300000,
    T=heaCooVol.T_b_nominal)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,10})));
  Fluid.Sources.MassFlowSource_T           supHea(
    redeclare package Medium = Medium,
    m_flow=1,
    nPorts=1)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,8})));
  HeatingOrCooling heaCooVol(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=0,
    nLoa=1,
    T_a_nominal=318.15,
    T_b_nominal=313.15,
    Q_flowLoa_nominal={1000},
    TLoa_nominal={293.15}) annotation (Placement(transformation(extent={{-10,2},{10,22}})));
  HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=heaCooVol.TLoa_nominal[1])
    annotation (Placement(transformation(extent={{-128,40},{-108,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=1000)
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
equation
  connect(supHea.ports[1], heaCooVol.port_a)
    annotation (Line(points={{-62,8},{-36,8},{-36,12},{-10,12}}, color={0,127,255}));
  connect(heaCooVol.port_b, sinHea.ports[1])
    annotation (Line(points={{10,12},{40,12},{40,10},{70,10}}, color={0,127,255}));
  connect(prescribedTemperature.port, heaCooVol.heaPorLoa[1])
    annotation (Line(points={{-60,50},{0,50},{0,22}}, color={191,0,0}));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-107,50},{-82,50}}, color={0,0,127}));
  connect(realExpression1.y, heaCooVol.Q_flowLoaReq[1]) annotation (Line(points={{-27,20},{-12,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Test;
