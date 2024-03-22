within Buildings.Experimental.DHC.Networks.Connections.Examples;
model Connection1PipeExample
  "Example model that showcases Connection1PipeAutosize and Connection1PipePlugFlow models"
  extends Modelica.Icons.Example;
    package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.Length dh(
    fixed=false,
    start=0.01,
    min=0.001) "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal = 1
    "Nominal mass flow rate in the distribution line";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 0.5
    "Nominal mass flow rate in the connection line";
  parameter Modelica.Units.SI.Length lDis = 100
    "Length of the distribution pipe before the connection";
  Buildings.Experimental.DHC.Networks.Connections.Connection1Pipe_R
    connection1PipeAutosize(
    redeclare package Medium = MediumW,
    mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    lDis=lDis,
    dhDis=dh) annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT bouDisAutoSize(
    redeclare final package Medium = MediumW,
    p=300000,
    nPorts=1) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant mDis_flow_nominal_exp(k=mDis_flow_nominal)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDisAutoSize(
    dp_nominal=100000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Distribution network pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={32,16})));

  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumConAutoSize(
    dp_nominal=5000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Agent connection pump" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,80})));
  Buildings.Experimental.DHC.Networks.Connections.Connection1PipePlugFlow_v
    connection1PipeplugFlow(
    redeclare package Medium = MediumW,
    mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    dIns=0.001,
    kIns=1,
    lDis=lDis)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Fluid.Sources.Boundary_pT bouDisPlugFlow(
    redeclare final package Medium = MediumW,
    p=300000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDisPlugFlow(
    dp_nominal=100000,
    redeclare final package Medium = MediumW,
    m_flow_nominal = mDis_flow_nominal) "Distribution network pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={32,-80})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumConPlugFlow(
    dp_nominal=5000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Agent connection pump" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,-20})));
  Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling pipeGroundCoupling(
    lPip=lDis,
    rPip=0.04,
    thiGroLay=1.1,
    nSta=5,
    nSeg=1)
    annotation (Placement(transformation(extent={{-11,-10},{11,10}},
        rotation=0,
        origin={-11,-30})));

  Modelica.Blocks.Sources.Step mCon_flow_nominal_exp(height=mCon_flow_nominal,
      startTime=1800)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
equation
  connect(pumDisAutoSize.port_b, connection1PipeAutosize.port_aDis) annotation (
     Line(points={{22,16},{10,16},{10,50},{20,50}}, color={0,127,255}));
  connect(bouDisAutoSize.ports[1], connection1PipeAutosize.port_aDis)
    annotation (Line(points={{0,10},{10,10},{10,50},{20,50}}, color={0,127,255}));
  connect(pumDisAutoSize.port_a, connection1PipeAutosize.port_bDis) annotation (
     Line(points={{42,16},{50,16},{50,50},{40,50}}, color={0,127,255}));
  connect(mDis_flow_nominal_exp.y, pumDisAutoSize.m_flow_in)
    annotation (Line(points={{-59,30},{32,30},{32,28}}, color={0,0,127}));
  connect(connection1PipeAutosize.port_bCon, pumConAutoSize.port_a) annotation (
     Line(points={{30,60},{30,62},{16,62},{16,80},{20,80}}, color={0,127,255}));
  connect(pumConAutoSize.port_b, connection1PipeAutosize.port_aCon) annotation (
     Line(points={{40,80},{42,80},{42,62},{36,62},{36,60}}, color={0,127,255}));
  connect(pumDisPlugFlow.port_b, connection1PipeplugFlow.port_aDis) annotation (
     Line(points={{22,-80},{12,-80},{12,-50},{20,-50}}, color={0,127,255}));
  connect(bouDisPlugFlow.ports[1], connection1PipeplugFlow.port_aDis)
    annotation (Line(points={{0,-80},{12,-80},{12,-50},{20,-50}},   color={0,127,
          255}));
  connect(pumDisPlugFlow.port_a, connection1PipeplugFlow.port_bDis) annotation (
     Line(points={{42,-80},{50,-80},{50,-50},{40,-50}}, color={0,127,255}));
  connect(mDis_flow_nominal_exp.y, pumDisPlugFlow.m_flow_in) annotation (Line(
        points={{-59,30},{-52,30},{-52,-64},{32,-64},{32,-68}}, color={0,0,127}));
  connect(connection1PipeplugFlow.port_bCon, pumConPlugFlow.port_a) annotation (
     Line(points={{30,-40},{30,-38},{18,-38},{18,-20},{20,-20}}, color={0,127,255}));
  connect(pumConPlugFlow.port_b, connection1PipeplugFlow.port_aCon) annotation (
     Line(points={{40,-20},{44,-20},{44,-38},{36,-38},{36,-40}}, color={0,127,255}));
  connect(pipeGroundCoupling.heatPorts[1], connection1PipeplugFlow.heatPortDis)
    annotation (Line(points={{-11,-35},{-11,-47.4},{25,-47.4}},
        color={127,0,0}));
  connect(mCon_flow_nominal_exp.y, pumConAutoSize.m_flow_in) annotation (Line(
        points={{-59,80},{0,80},{0,98},{30,98},{30,92}}, color={0,0,127}));
  connect(pumConPlugFlow.m_flow_in, pumConAutoSize.m_flow_in) annotation (Line(
        points={{30,-8},{30,-4},{60,-4},{60,98},{30,98},{30,92}}, color={0,0,127}));
  annotation (__Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Networks/Connections/Examples/Connection1PipeExample.mos" "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model of two one-pipe connection models that could be used i.e for building a reservoir network to connect one agent in series.  It uses
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Connections.Connection1Pipe_R\">
Buildings.Experimental.DHC.Networks.Connections.Connection1PipeAutosize</a> and
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Connections.Connection1PipePlugFlow_v\">
Buildings.Experimental.DHC.Networks.Connections.Connection1PipePlugFlow</a>. The agent, in this example just a pump, will draw water from the distribution pipe and release it to the same pipe.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2024, Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection1PipeExample;
