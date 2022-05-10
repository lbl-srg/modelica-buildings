within Buildings.Fluid.HydronicConfigurations.Examples.ControlValveAuthority;
model TwoWayOpenLoop
  "Model illustrating the concept of the authority for two-way valves"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure pMin_nominal = 2E5
    "Circuit minimum pressure at design conditions";
  parameter Modelica.Units.SI.Pressure dpTot_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = Medium,
    final p=pMin_nominal + dpTot_nominal,
    nPorts=4) "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = Medium,
    final p=pMin_nominal,
    nPorts=6)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Actuators.Valves.TwoWayEqualPercentage valAut100(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpTot_nominal,
    use_inputFilter=false) "Control valve with 100% authority"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-20})));
  Controls.OBC.CDL.Continuous.Sources.Ramp      ope(duration=100)
                   "Valve opening signal"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  FixedResistances.PressureDrop ter50(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.5 * dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut50(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal= 0.5 * dpTot_nominal,
    use_inputFilter=false) "Control valve with 50% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-20})));
  FixedResistances.PressureDrop ter75(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.75*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 75% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut25(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.25*dpTot_nominal,
    use_inputFilter=false) "Control valve with 25% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-20})));
  FixedResistances.PressureDrop ter25(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut75(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.75*dpTot_nominal,
    use_inputFilter=false) "Control valve with 75% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-20})));
  Sources.Boundary_pT supOve(
    redeclare final package Medium = Medium,
    final p=pMin_nominal + 1.5*dpTot_nominal,
    nPorts=2)
    "Pressure boundary condition at supply augmented by 50% from design value"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Actuators.Valves.TwoWayEqualPercentage valAut50Ove(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.5*dpTot_nominal,
    use_inputFilter=false) "Control valve with 50% authority and overflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-20})));
  FixedResistances.PressureDrop ter50Ove(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.5*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,20})));
  FixedResistances.PressureDrop ter50Bal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.5*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut33Bal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.5*dpTot_nominal,
    use_inputFilter=false)
    "Control valve with 33% authority and balanced circuit" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,-20})));
  FixedResistances.PressureDrop bal50(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.5*dpTot_nominal)
    "Balancing valve as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,-60})));
equation
  connect(sup.ports[1], valAut100.port_a) annotation (Line(points={{-120,58.5},
          {-100,58.5},{-100,-10}},color={0,127,255}));
  connect(ope.y, valAut100.y)
    annotation (Line(points={{-118,100},{-80,100},{-80,-20},{-88,-20}},
                                                          color={0,0,127}));
  connect(valAut100.port_b, ret.ports[1]) annotation (Line(points={{-100,-30},{
          -100,-81.6667},{-120,-81.6667}},
                              color={0,127,255}));
  connect(sup.ports[2], ter50.port_a)
    annotation (Line(points={{-120,59.5},{-20,59.5},{-20,30}},
                                                        color={0,127,255}));
  connect(ter50.port_b, valAut50.port_a)
    annotation (Line(points={{-20,10},{-20,-10}},
                                                color={0,127,255}));
  connect(ope.y, valAut50.y) annotation (Line(points={{-118,100},{0,100},{0,-20},
          {-8,-20}}, color={0,0,127}));
  connect(ter75.port_b, valAut25.port_a)
    annotation (Line(points={{20,10},{20,-10}}, color={0,127,255}));
  connect(ope.y, valAut25.y) annotation (Line(points={{-118,100},{40,100},{40,
          -20},{32,-20}},
                     color={0,0,127}));
  connect(sup.ports[3], ter75.port_a) annotation (Line(points={{-120,60.5},{20,
          60.5},{20,30}},
                    color={0,127,255}));
  connect(ter25.port_a, sup.ports[4]) annotation (Line(points={{-60,30},{-60,
          61.5},{-120,61.5}},
                           color={0,127,255}));
  connect(ter25.port_b, valAut75.port_a)
    annotation (Line(points={{-60,10},{-60,-10}}, color={0,127,255}));
  connect(valAut75.port_b, ret.ports[2]) annotation (Line(points={{-60,-30},{
          -60,-78},{-120,-78},{-120,-81}},  color={0,127,255}));
  connect(valAut50.port_b, ret.ports[3]) annotation (Line(points={{-20,-30},{
          -20,-80.3333},{-120,-80.3333}},
                                      color={0,127,255}));
  connect(valAut25.port_b, ret.ports[4])
    annotation (Line(points={{20,-30},{20,-79.6667},{-120,-79.6667}},
                                                          color={0,127,255}));
  connect(ope.y, valAut75.y) annotation (Line(points={{-118,100},{-40,100},{-40,
          -20},{-48,-20}}, color={0,0,127}));
  connect(supOve.ports[1], ter50Ove.port_a)
    annotation (Line(points={{70,59},{80,59},{80,30}}, color={0,127,255}));
  connect(valAut50Ove.port_b, ret.ports[5]) annotation (Line(points={{80,-30},{
          80,-80},{-120,-80},{-120,-79}}, color={0,127,255}));
  connect(ter50Ove.port_b, valAut50Ove.port_a)
    annotation (Line(points={{80,10},{80,-10}}, color={0,127,255}));
  connect(ope.y, valAut50Ove.y) annotation (Line(points={{-118,100},{100,100},{
          100,-20},{92,-20}}, color={0,0,127}));
  connect(ter50Bal.port_b, valAut33Bal.port_a)
    annotation (Line(points={{120,10},{120,-10}}, color={0,127,255}));
  connect(supOve.ports[2], ter50Bal.port_a) annotation (Line(points={{70,61},{
          96,61},{96,60},{120,60},{120,30}}, color={0,127,255}));
  connect(valAut33Bal.port_b, bal50.port_a)
    annotation (Line(points={{120,-30},{120,-50}}, color={0,127,255}));
  connect(bal50.port_b, ret.ports[6]) annotation (Line(points={{120,-70},{120,
          -80},{0,-80},{0,-78.3333},{-120,-78.3333}}, color={0,127,255}));
  connect(ope.y, valAut33Bal.y) annotation (Line(points={{-118,100},{140,100},{
          140,-20},{132,-20}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})),
  experiment(
    StopTime=100,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/Examples/ControlValveAuthority/TwoWayOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the concept of the authority for two-way control valves 
controlled with an open loop that modulates the valve from fully
closed to fully open position.
The valve authority
<i>
&beta; = &Delta;p<sub>min</sub> / &Delta;p<sub>max</sub>
</i>
can be computed by dividing the pressure drop across the
valve between those two extreme positions. 
</p>
<ul>
<li>
The components <code>valAut&lt;25..100&gt;</code> show how the authority
affects the inherent flow characteristic of the valve which corresponds 
to an authority <i>&beta; = 100%</i>.
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
The computed authority <i>&beta;</i> is higher for 
<code>valAut50Ove</code> (<i>&beta; = 50%</i>) due to the overflow in 
fully open conditions.
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
differential at the circuit boundaries.
</li>
<li>
The disturbance of the flow characteristic of the valve (normalized flow rate
as a function of the valve opening) is explained by the conventional authority.
However, this has little value if the maximum flow rate is significantly different
from the design value.
Normalizing by the design flow rate gives more indication on the controllability
of the system. The disturbance of the flow characteristic is then explained
by the practical authority as 
<i>d(V&#775;(y) / V&#775;<sub>design</sub>) / dy = 
1 / &beta;'<sup>1/2</sup> * d(Kv(y) / Kvs) / dy</i>
when <i>y</i> tends towards zero. 
</li>
</ul>
</li>
</ul>
</html>"));
end TwoWayOpenLoop;
