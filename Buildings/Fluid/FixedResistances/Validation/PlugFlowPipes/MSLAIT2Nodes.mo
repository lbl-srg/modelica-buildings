within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model MSLAIT2Nodes
  "Smaller discretisation. Validation pipe against data from Austrian Institute of Technology with standard library components"
  extends Modelica.Icons.Example;

  Fluid.Sources.MassFlowSource_T Point1(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={82,-92})));
  package Medium = Buildings.Media.Water;
  Fluid.Sources.MassFlowSource_T Point4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 4"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={22,150})));
  Fluid.Sources.MassFlowSource_T Point3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 3"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-48,-96})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 2"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-96,152})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
    "Read measurement data"
    annotation (Placement(transformation(extent={{0,-158},{20,-138}})));
  Data.PipeDataAIT151218 pipeDataAIT151218 "Measurement data from AIT"
    annotation (Placement(transformation(extent={{-30,-158},{-10,-138}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    "Mass flow rate for substation 3"
    annotation (Placement(transformation(extent={{-112,-126},{-72,-106}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    "Mass flow rate for substation 4"
    annotation (Placement(transformation(extent={{220,166},{180,186}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    "Mass flow rate for substation 2"
    annotation (Placement(transformation(extent={{-146,172},{-106,192}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    "Inlet temperature"
    annotation (Placement(transformation(extent={{18,-132},{58,-112}})));
  Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) "Mass flow sink for excluded branch"
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={82,26})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature "Variable environment temperature"
    annotation (Placement(transformation(extent={{40,-158},{60,-138}})));

  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  Modelica.Fluid.Pipes.DynamicPipe pip0(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    length=20,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal(displayUnit="Pa") = 10*pip0.length, m_flow_nominal=0.3),
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 0"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={82,-8})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  parameter Real R(unit="(m.K)/W")=1/(2*kIns*Modelica.Constants.pi)
      *log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.18) "Thermal resistance per unit length of main pipes";
  parameter Real R80(unit="(m.K)/W")=1/(2*0.024*Modelica.Constants.pi)
      *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07) "Thermal resistance per unit length of service pipes";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0[pip0.nNodes](each R=
        2*R/pip0.length) "Thermal resistances for elements of pipe 0"
    annotation (Placement(transformation(extent={{94,-18},{114,2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={132,-8})));
  Modelica.Fluid.Pipes.DynamicPipe pip1(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=115,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          m_flow_nominal=0.3, dp_nominal=10*pip1.length),
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 1"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={38,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={108,54})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1[pip1.nNodes](each R=
        2*R/pip1.length) "Thermal resistances for elements of pipe 1"
    annotation (Placement(transformation(extent={{56,44},{76,64}})));
  Modelica.Fluid.Pipes.DynamicPipe pip2(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=76,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip2.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 2"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-96,42})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col2(m=pip2.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-72,108})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res2[pip2.nNodes](each R=
        2*R80/pip2.length) "Thermal resistances for elements of pipe 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-72,68})));
  Modelica.Fluid.Pipes.DynamicPipe pip3(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=38,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip3.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 3"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-48,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col3(m=pip3.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={18,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res3[pip3.nNodes](each R=
        2*R80/pip3.length) "Thermal resistances for elements of pipe 3"
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,-30})));
  Modelica.Fluid.Pipes.DynamicPipe pip4(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=29,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip4.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 4"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={18,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,108})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res4[pip4.nNodes](each R=
        2*R80/pip4.length) "Thermal resistances for elements of pipe 4"
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,68})));
  Modelica.Fluid.Pipes.DynamicPipe pip5(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=20,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip5.length, m_flow_nominal=0.3),
    nNodes=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 5"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-28,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col5(m=pip5.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-28,108})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res5[pip5.nNodes](each R=
        2*R/pip5.length) "Thermal resistances for elements of pipe 5"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,68})));
  parameter Modelica.SIunits.ThermalConductivity kIns=0.024
    "Heat conductivity";
  parameter Modelica.SIunits.Length dIns=0.045
    "Thickness of pipe insulation";
  parameter Modelica.SIunits.Diameter diameter=0.089
    "Outer diameter of pipe";
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p2(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-96,100})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p3(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-48,-64})));
  Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
  Fluid.Sensors.TemperatureTwoPort senTem_p1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={82,-54})));
  Fluid.Sensors.TemperatureTwoPort senTem_p4(
  redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={18,112})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";

  Modelica.Blocks.Logical.Switch switch
    "Decide if mass flow rate is below measurement noise threshold or not"
    annotation (Placement(transformation(extent={{94,158},{74,178}})));
  Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
    "Default value when mass flow rate is below measurement noise threshold"
    annotation (Placement(transformation(extent={{220,150},{180,170}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
    "Measurement noise threshold"
    annotation (Placement(transformation(extent={{144,124},{124,144}})));
  Fluid.Sources.MassFlowSource_T Point5(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Low flow bypass of substation 4"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,102})));
  Modelica.Blocks.Logical.Switch switch1
    "Decide if mass flow rate is below measurement noise threshold or not"
    annotation (Placement(transformation(extent={{96,84},{76,104}})));
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-70,-116},{-56,-116},{-56,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-88,164},{-88,182},{-104,182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{60,-122},{78,-122},{78,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
      points={{21,-148},{26,-148},{26,-130},{74,-130},{74,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[9], prescribedTemperature.T)
    annotation (Line(points={{21,-148},{38,-148}},        color={0,0,127}));
  connect(pip0.port_b, ExcludedBranch.ports[1])
    annotation (Line(points={{82,2},{82,16}}, color={0,127,255}));
  connect(pip4.port_a, pip1.port_b)
    annotation (Line(points={{18,30},{18,10},{28,10}}, color={0,127,255}));
  connect(pip5.port_a, pip1.port_b)
    annotation (Line(points={{-18,10},{28,10}},
                                              color={0,127,255}));
  connect(pip1.port_a, pip0.port_b) annotation (Line(points={{48,10},{82,10},{
          82,2}},      color={0,127,255}));
  connect(pip2.port_b, senTem_p2.port_a)
    annotation (Line(points={{-96,52},{-96,90}},          color={0,127,255}));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-96,110},
          {-96,142}},                 color={0,127,255}));
  connect(senTem_p3.port_a, pip3.port_b) annotation (Line(points={{-48,-54},{
          -48,-40}},       color={0,127,255}));
  connect(senTem_p3.port_b, Point3.ports[1]) annotation (Line(points={{-48,-74},
          {-48,-86}},                     color={0,127,255}));
  connect(pip3.port_a, pip5.port_b) annotation (Line(points={{-48,-20},{-48,10},
          {-38,10}},                 color={0,127,255}));
  connect(senTemIn_p2.port_a, pip5.port_b)
    annotation (Line(points={{-60,10},{-38,10}}, color={0,127,255}));
  connect(senTemIn_p2.port_b, pip2.port_a)
    annotation (Line(points={{-80,10},{-80,32},{-96,32}}, color={0,127,255}));
  connect(pip4.port_b, senTem_p4.port_a) annotation (Line(points={{18,50},{18,
          102}},            color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1])
    annotation (Line(points={{18,122},{18,140},{22,140}},
                                               color={0,127,255}));
  connect(senTem_p1.port_a, Point1.ports[1])
    annotation (Line(points={{82,-64},{82,-82}}, color={0,127,255}));
  connect(senTem_p1.port_b, pip0.port_a) annotation (Line(points={{82,-44},{82,
          -18}},              color={0,127,255}));
  connect(m_flow_zero.y,switch. u3)
    annotation (Line(points={{178,160},{96,160}},      color={0,0,127}));
  connect(switch.u1, m_flow_p4.y) annotation (Line(points={{96,176},{178,176}},
                               color={0,0,127}));
  connect(Point4.m_flow_in, switch.y) annotation (Line(points={{30,162},{30,168},
          {73,168}},          color={0,0,127}));
  connect(switch.u2, lessThreshold.y) annotation (Line(points={{96,168},{108,
          168},{108,134},{123,134}},
                             color={255,0,255}));
  connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{146,134},{152,
          134},{152,176},{178,176}},     color={0,0,127}));
  connect(Point5.m_flow_in,switch1. y)
    annotation (Line(points={{60,94},{75,94}},         color={0,0,127}));
  connect(lessThreshold.y, switch1.u2) annotation (Line(points={{123,134},{108,
          134},{108,94},{98,94}},
                              color={255,0,255}));
  connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{178,176},{156,176},
          {156,86},{98,86}},  color={0,0,127}));
  connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{178,160},{160,
          160},{160,102},{98,102}},
                              color={0,0,127}));
  connect(Point5.ports[1], senTem_p4.port_a) annotation (Line(points={{38,102},
          {18,102}},                               color={0,127,255}));
  connect(pip2.heatPorts, res2.port_a) annotation (Line(points={{-91.6,42.1},{
          -71.8,42.1},{-71.8,58},{-72,58}}, color={127,0,0}));
  connect(res2.port_b, col2.port_a)
    annotation (Line(points={{-72,78},{-72,98}}, color={191,0,0}));
  connect(col5.port_a, res5.port_b)
    annotation (Line(points={{-28,98},{-28,78}},          color={191,0,0}));
  connect(res5.port_a, pip5.heatPorts) annotation (Line(points={{-28,58},{-28,
          54},{-28.1,54},{-28.1,14.4}}, color={191,0,0}));
  connect(res4.port_a, pip4.heatPorts)
    annotation (Line(points={{-6.66134e-016,58},{-6.66134e-016,40.1},{13.6,40.1}},
                                                            color={191,0,0}));
  connect(res4.port_b, col4.port_a)
    annotation (Line(points={{4.44089e-016,78},{4.44089e-016,98},{-1.33227e-015,
          98}},                                        color={191,0,0}));
  connect(col2.port_b, col5.port_b) annotation (Line(points={{-72,118},{-72,184},
          {-28,184},{-28,118}},                    color={191,0,0}));
  connect(col5.port_b, col4.port_b) annotation (Line(points={{-28,118},{-28,184},
          {1.33227e-015,184},{1.33227e-015,118}}, color={191,0,0}));
  connect(pip1.heatPorts, res1.port_a)
    annotation (Line(points={{37.9,14.4},{37.9,54},{56,54}}, color={127,0,0}));
  connect(res1.port_b, col1.port_a)
    annotation (Line(points={{76,54},{98,54}},         color={191,0,0}));
  connect(col4.port_b, col1.port_b) annotation (Line(points={{1.33227e-015,118},
          {1.33227e-015,184},{166,184},{166,54},{118,54}},
                                        color={191,0,0}));
  connect(pip0.heatPorts, res0.port_a) annotation (Line(points={{86.4,-7.9},{
          89.2,-7.9},{89.2,-8},{94,-8}}, color={127,0,0}));
  connect(res0.port_b, col0.port_a)
    annotation (Line(points={{114,-8},{118,-8},{122,-8}}, color={191,0,0}));
  connect(col1.port_b, col0.port_b) annotation (Line(points={{118,54},{166,54},
          {166,-8},{142,-8}}, color={191,0,0}));
  connect(col0.port_b, prescribedTemperature.port) annotation (Line(points={{142,-8},
          {166,-8},{166,-148},{60,-148}},       color={191,0,0}));
  connect(pip3.heatPorts, res3.port_a) annotation (Line(points={{-43.6,-30.1},{
          -35.8,-30.1},{-35.8,-30},{-30,-30}}, color={127,0,0}));
  connect(res3.port_b, col3.port_a)
    annotation (Line(points={{-10,-30},{8,-30}},          color={191,0,0}));
  connect(col3.port_b, prescribedTemperature.port) annotation (Line(points={{28,-30},
          {166,-30},{166,-148},{60,-148}},  color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{
            220,200}})),
    experiment(StopTime=603900, Tolerance=1e-006,
    __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p>The example contains
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.PipeDataAIT151218\">
experimental data</a> from a real district heating network.
This data is used to validate this library's
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">plug flow pipe model</a>
in <a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a>.
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
<p>The pipes' temperatures are not initialized, thus results of outflow temperature
before approximately the first 10000 seconds should not be considered.
</p>
<h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test district heating network\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Validation/PlugFlowPipes/AITTestBench.png\"/> </p>
<h4>Calibration</h4>
<p>
To calculate the length specific thermal resistance <code>R</code> of the pipe,
the thermal resistance of the surrounding ground is added.
</p>
<p align=\"center\"style=\"font-style:italic;\">
R=1/(0.208)+1/(2 &nbsp; lambda<sub>g</sub> Modelica.Constants.pi) &nbsp; log(1/0.18)
</p>
<p>
Where the thermal conductivity of the ground <code>lambda_g</code> = 2.4 W/(m K).
</p>
</html>", revisions="<html>
<ul>
<li>November 28, 2016 by Bram van der Heijde:<br/>Remove <code>pipVol.</code>
</li>
<li>
August 24, 2016 by Bram van der Heijde:<br/>
Implement validation with MSL pipes for comparison, based on AIT validation.
</li>
<li>
July 4, 2016 by Bram van der Heijde:<br/>Added parameters to test the
influence of allowFlowReversal and the presence of explicit volumes in the pipe.
</li>
<li>January 26, 2016 by Carles Ribas:<br/>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/MSLAIT2Nodes.mos"
        "Simulate and plot"));
end MSLAIT2Nodes;
