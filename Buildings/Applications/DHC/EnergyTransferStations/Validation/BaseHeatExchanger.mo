within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model BaseHeatExchanger
  "Validation of the base subsystem model with district heat exchanger"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-62})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Secondary boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-62})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T1(
    offset=8 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=5,
    duration=1000,
    startTime=1000) "Primary temperature"
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T2Col(
    offset=6 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=10,
    duration=1000,
    startTime=2000) "Secondary temperature"
    annotation (Placement(transformation(extent={{-230,-12},{-210,8}})));
  Fluid.Sensors.TemperatureTwoPort senT2OutPum(redeclare final package Medium
      = Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary outlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort senT1Out(redeclare final package Medium =
        Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary outlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2Inl(redeclare final package Medium =
        Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary inlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-80})));
  Fluid.Sensors.TemperatureTwoPort senT1Inl(redeclare final package Medium =
        Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary inlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT1(
    offset=0,
    y(final unit="K", displayUnit="degC"),
    height=-3,
    duration=1000,
    startTime=3000) "Primary additional deltaT"
    annotation (Placement(transformation(extent={{190,-50},{170,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{150,-70},{130,-50}})));
  Modelica.Blocks.Sources.BooleanExpression uHeaRej(y=time >= 3000)
    "Full heat rejection enabled signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{-192,8},{-172,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT2Col(
    y(final unit="K", displayUnit="degC"),
    height=-10,
    duration=500,
    startTime=4500) "Secondary additional deltaT"
    annotation (Placement(transformation(extent={{-230,28},{-210,48}})));
  Modelica.Blocks.Sources.BooleanExpression uColRej(y=time >= 1000 and time <
        2000)
    "Full cold rejection enabled signal"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  FifthGeneration.BaseClasses.HeatExchanger hexPum(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    have_valDis=false,
    dp1Hex_nominal=10E3,
    dp2Hex_nominal=10E3,
    QHex_flow_nominal=1E6,
    T_a1Hex_nominal=281.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=279.15) "Heat exchanger with primary pump"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T2Hea(
    offset=45 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=10,
    duration=1000,
    startTime=2000) "Secondary temperature"
    annotation (Placement(transformation(extent={{-230,-130},{-210,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{-192,-110},{-172,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dT2Hea(
    y(final unit="K", displayUnit="degC"),
    height=10,
    duration=500,
    startTime=4500) "Secondary additional deltaT"
    annotation (Placement(transformation(extent={{-230,-90},{-210,-70}})));
  Fluid.Sources.Boundary_pT bou2Val(
    redeclare package Medium = Medium,
    p=Medium.p_default + 10E3,
    use_T_in=true,
    nPorts=2) "Secondary boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));
  FifthGeneration.BaseClasses.HeatExchanger hexVal(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    have_valDis=true,
    dp1Hex_nominal=10E3,
    dp2Hex_nominal=10E3,
    QHex_flow_nominal=1E6,
    T_a1Hex_nominal=281.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=279.15) "Heat exchanger with primary control valve"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
equation
  connect(senT2OutPum.port_b, bou2.ports[1]) annotation (Line(points={{-90,-40},
          {-100,-40},{-100,-60}}, color={0,127,255}));
  connect(bou1.ports[1], senT1Out.port_b) annotation (Line(points={{100,-60},{100,
          -40},{80,-40}}, color={0,127,255}));
  connect(bou2.ports[2], senT2Inl.port_a) annotation (Line(points={{-100,-64},{-100,
          -80},{-90,-80}}, color={0,127,255}));
  connect(senT1Inl.port_a, bou1.ports[2]) annotation (Line(points={{80,-80},{100,
          -80},{100,-64}}, color={0,127,255}));
  connect(mulSum.y, bou1.T_in) annotation (Line(points={{128,-60},{126,-60},{126,
          -58},{122,-58}}, color={0,0,127}));
  connect(dT1.y, mulSum.u[1]) annotation (Line(points={{168,-40},{160,-40},{160,
          -60},{156,-60},{156,-59},{152,-59}}, color={0,0,127}));
  connect(T1.y, mulSum.u[2]) annotation (Line(points={{168,-80},{160,-80},{160,-61},
          {152,-61}}, color={0,0,127}));
  connect(T2Col.y, mulSum1.u[1]) annotation (Line(points={{-208,-2},{-200,-2},{
          -200,19},{-194,19}}, color={0,0,127}));
  connect(dT2Col.y, mulSum1.u[2]) annotation (Line(points={{-208,38},{-200,38},
          {-200,17},{-194,17}}, color={0,0,127}));
  connect(senT1Out.port_a, hexPum.port_a1) annotation (Line(points={{60,-40},{-40,
          -40},{-40,-54},{-10,-54}}, color={0,127,255}));
  connect(hexPum.port_b1, senT1Inl.port_b) annotation (Line(points={{10,-54},{
          40,-54},{40,-80},{60,-80}}, color={0,127,255}));
  connect(senT2Inl.port_b, hexPum.port_a2) annotation (Line(points={{-70,-80},{
          20,-80},{20,-66},{10,-66}}, color={0,127,255}));
  connect(hexPum.port_b2, senT2OutPum.port_a) annotation (Line(points={{-10,-66},
          {-60,-66},{-60,-40},{-70,-40}}, color={0,127,255}));
  connect(uHeaRej.y, hexPum.uHeaRej) annotation (Line(points={{-99,100},{-46,
          100},{-46,-58},{-12,-58}}, color={255,0,255}));
  connect(uColRej.y, hexPum.uColRej) annotation (Line(points={{-99,80},{-52,80},
          {-52,-62},{-12,-62}}, color={255,0,255}));
  connect(swi.y, bou2.T_in) annotation (Line(points={{-138,-60},{-130,-60},{
          -130,-58},{-122,-58}}, color={0,0,127}));
  connect(uColRej.y, swi.u2) annotation (Line(points={{-99,80},{-80,80},{-80,
          -20},{-180,-20},{-180,-60},{-162,-60}}, color={255,0,255}));
  connect(mulSum1.y, swi.u1) annotation (Line(points={{-170,18},{-166,18},{-166,
          -52},{-162,-52}}, color={0,0,127}));
  connect(T2Hea.y, mulSum2.u[1]) annotation (Line(points={{-208,-120},{-200,
          -120},{-200,-99},{-194,-99}}, color={0,0,127}));
  connect(dT2Hea.y, mulSum2.u[2]) annotation (Line(points={{-208,-80},{-200,-80},
          {-200,-101},{-194,-101}}, color={0,0,127}));
  connect(mulSum2.y, swi.u3) annotation (Line(points={{-170,-100},{-166,-100},{
          -166,-68},{-162,-68}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-240,-140},{240,140}})),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/BaseHeatExchanger.mos"
        "Simulate and plot"),
    experiment(StopTime=5000, __Dymola_Algorithm="Dassl"));
end BaseHeatExchanger;
