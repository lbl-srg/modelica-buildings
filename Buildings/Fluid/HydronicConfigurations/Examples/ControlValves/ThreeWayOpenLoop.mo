within Buildings.Fluid.HydronicConfigurations.Examples.ControlValves;
model ThreeWayOpenLoop
  "Model illustrating the concept of the authority for three-way valves and open loop control"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Boolean is_bypBal=false
    "Set to true for a balancing valve in the bypass";

  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumLiq,
    final p=p_min + dp_nominal,
    nPorts=15)
    "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=10)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  FixedResistances.PressureDrop ter50(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5 * dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut50(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal= 0.5 * dp_nominal,
    final dpFixed_nominal={0, 0.5} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)                "Control valve with 50% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-20})));
  FixedResistances.PressureDrop ter75(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.75*dp_nominal)
    "Terminal unit as a fixed resistance destroying 75% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut25(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.25*dp_nominal,
    final dpFixed_nominal={0, 0.75} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)                "Control valve with 25% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-20})));
  FixedResistances.PressureDrop ter25(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.25*dp_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut75(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.75*dp_nominal,
    final dpFixed_nominal={0, 0.25} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)                "Control valve with 75% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-20})));
  Sources.Boundary_pT supOve(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 1.5*dp_nominal,
    nPorts=4)
    "Pressure boundary condition at supply augmented by 50% from design value"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut50Ove(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.5*dp_nominal,
    final dpFixed_nominal={0, 0.5} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)                "Control valve with 50% authority and overflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,-20})));
  FixedResistances.PressureDrop ter50Ove(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5*dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,20})));
  FixedResistances.PressureDrop ter50Bal(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5*dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut50Bal(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.5*dp_nominal,
    final dpFixed_nominal={0, 0.5} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1) "Control valve with 50% authority and balanced circuit"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-20})));
  FixedResistances.PressureDrop bal50(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.5*dp_nominal)
    "Balancing valve as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-60})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut100(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=1*dp_nominal,
    final dpFixed_nominal={0, 0},
    use_inputFilter=false,
    fraK=1)
    "Control valve with 100% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,-20})));
  FixedResistances.PressureDrop ter67(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.67*dp_nominal)
    "Terminal unit as a fixed resistance destroying 67% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut33(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.33*dp_nominal,
    final dpFixed_nominal={0, 0.67} * dp_nominal *
      (if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)
    "Control valve with 33% authority"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-20})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut50Ter10(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.1*dp_nominal,
    final dpFixed_nominal={0,0.1}*dp_nominal*(if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)
    "Control valve with 50% authority and terminal unit with low-pressure drop"
                                                                    annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-20})));
  FixedResistances.PressureDrop ter10Bal(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.1*dp_nominal)
    "Terminal unit as a fixed resistance destroying 10% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,20})));
  FixedResistances.PressureDrop bal80(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.8*dp_nominal)
    "Balancing valve as a fixed resistance destroying 80% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut50Mix(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=dp_nominal,
    final dpFixed_nominal={0,0},
    fraK=1)
    "Control valve with 50% authority and terminal unit with low-pressure drop"
                                                                    annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-120})));
  FixedResistances.PressureDrop terMix(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=3e4)
    "Terminal unit as a fixed resistance"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,-140})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    use_inputFilter=false,
    per(pressure(
      V_flow={0, 1, 2} * mLiq_flow_nominal / 996,
      dp = {1.14, 1, 0.42} * (terMix.dp_nominal+valAut50Mix.dpValve_nominal))),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Secondary pump"
    annotation (Placement(transformation(extent={{30,-130},{50,-110}})));

  FixedResistances.PressureDrop balMix(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=dp_nominal)
    "Balancing valve as a fixed resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-160})));

  FixedResistances.PressureDrop ter1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.25*dp_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-182,10})));
  Components.ThreeWayValve                       valAut1(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.75*dp_nominal,
    final dpFixed_nominal={0,0.25}*dp_nominal*(if is_bypBal then 1 else 0),
    use_inputFilter=false,
    fraK=1)                "Control valve with 75% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-182,-30})));
equation
  connect(ope.y, valAut50.y) annotation (Line(points={{-158,100},{-44,100},{-44,
          -20},{-48,-20}},
                     color={0,0,127}));
  connect(ope.y, valAut25.y) annotation (Line(points={{-158,100},{36,100},{36,-20},
          {32,-20}}, color={0,0,127}));
  connect(ope.y, valAut75.y) annotation (Line(points={{-158,100},{-84,100},{-84,
          -20},{-88,-20}}, color={0,0,127}));
  connect(ope.y, valAut50Ove.y) annotation (Line(points={{-158,100},{156,100},{156,
          -20},{152,-20}},    color={0,0,127}));
  connect(ope.y,valAut50Bal. y) annotation (Line(points={{-158,100},{200,100},{200,
          -20},{192,-20}},     color={0,0,127}));
  connect(ope.y, valAut100.y) annotation (Line(points={{-158,100},{-124,100},{-124,
          -20},{-128,-20}},color={0,0,127}));
  connect(sup.ports[1], valAut100.port_1) annotation (Line(points={{-160,
          58.1333},{-140,58.1333},{-140,-10}},
                                      color={0,127,255}));
  connect(sup.ports[2], valAut100.port_3) annotation (Line(points={{-160,58.4},
          {-160,-20},{-150,-20}},
                            color={0,127,255}));
  connect(sup.ports[3], ter25.port_a) annotation (Line(points={{-160,58.6667},{
          -100,58.6667},{-100,30}},
                              color={0,127,255}));
  connect(ter25.port_b, valAut75.port_1)
    annotation (Line(points={{-100,10},{-100,-10}},
                                                  color={0,127,255}));
  connect(ter50.port_b, valAut50.port_1)
    annotation (Line(points={{-60,10},{-60,-10}}, color={0,127,255}));
  connect(sup.ports[4], valAut75.port_3) annotation (Line(points={{-160,58.9333},
          {-120,58.9333},{-120,-20},{-110,-20}},
                                       color={0,127,255}));
  connect(ter67.port_b, valAut33.port_1)
    annotation (Line(points={{-20,10},{-20,-10}},
                                              color={0,127,255}));
  connect(sup.ports[5], ter50.port_a) annotation (Line(points={{-160,59.2},{-60,
          59.2},{-60,30}}, color={0,127,255}));
  connect(sup.ports[6], valAut50.port_3) annotation (Line(points={{-160,59.4667},
          {-80,59.4667},{-80,-20},{-70,-20}},
                                      color={0,127,255}));
  connect(sup.ports[7], ter67.port_a)
    annotation (Line(points={{-160,59.7333},{-20,59.7333},{-20,30}},
                                                           color={0,127,255}));
  connect(sup.ports[8], valAut33.port_3) annotation (Line(points={{-160,60},{
          -40,60},{-40,-20},{-30,-20}},
                                    color={0,127,255}));
  connect(valAut33.y, ope.y) annotation (Line(points={{-8,-20},{-4,-20},{-4,100},
          {-158,100}}, color={0,0,127}));
  connect(supOve.ports[1], ter50Ove.port_a) annotation (Line(points={{120,58.5},
          {140,58.5},{140,30}},color={0,127,255}));
  connect(supOve.ports[2], valAut50Ove.port_3)
    annotation (Line(points={{120,59.5},{120,-20},{130,-20}},
                                                           color={0,127,255}));
  connect(ter50Ove.port_b, valAut50Ove.port_1)
    annotation (Line(points={{140,10},{140,-10}}, color={0,127,255}));
  connect(supOve.ports[3], ter50Bal.port_a) annotation (Line(points={{120,60.5},
          {180,60.5},{180,30}},color={0,127,255}));
  connect(ter50Bal.port_b,valAut50Bal. port_1)
    annotation (Line(points={{180,10},{180,-10}}, color={0,127,255}));
  connect(valAut50Bal.port_2, bal50.port_a)
    annotation (Line(points={{180,-30},{180,-50}}, color={0,127,255}));
  connect(supOve.ports[4],valAut50Bal. port_3) annotation (Line(points={{120,61.5},
          {160,61.5},{160,-20},{170,-20}}, color={0,127,255}));
  connect(sup.ports[9], ter75.port_a) annotation (Line(points={{-160,60.2667},{
          20,60.2667},{20,30}},
                    color={0,127,255}));
  connect(sup.ports[10], valAut25.port_3) annotation (Line(points={{-160,
          60.5333},{0,60.5333},{0,-20},{10,-20}},
                                       color={0,127,255}));
  connect(ter75.port_b, valAut25.port_1)
    annotation (Line(points={{20,10},{20,-10}}, color={0,127,255}));
  connect(valAut100.port_2, ret.ports[1]) annotation (Line(points={{-140,-30},{
          -140,-81.8},{-160,-81.8}},  color={0,127,255}));
  connect(valAut75.port_2, ret.ports[2]) annotation (Line(points={{-100,-30},{
          -100,-81.4},{-160,-81.4}},  color={0,127,255}));
  connect(valAut50.port_2, ret.ports[3]) annotation (Line(points={{-60,-30},{
          -60,-81},{-160,-81}},       color={0,127,255}));
  connect(valAut33.port_2, ret.ports[4])
    annotation (Line(points={{-20,-30},{-20,-80.6},{-160,-80.6}},
                                                          color={0,127,255}));
  connect(valAut25.port_2, ret.ports[5]) annotation (Line(points={{20,-30},{20,
          -80.2},{-160,-80.2}},
                            color={0,127,255}));
  connect(valAut50Ove.port_2, ret.ports[6]) annotation (Line(points={{140,-30},
          {140,-80},{-160,-80},{-160,-79.8}},   color={0,127,255}));
  connect(bal50.port_b, ret.ports[7]) annotation (Line(points={{180,-70},{180,
          -80},{40,-80},{40,-79.4},{-160,-79.4}},
                                           color={0,127,255}));
  connect(ter10Bal.port_b,valAut50Ter10. port_1)
    annotation (Line(points={{60,10},{60,-10}},  color={0,127,255}));
  connect(valAut50Ter10.port_2, bal80.port_a)
    annotation (Line(points={{60,-30},{60,-40}},   color={0,127,255}));
  connect(bal80.port_b, ret.ports[8]) annotation (Line(points={{60,-60},{60,-80},
          {-160,-80},{-160,-79}},           color={0,127,255}));
  connect(ope.y,valAut50Ter10. y) annotation (Line(points={{-158,100},{80,100},{
          80,-20},{72,-20}},    color={0,0,127}));
  connect(sup.ports[11], ter10Bal.port_a) annotation (Line(points={{-160,60.8},
          {-64,60.8},{-64,62},{60,62},{60,30}},  color={0,127,255}));
  connect(sup.ports[12],valAut50Ter10. port_3) annotation (Line(points={{-160,
          61.0667},{40,61.0667},{40,-20},{50,-20}},     color={0,127,255}));
  connect(valAut50Mix.port_3, balMix.port_a) annotation (Line(points={{0,-130},{
          0,-160},{-20,-160}}, color={0,127,255}));
  connect(terMix.port_b, balMix.port_a) annotation (Line(points={{60,-150},{60,-160},
          {-20,-160}}, color={0,127,255}));
  connect(balMix.port_b, ret.ports[9]) annotation (Line(points={{-40,-160},{
          -160,-160},{-160,-78.6}},
                                  color={0,127,255}));
  connect(valAut50Mix.port_2, pum.port_a) annotation (Line(points={{10,-120},{30,
          -120},{30,-120}}, color={0,127,255}));
  connect(valAut50Mix.port_1, sup.ports[13]) annotation (Line(points={{-10,-120},
          {-156,-120},{-156,61.3333},{-160,61.3333}}, color={0,127,255}));
  connect(pum.port_b, terMix.port_a) annotation (Line(points={{50,-120},{60,-120},
          {60,-130}}, color={0,127,255}));
  connect(ope.y, valAut50Mix.y)
    annotation (Line(points={{-158,100},{0,100},{0,-108}}, color={0,0,127}));
  connect(sup.ports[14], ter1.port_a) annotation (Line(points={{-160,61.6},{
          -172,61.6},{-172,20},{-182,20}}, color={0,127,255}));
  connect(ter1.port_b, valAut1.port_1)
    annotation (Line(points={{-182,0},{-182,-20}}, color={0,127,255}));
  connect(sup.ports[15], valAut1.port_3) annotation (Line(points={{-160,61.8667},
          {-176,61.8667},{-176,-30},{-192,-30}}, color={0,127,255}));
  connect(valAut1.port_2, ret.ports[10]) annotation (Line(points={{-182,-40},{
          -172,-40},{-172,-78.2},{-160,-78.2}}, color={0,127,255}));
  connect(ope.y, valAut1.y) annotation (Line(points={{-158,100},{-164,100},{
          -164,-30},{-170,-30}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{220,120}})),
  experiment(
    StopTime=100,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/Examples/ControlValves/ThreeWayOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the concept of the authority for three-way valves
controlled with an open loop that modulates the valve from fully
closed (bypass flow) to fully open position.

Another phenomenon may also be observed with that example, that is
the overflow when the valve is fully closed.
However, a more detailed analysis of that phenomenom is needed (and
provided with the model
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop</a>)
to take into account how the variation
of the flow resistance affects the operating point of a pump
operated at constant speed, and the pressure differential available
at other terminal units.

In the case where it is not balanced and considering for instance
<i>&Delta;p<sub>A-B</sub>(y=100%) &asymp; &Delta;p<sub>L-M</sub>(y=0%)</i>
the valve authority computed with the latter equation is close to
one whatever the pressure differential at the circuit boundaries,
provided that the overflow in the bypass branch is not significant when the valve
is closed.

The valve authority
<i>
&beta; = &Delta;p<sub>min</sub> / &Delta;p<sub>max</sub>
</i>
can be computed by dividing the pressure drop across the
valve between those two extreme positions (see plot #2 for
the pressure drop values and the command log for the computed
value of the authority).
</p>
<ul>
<li>
The components <code>valAut&lt;25..100&gt;</code> show how the authority
affects the inherent flow characteristic of the valve which corresponds
to an authority <i>&beta; = 100%</i> (see plot #1).
The major disturbance appears for authorities strictly lower than
<i>&beta; = 50%</i> which is usually adopted as the sizing criteria
for control valves.
</li>

</html>"));
end ThreeWayOpenLoop;
