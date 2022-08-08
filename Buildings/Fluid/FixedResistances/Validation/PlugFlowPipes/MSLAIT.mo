within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model MSLAIT
  "Validation pipe against data from Austrian Institute of Technology with standard library components"
  extends Modelica.Icons.Example;

  Fluid.Sources.MassFlowSource_T Point1(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={124,-84})));
  package Medium = Buildings.Media.Water;
  Fluid.Sources.MassFlowSource_T Point4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 4"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={42,120})));
  Fluid.Sources.MassFlowSource_T Point3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 3"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-48,-106})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Substation 2"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-104,110})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(
    tableOnFile=true,
    tableName="dat",
    columns=2:pipeDataAIT151218.nCol,
    fileName=pipeDataAIT151218.filNam)
    "Read measurement data"
    annotation (Placement(transformation(extent={{34,-152},{54,-132}})));
  Data.PipeDataAIT151218 pipeDataAIT151218 "Record with measurement data"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    "Mass flow rate for substation 3"
    annotation (Placement(transformation(extent={{-102,-136},{-62,-116}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    "Mass flow rate for substation 2"
    annotation (Placement(transformation(extent={{-154,120},{-114,140}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    "Inlet temperature"
    annotation (Placement(transformation(extent={{62,-110},{102,-90}})));
  Buildings.Fluid.Sources.Boundary_pT ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) "Mass flow sink for excluded branch"
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={124,26})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature "Variable environment temperature"
    annotation (Placement(transformation(extent={{74,-152},{94,-132}})));

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
    nNodes=20,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal(displayUnit="Pa") = 10*pip0.length, m_flow_nominal=0.3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 0"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={124,-8})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  parameter Modelica.Units.SI.ThermalResistance R=1/(2*kIns*Modelica.Constants.pi)
      *log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.18)
    "Thermal resistance of main pipes";
  parameter Modelica.Units.SI.ThermalResistance R80=1/(2*0.024*Modelica.Constants.pi)
      *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07)
    "Thermal resistance of service pipes";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0[pip0.nNodes](each R=
        R) "Thermal resistances for pipe 0"
           annotation (Placement(transformation(extent={{142,-18},{162,2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={182,-8})));
  Modelica.Fluid.Pipes.DynamicPipe pip1(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=115,
    nNodes=115,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          m_flow_nominal=0.3, dp_nominal=10*pip1.length),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 1"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={78,4})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={102,46})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1[pip1.nNodes](each R=
        R) "Thermal resistances for pipe 1"
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={78,30})));
  Modelica.Fluid.Pipes.DynamicPipe pip2(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=76,
    nNodes=76,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip2.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 2"
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-104,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col2(m=pip2.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-66,64})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res2[pip2.nNodes](each R=
        R80) "Thermal resistances for pipe 2"
             annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  Modelica.Fluid.Pipes.DynamicPipe pip3(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=38,
    nNodes=38,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip3.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 3"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-48,-48})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col3(m=pip3.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-48})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res3[pip3.nNodes](each R=
        R80) "Thermal resistances for pipe 3"
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-4,-48})));
  Modelica.Fluid.Pipes.DynamicPipe pip4(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=29,
    nNodes=29,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip4.length, m_flow_nominal=0.3),
    diameter=0.0337 - 2*0.0032,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 4"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={42,38})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={16,96})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res4[pip4.nNodes](each R=
        R80) "Thermal resistances for pipe 4"
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={16,62})));
  Modelica.Fluid.Pipes.DynamicPipe pip5(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=20,
    nNodes=20,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip5.length, m_flow_nominal=0.3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Pipe 5"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22,4})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col5(m=pip5.nNodes)
    "Combine heat flows to one"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-22,96})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res5[pip5.nNodes](each R=
        R) "Thermal resistances for pipe 5"
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-22,62})));
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.024
    "Heat conductivity of pipe insulation material";
  parameter Modelica.Units.SI.Length dIns=0.045 "Thickness of pipe insulation";
  parameter Modelica.Units.SI.Diameter diameter=0.089 "Outer diameter of pipe";
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p2(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-104,74})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p3(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-48,-74})));
  Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-54,-6},{-74,14}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p1(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={124,-42})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p4(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,80})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.Units.SI.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";

  Fluid.Sources.MassFlowSource_T Point5(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow sink for substation 4 in case of low flow rates"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,70})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    "Measured mass flow rate for substation 4"
    annotation (Placement(transformation(extent={{220,164},{180,184}})));
  Modelica.Blocks.Logical.Switch switch
    "Switch to avoid mass flow rate measurement noise on substation with flow standstill."
    annotation (Placement(transformation(extent={{100,156},{80,176}})));
  Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
    "Default value when mass flow rate is below noise threshold"
    annotation (Placement(transformation(extent={{220,148},{180,168}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
    "Check if mass flow rate is lower than 0.001"
    annotation (Placement(transformation(extent={{144,122},{124,142}})));
  Modelica.Blocks.Logical.Switch switch1
    "If flow is lower than measurement noise threshold, bypass temperature sensor"
    annotation (Placement(transformation(extent={{100,82},{80,102}})));
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-60,-126},{-56,-126},{-56,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-96,122},{-96,130},{-112,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{104,-100},{120,-100},{120,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
      points={{55,-142},{64,-142},{64,-108},{116,-108},{116,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[9], prescribedTemperature.T)
    annotation (Line(points={{55,-142},{72,-142}},        color={0,0,127}));
  connect(pip0.port_b, ExcludedBranch.ports[1])
    annotation (Line(points={{124,2},{124,16}},
                                              color={0,127,255}));
  connect(pip4.port_a, pip1.port_b)
    annotation (Line(points={{42,28},{42,4},{68,4}},   color={0,127,255}));
  connect(pip5.port_a, pip1.port_b)
    annotation (Line(points={{-12,4},{68,4}}, color={0,127,255}));
  connect(pip1.port_a, pip0.port_b) annotation (Line(points={{88,4},{124,4},{
          124,2}},     color={0,127,255}));
  connect(pip2.port_b, senTem_p2.port_a)
    annotation (Line(points={{-104,50},{-104,64}},        color={0,127,255}));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-104,84},
          {-104,100}},                color={0,127,255}));
  connect(senTem_p3.port_a, pip3.port_b) annotation (Line(points={{-48,-64},{
          -48,-58}},       color={0,127,255}));
  connect(senTem_p3.port_b, Point3.ports[1]) annotation (Line(points={{-48,-84},
          {-48,-96}},                     color={0,127,255}));
  connect(pip3.port_a, pip5.port_b) annotation (Line(points={{-48,-38},{-48,4},
          {-32,4}},                  color={0,127,255}));
  connect(senTemIn_p2.port_a, pip5.port_b)
    annotation (Line(points={{-54,4},{-32,4}},   color={0,127,255}));
  connect(senTemIn_p2.port_b, pip2.port_a)
    annotation (Line(points={{-74,4},{-104,4},{-104,30}}, color={0,127,255}));
  connect(pip4.port_b, senTem_p4.port_a) annotation (Line(points={{42,48},{42,
          70}},             color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1])
    annotation (Line(points={{42,90},{42,110}},color={0,127,255}));
  connect(senTem_p1.port_a, Point1.ports[1])
    annotation (Line(points={{124,-52},{124,-74}},
                                                 color={0,127,255}));
  connect(senTem_p1.port_b, pip0.port_a) annotation (Line(points={{124,-32},{
          124,-18}},          color={0,127,255}));
  connect(Point5.ports[1], senTem_p4.port_a) annotation (Line(points={{54,70},{
          42,70}},                                 color={0,127,255}));
  connect(pip2.heatPorts, res2.port_a) annotation (Line(points={{-99.6,40.1},{
          -95.8,40.1},{-95.8,40},{-92,40}},
                                      color={127,0,0}));
  connect(res2.port_b, col2.port_a)
    annotation (Line(points={{-72,40},{-66,40},{-66,54}}, color={191,0,0}));
  connect(pip5.heatPorts, res5.port_a) annotation (Line(points={{-22.1,8.4},{
          -22.1,30},{-22,30},{-22,52}},
                                  color={127,0,0}));
  connect(res5.port_b, col5.port_a)
    annotation (Line(points={{-22,72},{-22,86}},          color={191,0,0}));
  connect(res4.port_a, pip4.heatPorts) annotation (Line(points={{16,52},{16,
          38.1},{37.6,38.1}},    color={191,0,0}));
  connect(res4.port_b, col4.port_a)
    annotation (Line(points={{16,72},{16,86}}, color={191,0,0}));
  connect(pip3.heatPorts, res3.port_a) annotation (Line(points={{-43.6,-48.1},{
          -14,-48.1},{-14,-48}},
                             color={127,0,0}));
  connect(res3.port_b, col3.port_a) annotation (Line(points={{6,-48},{18,-48}},
                                        color={191,0,0}));
  connect(res1.port_a, pip1.heatPorts)
    annotation (Line(points={{78,20},{78,8.4},{77.9,8.4}},   color={191,0,0}));
  connect(res1.port_b, col1.port_a)
    annotation (Line(points={{78,40},{78,46},{92,46}}, color={191,0,0}));
  connect(pip0.heatPorts, res0.port_a) annotation (Line(points={{128.4,-7.9},{
          135.2,-7.9},{135.2,-8},{142,-8}},
                                    color={127,0,0}));
  connect(res0.port_b, col0.port_a)
    annotation (Line(points={{162,-8},{172,-8}}, color={191,0,0}));
  connect(col2.port_b, col5.port_b) annotation (Line(points={{-66,74},{-66,132},
          {-22,132},{-22,106}}, color={191,0,0}));
  connect(col5.port_b, col4.port_b) annotation (Line(points={{-22,106},{-22,132},
          {16,132},{16,106}}, color={191,0,0}));
  connect(col0.port_b, prescribedTemperature.port) annotation (Line(points={{192,-8},
          {214,-8},{214,-142},{94,-142}},   color={191,0,0}));
  connect(col3.port_b, prescribedTemperature.port) annotation (Line(points={{38,-48},
          {214,-48},{214,-142},{94,-142}},    color={191,0,0}));
  connect(col4.port_b, prescribedTemperature.port) annotation (Line(points={{16,
          106},{16,190},{214,190},{214,-142},{94,-142}}, color={191,0,0}));
  connect(m_flow_zero.y,switch. u3)
    annotation (Line(points={{178,158},{102,158}},     color={0,0,127}));
  connect(switch.u1,m_flow_p4. y) annotation (Line(points={{102,174},{178,174}},
                               color={0,0,127}));
  connect(Point4.m_flow_in,switch. y) annotation (Line(points={{50,132},{50,166},
          {79,166}},          color={0,0,127}));
  connect(switch.u2,lessThreshold. y) annotation (Line(points={{102,166},{108,
          166},{108,132},{123,132}},
                             color={255,0,255}));
  connect(lessThreshold.u,m_flow_p4. y) annotation (Line(points={{146,132},{152,
          132},{152,174},{178,174}},     color={0,0,127}));
  connect(lessThreshold.y,switch1. u2) annotation (Line(points={{123,132},{108,
          132},{108,92},{102,92}},
                              color={255,0,255}));
  connect(m_flow_p4.y,switch1. u3) annotation (Line(points={{178,174},{156,174},
          {156,84},{102,84}}, color={0,0,127}));
  connect(m_flow_zero.y,switch1. u1) annotation (Line(points={{178,158},{160,
          158},{160,100},{102,100}},
                              color={0,0,127}));
  connect(switch1.y, Point5.m_flow_in) annotation (Line(points={{79,92},{78,92},
          {78,62},{76,62}}, color={0,0,127}));
  connect(col1.port_b, prescribedTemperature.port) annotation (Line(points={{
          112,46},{214,46},{214,-142},{94,-142}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{
            220,200}})),
    experiment(
      StopTime=603900,
      Tolerance=1e-006),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/MSLAIT.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
The example contains
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.PipeDataAIT151218\">
experimental data</a> from a real district heating network.
This data is used to validate this library's
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a> in
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a>.
This model compares its performance with the original Modelica Standard Library
pipes, using one discretization element per unit length of pipe.
For a coarser discretization, please refer to
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.MSLAIT2Nodes\">
MSLAIT2Nodes</a>.
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
<p>The pipes' temperatures are not initialized, thus results of outflow
temperature before approximately the first 10000 seconds should not be considered.
</p>
<h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test district heating network\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Validation/PlugFlowPipes/AITTestBench.png\"/> </p>
<h4>Calibration</h4>
<p>To calculate the length specific thermal resistance <code>R</code> of the
pipe, the thermal resistance of the surrounding ground is added. </p>
<p align=\"center\"style=\"font-style:italic;\">
R=1/(0.208)+1/(2 &nbsp; lambda_g &nbsp; Modelica.Constants.pi) &nbsp; log(1/0.18)</p>
<p>
Where the thermal conductivity of the ground <code>lambda_g</code> = 2.4 W/(m K).
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
<li>November 28, 2016 by Bram van der Heijde:<br/>Remove <code>pipVol.</code>
</li>
<li>August 24, 2016 by Bram van der Heijde:<br/>
Implement validation with MSL pipes for comparison, based on AIT validation.
</li>
<li>
July 4, 2016 by Bram van der Heijde:<br/>Added parameters to test the
influence of allowFlowReversal and the presence of explicit volumes in the pipe.
</li>
<li>January 26, 2016 by Carles Ribas:<br/>First implementation. </li>
</ul>
</html>"));
end MSLAIT;
