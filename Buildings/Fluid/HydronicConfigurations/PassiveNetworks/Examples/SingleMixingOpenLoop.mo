within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples;
model SingleMixingOpenLoop
  "Model illustrating the operation of single mixing circuits with primary back pressure"
  extends BaseClasses.PartialPassivePrimary(
    typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    TLiqEnt_nominal=60 + 273.15,
    TLiqLvg_nominal=TLiqEnt_nominal - 10,
    TLiqSup_nominal=TLiqEnt_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    del1(nPorts=3),
    res1(dp_nominal=3e4));

  parameter Boolean is_bal=false
    "Set to true for balanced bypass branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa") = 5e3
    "Control valve pressure drop at design conditions";

  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con(
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput,
    redeclare final package Medium=MediumLiq,
    val(fraK=1.0),
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=loa.m_flow_nominal,
    dp1_nominal=res1.dp_nominal,
    final dp2_nominal=loa.dpLiq_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal3_nominal=if is_bal then res1.dp_nominal else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load
    loa(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final dpLiq_nominal=dpTer_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal) "Load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con1(
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput,
    redeclare final package Medium = MediumLiq,
    val(fraK=1.0),
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=loa1.m_flow_nominal,
    dp1_nominal=res1.dp_nominal,
    final dp2_nominal=loa1.dpLiq_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal3_nominal=if is_bal then res1.dp_nominal else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final dpLiq_nominal=dpTer_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal) "Load"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(k=1)
    "Operating mode"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fraLoa(k=1)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable  ope(
    table=[0,1,1; 1,0,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    timeScale=100) "Valve opening signal"
    annotation (Placement(transformation(extent={{-122,-10},{-102,10}})));

equation
  connect(con.port_b2, loa.port_a)
    annotation (Line(points={{4,-20},{0,-20},{0,30}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,30},{20,-20},{
          16,-20}},    color={0,127,255}));
  connect(con.port_b1, del1.ports[2])
    annotation (Line(points={{16,-40},{20,-40},{20,-80}}, color={0,127,255}));
  connect(con1.port_b1, del1.ports[3]) annotation (Line(points={{76,-40},{80,-40},
          {80,-80},{20,-80}}, color={0,127,255}));
  connect(mode.y, loa.mode) annotation (Line(points={{-98,80},{-20,80},{-20,34},
          {-2,34}}, color={255,127,0}));
  connect(mode.y, loa1.mode) annotation (Line(points={{-98,80},{40,80},{40,34},
          {58,34}}, color={255,127,0}));
  connect(mode.y, con.mode) annotation (Line(points={{-98,80},{-20,80},{-20,-22},
          {-2,-22}}, color={255,127,0}));
  connect(fraLoa.y, loa.u) annotation (Line(points={{-98,120},{-10,120},{-10,
          38},{-2,38}}, color={0,0,127}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-98,120},{50,120},{50,38},
          {58,38}}, color={0,0,127}));
  connect(mode.y, con1.mode) annotation (Line(points={{-98,80},{40,80},{40,34},
          {54,34},{54,-22},{58,-22}}, color={255,127,0}));
  connect(res1.port_b, con.port_a1) annotation (Line(points={{-10,-60},{0,-60},
          {0,-40},{4,-40}}, color={0,127,255}));
  connect(res1.port_b, con1.port_a1) annotation (Line(points={{-10,-60},{60,-60},
          {60,-40},{64,-40}}, color={0,127,255}));
  connect(con1.port_b2, loa1.port_a)
    annotation (Line(points={{64,-20},{60,-20},{60,30}}, color={0,127,255}));
  connect(loa1.port_b, con1.port_a2) annotation (Line(points={{80,30},{80,-20},
          {76,-20}},   color={0,127,255}));
  connect(ope.y[1], con.yVal) annotation (Line(points={{-100,0},{-40,0},{-40,
          -30},{-2,-30}},
                     color={0,0,127}));
  connect(ope.y[2], con1.yVal) annotation (Line(points={{-100,0},{40,0},{40,-30},
          {58,-30}}, color={0,0,127}));
annotation (
experiment(
  StopTime=100,
  Tolerance=1e-6),
__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/PassiveNetworks/Examples/SingleMixingOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the disturbance caused on the three-way valve
operation by an induced negative pressure differential at the
circuit boundaries.
Two consumer circuits are connected to a primary loop by means of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>.
The primary loop is configured with a flow resistance that
generates a negative pressure differential at the boundaries of the
consumer circuits
(representing for instance a boiler with a high pressure drop
and no minimum flow requirement).
Each consumer circuit is equipped with a circulation pump
that is sized to cover the primary pressure differential.
When the parameter <code>is_bal</code> is <code>false</code>
no bypass balancing valve is considered.
When this parameter is <code>true</code> a bypass balancing
valve is considered with the same design pressure drop
as the one in the primary loop.
The pump design head remains unchanged whatever the value
of the parameter <code>is_bal</code>.
The model is configured in steady-state with open loop control.
The load on each consumer circuit is constant.
The control valve of the first circuit is modulated
from fully open to fully closed position while the
control valve of the remote circuit is kept fully open.
</p>
<p>
When the bypass is not balanced, the flow reverses in the primary
branch when the valve opening is below <i>20%</i> which means
that the load cannot be served any more.
</p>
<p>
When the bypass is balanced, no flow reversal occurs and the
mixing function of the three-way valve is preserved
over its whole opening range.
</p>
<p>
Note that the setting of this model represents an oversized control
valve with a low authority <i>&beta; = 0.14</i>.
Setting a higher valve design pressure drop to reach an authority
close to <i>0.5</i> alleviates the risk of primary flow reversal
and reduces the need for a bypass balancing valve.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleMixingOpenLoop;
