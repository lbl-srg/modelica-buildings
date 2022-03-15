within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
model DummyUser "Dummy user model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=1);

  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_a_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_b_nominal=12+273.15
    "Nominal temperature of CHW return";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_a_nominal-p_b_nominal
    "Nominal pressure difference";

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-5,
    dpValve_nominal=0.1*dp_nominal,
    m_flow_nominal=m_flow_nominal,
    y_start=0) "User control valve"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaCon
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{22,70},{42,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=0.5,
    p_start=p_a_nominal,
    T_start=T_b_nominal) "Volume representing the consumer"
    annotation (
      Placement(transformation(
        origin={0,-10},
        extent={{10,10},{-10,-10}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TUsr
    "Temperature of the user"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    Ti=1000,
    reverseActing=false) "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,40})));
  Modelica.Blocks.Interfaces.RealInput QCooLoa_flow
    "Cooling load of the consumer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput TSet "CHW return setpoint" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealOutput yVal_actual
    "Consumer control valve actuator position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium = Medium)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Interfaces.RealOutput dpUsr
    "Differential pressure of the user" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,110})));
equation
  connect(val.port_b, vol.ports[1])
    annotation (Line(points={{-30,0},{0,0}}, color={0,127,255}));
  connect(heaCon.port, vol.heatPort)
    annotation (Line(points={{42,80},{54,80},{54,-10},{10,-10}},
                                                       color={191,0,0}));
  connect(vol.heatPort,TUsr. port)
    annotation (Line(points={{10,-10},{54,-10},{54,-30},{40,-30}},
                                                       color={191,0,0}));
  connect(preDro.port_a, vol.ports[2]) annotation (Line(points={{60,0},{-1,0}},
                            color={0,127,255}));
  connect(TUsr.T, conPI.u_m)
    annotation (Line(points={{19,-30},{-70,-30},{-70,28}}, color={0,0,127}));
  connect(heaCon.Q_flow, QCooLoa_flow)
    annotation (Line(points={{22,80},{-110,80}}, color={0,0,127}));
  connect(conPI.u_s, TSet)
    annotation (Line(points={{-82,40},{-110,40}}, color={0,0,127}));
  connect(dpSen.p_rel, dpUsr)
    annotation (Line(points={{0,-59},{0,-80},{110,-80}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{-35,7},{-35,40},{110,40}}, color={0,0,127}));
  connect(val.port_a, port_a)
    annotation (Line(points={{-50,0},{-100,0}}, color={0,127,255}));
  connect(dpSen.port_a, port_a) annotation (Line(
      points={{-10,-50},{-100,-50},{-100,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(preDro.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(dpSen.port_b, port_b) annotation (Line(
      points={{10,-50},{100,-50},{100,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(conPI.y, val.y)
    annotation (Line(points={{-59,40},{-40,40},{-40,12}}, color={0,0,127}));
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere)}),
                                 Documentation(info="<html>
<p>
(Draft)
For simplicity, instead of setting up a heat exchanger to a room model,
the consumer control valve simply tracks the return CHW temperature.  
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end DummyUser;
