within Buildings.Fluid.Storage.Plant;
model DummyConsumer "Dummy consumer model"
/*
For simplification, instead of setting up a heat exchanger to a room model,
the consumer control valve simply tracks the return CHW temperature.  
*/
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_a_nominal-p_b_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_a_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_b_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Boolean allowFlowReversal=false
    "Flow reversal setting on chiller branch";

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCon(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m_flow_nominal) "Consumer control valve"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaCon
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{22,70},{42,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    V=1,
    p_start=p_a_nominal,
    T_start=T_b_nominal) "Volume representing the consumer"
    annotation (
      Placement(transformation(
        origin={0,-10},
        extent={{10,10},{-10,-10}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TCon
    "Temperature of the consumer"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.Continuous.LimPID conPI_valCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=10,
    Ti=1000,
    reverseActing=false)
           "PI controller for consumer control valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
  Modelica.Blocks.Math.Gain gain(k=1)    "Gain" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,60})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=p_a_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-112,-10},{-92,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=p_b_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput QCooLoa_flow
    "Cooling load of the consumer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));
  Modelica.Blocks.Interfaces.RealInput TSet "CHW return setpoint" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50})));
  Modelica.Blocks.Interfaces.RealOutput yVal_actual
    "Consumer control valve actuator position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,110})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium = Medium)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Interfaces.RealOutput dp
    "Differential pressure of the consumer" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-30,110})));
equation
  connect(valCon.port_b, vol.ports[1]) annotation (Line(points={{-60,0},{1,0}},
                          color={0,127,255}));
  connect(heaCon.port, vol.heatPort)
    annotation (Line(points={{42,80},{54,80},{54,-10},{10,-10}},
                                                       color={191,0,0}));
  connect(vol.heatPort, TCon.port)
    annotation (Line(points={{10,-10},{54,-10},{54,-30},{40,-30}},
                                                       color={191,0,0}));
  connect(preDro.port_a, vol.ports[2]) annotation (Line(points={{60,0},{-1,0}},
                            color={0,127,255}));
  connect(conPI_valCon.y, gain.u)
    annotation (Line(points={{-39,60},{-22,60}}, color={0,0,127}));
  connect(gain.y, valCon.y)
    annotation (Line(points={{1,60},{6,60},{6,18},{-70,18},{-70,12}},
                                                      color={0,0,127}));
  connect(TCon.T, conPI_valCon.u_m) annotation (Line(points={{19,-30},{-50,-30},
          {-50,48}},          color={0,0,127}));
  connect(valCon.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(preDro.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(heaCon.Q_flow, QCooLoa_flow)
    annotation (Line(points={{22,80},{-110,80}}, color={0,0,127}));
  connect(conPI_valCon.u_s, TSet)
    annotation (Line(points={{-62,60},{-110,60}}, color={0,0,127}));
  connect(port_a, dpSen.port_a) annotation (Line(
      points={{-100,0},{-100,-50},{-10,-50}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(dpSen.port_b, port_b) annotation (Line(
      points={{10,-50},{100,-50},{100,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(dpSen.p_rel, dp)
    annotation (Line(points={{0,-59},{0,-80},{110,-80}}, color={0,0,127}));
  connect(valCon.y_actual, yVal_actual)
    annotation (Line(points={{-65,7},{-65,40},{110,40}}, color={0,0,127}));
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere)}));
end DummyConsumer;
