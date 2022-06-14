within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model DiversionOpenLoop "Model illustrating the operation of diversion circuits with constant speed pump"
  extends BaseClasses.PartialActivePrimary(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dpPum_nominal=
    (2 * dpPip_nominal + dpTer_nominal + dpValve_nominal) * kSizPum,
    pum(inputType=Buildings.Fluid.Types.InputType.Constant),
    del1(nPorts=3));

  parameter Boolean is_bal=false
    "Set to true for balanced bypass branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic typCha=
    Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Control valve characteristic"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    displayUnit="Pa") = dpTer_nominal
    "Control valve pressure drop at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpBal3_nominal(
    final min=0,
    displayUnit="Pa") = if is_bal then dpTer_nominal else 0
    "Bypass balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  ActiveNetworks.Diversion con(
    redeclare final package Medium=MediumLiq,
    val(fraK=1),
    final typCha=typCha,
    final use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=mTer_flow_nominal,
    final dp2_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpPum_nominal - dpPip_nominal - dpTer_nominal - dpValve_nominal,
    final dpBal3_nominal=dpBal3_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load loa(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final dpLiq_nominal=dpTer_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fraLoa(k=1)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  ActiveNetworks.Diversion con1(
    redeclare final package Medium = MediumLiq,
    val(fraK=1),
    final typCha=typCha,
    final use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=mTer_flow_nominal,
    final dp2_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpPum_nominal - 2 * dpPip_nominal - dpTer_nominal - dpValve_nominal,
    final dpBal3_nominal=dpBal3_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load loa1(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final dpLiq_nominal=dpTer_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.PressureDrop res1b(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal - mTer_flow_nominal,
    final dp_nominal=dpPip_nominal) "Pipe pressure drop"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Sensors.RelativePressure dp1(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable ope(
    table=[0,1,1; 1,0,1; 2,1,0; 3,0,0],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    timeScale=100) "Valve opening signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(k=1)
    "Operating mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(con.port_b2, loa.port_a) annotation (Line(points={{4,30},{0,30},{0,60}},
                        color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,60},{20,30},{16,
          30},{16,29.8}}, color={0,127,255}));
  connect(fraLoa.y, loa.u) annotation (Line(points={{-78,80},{0,80},{0,68},{-2,68}},
        color={0,0,127}));
  connect(con1.port_b2, loa1.port_a) annotation (Line(points={{64,30},{60,30},{60,
          60}},         color={0,127,255}));
  connect(con1.port_a2, loa1.port_b) annotation (Line(points={{76,29.8},{76,30},
          {80,30},{80,60}}, color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-78,80},{40,80},{40,68},{58,
          68}}, color={0,0,127}));
  connect(dp1.port_a, res1b.port_b)
    annotation (Line(points={{60,-20},{60,-60},{50,-60}}, color={0,127,255}));
  connect(dp1.port_a, con1.port_a1) annotation (Line(points={{60,-20},{60,0},{64,
          0},{64,10}}, color={0,127,255}));
  connect(con1.port_b1, dp1.port_b) annotation (Line(points={{76,10},{76,0},{80,
          0},{80,-20}},  color={0,127,255}));
  connect(con.port_b1, dp.port_b) annotation (Line(points={{16,10},{16,2},{20,2},
          {20,-20}}, color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,10},{4,2},{0,2},{0,
          -20}},     color={0,127,255}));
  connect(ope.y[1], con.yVal)
    annotation (Line(points={{-78,0},{-20,0},{-20,20},{-2,20}},
                                                color={0,0,127}));
  connect(ope.y[2], con1.yVal) annotation (Line(points={{-78,0},{40,0},{40,20},{
          58,20}},                 color={0,0,127}));
  connect(res1.port_b, dp.port_a) annotation (Line(points={{-10,-60},{0,-60},{0,
          -20}},     color={0,127,255}));
  connect(dp.port_b, del1.ports[2])
    annotation (Line(points={{20,-20},{20,-80}},   color={0,127,255}));
  connect(res1.port_b, res1b.port_a)
    annotation (Line(points={{-10,-60},{30,-60}},  color={0,127,255}));
  connect(dp1.port_b, del1.ports[3]) annotation (Line(points={{80,-20},{80,-80},
          {20,-80}},  color={0,127,255}));
  connect(mode.y, loa.mode) annotation (Line(points={{-78,40},{-20,40},{-20,64},
          {-2,64}}, color={255,127,0}));
  connect(mode.y, loa1.mode) annotation (Line(points={{-78,40},{40,40},{40,64},
          {58,64}}, color={255,127,0}));
   annotation (experiment(
    StopTime=300,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of a diversion circuit to modulate
the heat flow rate transmitted to a constant load.
Two identical secondary circuits are connected to a primary circuit
with a constant speed pump.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The model is configured in steady-state.
</li>
<li>
Secondary and valve flow resistances are not lumped together
so that the valve authority can be computed as
<code>val.res1.dp / val.res2.dp</code> when the valve is
fully open.
</li>
<li>
The design conditions at <code>time = 0</code> are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
<li>
The bypass branch of the three-way valve is balanced at
design conditions if the parameter <code>is_bal</code>
is set to <code>true</code>. Otherwise no fixed flow
resistance is considered in the bypass branch, only the
variable flow resistance corresponding to the control valve.
The parameter <code>fraK</code> of the control valves is
set at <i>1.0</i> to effectively have an unbalanced bypass branch
for <code>con.dpBal3_nominal = 0</code>, see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves\">
Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves</a>.
</li>
</ul>
<p>
When simulated with the default parameter values, this example
shows the following points.
</p>
<ul>
<li>
The overflow caused by the unbalanced bypass branch when the valve
is fully closed (see plot #2 at <code>time = 100</code>)
creates a concomitant flow shortage in the other circuit with the
valve fully open.
However, the flow shortage (<i>6%</i>) is of a much lower amplitude than
the overflow (<i>27%</i>).
Indeed the equivalent flow resistance seen by the pump is lower than at
design conditions, leading a shift of the operating point of the pump
towards a flow rate value higher than design, which partly compensates
for the overflow.
</li>
<li>
The impact on the heat flow rate transferred to the load (see plot #4) is of an
even lower amplitude (<i>2%</i>) due to the emission characteristic of the
terminal unit.
</li>
<li>
The equal-percentage / linear characteristic of the control valve yields
a relationship between the heat flow rate transferred to the load and the
valve opening that is close to linear (see plot #4).
</li>
</ul>
<h4>
Sensitivity analysis
</h4>
<p>
Those observations are confirmed by a sensitivity study to the following
parameters.
</p>
<ul>
<li>
Ratio of the terminal unit pressure drop to the pump head at
design conditions (see the icon of the diversion circuit component for the
location of points J and A):
<i>&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub></i>
varying from <i>0.1</i> to <i>0.4</i>
</li>
<li>
Ratio of the control valve authority:
<i>&beta; = &Delta;p<sub>A-AB</sub> / &Delta;p<sub>J-AB</sub></i>
varying from <i>0.1</i> to <i>0.7</i>
</li>
<li>
Balanced bypass branch:
<code>is_bal</code> switched from <code>false</code> to <code>true</code>
</li>
<li>
Valve characteristic:
<code>ThreeWayValve</code> switched from equal percentage-linear (EL) to
linear-linear (LL).
</li>
</ul>
<h5>
Direct and bypass mass flow rate
</h5>
<p>
The overflow in the bypass branch when the valve is fully closed increases with
<i>&psi;</i> and decreases with <i>&beta;</i>.
It it close to <i>80%</i> for <i>&psi; = 40%</i> and <i>&beta; = 10%</i>.
However, the concomitant flow shortage in the other terminal unit with a valve
fully open is limited to about <i>20%</i>.
For a valve authority of <i>&beta; = 50%</i> one may note that the flow shortage
is limited to about <i>10%</i>, indicating that selecting the control valve with
a suitable authority largely dampens the impact of an unbalanced bypass branch.
</p>
<p>
<img alt=\"Diversion circuit bypass flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop_mBypass.png\"/>
<br/>
<i>Bypass mass flow rate (ratio to design value) at fully closed conditions
as a function of
&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub>
for various valve authorities &beta; (color scale),
and a bypass branch either balanced (right plot) or not (left plot).
</i>
</p>
<p>
<img alt=\"Diversion circuit direct flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop_mDirect.png\"/>
<br/>
<i>Direct mass flow rate (ratio to design value) at fully open conditions
as a function of
&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub>
for various valve authorities &beta; (color scale),
and a bypass branch either balanced (right plot) or not (left plot).
</i>
</p>
<p>
<img alt=\"Diversion circuit pump flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop_mPump.png\"/>
<br/>
<i>Pump mass flow rate (ratio to design value) as a function of
&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub>
for various valve authorities &beta; (color scale),
a bypass branch either balanced (right plots) or not (left plots)
and either an equal-percentage / linear valve characteristic (top plots)
or a linear / linear valve characteristic (bottom plots).
</i>
</p>
<p>
<img alt=\"Diversion circuit heat flow rate fully open\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop_Q100.png\"/>
<br/>
<i>Heat flow rate (ratio to design value) at fully open conditions
as a function of
&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub>
for various valve authorities &beta; (color scale),
and a bypass branch either balanced (right plot) or not (left plot).
</i>
</p>
<p>
<img alt=\"Diversion circuit heat flow rate 10% open\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionOpenLoop_Q10.png\"/>
<br/>
<i>Heat flow rate (ratio to design value) at 10% open conditions
as a function of
&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub>
for various valve authorities &beta; (color scale),
and a bypass branch either balanced (right plot) or not (left plot).
</i>
</p>
</html>"));
end DiversionOpenLoop;
