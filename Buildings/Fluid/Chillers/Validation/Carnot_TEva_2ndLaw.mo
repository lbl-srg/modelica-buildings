within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_2ndLaw
  "Test model to verify that the 2nd law is not violated"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal = -100E3
    "Evaporator heat flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
    QEva_flow_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";

  Sources.MassFlowSource_T               sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_m_flow_in=false,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
  Sources.FixedBoundary               sin2(
    redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,-72})));
  Carnot_TEva                        chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m2_flow_nominal=m2_flow_nominal,
    show_T=true,
    QEva_flow_nominal=QEva_flow_nominal,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dp1_nominal=6000,
    dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Sources.FixedBoundary               sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,30})));
  Sources.MassFlowSource_T               sou2(nPorts=1,
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    use_T_in=true,
    T=293.15)
    annotation (Placement(transformation(extent={{80,-66},{60,-46}})));
  Modelica.Blocks.Sources.Constant TEvaIn(k=273.15 + 20)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant dTEva(k=dTEva_nominal)
    "Temperature difference over evaporator"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Constant dTSmall(k=0.01) "Small temperature lift"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Sensors.EntropyFlowRate S_a1(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{-34,-56},{-14,-36}})));
equation
  connect(sou2.ports[1], chi.port_a2)
    annotation (Line(points={{60,-56},{40,-56}},      color={0,127,255}));
  connect(TEvaIn.y, sou2.T_in) annotation (Line(points={{-59,80},{-59,80},{94,
          80},{94,-52},{82,-52}}, color={0,0,127}));
  connect(add.u1, TEvaIn.y) annotation (Line(points={{-42,66},{-50,66},{-50,80},
          {-59,80}}, color={0,0,127}));
  connect(dTEva.y, add.u2) annotation (Line(points={{-59,50},{-50,50},{-50,54},
          {-42,54}}, color={0,0,127}));
  connect(add.y, chi.TSet) annotation (Line(points={{-19,60},{-10,60},{-10,-40},
          {18,-40},{18,-41}}, color={0,0,127}));
  connect(add.y, add1.u1) annotation (Line(points={{-19,60},{-10,60},{-10,46},{
          -2,46}}, color={0,0,127}));
  connect(dTSmall.y, add1.u2) annotation (Line(points={{-59,10},{-30,10},{-30,
          34},{-2,34}}, color={0,0,127}));
  connect(sou1.T_in, add1.y) annotation (Line(points={{-64,-36},{-50,-36},{-50,
          0},{32,0},{32,40},{21,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Carnot_TEva_2ndLaw;
