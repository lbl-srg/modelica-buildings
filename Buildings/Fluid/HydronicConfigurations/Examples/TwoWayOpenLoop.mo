within Buildings.Fluid.HydronicConfigurations.Examples;
model TwoWayOpenLoop
  "Model illustrating the concept of the authority for two-way valves and open loop control"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumLiq,
    final p=p_min + dp_nominal,
    nPorts=5) "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=7)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  FixedResistances.PressureDrop ter50(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5 * dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut50(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal= 0.5 * dp_nominal,
    use_inputFilter=false) "Control valve with 50% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-20})));
  FixedResistances.PressureDrop ter75(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.75*dp_nominal)
    "Terminal unit as a fixed resistance destroying 75% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut25(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.25*dp_nominal,
    use_inputFilter=false) "Control valve with 25% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-20})));
  FixedResistances.PressureDrop ter25(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.25*dp_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut75(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.75*dp_nominal,
    use_inputFilter=false) "Control valve with 75% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-20})));
  Sources.Boundary_pT supOve(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 1.5*dp_nominal,
    nPorts=2)
    "Pressure boundary condition at supply augmented by 50% from design value"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Actuators.Valves.TwoWayEqualPercentage valAut50Ove(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.5*dp_nominal,
    use_inputFilter=false) "Control valve with 50% authority and overflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,-20})));
  FixedResistances.PressureDrop ter50Ove(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5*dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,20})));
  FixedResistances.PressureDrop ter50Bal(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.5*dp_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut33Bal(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.5*dp_nominal,
    use_inputFilter=false)
    "Control valve with 33% authority and balanced circuit" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-20})));
  FixedResistances.PressureDrop bal50(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.5*dp_nominal)
    "Balancing valve as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-60})));
  Actuators.Valves.TwoWayEqualPercentage valAut100(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=1*dp_nominal,
    use_inputFilter=false) "Control valve with 100% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,-20})));
  FixedResistances.PressureDrop ter67(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dp_nominal=0.67*dp_nominal)
    "Terminal unit as a fixed resistance destroying 67% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut33(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.33*dp_nominal,
    use_inputFilter=false) "Control valve with 33% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-20})));
equation
  connect(sup.ports[2], ter50.port_a)
    annotation (Line(points={{-140,59.2},{-40,59.2},{-40,30}},
                                                        color={0,127,255}));
  connect(ter50.port_b, valAut50.port_a)
    annotation (Line(points={{-40,10},{-40,-10}},
                                                color={0,127,255}));
  connect(ope.y, valAut50.y) annotation (Line(points={{-138,100},{-20,100},{-20,
          -20},{-28,-20}},
                     color={0,0,127}));
  connect(ter75.port_b, valAut25.port_a)
    annotation (Line(points={{40,10},{40,-10}}, color={0,127,255}));
  connect(ope.y, valAut25.y) annotation (Line(points={{-138,100},{60,100},{60,
          -20},{52,-20}},
                     color={0,0,127}));
  connect(sup.ports[3], ter75.port_a) annotation (Line(points={{-140,60},{40,60},
          {40,30}}, color={0,127,255}));
  connect(ter25.port_a, sup.ports[4]) annotation (Line(points={{-80,30},{-80,
          60.8},{-140,60.8}},
                           color={0,127,255}));
  connect(ter25.port_b, valAut75.port_a)
    annotation (Line(points={{-80,10},{-80,-10}}, color={0,127,255}));
  connect(valAut75.port_b, ret.ports[2]) annotation (Line(points={{-80,-30},{
          -80,-78},{-140,-78},{-140,-81.1429}},
                                            color={0,127,255}));
  connect(valAut50.port_b, ret.ports[3]) annotation (Line(points={{-40,-30},{
          -40,-80.5714},{-140,-80.5714}},
                                      color={0,127,255}));
  connect(valAut25.port_b, ret.ports[4])
    annotation (Line(points={{40,-30},{40,-80},{-140,-80}},
                                                          color={0,127,255}));
  connect(ope.y, valAut75.y) annotation (Line(points={{-138,100},{-60,100},{-60,
          -20},{-68,-20}}, color={0,0,127}));
  connect(supOve.ports[1], ter50Ove.port_a)
    annotation (Line(points={{110,59},{120,59},{120,30}},
                                                       color={0,127,255}));
  connect(valAut50Ove.port_b, ret.ports[5]) annotation (Line(points={{120,-30},
          {120,-80},{-140,-80},{-140,-79.4286}},
                                          color={0,127,255}));
  connect(ter50Ove.port_b, valAut50Ove.port_a)
    annotation (Line(points={{120,10},{120,-10}},
                                                color={0,127,255}));
  connect(ope.y, valAut50Ove.y) annotation (Line(points={{-138,100},{140,100},{
          140,-20},{132,-20}},color={0,0,127}));
  connect(ter50Bal.port_b, valAut33Bal.port_a)
    annotation (Line(points={{160,10},{160,-10}}, color={0,127,255}));
  connect(supOve.ports[2], ter50Bal.port_a) annotation (Line(points={{110,61},{
          136,61},{136,60},{160,60},{160,30}},
                                             color={0,127,255}));
  connect(valAut33Bal.port_b, bal50.port_a)
    annotation (Line(points={{160,-30},{160,-50}}, color={0,127,255}));
  connect(bal50.port_b, ret.ports[6]) annotation (Line(points={{160,-70},{160,
          -80},{40,-80},{40,-78.8571},{-140,-78.8571}},
                                                      color={0,127,255}));
  connect(ope.y, valAut33Bal.y) annotation (Line(points={{-138,100},{180,100},{
          180,-20},{172,-20}}, color={0,0,127}));
  connect(sup.ports[1], valAut100.port_a) annotation (Line(points={{-140,58.4},
          {-130,58.4},{-130,62},{-120,62},{-120,-10}}, color={0,127,255}));
  connect(valAut100.port_b, ret.ports[1]) annotation (Line(points={{-120,-30},{
          -120,-81.7143},{-140,-81.7143}}, color={0,127,255}));
  connect(ope.y, valAut100.y) annotation (Line(points={{-138,100},{-100,100},{
          -100,-20},{-108,-20}},
                           color={0,0,127}));
  connect(valAut33.port_a, ter67.port_b)
    annotation (Line(points={{0,-10},{0,10}}, color={0,127,255}));
  connect(valAut33.port_b, ret.ports[7]) annotation (Line(points={{0,-30},{0,
          -78.2857},{-140,-78.2857}}, color={0,127,255}));
  connect(ter67.port_a, sup.ports[5])
    annotation (Line(points={{0,30},{0,61.6},{-140,61.6}}, color={0,127,255}));
  connect(valAut33.y, ope.y) annotation (Line(points={{12,-20},{20,-20},{20,100},
          {-138,100}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})),
  experiment(
    StopTime=100,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/Examples/TwoWayOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the concept of the authority for two-way valves
controlled with an open loop that modulates the valve from fully
closed to fully open position.
The valve authority
<i>
&beta; = &Delta;p(y=100%) / &Delta;p(y=0%)
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
when <i>y</i> tends towards zero and where the function <i>Kv(y) / Kvs</i> 
is the inherent valve characteristic.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayOpenLoop;
