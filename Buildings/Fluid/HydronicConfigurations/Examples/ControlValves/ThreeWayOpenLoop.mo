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
  parameter Modelica.Units.SI.Pressure dp_nominal=100000
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumLiq,
    final p=p_min + dp_nominal,
    nPorts=12)
    "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=8)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
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
          58.1667},{-140,58.1667},{-140,-10}},
                                      color={0,127,255}));
  connect(sup.ports[2], valAut100.port_3) annotation (Line(points={{-160,58.5},{
          -160,-20},{-150,-20}},
                            color={0,127,255}));
  connect(sup.ports[3], ter25.port_a) annotation (Line(points={{-160,58.8333},{
          -100,58.8333},{-100,30}},
                              color={0,127,255}));
  connect(ter25.port_b, valAut75.port_1)
    annotation (Line(points={{-100,10},{-100,-10}},
                                                  color={0,127,255}));
  connect(ter50.port_b, valAut50.port_1)
    annotation (Line(points={{-60,10},{-60,-10}}, color={0,127,255}));
  connect(sup.ports[4], valAut75.port_3) annotation (Line(points={{-160,59.1667},
          {-120,59.1667},{-120,-20},{-110,-20}},
                                       color={0,127,255}));
  connect(ter67.port_b, valAut33.port_1)
    annotation (Line(points={{-20,10},{-20,-10}},
                                              color={0,127,255}));
  connect(sup.ports[5], ter50.port_a) annotation (Line(points={{-160,59.5},{-60,
          59.5},{-60,30}}, color={0,127,255}));
  connect(sup.ports[6], valAut50.port_3) annotation (Line(points={{-160,59.8333},
          {-80,59.8333},{-80,-20},{-70,-20}},
                                      color={0,127,255}));
  connect(sup.ports[7], ter67.port_a)
    annotation (Line(points={{-160,60.1667},{-20,60.1667},{-20,30}},
                                                           color={0,127,255}));
  connect(sup.ports[8], valAut33.port_3) annotation (Line(points={{-160,60.5},{-40,
          60.5},{-40,-20},{-30,-20}},
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
  connect(sup.ports[9], ter75.port_a) annotation (Line(points={{-160,60.8333},{
          20,60.8333},{20,30}},
                    color={0,127,255}));
  connect(sup.ports[10], valAut25.port_3) annotation (Line(points={{-160,
          61.1667},{0,61.1667},{0,-20},{10,-20}},
                                       color={0,127,255}));
  connect(ter75.port_b, valAut25.port_1)
    annotation (Line(points={{20,10},{20,-10}}, color={0,127,255}));
  connect(valAut100.port_2, ret.ports[1]) annotation (Line(points={{-140,-30},{-140,
          -81.75},{-160,-81.75}},     color={0,127,255}));
  connect(valAut75.port_2, ret.ports[2]) annotation (Line(points={{-100,-30},{-100,
          -81.25},{-160,-81.25}},     color={0,127,255}));
  connect(valAut50.port_2, ret.ports[3]) annotation (Line(points={{-60,-30},{-60,
          -80.75},{-160,-80.75}},     color={0,127,255}));
  connect(valAut33.port_2, ret.ports[4])
    annotation (Line(points={{-20,-30},{-20,-80.25},{-160,-80.25}},
                                                          color={0,127,255}));
  connect(valAut25.port_2, ret.ports[5]) annotation (Line(points={{20,-30},{20,-79.75},
          {-160,-79.75}},   color={0,127,255}));
  connect(valAut50Ove.port_2, ret.ports[6]) annotation (Line(points={{140,-30},{
          140,-80},{-160,-80},{-160,-79.25}},   color={0,127,255}));
  connect(bal50.port_b, ret.ports[7]) annotation (Line(points={{180,-70},{180,-80},
          {40,-80},{40,-78.75},{-160,-78.75}},
                                           color={0,127,255}));
  connect(ter10Bal.port_b,valAut50Ter10. port_1)
    annotation (Line(points={{60,10},{60,-10}},  color={0,127,255}));
  connect(valAut50Ter10.port_2, bal80.port_a)
    annotation (Line(points={{60,-30},{60,-40}},   color={0,127,255}));
  connect(bal80.port_b, ret.ports[8]) annotation (Line(points={{60,-60},{60,-80},
          {-160,-80},{-160,-78.25}},        color={0,127,255}));
  connect(ope.y,valAut50Ter10. y) annotation (Line(points={{-158,100},{80,100},{
          80,-20},{72,-20}},    color={0,0,127}));
  connect(sup.ports[11], ter10Bal.port_a) annotation (Line(points={{-160,61.5},{
          -64,61.5},{-64,62},{60,62},{60,30}},   color={0,127,255}));
  connect(sup.ports[12],valAut50Ter10. port_3) annotation (Line(points={{-160,
          61.8333},{40,61.8333},{40,-20},{50,-20}},     color={0,127,255}));
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
This model illustrates the concept of the authority for three-way control valves 
controlled with an open loop that modulates the valve from fully
closed (bypass flow) to fully open position.

Another phenomenon may also be observed with that example, that is 
the overflow when the valve is fully closed.
However, a more detailed analysis of that phenomenom is needed (and
provided with the model ) to take into account how the variation
of the flow resistance affects the operating point of a pump
operated at constant speed, and the pressure differential available
at other terminal units.

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
<li>
The components <code>valAut50Ove</code> and <code>valAut33Bal</code> illustrate
the concept of \"practical authority\". 
The circuits are exposed to a pressure differential <i>50%</i> higher than
design whereas the valve size is identical in both cases
(<i>Kvs = 5.1</i> m3/h/bar^(1/2)).
The circuit with <code>valAut33Bal</code> includes a balancing valve that 
enables reaching the design flow when the control valve is fully open.
The computed authority for <code>valAut50Ove</code> (<i>&beta; = 50%</i>) is higher
than for <code>valAut33Bal</code> (<i>&beta; = 33%</i>) due to the overflow in 
fully open conditions for the former component.
This is paradoxical because practically the controllability should be 
similar in a real system since the two valves are identical and the pressure 
differential at the circuit boundaries is the same.
To support that statement one can notice that the rate of change of the flow
rate with respect to the valve opening is similar between the two 
components at low valve opening (<i>y &le; 50% </i>).
Now computing the practical authority we get:
<i>
&beta;' = &beta; / (V&#775;<sub>actual</sub> / V&#775;<sub>design</sub>)<sup>2</sup> = 33%
</i>
for those two components.
This yields the following statements.
<ul>
<li>
The practical authority does not vary whether the circuit is balanced or not,
as opposed to the conventional authority.
</li>
<li>
The practical authority only depends on the valve size and the available pressure
differential at the circuit boundaries.
</li>
<li>
The conventional authority does not depend on the available pressure
differential at the circuit boundaries as it affects <i>&Delta;p<sub>min</sub></i>
and <i>/ &Delta;p<sub>max</sub></i> with the same factor (see for instance
components <code>valAut50</code> and <code>valAut50Ove</code>).
</li>
<li>
The disturbance of the flow characteristic of the valve (flow rate normalized by 
its maximum value, as a function of the valve opening, see plot #3) is explained 
by the conventional authority.
However, this has little value if the maximum flow rate is significantly different
from the design value.
Normalizing by the design flow rate gives more indication on the controllability
of the system. The disturbance of the flow characteristic (when the fractional flow rate 
is expressed as a fraction of the design flow rate, see plot #1) is then explained by the 
practical authority as 
<i>d(V&#775;(y) / V&#775;<sub>design</sub>) / dy = 
1 / &beta;' <sup>1/2</sup> * d(Kv(y) / Kvs) / dy</i>
when <i>y</i> tends towards zero and where <i>Kv(y) / Kvs = f(y)</i> is the 
inherent valve characteristic. 
</li>
</ul>
</li>
</ul>
</html>"));
end ThreeWayOpenLoop;
