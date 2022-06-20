within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Decoupling "Decoupling circuit"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpBal3_nominal=1e4,
    m1_flow_nominal(min=(1+1e-2)*m2_flow_nominal)=1.05 * m2_flow_nominal,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=5,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay,
    final have_set=false,
    final have_typVar=false);

  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  FixedResistances.Junction junBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));

  Components.TwoWayValve val(
    redeclare final package Medium = Medium,
    final typCha=typCha,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then dpBal1_nominal else 0,
    final flowCharacteristics=flowCharacteristics)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,-40})));

  FixedResistances.PressureDrop res1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-70})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Secondary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPum,
    final typMod=typPumMod,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=dp2_nominal + dpBal2_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit supply temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  Controls.PIDWithOperatingMode ctl(
    r=dpBal3_nominal,
    final reverseActing=true,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    if typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Controller"
    annotation (Placement(transformation(extent={{-10,-50},{10,-70}})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
    else 1)
    "Consumer circuit return temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal-m2_flow_nominal,
    final dp_nominal=dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0)));
  Sensors.RelativePressure dp3(
    redeclare final package Medium = Medium)
    "Pressure drop across bypass balancing valve"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp3Set(
    y(final unit="Pa"),
    final k=dpBal3_nominal)
    "Pressure differential set point"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger enaCtl
    "Enable signal for control loop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-20})));
equation
  connect(port_a1, junBypSup.port_1)
    annotation (Line(points={{-60,-100},{-60,-10}}, color={0,127,255}));
  connect(val.port_b, res1.port_a)
    annotation (Line(points={{60,-50},{60,-60}}, color={0,127,255}));
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-80},{60,-100}}, color={0,127,255}));
  connect(mode, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(junBypSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(ctl.y, val.y)
    annotation (Line(points={{12,-60},{40,-60},{40,-40},{48,-40}},
                                                 color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-80},{40,-80},
          {40,-40},{48,-40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{53,-46},{53,-54},
          {80,-54},{80,-40},{120,-40}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-67,52},{80,52},
          {80,40},{120,40}},color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-69,52},{-69,54},{80,54},{80,
          60},{120,60}},
                     color={0,0,127}));
  connect(junBypRet.port_2, val.port_a)
    annotation (Line(points={{60,-10},{60,-30},{60,-30}}, color={0,127,255}));
  connect(res2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b, res2.port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(junBypSup.port_3, res3.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(res3.port_b, junBypRet.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(dp3.port_a, res3.port_a) annotation (Line(points={{-10,-20},{-20,-20},
          {-20,0},{-10,0}}, color={0,127,255}));
  connect(dp3.port_b, res3.port_b) annotation (Line(points={{10,-20},{20,-20},{20,
          0},{10,0}}, color={0,127,255}));
  connect(dp3.p_rel, ctl.u_m)
    annotation (Line(points={{0,-29},{0,-48}}, color={0,0,127}));
  connect(dp3Set.y, ctl.u_s) annotation (Line(points={{-28,-60},{-12,-60}},
                      color={0,0,127}));
  connect(enaCtl.y, ctl.mod) annotation (Line(points={{-40,-32},{-40,-40},{-6,-40},
          {-6,-48}}, color={255,127,0}));
  connect(isEna.y, enaCtl.u) annotation (Line(points={{12,80},{20,80},{20,20},{
          -40,20},{-40,-8}},  color={255,0,255}));
  connect(isEna.y, pum.y1) annotation (Line(points={{12,80},{20,80},{20,20},{
          -67,20},{-67,34.8}}, color={255,0,255}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Icon(
    graphics={
      Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Decoupling.svg")}),                                                                                                       Diagram(
    coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The P-controller mimics a self-acting &Delta;P control valve
with a proportional band of <i>&plusmn;20%</i> around the
pressure differential set point.
This set point corresponds to the design pressure drop of the
bypass balancing valve, typically around <i>10</i>&nbsp;Pa.
Note that this configuration yields a nearly constant
bypass flow rate, as opposed to a constant percentage
of the consumer circuit flow rate that a temperature-based
control could provide.
</p>
</html>"));
end Decoupling;
