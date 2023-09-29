within Buildings.Fluid.Storage.Validation;
model HeatExchangerDynamics
  "Test model for stratified tank with steady-state and dynamic heat exchanger balance"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  constant Integer nSeg = 7 "Number of segments in tank";

  parameter Modelica.Units.SI.HeatFlowRate QHex_flow_nominal=2000
    "Design heat flow rate of heat exchanger";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=QHex_flow_nominal/
      4200/4;

  Buildings.Fluid.Sources.Boundary_pT watInTan(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=2,
    T=273.15 + 30,
    p(displayUnit="Pa")) "Boundary condition for water in the tank"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T mHex_flow1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=273.15 + 60,
    nPorts=1) "Mass flow rate through the heat exchanger"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  model Tank = StratifiedEnhancedInternalHex (
    redeclare package Medium = Medium,
    redeclare package MediumHex = Medium,
    hTan=2,
    dIns=0.3,
    VTan=0.3,
    nSeg=nSeg,
    hHex_a=1,
    hHex_b=0.2,
    Q_flow_nominal=QHex_flow_nominal,
    TTan_nominal=313.15,
    THex_nominal=333.15,
    mHex_flow_nominal=m_flow_nominal,
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Tank with dynamic heat exchanger balance";

  Tank tanDyn "Tank with dynamic heat exchanger balance"
    annotation (Placement(transformation(extent={{32,20},{52,40}})));

  Tank tanSte(energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Tank with steady-state heat exchanger balance"
    annotation (Placement(transformation(extent={{32,-20},{52,0}})));

  Modelica.Blocks.Sources.Trapezoid mHex_flow_in(
    period=7200,
    amplitude=m_flow_nominal,
    offset=0,
    rising=1800,
    width=1800,
    falling=1800,
    startTime=900) "Control signal for mass flow rate in heat exchanger"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 30,
    p(displayUnit="Pa"),
    nPorts=2) "Sink boundary condition"
    annotation (Placement(transformation(extent={{-62,-48},{-42,-28}})));

  Buildings.Fluid.Sources.MassFlowSource_T mHex_flow2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=273.15 + 60,
    nPorts=1) "Mass flow rate through the heat exchanger"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTanDyn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor at tank outlet"
    annotation (Placement(transformation(extent={{10,0},{-10,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTanSte(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor at tank outlet"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T mWatTanDyn_flow(
    redeclare package Medium = Medium,
    nPorts=1) "Mass flow rate through the tank"
    annotation (Placement(transformation(extent={{82,10},{62,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T mWatTanSte_flow(
    redeclare package Medium = Medium,
    nPorts=1) "Mass flow rate through the tank"
    annotation (Placement(transformation(extent={{82,-30},{62,-10}})));
equation
  connect(mHex_flow_in.y, mHex_flow1.m_flow_in) annotation (Line(
      points={{-79,20},{-70,20},{-70,28},{-62,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mHex_flow2.m_flow_in, mHex_flow_in.y) annotation (Line(points={{-62,-2},
          {-70,-2},{-70,20},{-79,20}}, color={0,0,127}));
  connect(mHex_flow2.ports[1], tanSte.portHex_a) annotation (Line(points={{-40,-10},
          {-32,-10},{-30,-10},{-30,-13.8},{32,-13.8}},  color={0,127,255}));
  connect(watInTan.ports[1], tanSte.port_a) annotation (Line(points={{-40,59},{
          -40,59},{-22,59},{-22,0},{42,0}},  color={0,127,255}));
  connect(mHex_flow1.ports[1], tanDyn.portHex_a) annotation (Line(points={{-40,
          20},{-30,20},{-30,26.2},{32,26.2}}, color={0,127,255}));
  connect(watInTan.ports[2], tanDyn.port_a) annotation (Line(points={{-40,61},{
          -30,61},{-20,61},{-20,40},{42,40}},
                                           color={0,127,255}));
  connect(senTanDyn.port_a, tanDyn.portHex_b) annotation (Line(points={{10,10},{
          20,10},{20,22},{32,22}}, color={0,127,255}));
  connect(senTanSte.port_a, tanSte.portHex_b) annotation (Line(points={{10,-40},
          {20,-40},{20,-18},{32,-18}}, color={0,127,255}));
  connect(senTanDyn.port_b, sin.ports[1]) annotation (Line(points={{-10,10},{
          -20,10},{-20,-39},{-42,-39}},
                                    color={0,127,255}));
  connect(senTanSte.port_b, sin.ports[2]) annotation (Line(points={{-10,-40},{
          -42,-40},{-42,-37}},
                           color={0,127,255}));
  connect(mWatTanDyn_flow.ports[1], tanDyn.port_b)
    annotation (Line(points={{62,20},{42,20}}, color={0,127,255}));
  connect(mWatTanSte_flow.ports[1], tanSte.port_b)
    annotation (Line(points={{62,-20},{42,-20}}, color={0,127,255}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Validation/HeatExchangerDynamics.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This validation model compares two tank models. The only difference between
the two tank models is that one uses a dynamic energy balance, whereas
the other uses a steady-state energy balance for the heat exchanger.
The mass flow rate through the heat exchanger is varied from zero to
the design flow rate and back to zero to test the model under conditions in
which no water flows through the heat exchanger.
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Added zero mass flow rate boundary conditions to avoid a translation error in Dymola 2018.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/834\">issue 834</a>.
</li>
<li>
January 8, 2016 by Michael Wetter:<br/>
First implementation to test
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">issue 434</a>.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=14400));
end HeatExchangerDynamics;
