within Buildings.Experimental.DHC.Networks.Connections.Examples;
model Connection2PipeExample
  "Example model that showcases Connection2PipeAutosize and Connection2PipePlugFlow models"
  extends Modelica.Icons.Example;
    package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.Length dhDis(
    fixed=false,
    start=0.01,
    min=0.001) "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.Units.SI.Length dhRet(
    fixed=false,
    start=0.01,
    min=0.001) "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal=1
    "Nominal mass flow rate in the distribution line";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.5
    "Nominal mass flow rate in the connection line";
  parameter Modelica.Units.SI.Length lDis=100
    "Length of the distribution pipe before the connection";
  Buildings.Experimental.DHC.Networks.Connections.Connection2PipeAutosize connection2PipeAutosize(
    redeclare package Medium = MediumW,
    mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    dhDisRet=dhRet,
    lDis=lDis,
    dhDis=dhDis)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT bouDisAutoSize(
    redeclare final package Medium = MediumW,
    p=300000,
    nPorts=1) annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Blocks.Sources.Constant mDis_flow_nominal_exp(k=mDis_flow_nominal)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDisAutoSize(
    dp_nominal=100000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Distribution network pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,20})));

  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumConAutoSize(
    dp_nominal=5000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Agent connection pump" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,82})));
  Buildings.Experimental.DHC.Networks.Connections.Connection2PipePlugFlow connection2PipeplugFlow(
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
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDisPlugFlow(
    dp_nominal=100000,
    redeclare final package Medium = MediumW,
    m_flow_nominal=mDis_flow_nominal) "Distribution network pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-12,-80})));
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
    nSeg=2)
    annotation (Placement(transformation(extent={{-11,-10},{11,10}},
        rotation=0,
        origin={-9,-30})));

  Modelica.Blocks.Sources.Step mCon_flow_nominal_exp(height=mCon_flow_nominal,
      startTime=1800)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Fluid.Sensors.MassFlowRate senMasFloDisAutosize(redeclare final package
      Medium = MediumW) "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,50})));
  Fluid.Sensors.MassFlowRate senMasFloDisPlugFlow(redeclare final package
      Medium = MediumW) "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,-50})));
equation
  connect(mDis_flow_nominal_exp.y, pumDisAutoSize.m_flow_in)
    annotation (Line(points={{-59,40},{-10,40},{-10,32}},
                                                        color={0,0,127}));
  connect(mDis_flow_nominal_exp.y, pumDisPlugFlow.m_flow_in) annotation (Line(
        points={{-59,40},{-52,40},{-52,-60},{-12,-60},{-12,-68}},
                                                                color={0,0,127}));
  connect(connection2PipeplugFlow.port_bCon, pumConPlugFlow.port_a) annotation (
     Line(points={{30,-40},{30,-38},{16,-38},{16,-20},{20,-20}}, color={0,127,255}));
  connect(pumConPlugFlow.port_b,connection2PipeplugFlow. port_aCon) annotation (
     Line(points={{40,-20},{46,-20},{46,-38},{36,-38},{36,-40}}, color={0,127,255}));
  connect(pipeGroundCoupling.heatPorts[1],connection2PipeplugFlow. heatPortDis)
    annotation (Line(points={{-9.825,-35},{-9.825,-44.6},{20,-44.6}},
        color={127,0,0}));
  connect(mCon_flow_nominal_exp.y, pumConAutoSize.m_flow_in) annotation (Line(
        points={{-59,80},{0,80},{0,98},{30,98},{30,94}}, color={0,0,127}));
  connect(pumConPlugFlow.m_flow_in, pumConAutoSize.m_flow_in) annotation (Line(
        points={{30,-8},{30,-6},{94,-6},{94,98},{30,98},{30,94}}, color={0,0,127}));
  connect(pumDisAutoSize.port_a,connection2PipeAutosize. port_bDisRet)
    annotation (Line(points={{0,20},{12,20},{12,44},{20,44}},  color={0,127,255}));
  connect(pumDisPlugFlow.port_a,connection2PipeplugFlow. port_bDisRet)
    annotation (Line(points={{-2,-80},{10,-80},{10,-56},{20,-56}},
                                                        color={0,127,255}));
  connect(connection2PipeplugFlow.heatPortRet, pipeGroundCoupling.heatPorts[2])
    annotation (Line(points={{20,-41},{20,-42},{-8.175,-42},{-8.175,-35}},
        color={191,0,0}));
  connect(pumDisPlugFlow.port_b, connection2PipeplugFlow.port_aDisSup)
    annotation (Line(points={{-22,-80},{-30,-80},{-30,-50},{20,-50}}, color={0,127,
          255}));
  connect(pumDisAutoSize.port_b, connection2PipeAutosize.port_aDisSup)
    annotation (Line(points={{-20,20},{-24,20},{-24,50},{20,50}}, color={0,127,255}));
  connect(connection2PipeAutosize.port_bCon, pumConAutoSize.port_a) annotation (
     Line(points={{30,60},{30,64},{16,64},{16,82},{20,82}}, color={0,127,255}));
  connect(pumConAutoSize.port_b, connection2PipeAutosize.port_aCon) annotation (
     Line(points={{40,82},{44,82},{44,64},{36,64},{36,60}}, color={0,127,255}));
  connect(connection2PipeAutosize.port_bDisSup, senMasFloDisAutosize.port_a)
    annotation (Line(points={{40,50},{54,50}}, color={0,127,255}));
  connect(senMasFloDisAutosize.port_b, connection2PipeAutosize.port_aDisRet)
    annotation (Line(points={{74,50},{84,50},{84,28},{48,28},{48,44},{40,44}},
        color={0,127,255}));
  connect(connection2PipeplugFlow.port_bDisSup, senMasFloDisPlugFlow.port_a)
    annotation (Line(points={{40,-50},{56,-50}}, color={0,127,255}));
  connect(senMasFloDisPlugFlow.port_b, connection2PipeplugFlow.port_aDisRet)
    annotation (Line(points={{76,-50},{84,-50},{84,-70},{50,-70},{50,-56},{40,-56}},
        color={0,127,255}));
  connect(bouDisPlugFlow.ports[1], connection2PipeplugFlow.port_aDisSup)
    annotation (Line(points={{-40,-80},{-30,-80},{-30,-50},{20,-50}}, color={0,127,
          255}));
  connect(bouDisAutoSize.ports[1], connection2PipeAutosize.port_aDisSup)
    annotation (Line(points={{-30,20},{-24,20},{-24,50},{20,50}}, color={0,127,255}));
  annotation (__Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Networks/Connections/Examples/Connection2PipeExample.mos" "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model of two two-pipe connection models that could be used i.e for building a bi-directional network to connect one agent in series.  It uses 
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Connections.Connection2PipeAutosize\">
Buildings.Experimental.DHC.Networks.Connections.Connection2PipeAutosize</a> and 
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Connections.Connection2PipePlugFlow\">
Buildings.Experimental.DHC.Networks.Connections.Connection2PipePlugFlow</a>. The agent, in this example just a pump, will draw water from the distribution supply pipe and release it in the return pipe.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2024, Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2PipeExample;
