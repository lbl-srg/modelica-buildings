within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
model IdealUser "Ideal user model"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Temperature T_a_nominal
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_b_nominal
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference";

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpValve_nominal=0.1*dp_nominal,
    m_flow_nominal=m_flow_nominal,
    y_start=0) "User control valve"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaCon
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{22,70},{42,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium,
    final prescribedHeatFlowRate=true,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=0.5,
    p_start=500000,
    T_start=T_b_nominal) "Volume representing the consumer"
    annotation (
      Placement(transformation(
        origin={70,0},
        extent={{10,10},{-10,-10}},
        rotation=90)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TUse
    "Temperature of the user"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-60})));
  Buildings.Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    Ti=1000,
    reverseActing=false) "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,30})));
  Modelica.Blocks.Interfaces.RealInput QCooLoa_flow
    "Cooling load of the consumer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealOutput yVal_actual
    "Consumer control valve actuator position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(
    redeclare final package Medium = Medium)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-70,-10})));
  Modelica.Blocks.Interfaces.RealOutput dpUse
    "Differential pressure from the sensor"
                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,40})));
  Modelica.Blocks.Sources.Constant set_TRet(final k=T_b_nominal)
    "CHW return temperature setpoint"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
equation
  connect(val.port_b, vol.ports[1])
    annotation (Line(points={{20,60},{60,60},{60,1}},
                                             color={0,127,255}));
  connect(heaCon.port, vol.heatPort)
    annotation (Line(points={{42,80},{70,80},{70,10}}, color={191,0,0}));
  connect(vol.heatPort,TUse. port)
    annotation (Line(points={{70,10},{40,10}},         color={191,0,0}));
  connect(preDro.port_a, vol.ports[2]) annotation (Line(points={{20,-60},{60,-60},
          {60,-1}},         color={0,127,255}));
  connect(TUse.T, conPI.u_m)
    annotation (Line(points={{19,10},{-30,10},{-30,18}},   color={0,0,127}));
  connect(heaCon.Q_flow, QCooLoa_flow)
    annotation (Line(points={{22,80},{-110,80}}, color={0,0,127}));
  connect(dpSen.p_rel,dpUse)
    annotation (Line(points={{-61,-10},{-48,-10},{-48,-80},{110,-80}},
                                                         color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{15,67},{94,67},{94,70},{110,70}},
                                                         color={0,0,127}));
  connect(val.port_a, port_a)
    annotation (Line(points={{0,60},{-100,60}}, color={0,127,255}));
  connect(dpSen.port_a, port_a) annotation (Line(
      points={{-70,-1.77636e-15},{-70,0},{-100,0},{-100,60}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(preDro.port_b, port_b)
    annotation (Line(points={{-1.77636e-15,-60},{-100,-60}},
                                              color={0,127,255}));
  connect(dpSen.port_b, port_b) annotation (Line(
      points={{-70,-20},{-100,-20},{-100,-60}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(conPI.y, val.y)
    annotation (Line(points={{-19,30},{-14,30},{-14,78},{10,78},{10,72}},
                                                          color={0,0,127}));
  connect(set_TRet.y, conPI.u_s)
    annotation (Line(points={{-59,30},{-42,30}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ideUse",
                                 Documentation(info="<html>
<p>
This is a simple ideal user model used by example models under
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples\">
Buildings.Fluid.Storage.Plant.Examples</a>.
The control valve simply tries to maintain the CHW return temperature
at its nominal value.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,40},{40,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,34},{-4,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{6,34},{34,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,-4},{-4,-34}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{6,-4},{34,-34}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-151,-100},{149,-140}},
          textColor={0,0,255},
          textString="%name")}));
end IdealUser;
