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
  final parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
    QEva_flow_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";

  final parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=
    -m2_flow_nominal/dTCon_nominal*dTEva_nominal
    "Nominal mass flow rate at condeser water side";

  Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_m_flow_in=false,
    use_T_in=true) "Mass flow rate source"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Sources.FixedBoundary sin1(
    redeclare package Medium = Medium2,
    nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-88,-100})));

  Carnot_TEva chi(
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
    dp1_nominal=0,
    dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Chiller model"
    annotation (Placement(transformation(extent={{6,-98},{26,-78}})));

  Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    use_T_in=true,
    T=293.15,
    nPorts=1) "Mass flow rate source"
    annotation (Placement(transformation(extent={{102,-110},{82,-90}})));
  Modelica.Blocks.Sources.Constant TEvaIn(k=273.15 + 20)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant dTEva(k=dTEva_nominal)
    "Temperature difference over evaporator"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Constant dTSmall(k=0.01) "Small temperature lift"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{8,30},{28,50}})));
  Sensors.EntropyFlowRate S_a1(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Sensors.EntropyFlowRate S_a2(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-110},{-50,-90}})));
  Sensors.EntropyFlowRate S_a3(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{58,-110},{38,-90}})));
  Sensors.EntropyFlowRate S_a4(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{38,-70},{58,-50}})));
  Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2, nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={88,-60})));
  Modelica.Blocks.Math.Add SIn_flow
    "Entropy carried by flow that goes into the chiller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.Add SOut_flow
    "Entropy carried by flow that leaves the chiller"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Math.Add dS_flow(k2=-1)
    "Change in entropy inflow and outflow"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
equation
  connect(TEvaIn.y, sou2.T_in) annotation (Line(points={{-59,80},{-59,80},{130,80},
          {130,-96},{104,-96}},   color={0,0,127}));
  connect(add.u1, TEvaIn.y) annotation (Line(points={{-42,66},{-50,66},{-50,80},
          {-59,80}}, color={0,0,127}));
  connect(dTEva.y, add.u2) annotation (Line(points={{-59,50},{-50,50},{-50,54},
          {-42,54}}, color={0,0,127}));
  connect(add.y, chi.TSet) annotation (Line(points={{-19,60},{-2,60},{-2,-78},{4,
          -78},{4,-79}},      color={0,0,127}));
  connect(add.y, add1.u1) annotation (Line(points={{-19,60},{-10,60},{-10,46},{6,
          46}},    color={0,0,127}));
  connect(dTSmall.y, add1.u2) annotation (Line(points={{-59,20},{-30,20},{-30,34},
          {6,34}},      color={0,0,127}));
  connect(sou1.T_in, add1.y) annotation (Line(points={{-102,-56},{-120,-56},{-120,
          0},{32,0},{32,40},{29,40}}, color={0,0,127}));
  connect(sin1.ports[1], S_a2.port_b) annotation (Line(points={{-78,-100},{-78,-100},
          {-50,-100}}, color={0,127,255}));
  connect(sou1.ports[1], S_a1.port_a) annotation (Line(points={{-80,-60},{-80,-60},
          {-50,-60}}, color={0,127,255}));
  connect(S_a1.port_b, chi.port_a1) annotation (Line(points={{-30,-60},{-12,-60},
          {-12,-82},{6,-82}}, color={0,127,255}));
  connect(chi.port_b1, S_a4.port_a) annotation (Line(points={{26,-82},{32,-82},{
          32,-60},{38,-60}}, color={0,127,255}));
  connect(S_a4.port_b, sin2.ports[1])
    annotation (Line(points={{58,-60},{64,-60},{78,-60}}, color={0,127,255}));
  connect(S_a3.port_a, sou2.ports[1]) annotation (Line(points={{58,-100},{70,-100},
          {82,-100}}, color={0,127,255}));
  connect(S_a2.port_a, chi.port_b2) annotation (Line(points={{-30,-100},{-12,-100},
          {-12,-94},{6,-94}}, color={0,127,255}));
  connect(S_a3.port_b, chi.port_a2) annotation (Line(points={{38,-100},{36,-100},
          {36,-94},{26,-94}}, color={0,127,255}));
  connect(S_a4.S_flow, SOut_flow.u2)
    annotation (Line(points={{48,-49},{48,-36},{58,-36}}, color={0,0,127}));
  connect(S_a2.S_flow, SOut_flow.u1) annotation (Line(points={{-40,-89},{-40,-80},
          {-20,-80},{-20,-24},{58,-24}}, color={0,0,127}));
  connect(S_a3.S_flow, SIn_flow.u2) annotation (Line(points={{48,-89},{48,-74},{
          30,-74},{30,-6},{58,-6}}, color={0,0,127}));
  connect(S_a1.S_flow, SIn_flow.u1) annotation (Line(points={{-40,-49},{-40,-49},
          {-40,4},{58,4},{58,6}}, color={0,0,127}));
  connect(SIn_flow.y, dS_flow.u1)
    annotation (Line(points={{81,0},{88,0},{88,-4},{98,-4}}, color={0,0,127}));
  connect(SOut_flow.y, dS_flow.u2) annotation (Line(points={{81,-30},{88,-30},{88,
          -16},{98,-16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {140,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,120}}),
                                                     graphics={Text(
          extent={{18,120},{94,88}},
          lineColor={28,108,200},
          textString="fixme: This needs to be completed")}));
end Carnot_TEva_2ndLaw;
