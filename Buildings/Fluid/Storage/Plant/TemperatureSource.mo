within Buildings.Fluid.Storage.Plant;
model TemperatureSource
  "An ideal source that sets fluid temperature to the prescribed value"

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

  Buildings.Fluid.Sensors.TemperatureTwoPort T_a(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    T_start=T_a_nominal,
    tauHeaTra=1) "Temperature sensor to port_a"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_b(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    T_start=T_b_nominal,
    tauHeaTra=1) "Temperature sensor to port_b"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=p_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=p_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Buildings.Fluid.Sensors.MassFlowRate mVol_flow(
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
        origin={-60,110})));
  Buildings.Fluid.Sources.PropertySource_T proSouT(
    redeclare package Medium = Medium,
    final use_T_in=true,
    final allowFlowReversal=allowFlowReversal)
    "Property source that prescribes the temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression setT(
    y(final unit="K", final displayUnit="degC")=
      if m_flow<0 and allowFlowReversal then
        12+273.15
      else
        7+273.15) "Set temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(T_b.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(T_a.port_a, mVol_flow.port_b)
    annotation (Line(points={{-40,0},{-60,0}}, color={0,127,255}));
  connect(mVol_flow.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(mVol_flow.m_flow, m_flow)
    annotation (Line(points={{-70,11},{-70,110}}, color={0,0,127}));
  connect(T_a.port_b, proSouT.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(proSouT.port_b, T_b.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(setT.y, proSouT.T_in)
    annotation (Line(points={{-19,40},{-4,40},{-4,12}}, color={0,0,127}));
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
end TemperatureSource;
