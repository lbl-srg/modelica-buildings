within Buildings.Fluid.HydronicConfigurations.BaseClasses;
model SingleMixing "Single mixing circuit"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    final m1_flow_nominal=m2_flow_nominal,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final have_pum=true);

  Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then {dpBal1_nominal, dpBal3_nominal} else {0,0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      choicesAllMatching = true,
      Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-40})));
  FixedResistances.Junction jun(
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
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
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
  Buildings.Fluid.HydronicConfigurations.Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPumMod,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=dp2_nominal + dpBal2_nominal +
      max({val.dpValve_nominal, val.dp3Valve_nominal}) + dpBal3_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      choicesAllMatching = true,
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit supply temperature sensor"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  Controls.PIDWithOperatingMode ctl(
    final reverseActing=typFun==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti) if have_ctl
    "Controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch on/off"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{50,22},{30,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant One(final k=1)
    if typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant
    "one"
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit return temperature sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,58})));
  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{10,-50},{-10,-30}},
        rotation=0)));
equation
  connect(port_b1,res1. port_b)
    annotation (Line(points={{60,-100},{60,-80}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(ctl.y, val.y) annotation (Line(points={{12,0},{20,0},{20,-60},{-80,-60},
          {-80,-40},{-72,-40}},
                 color={0,0,127}));
  connect(mod, ctl.mod) annotation (Line(points={{-120,80},{-90,80},{-90,-16},{-6,
          -16},{-6,-12}},
        color={255,127,0}));
  connect(T2Sup.T, ctl.u_m) annotation (Line(points={{-49,60},{-20,60},{-20,-20},
          {0,-20},{0,-12}}, color={0,0,127}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-90,-40},{-90,-20},
          {-30,-20},{-30,0},{-12,0}},
                      color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-40},{-72,
          -40}},              color={0,0,127}));
  connect(mod, isEna.u)
    annotation (Line(points={{-120,80},{-42,80}}, color={255,127,0}));
  connect(isEna.y, swi.u2) annotation (Line(points={{-18,80},{16,80},{16,40},{
          12,40}},
                color={255,0,255}));
  connect(yPum, swi.u1) annotation (Line(points={{-120,40},{-84,40},{-84,56},{20,
          56},{20,48},{12,48}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{28,32},{12,32}}, color={0,0,127}));
  connect(swi.y, pum.y)
    annotation (Line(points={{-12,40},{-48,40}}, color={0,0,127}));
  connect(One.y, swi.u1) annotation (Line(points={{28,80},{20,80},{20,48},{12,
          48}},
        color={0,0,127}));
  connect(jun.port_2,res1. port_a)
    annotation (Line(points={{60,-50},{60,-60}}, color={0,127,255}));
  connect(res2.port_b, jun.port_1)
    annotation (Line(points={{60,20},{60,-30}},          color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-60,-30},{-60,30}}, color={0,127,255}));
  connect(val.port_1, port_a1)
    annotation (Line(points={{-60,-50},{-60,-100}}, color={0,127,255}));
  connect(pum.P, PPum) annotation (Line(points={{-51,52},{-51,54},{80,54},{80,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-53,52},{80,52},
          {80,40},{120,40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{-67,-34},{-67,
          -32},{-78,-32},{-78,-58},{80,-58},{80,-60},{120,-60}}, color={0,0,127}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,68}}, color={0,127,255}));
  connect(T2Ret.port_b,res2. port_a)
    annotation (Line(points={{60,48},{60,40}}, color={0,127,255}));
  connect(jun.port_3, res3.port_a)
    annotation (Line(points={{50,-40},{10,-40}}, color={0,127,255}));
  connect(res3.port_b, val.port_3)
    annotation (Line(points={{-10,-40},{-50,-40}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary
</p>
    
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.
The control valve should be sized with a pressure drop at least equal to the
maximum of <i>&Delta;p<sub>a1-b1</sub></i> and <i>3e3</i>&nbsp;Pa.
Its authority is 
<i>&beta; = &Delta;p<sub>A-AB</sub> / 
(&Delta;p<sub>A-AB</sub> + &Delta;p<sub>a1-b1</sub>)</i>.
</p>
<p>
In most cases the bypass balancing valve is not needed.
However, it may be needed to counter negative back pressure
created by other served circuits.
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with 
<code>m2_flow_nominal</code> and 
<code>dp2_nominal + dpBal2_nominal + max({val.dpValve_nominal, val.dp3Valve_nominal}) + dpBal3_nominal</code>   
at maximum speed.
</p>
</html>"));
end SingleMixing;
