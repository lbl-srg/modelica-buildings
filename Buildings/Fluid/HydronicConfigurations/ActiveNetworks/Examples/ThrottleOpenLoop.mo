within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model ThrottleOpenLoop
  "Model illustrating the operation of throttle circuits with variable speed pump"
  extends BaseClasses.PartialActivePrimary(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dpPum_nominal=(dpPip_nominal + dpPip1_nominal + dpSetVal.k)*kSizPum,
    mPum_flow_nominal=m1_flow_nominal / 0.9,
    del1(nPorts=4));

  parameter Boolean is_bal=false
    "Set to true for balanced primary branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic typCha=
    Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Control valve characteristic"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    displayUnit="Pa") = dpTer_nominal
    "Control valve pressure drop at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpPip1_nominal(
    displayUnit="Pa")=3E4
    "Pipe section (between two circuits) pressure drop at design conditions";

  Throttle con(
    redeclare final package Medium=MediumLiq,
    final use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=mTer_flow_nominal,
    final dp2_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=if is_bal then
      dpPum_nominal - dpPip_nominal - dpTer_nominal - dpValve_nominal
      else 0)
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
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Throttle con1(
    final use_lumFloRes=false,
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=mTer_flow_nominal,
    final dp2_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=0)
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
    final dp_nominal=dpPip1_nominal) "Pipe pressure drop"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-30},{20,-50}})));
  Sensors.RelativePressure dp1(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{60,-30},{80,-50}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable ope(
    table=[0,1,1; 1,0,1; 2,1,0; 3,0,0],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    timeScale=100) "Valve opening signal"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    k=10,
    Ti=1,
    r=MediumLiq.p_default,
    xi_start=1)
    "Pump controller"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpSetVal(final k=
        dpTer_nominal + dpValve_nominal) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  FixedResistances.PressureDrop resEnd(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*mPum_flow_nominal,
    final dp_nominal=dpSetVal.k) "Pipe pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-70})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(k=1)
    "Operating mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
equation
  connect(con.port_b2, loa.port_a) annotation (Line(points={{4,30},{4,44},{0,44},
          {0,60}},      color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,60},{20,44},{16,
          44},{16,29.8}}, color={0,127,255}));
  connect(fraLoa.y, loa.u) annotation (Line(points={{-78,120},{-20,120},{-20,68},
          {-2,68}},
        color={0,0,127}));
  connect(con1.port_b2, loa1.port_a) annotation (Line(points={{64,30},{64,40},{
          60,40},{60,60}},
                        color={0,127,255}));
  connect(con1.port_a2, loa1.port_b) annotation (Line(points={{76,29.8},{76,40},
          {80,40},{80,60}}, color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-78,120},{40,120},{40,68},
          {58,68}},
                color={0,0,127}));
  connect(dp1.port_a, res1b.port_b)
    annotation (Line(points={{60,-40},{60,-60},{50,-60}}, color={0,127,255}));
  connect(dp1.port_a, con1.port_a1) annotation (Line(points={{60,-40},{60,0},{
          64,0},{64,10}},
                       color={0,127,255}));
  connect(con1.port_b1, dp1.port_b) annotation (Line(points={{76,10},{76,0},{80,
          0},{80,-40}},  color={0,127,255}));
  connect(con.port_b1, dp.port_b) annotation (Line(points={{16,10},{16,0},{20,0},
          {20,-40}}, color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,10},{4,0},{0,0},{
          0,-40}},   color={0,127,255}));
  connect(ope.y[1], con.yVal)
    annotation (Line(points={{-78,40},{-20,40},{-20,20},{-2,20}},
                                                color={0,0,127}));
  connect(ope.y[2], con1.yVal) annotation (Line(points={{-78,40},{40,40},{40,20},
          {58,20}},                color={0,0,127}));
  connect(dp1.p_rel, conPID.u_m) annotation (Line(points={{70,-31},{70,-20},{
          -60,-20},{-60,-12}},
                          color={0,0,127}));
  connect(dpSetVal.y, conPID.u_s)
    annotation (Line(points={{-78,0},{-72,0}},   color={0,0,127}));
  connect(res1b.port_b, resEnd.port_a)
    annotation (Line(points={{50,-60},{100,-60}}, color={0,127,255}));
  connect(res1.port_b, dp.port_a) annotation (Line(points={{-10,-60},{0,-60},{0,
          -40}},     color={0,127,255}));
  connect(res1.port_b, res1b.port_a)
    annotation (Line(points={{-10,-60},{30,-60}},  color={0,127,255}));
  connect(dp.port_b, del1.ports[2])
    annotation (Line(points={{20,-40},{20,-80}},   color={0,127,255}));
  connect(del1.ports[3], resEnd.port_b)
    annotation (Line(points={{20,-80},{100,-80}},   color={0,127,255}));
  connect(dp1.port_b, del1.ports[4]) annotation (Line(points={{80,-40},{80,-80},
          {20,-80}},  color={0,127,255}));
  connect(conPID.y, pum.y) annotation (Line(points={{-48,0},{-40,0},{-40,-40},{
          -80,-40},{-80,-48}},          color={0,0,127}));
  connect(mode.y, loa.mode) annotation (Line(points={{-78,80},{-24,80},{-24,64},
          {-2,64}}, color={255,127,0}));
  connect(mode.y, loa1.mode) annotation (Line(points={{-78,80},{36,80},{36,64},
          {58,64}}, color={255,127,0}));
   annotation (experiment(
    StopTime=300,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/ThrottleOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
The pipe pressure drop between the two consumer circuits is voluntarily
high to showcase typical balancing issues encountered in large
distribution systems.
</p>
<p>
This model illustrates the use of a throttle circuit to modulate
the heat flow rate transmitted to a constant load.
Two identical secondary circuits are connected to a primary circuit
with a variable speed pump.
The pump speed is modulated to track a constant pressure differential
at the boundaries of the remote circuit.
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
Each consumer circuit is balanced at design conditions if the parameter
<code>is_bal</code> is set to <code>true</code>.
</li>
</ul>
<p>
When simulated with the default parameter values, this example
shows the following points.
</p>
<ul>
<li>
The overflow caused by the unbalanced
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


</html>"),
    Diagram(coordinateSystem(extent={{-140,-140},{140,140}})));
end ThrottleOpenLoop;
