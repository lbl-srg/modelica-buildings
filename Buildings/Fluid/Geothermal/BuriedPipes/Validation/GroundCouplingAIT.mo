within Buildings.Fluid.Geothermal.BuriedPipes.Validation;
model GroundCouplingAIT
  "Validation for pipe and ground coupling against data from Austrian Institute of Technology"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Real R80(unit="(m.K)/W")=1/(2*0.024*Modelica.Constants.pi)
      *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07) "Thermal resistance per unit length of service pipes";

  parameter Boolean pipVol=true
    "Flag to decide whether volumes are included at the end points of the pipe";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";

  parameter Modelica.SIunits.Length thickness=0.0032 "Pipe wall thickness";

  Fluid.Sources.MassFlowSource_T Point1(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-78})));

  Fluid.Sources.MassFlowSource_T Point4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 4"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={8,108})));
  Fluid.Sources.MassFlowSource_T Point3(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) "Subsation 3"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-80})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Subtation 2"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-88,82})));
  FixedResistances.PlugFlowPipe pip1(
    redeclare package Medium = Medium,
    dh=0.0825,
    dIns=0.045,
    kIns=0.024,
    length=115,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 1"
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
  FixedResistances.PlugFlowPipe pip4(
    dh=0.0273,
    redeclare package Medium = Medium,
    length=29,
    dIns=0.0182,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    thickness=thickness,
    nPorts=2,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 4" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,40})));

  FixedResistances.PlugFlowPipe pip5(
    redeclare package Medium = Medium,
    length=20,
    dh=0.0825,
    kIns=0.024,
    dIns=0.045,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 5"
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));

  FixedResistances.PlugFlowPipe pip2(
    redeclare package Medium = Medium,
    length=76,
    dIns=0.0182,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    m_flow_nominal=0.3,
    thickness=thickness,
    dh=0.0273,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 2" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,26})));

  FixedResistances.PlugFlowPipe pip3(
    redeclare package Medium = Medium,
    length=38,
    dIns=0.0182,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    m_flow_nominal=0.3,
    thickness=thickness,
    dh=0.0273,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 3" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,-20})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(
    tableOnFile=true,
    tableName="dat",
    columns=2:pipeDataAIT151218.nCol,
    fileName=pipeDataAIT151218.filNam)
    "Read measurement data"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  FixedResistances.Validation.PlugFlowPipes.Data.PipeDataAIT151218 pipeDataAIT151218
    "Measurement data from AIT network"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    "Mass flow rate for substation 3"
    annotation (Placement(transformation(extent={{-100,-114},{-60,-94}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    "Mass flow rate of substation 4"
    annotation (Placement(transformation(extent={{156,130},{116,150}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-14,90},{-54,110}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    "Inlet temperature"
    annotation (Placement(transformation(extent={{20,-114},{60,-94}})));
  Fluid.Sensors.TemperatureTwoPort senTem_p3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-50})));
  Fluid.Sensors.TemperatureTwoPort senTem_p2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-88,56})));
  Fluid.Sensors.TemperatureTwoPort senTem_p4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,80})));
  Fluid.Sensors.TemperatureTwoPort senTem_p1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-50})));
  FixedResistances.PlugFlowPipe pip0(
    redeclare package Medium = Medium,
    dh=0.0825,
    dIns=0.045,
    kIns=0.024,
    length=20,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 0" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-10})));
  Buildings.Fluid.Sources.Boundary_pT ExcludedBranch(redeclare package
      Medium =                                                                  Medium,
      nPorts=1) "Mass flow sink for excluded branch"
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={82,40})));
  Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));

  Modelica.Blocks.Logical.Switch switch
    "Decide if mass flow rate is below measurement noise threshold or not"
    annotation (Placement(transformation(extent={{54,116},{34,136}})));
  Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
    "Default value if mass flow rate is below measurement noise threshold"
    annotation (Placement(transformation(extent={{156,108},{116,128}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
    "Measurement noise threshold"
    annotation (Placement(transformation(extent={{92,120},{76,136}})));
  Modelica.Blocks.Logical.Switch switch1
    "Decide if mass flow rate is below measurement noise threshold or not"
    annotation (Placement(transformation(extent={{130,54},{110,74}})));
  Fluid.Sources.MassFlowSource_T Point5(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)
    "Bypass temperature sensor when flow rate is below measurement threshold"
              annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={46,56})));

  GroundCoupling groMai(
    nPip=1,
    nSeg=3,
    soiDat=soiDat,
    cliCon=cliCon,
    len={pip0.length,pip1.length,pip5.length},
    dep={1},
    pos={0},
    rad={0.0889}) "Main line pipes ground coupling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,30})));
  BoundaryConditions.GroundTemperature.ClimaticConstants.Generic cliCon(
    TSurMea=281.53,
    TSurAmp=9.88,
    sinPha=9002880)
    "Climatic constants in Pongau, Austria"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  parameter HeatTransfer.Data.Soil.Generic soiDat(
    k=2.4,
    c=1000,
    d=1600) "Soil thermal properties"
    annotation (Placement(transformation(extent={{120,-120},{140,-98}})));
  GroundCoupling groSup(
    nPip=1,
    nSeg=3,
    soiDat=soiDat,
    cliCon=cliCon,
    len={pip2.length,pip3.length,pip4.length},
    dep={1},
    pos={0},
    rad={0.0337}) "Customers supply pipes ground coupling" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,70})));
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-58,-104},{-58,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-80,94},{-80,100},{-56,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{62,-104},{76,-104},{76,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
      points={{41,-70},{64,-70},{64,-90},{72,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-88,66},
          {-88,66},{-88,70},{-88,72}}, color={0,127,255}));
  connect(Point3.ports[1], senTem_p3.port_b)
    annotation (Line(points={{-50,-70},{-50,-60}}, color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1])
    annotation (Line(points={{8,90},{8,98}},        color={0,127,255}));
  connect(Point1.ports[1], senTem_p1.port_b)
    annotation (Line(points={{80,-68},{80,-60}},          color={0,127,255}));
  connect(senTem_p1.port_a, pip0.port_a)
    annotation (Line(points={{80,-40},{80,-20}},          color={0,127,255}));
  connect(switch.u1, m_flow_p4.y) annotation (Line(points={{56,134},{72,134},{
          72,140},{114,140}},color={0,0,127}));
  connect(m_flow_zero.y, switch.u3)
    annotation (Line(points={{114,118},{100,118},{100,102},{86,102},{86,118},{
          56,118}},                                    color={0,0,127}));
  connect(switch.y, Point4.m_flow_in)
    annotation (Line(points={{33,126},{16,126},{16,120}},color={0,0,127}));
  connect(switch.u2, lessThreshold.y) annotation (Line(points={{56,126},{64,126},
          {64,128},{75.2,128}},
                            color={255,0,255}));
  connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{93.6,128},{
          100,128},{100,140},{114,140}},
                               color={0,0,127}));
  connect(pip1.port_a, pip0.ports_b[1])
    annotation (Line(points={{50,10},{78,10},{78,0}}, color={0,127,255}));
  connect(pip1.ports_b[1], pip4.port_a)
    annotation (Line(points={{30,8},{10,8},{10,30}}, color={0,127,255}));
  connect(pip5.port_a, pip1.ports_b[2])
    annotation (Line(points={{0,10},{30,10},{30,12}}, color={0,127,255}));
  connect(pip4.ports_b[1], senTem_p4.port_a)
    annotation (Line(points={{12,50},{12,60},{8,60},{8,70}},
                                                    color={0,127,255}));
  connect(Point5.ports[1], pip4.ports_b[2]) annotation (Line(points={{36,56},
          {36,56},{8,56},{8,50}},  color={0,127,255}));
  connect(pip5.ports_b[1], senTemIn_p2.port_b)
    annotation (Line(points={{-20,8},{-60,8}},          color={0,127,255}));
  connect(pip3.port_a, pip5.ports_b[2])
    annotation (Line(points={{-50,-10},{-50,12},{-20,12}},
                                                         color={0,127,255}));
  connect(senTemIn_p2.port_a, pip2.port_a)
    annotation (Line(points={{-80,8},{-88,8},{-88,16}},   color={0,127,255}));
  connect(pip2.ports_b[1], senTem_p2.port_a)
    annotation (Line(points={{-88,36},{-88,46}},          color={0,127,255}));
  connect(pip3.ports_b[1], senTem_p3.port_a) annotation (Line(points={{-50,-30},
          {-50,-40}},           color={0,127,255}));
  connect(ExcludedBranch.ports[1], pip0.ports_b[2]) annotation (Line(points={{82,30},
          {82,0}},                       color={0,127,255}));
  connect(switch1.y, Point5.m_flow_in) annotation (Line(points={{109,64},{58,64}},
                            color={0,0,127}));
  connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{114,140},{100,140},
          {100,108},{152,108},{152,56},{132,56}},               color={0,0,127}));
  connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{114,118},{104,
          118},{104,80},{150,80},{150,72},{132,72}},  color={0,0,127}));
  connect(lessThreshold.y, switch1.u2) annotation (Line(points={{75.2,128},{66,
          128},{66,104},{140,104},{140,64},{132,64}},
                                                    color={255,0,255}));
  connect(groMai.ports[1, 1], pip0.heatPort) annotation (Line(points={{130,20},
          {110,20},{110,-10},{90,-10}}, color={191,0,0}));
  connect(groMai.ports[1, 2], pip1.heatPort)
    annotation (Line(points={{130,20},{40,20}}, color={191,0,0}));
  connect(groMai.ports[1, 2], pip5.heatPort)
    annotation (Line(points={{130,20},{-10,20}}, color={191,0,0}));
  connect(groSup.ports[1, 1], pip2.heatPort) annotation (Line(points={{-30,60},
          {-30,40},{-60,40},{-60,26},{-78,26}}, color={191,0,0}));
  connect(groSup.ports[1, 2], pip3.heatPort) annotation (Line(points={{-30,60},
          {-30,-20},{-40,-20}}, color={191,0,0}));
  connect(groSup.ports[1, 3], pip4.heatPort)
    annotation (Line(points={{-30,60},{-30,40},{0,40}}, color={191,0,0}));
  annotation (
    experiment(
      StopTime=603900,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Geothermal/BuriedPipes/Validation/GroundCouplingAIT.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-120,-160},{160,160}})),
    Documentation(info="<html>
<p>
Validation of <a href=\"modelica://Buildings.Fluid.Geothermal.BuriedPipes.GroundCoupling\">
Buildings.Fluid.Geothermal.BuriedPipes.GroundCoupling</a> using the experimental data collected by
the Austrian Institute of Technology.
</p>
<p>
See <a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a> for more info.
</p>
</html>", revisions="<html>
<ul>
<li>
June 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundCouplingAIT;
