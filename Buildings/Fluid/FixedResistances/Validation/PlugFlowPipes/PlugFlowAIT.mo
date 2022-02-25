within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model PlugFlowAIT
  "Validation pipe against data from Austrian Institute of Technology"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Real R80(unit="(m.K)/W")=1/(2*0.024*Modelica.Constants.pi)
      *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07) "Thermal resistance per unit length of service pipes";

  parameter Boolean pipVol=true
    "Flag to decide whether volumes are included at the end points of the pipe";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.Units.SI.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";

  parameter Modelica.Units.SI.Length thickness=0.0032 "Pipe wall thickness";

  Fluid.Sources.MassFlowSource_T Point1(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-82})));

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
        origin={-50,-82})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Subtation 2"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-88,82})));
  PlugFlowPipe pip1(
    redeclare package Medium = Medium,
    dh=0.0825,
    dIns=0.045,
    kIns=0.024,
    length=115,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 1"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  PlugFlowPipe pip4(
    dh = 0.0337 - 2*0.0032,
    redeclare package Medium = Medium,
    length=29,
    dIns=0.045,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    thickness=thickness,
    R=R80,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 4"
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={10,40})));

  PlugFlowPipe pip5(
    redeclare package Medium = Medium,
    length=20,
    dh=0.0825,
    kIns=0.024,
    dIns=0.045,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 5"
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));

  PlugFlowPipe pip2(
    redeclare package Medium = Medium,
    length=76,
    dIns=0.045,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    thickness=thickness,
    dh=0.0337 - 2*0.0032,
    R=R80,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 2"
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,26})));

  PlugFlowPipe pip3(
    redeclare package Medium = Medium,
    length=38,
    dIns=0.045,
    kIns=0.024,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    thickness=thickness,
    dh=0.0337 - 2*0.0032,
    R=R80,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 3"
                    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,-20})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(
    tableOnFile=true,
    tableName="dat",
    columns=2:pipeDataAIT151218.nCol,
    fileName=pipeDataAIT151218.filNam)
    "Read measurement data"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Data.PipeDataAIT151218 pipeDataAIT151218 "Measurement data from AIT network"
    annotation (Placement(transformation(extent={{-30,-140},{-10,-120}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    "Mass flow rate for substation 3"
    annotation (Placement(transformation(extent={{-104,-120},{-64,-100}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    "Mass flow rate of substation 4"
    annotation (Placement(transformation(extent={{156,130},{116,150}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-14,90},{-54,110}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    "Inlet temperature"
    annotation (Placement(transformation(extent={{18,-114},{58,-94}})));
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
  PlugFlowPipe pip0(
    redeclare package Medium = Medium,
    dh=0.0825,
    dIns=0.045,
    kIns=0.024,
    length=20,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness,
    cPip=500,
    rhoPip=8000,
    initDelay=false,
    m_flow_start=0) "Pipe 0"
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-10})));
  Buildings.Fluid.Sources.Boundary_pT ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) "Mass flow sink for excluded branch"
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={82,40})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature "Variable environment temperature"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
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

  Buildings.Fluid.FixedResistances.Junction splPip1(
    redeclare package Medium = Medium,
    m_flow_nominal={pip1.m_flow_nominal,pip5.m_flow_nominal,pip4.m_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter coming out of pip1"
    annotation (Placement(transformation(extent={{30,20},{10,0}})));
  Buildings.Fluid.FixedResistances.Junction splPip2(
    redeclare package Medium = Medium,
    m_flow_nominal={pip5.m_flow_nominal,pip2.m_flow_nominal,pip3.m_flow_nominal},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter coming out of pip5"
    annotation (Placement(transformation(extent={{-30,0},{-50,20}})));
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-62,-110},{-58,-110},{-58,-94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-80,94},{-80,100},{-56,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{60,-104},{76,-104},{76,-94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
      points={{21,-130},{26,-130},{26,-112},{72,-112},{72,-94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[9], prescribedTemperature.T)
    annotation (Line(points={{21,-130},{38,-130}},        color={0,0,127}));
  connect(pip4.heatPort, pip1.heatPort) annotation (Line(points={{20,40},{50,40},
          {50,20}},         color={191,0,0}));
  connect(pip1.heatPort, pip0.heatPort) annotation (Line(points={{50,20},{50,26},
          {100,26},{100,-10},{90,-10}},
                                      color={191,0,0}));
  connect(pip1.heatPort, pip2.heatPort) annotation (Line(points={{50,20},{50,26},
          {-78,26}},                   color={191,0,0}));
  connect(pip5.heatPort, pip2.heatPort) annotation (Line(points={{-10,20},{-10,26},
          {-78,26}},                       color={191,0,0}));
  connect(pip3.heatPort, pip2.heatPort) annotation (Line(points={{-40,-20},{-28,
          -20},{-28,26},{-78,26}},                  color={191,0,0}));
  connect(prescribedTemperature.port, pip0.heatPort) annotation (Line(points={{60,-130},
          {100,-130},{100,-10},{90,-10}},      color={191,0,0}));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-88,66},
          {-88,66},{-88,70},{-88,72}}, color={0,127,255}));
  connect(Point3.ports[1], senTem_p3.port_b)
    annotation (Line(points={{-50,-72},{-50,-60}}, color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1])
    annotation (Line(points={{8,90},{8,98}},        color={0,127,255}));
  connect(Point1.ports[1], senTem_p1.port_b)
    annotation (Line(points={{80,-72},{80,-60}},          color={0,127,255}));
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
  connect(pip1.port_a, pip0.port_b)
    annotation (Line(points={{60,10},{80,10},{80,0}}, color={0,127,255}));
  connect(pip4.port_b, senTem_p4.port_a)
    annotation (Line(points={{10,50},{10,60},{8,60},{8,70}},
                                                    color={0,127,255}));
  connect(Point5.ports[1], pip4.port_b) annotation (Line(points={{36,56},{36,56},
          {10,56},{10,50}},        color={0,127,255}));
  connect(senTemIn_p2.port_a, pip2.port_a)
    annotation (Line(points={{-80,8},{-88,8},{-88,16}},   color={0,127,255}));
  connect(pip2.port_b, senTem_p2.port_a)
    annotation (Line(points={{-88,36},{-88,46}},          color={0,127,255}));
  connect(pip3.port_b, senTem_p3.port_a) annotation (Line(points={{-50,-30},
          {-50,-40}},           color={0,127,255}));
  connect(ExcludedBranch.ports[1], pip0.port_b) annotation (Line(points={{82,30},
          {82,16},{82,0},{80,0}},        color={0,127,255}));
  connect(switch1.y, Point5.m_flow_in) annotation (Line(points={{109,64},{58,64}},
                            color={0,0,127}));
  connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{114,140},{100,140},
          {100,108},{152,108},{152,56},{132,56}},               color={0,0,127}));
  connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{114,118},{104,
          118},{104,80},{150,80},{150,72},{132,72}},  color={0,0,127}));
  connect(lessThreshold.y, switch1.u2) annotation (Line(points={{75.2,128},{66,
          128},{66,104},{140,104},{140,64},{132,64}},
                                                    color={255,0,255}));
  connect(pip5.port_a, splPip1.port_2)
    annotation (Line(points={{0,10},{10,10}},color={0,127,255}));
  connect(pip1.port_b, splPip1.port_1)
    annotation (Line(points={{40,10},{30,10}}, color={0,127,255}));
  connect(splPip1.port_3, pip4.port_a) annotation (Line(points={{20,20},{20,24},
          {10,24},{10,30}}, color={0,127,255}));
  connect(senTemIn_p2.port_b, splPip2.port_2)
    annotation (Line(points={{-60,8},{-60,10},{-50,10}}, color={0,127,255}));
  connect(pip5.port_b, splPip2.port_1)
    annotation (Line(points={{-20,10},{-30,10}}, color={0,127,255}));
  connect(pip3.port_a, splPip2.port_3) annotation (Line(points={{-50,-10},{-50,-4},
          {-40,-4},{-40,0}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=603900,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/PlugFlowAIT.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-120,-160},{160,160}})),
    Documentation(info="<html>
<p>
The example contains
experimental data from a real district heating network.
</p>
<p>The pipes' temperatures are not initialized. Therefore, results of
outflow temperature before approximately the first 10000 seconds should not be
considered.
</p>
<p>
Note that these three models are identical, except for the pipe model that is used:
</p>
<ul>
<li>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.MSLAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.MSLAIT</a>
uses the pipe model from the Modelica Standard Library, with a fine discretization.
See the parameter <code>nNodes</code>.
</li>
<li>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.MSLAIT2Nodes\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.MSLAIT2Nodes</a>
uses the same model as above, but sets <code>nNodes=2</code>.
</li>
<li>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a>
uses the plug flow model
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a>.
</li>
</ul>
<p>
This comparison between different discretization levels and pipe models is made
to check the influence of the discretization and pipe model on computation time
and simulation accuracy.
</p>
<h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test district heating network\"
src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Validation/PlugFlowPipes/AITTestBench.png\"/>
</p>
<h4>Calibration</h4>
<p>To calculate the length specific thermal resistance <code>R</code> of the pipe,
the thermal resistance of the surrounding ground is added, which yields</p>
<p align=\"center\"style=\"font-style:italic;\">
R=1/(0.208)+1/(2 &nbsp; lambda_g &nbsp; Modelica.Constants.pi) &nbsp; log(1/0.18),</p>
<p>where the thermal conductivity of the ground <code>lambda_g</code> = 2.4 W/(m K).
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2020, by Michael Wetter:<br/>
Replaced measured data from specification in Modelica file to external table,
as this reduces the computing time.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1289\"> #1289</a>.
</li>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>July 4, 2016 by Bram van der Heijde:<br/>Added parameters to test the
influence of allowFlowReversal and the presence of explicit volumes in the pipe.
</li>
<li>January 26, 2016 by Carles Ribas:<br/>First implementation. </li>
</ul>
</html>"));
end PlugFlowAIT;
