within Buildings.Fluid.Storage.Plant;
model DummyChillSource
  "An ideal chill (or heat) source that always turns the fluid passing through to the prescribed state"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.AbsolutePressure p_nominal=800000
    "Nominal pressure";
  parameter Modelica.Units.SI.Temperature T_a_nominal=12+273.15
    "Nominal temperature at port_a";
  parameter Modelica.Units.SI.Temperature T_b_nominal=7+273.15
    "Nominal temperature at port_b";
  parameter Boolean allowFlowReversal=false
    "Flow reversal setting";

  MixingVolumes.MixingVolume vol(
    nPorts=2,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    V=1E-3,
    p_start=p_nominal,
    T_start=T_b_nominal) "Volume"
    annotation (
      Placement(transformation(
        origin={0,20},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  Sensors.TemperatureTwoPort T_a(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    T_start=T_a_nominal,
    tauHeaTra=1) "Temperature sensor to port_a"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sensors.TemperatureTwoPort T_b(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    T_start=T_b_nominal,
    tauHeaTra=1) "Temperature sensor to port_b"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaChi
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{2,38},{22,58}})));
  Modelica.Blocks.Sources.RealExpression QVol(y=if allowFlowReversal and
        mVol_flow.m_flow < 0 then mVol_flow.m_flow*(T_b.port_a.h_outflow -
        Medium.specificEnthalpy(state=Medium.setState_pTX(
        p=p_nominal,
        T=T_a_nominal,
        X={1.}))) else mVol_flow.m_flow*(Medium.specificEnthalpy(state=
        Medium.setState_pTX(
        p=p_nominal,
        T=T_b_nominal,
        X={1.})) - T_a.port_b.h_outflow))
    "Heat flow that sets the flow to the desired state"
    annotation (Placement(transformation(extent={{-30,38},{-10,58}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=p_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-112,-10},{-92,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=p_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Sensors.MassFlowRate mVol_flow(
    redeclare package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow "Mass flow rate" annotation (
     Dialog(group="Time varying output signal"), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,110})));
equation
  connect(T_a.port_b, vol.ports[1])
    annotation (Line(points={{-20,0},{1,0},{1,10}}, color={0,127,255}));
  connect(T_b.port_a, vol.ports[2])
    annotation (Line(points={{20,0},{-1,0},{-1,10}}, color={0,127,255}));
  connect(heaChi.port,vol. heatPort)
    annotation (Line(points={{22,48},{28,48},{28,20},{10,20}},
                                                       color={191,0,0}));
  connect(QVol.y,heaChi. Q_flow)
    annotation (Line(points={{-9,48},{2,48}}, color={0,0,127}));
  connect(T_b.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(T_a.port_a, mVol_flow.port_b)
    annotation (Line(points={{-40,0},{-60,0}}, color={0,127,255}));
  connect(mVol_flow.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(m_flow, m_flow)
    annotation (Line(points={{-70,110},{-70,110}}, color={0,0,127}));
  connect(mVol_flow.m_flow, m_flow)
    annotation (Line(points={{-70,11},{-70,110}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Sphere,
          fillColor={28,108,200}), Text(
          extent={{-80,80},{80,-80}},
          textColor={255,255,255},
          textString="T",
          textStyle={TextStyle.Bold}),
        Polygon(
          points={{20,-104},{60,-119},{20,-134},{20,-104}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-119},{-60,-119}},
          color={0,128,255},
          visible=not allowFlowReversal),
        Text(
          extent={{-74,-130},{80,-172}},
          textColor={0,0,255},
          textString="%name")}),                                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DummyChillSource;
