within Buildings.Fluid.Storage.Validation;
model HeatExchangerLocation
  "Test model for heat exchanger with hHex_a and hHex_b interchanged"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water "Medium model";

 parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal = 6000
    "Design heat flow rate of heat exchanger";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal= QHex_flow_nominal/4200/4;

  Buildings.Fluid.Sources.Boundary_pT watInTan(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=2,
    T=273.15 + 30,
    p(displayUnit="Pa")) "Boundary condition for water in the tank"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Sources.MassFlowSource_T mHex_flow1(
    redeclare package Medium = Medium,
    nPorts=2,
    m_flow=m_flow_nominal/100,
    T=273.15 + 60)
              "Mass flow rate through the heat exchanger"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  model Tank = StratifiedEnhancedInternalHex (
    redeclare final package Medium = Medium,
    redeclare final package MediumHex = Medium,
    final VTan=0.3,
    final kIns=0.034,
    final dIns=0.04,
    final hTan=1.2,
    final m_flow_nominal=m_flow_nominal,
    final mHex_flow_nominal=m_flow_nominal,
    final nSeg=12,
    final hexSegMult=2,
    final Q_flow_nominal=QHex_flow_nominal,
    final TTan_nominal=293.15,
    final THex_nominal=273.15+60,
    final computeFlowResistance=false,
    final energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Tank";

  Tank tan_aTop(
    hHex_a=0.3,
    hHex_b=0.1)
    "Tank with heat exchanger inlet above its outlet"
    annotation (Placement(transformation(extent={{42,14},{62,34}})));

  Tank tan_bTop(
    hHex_a=0.1,
    hHex_b=0.3)
    "Tank with heat exchanger outlet above its inlet"
    annotation (Placement(transformation(extent={{40,-58},{60,-38}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 30,
    p(displayUnit="Pa"),
    nPorts=2) "Sink boundary condition"
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));

  Sensors.TemperatureTwoPort senTan_aTop(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor at tank outlet"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));

  Sensors.TemperatureTwoPort senTan_bTop(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor at tank outlet"
    annotation (Placement(transformation(extent={{10,-80},{-10,-60}})));
  Sources.MassFlowSource_T mWatTanSte_flow(redeclare package Medium = Medium,
      nPorts=1) "Mass flow rate through the tank"
    annotation (Placement(transformation(extent={{92,-58},{72,-38}})));
  Sources.MassFlowSource_T mWatTanDyn_flow(redeclare package Medium = Medium,
      nPorts=1) "Mass flow rate through the tank"
    annotation (Placement(transformation(extent={{94,14},{74,34}})));
equation
  connect(mHex_flow1.ports[1], tan_aTop.portHex_a) annotation (Line(points={{-20,22},
          {-20,20.2},{42,20.2}},     color={0,127,255}));
  connect(senTan_aTop.port_a, tan_aTop.portHex_b) annotation (Line(points={{10,-20},
          {10,-20},{20,-20},{20,16},{42,16}}, color={0,127,255}));
  connect(senTan_aTop.port_b, sin.ports[1]) annotation (Line(points={{-10,-20},{
          -26,-20},{-40,-20}}, color={0,127,255}));
  connect(senTan_bTop.port_b, sin.ports[2]) annotation (Line(points={{-10,-70},{
          -20,-70},{-20,-24},{-40,-24}}, color={0,127,255}));
  connect(senTan_bTop.port_a, tan_bTop.portHex_b) annotation (Line(points={{10,-70},
          {20,-70},{20,-56},{40,-56}}, color={0,127,255}));
  connect(tan_bTop.portHex_a, mHex_flow1.ports[2]) annotation (Line(points={{40,
          -51.8},{30,-51.8},{30,18},{-20,18}}, color={0,127,255}));
  connect(tan_aTop.port_a, watInTan.ports[1]) annotation (Line(points={{42,24},{
          38,24},{38,62},{-40,62}}, color={0,127,255}));
  connect(tan_bTop.port_a, watInTan.ports[2]) annotation (Line(points={{40,-48},
          {40,-48},{34,-48},{34,58},{-40,58}}, color={0,127,255}));
  connect(mWatTanDyn_flow.ports[1], tan_aTop.port_b)
    annotation (Line(points={{74,24},{62,24}}, color={0,127,255}));
  connect(tan_bTop.port_b, mWatTanSte_flow.ports[1])
    annotation (Line(points={{60,-48},{72,-48}}, color={0,127,255}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Validation/HeatExchangerLocation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation model compares two tank models. The only difference between
the two tank models is that <code>tan_aTop</code> has the hot water inlet
for the heat exchanger above its outlet, whereas <code>tan_bTop</code>
has the hot water inlet below its outlet. In both models, the heat exchanger
extends from element <i>9</i> to element <i>11</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2017, by Michael Wetter:<br/>
Added zero mass flow rate boundary conditions to avoid a translation error in Dymola 2018.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/834\">issue 834</a>.
</li>
<li>
June 23, 2016 by Michael Wetter:<br/>
First implementation to test
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/531\">issue 531</a>.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=600000));
end HeatExchangerLocation;
