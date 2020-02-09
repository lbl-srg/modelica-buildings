within Buildings.Applications.DHC.Loads.Validation;
model HeatExchanger
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1_nominal(
    min=273.15, displayUnit="degC") = T_a1_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 10
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 1
    "Heating water nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp1_nominal = 50000
    "Nominal pressure drop";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Nominal heat flow rate";
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    Q_flow_nominal=Q_flow_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    p(displayUnit="Pa") = dp1_nominal + Medium1.p_default,
    T=T_a1_nominal,
    nPorts=2) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,40})));
  Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    p(displayUnit="Pa") = Medium1.p_default,
    T=T_a1_nominal,
    nPorts=4) "Sink" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    show_T=false,
    dpValve_nominal=5000,
    use_inputFilter=false,
    dpFixed_nominal=dp1_nominal - 5000)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(duration=1)
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Fluid.Sources.MassFlowSource_T sou_m2_flow(
    redeclare each final package Medium = Medium2,
    use_m_flow_in=false,
    m_flow=m2_flow_nominal,
    use_T_in=false,
    T=T_a2_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{80,44},{60,64}})));
  Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa"),
    nPorts=4) "Sink"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex1(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    Q_flow_nominal=Q_flow_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Fluid.Sources.MassFlowSource_T sou_m1_flow(
    redeclare each final package Medium = Medium1,
    use_m_flow_in=true,
    use_T_in=false,
    T=T_a1_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{-40,16},{-20,36}})));
  Fluid.Sources.MassFlowSource_T sou_m2_flow1(
    redeclare each final package Medium = Medium2,
    use_m_flow_in=false,
    m_flow=m2_flow_nominal,
    use_T_in=false,
    T=T_a2_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{82,4},{62,24}})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex2(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,

    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    Q_flow_nominal=Q_flow_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,-36},{10,-16}})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex3(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,

    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    Q_flow_nominal=Q_flow_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,-76},{10,-56}})));
  Fluid.Sources.MassFlowSource_T sou_m1_flow1(
    redeclare each final package Medium = Medium1,
    use_m_flow_in=true,
    use_T_in=false,
    T=T_a1_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare final package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    show_T=false,
    dpValve_nominal=5000,
    use_inputFilter=false,
    dpFixed_nominal=dp1_nominal - 5000)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-20})));
  Fluid.Sources.MassFlowSource_T sou_m2_flow2(
    redeclare each final package Medium = Medium2,
    use_m_flow_in=true,
    use_T_in=false,
    T=T_a2_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{80,-42},{60,-22}})));
  Fluid.Sources.MassFlowSource_T sou_m2_flow3(
    redeclare each final package Medium = Medium2,
    use_m_flow_in=true,
    use_T_in=false,
    T=T_a2_nominal,
    nPorts=1) "Source for flow rate"
    annotation (Placement(transformation(extent={{80,-82},{60,-62}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=m2_flow_nominal)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
equation
  connect(hex.port_a1, val.port_b) annotation (Line(points={{-10,66},{-16,66},{-16,
          60},{-20,60}}, color={0,127,255}));
  connect(supHeaWat.ports[1], val.port_a) annotation (Line(points={{-80,42},{
          -50,42},{-50,60},{-40,60}},
                                 color={0,127,255}));
  connect(ram.y, val.y)
    annotation (Line(points={{-78,80},{-30,80},{-30,72}}, color={0,0,127}));
  connect(sou_m2_flow.ports[1], hex.port_a2) annotation (Line(points={{60,54},{
          10,54}},             color={0,127,255}));
  connect(sin2.ports[1], hex.port_b2) annotation (Line(points={{-80,3},{-46,3},
          {-46,54},{-10,54}},color={0,127,255}));
  connect(sou_m1_flow.ports[1], hex1.port_a1) annotation (Line(points={{-20,26},
          {-20,28},{-16,28},{-16,26},{-10,26}}, color={0,127,255}));
  connect(hex1.port_b2, sin2.ports[2]) annotation (Line(points={{-10,14},{-44,
          14},{-44,1},{-80,1}},
                              color={0,127,255}));
  connect(sou_m2_flow1.ports[1], hex1.port_a2)
    annotation (Line(points={{62,14},{10,14}}, color={0,127,255}));
  connect(ram.y, sou_m1_flow.m_flow_in) annotation (Line(points={{-78,80},{-62,
          80},{-62,34},{-42,34}}, color={0,0,127}));
  connect(val1.port_b, hex2.port_a1)
    annotation (Line(points={{-20,-20},{-10,-20}}, color={0,127,255}));
  connect(sou_m1_flow1.ports[1], hex3.port_a1)
    annotation (Line(points={{-20,-60},{-10,-60}}, color={0,127,255}));
  connect(hex2.port_b1, sin1.ports[1]) annotation (Line(points={{10,-20},{36,
          -20},{36,83},{60,83}}, color={0,127,255}));
  connect(hex3.port_b1, sin1.ports[2]) annotation (Line(points={{10,-60},{36,
          -60},{36,81},{60,81}}, color={0,127,255}));
  connect(ram.y, val1.y) annotation (Line(points={{-78,80},{-54,80},{-54,-8},{
          -30,-8}}, color={0,0,127}));
  connect(ram.y, sou_m1_flow1.m_flow_in) annotation (Line(points={{-78,80},{-60,
          80},{-60,-52},{-42,-52}}, color={0,0,127}));
  connect(sou_m2_flow2.ports[1], hex2.port_a2) annotation (Line(points={{60,-32},
          {36,-32},{36,-32},{10,-32}}, color={0,127,255}));
  connect(sou_m2_flow3.ports[1], hex3.port_a2)
    annotation (Line(points={{60,-72},{10,-72}}, color={0,127,255}));
  connect(sin2.ports[3], hex2.port_b2) annotation (Line(points={{-80,-1},{-46,
          -1},{-46,-32},{-10,-32}}, color={0,127,255}));
  connect(sin2.ports[4], hex3.port_b2) annotation (Line(points={{-80,-3},{-46,
          -3},{-46,-72},{-10,-72}}, color={0,127,255}));
  connect(ram.y, gai.u) annotation (Line(points={{-78,80},{-70,80},{-70,-90},{
          -62,-90}}, color={0,0,127}));
  connect(gai.y, sou_m2_flow3.m_flow_in) annotation (Line(points={{-38,-90},{28,
          -90},{28,-86},{92,-86},{92,-64},{82,-64}}, color={0,0,127}));
  connect(gai.y, sou_m2_flow2.m_flow_in) annotation (Line(points={{-38,-90},{
          27.931,-90},{27.931,-85.8621},{110,-85.8621},{110,-24},{82,-24}},
        color={0,0,127}));
  connect(supHeaWat.ports[2], val1.port_a) annotation (Line(points={{-80,38},{
          -60,38},{-60,-20},{-40,-20}}, color={0,127,255}));
  connect(hex.port_b1, sin1.ports[3]) annotation (Line(points={{10,66},{36,66},
          {36,79},{60,79}}, color={0,127,255}));
  connect(hex1.port_b1, sin1.ports[4]) annotation (Line(points={{10,26},{36,26},
          {36,77},{60,77}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchanger;
