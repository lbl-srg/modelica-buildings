within Buildings.DHC.ETS.Combined.Subsystems.Validation;
model WatersideEconomizer
  "Validation of the base subsystem model with waterside economizer"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT bou1Pum(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,-62})));
  Buildings.Fluid.Movers.FlowControlled_dp pum2Pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=hexPum.m2_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=25E4) "CHW pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,-40})));
  Modelica.Blocks.Sources.BooleanExpression uCoo(y=time >= 1000)
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer hexPum(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    show_T=true,
    conCon=Buildings.DHC.ETS.Types.ConnectionConfiguration.Pump,
    dp1Hex_nominal=3E4,
    dp2Hex_nominal=3E4,
    Q_flow_nominal=-1E6,
    T_a1_nominal=281.15,
    T_b1_nominal=291.15,
    T_a2_nominal=293.15,
    T_b2_nominal=283.15)
    "Heat exchanger with primary pump"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1OutPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary outlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,-80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1InlPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary inlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2OutPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary outlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2InlPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary inlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-80})));
  Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer hexVal(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    show_T=true,
    conCon=Buildings.DHC.ETS.Types.ConnectionConfiguration.TwoWayValve,
    dp1Hex_nominal=3E4,
    dp2Hex_nominal=3E4,
    Q_flow_nominal=-1E6,
    T_a1_nominal=281.15,
    T_b1_nominal=291.15,
    T_a2_nominal=293.15,
    T_b2_nominal=283.15)
    "Heat exchanger with primary control valve"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.Sources.Boundary_pT bou1InlVal(
    redeclare package Medium = Medium,
    p=Medium.p_default + 45E3,
    use_T_in=true,
    nPorts=1) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,40})));
  Buildings.Fluid.Sources.Boundary_pT bou1OutVal(redeclare package Medium =
        Medium, nPorts=1) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1InlVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary inlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1OutVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary outlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2OutVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m2_flow_nominal)
    "Secondary outlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2InlVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m2_flow_nominal)
    "Secondary inlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare final package
      Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,20})));
  Modelica.Blocks.Sources.TimeTable TChiWatRet(
    y(final unit="K", displayUnit="degC"),
    table=[0,10; 2,15; 3,16; 4.5,16; 5,13; 10,9],
    timeScale=1000,
    offset=273.15) "Chilled water return temperature values"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Modelica.Blocks.Sources.TimeTable TSerWat(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,8;
      1,8;
      2,13;
      3,18;
      4,6;
      5,18],
    timeScale=1000,
    offset=273.15) "Service water temperature values"
    annotation (Placement(transformation(extent={{200,-70},{180,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=4) "Secondary boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,0})));
  Buildings.Fluid.FixedResistances.PressureDrop resPum(
    redeclare package Medium = Medium,
    m_flow_nominal=hexPum.m2_flow_nominal,
    dp_nominal=20E4) "Pipe flow resistance"
    annotation (Placement(transformation(extent={{-100,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp     dpSet(
    height=15E4,
    duration=1000,
    offset=10E4,
    startTime=1500)                                                    "Differential pressure set point"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Buildings.Fluid.Movers.FlowControlled_dp pum2Val(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=hexPum.m2_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=25E4) "CHW pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,40})));
  Buildings.Fluid.FixedResistances.PressureDrop resVal(
    redeclare package Medium = Medium,
    m_flow_nominal=hexPum.m2_flow_nominal,
    dp_nominal=20E4) "Pipe flow resistance"
    annotation (Placement(transformation(extent={{-100,30},{-120,50}})));
  Modelica.Blocks.Sources.RealExpression yEva(y=0) "Isolation valve signal"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
equation
  connect(hexPum.port_b1,senT1OutPum.port_a)
    annotation (Line(points={{40,-54},{70,-54},{70,-80},{90,-80}},color={0,127,255}));
  connect(senT1OutPum.port_b, bou1Pum.ports[1]) annotation (Line(points={{110,-80},
          {130,-80},{130,-63}}, color={0,127,255}));
  connect(hexPum.port_a1,senT1InlPum.port_b)
    annotation (Line(points={{20,-54},{10,-54},{10,-40},{90,-40}},   color={0,127,255}));
  connect(senT1InlPum.port_a, bou1Pum.ports[2]) annotation (Line(points={{110,-40},
          {130,-40},{130,-61}}, color={0,127,255}));
  connect(hexPum.port_b2,senT2OutPum.port_a)
    annotation (Line(points={{20,-66},{-10,-66},{-10,-40},{-30,-40}}, color={0,127,255}));
  connect(senT2InlPum.port_b,hexPum.port_a2)
    annotation (Line(points={{-30,-80},{50,-80},{50,-66},{40,-66}},color={0,127,255}));
  connect(hexVal.port_a1,senT1InlVal.port_b)
    annotation (Line(points={{20,26},{10,26},{10,40},{90,40}},   color={0,127,255}));
  connect(senT1InlVal.port_a, bou1InlVal.ports[1])
    annotation (Line(points={{110,40},{130,40}}, color={0,127,255}));
  connect(bou1OutVal.ports[1], senT1OutVal.port_b)
    annotation (Line(points={{130,0},{110,0}}, color={0,127,255}));
  connect(senT1OutVal.port_a,hexVal.port_b1)
    annotation (Line(points={{90,0},{60,0},{60,26},{40,26}},color={0,127,255}));
  connect(hexVal.port_a2,senT2InlVal.port_b)
    annotation (Line(points={{40,14},{50,14},{50,0},{-30,0}},color={0,127,255}));
  connect(senT2OutVal.port_a,hexVal.port_b2)
    annotation (Line(points={{-30,40},{-10,40},{-10,14},{20,14}}, color={0,127,255}));
  connect(hexVal.port_a1,senRelPre.port_a)
    annotation (Line(points={{20,26},{10,26},{10,40},{80,40},{80,30}},   color={0,127,255}));
  connect(senRelPre.port_b,senT1OutVal.port_a)
    annotation (Line(points={{80,10},{80,0},{90,0}},color={0,127,255}));
  connect(TSerWat.y, bou1Pum.T_in) annotation (Line(points={{179,-60},{170,-60},
          {170,-58},{152,-58}}, color={0,0,127}));
  connect(TSerWat.y, bou1InlVal.T_in) annotation (Line(points={{179,-60},{170,-60},
          {170,44},{152,44}}, color={0,0,127}));
  connect(uCoo.y, hexVal.uCoo) annotation (Line(points={{-179,80},{0,80},{0,20},{18,20}},      color={255,0,255}));
  connect(uCoo.y, hexPum.uCoo) annotation (Line(points={{-179,80},{0,80},{0,-60},{18,-60}},      color={255,0,255}));
  connect(bou2.ports[1], senT2InlVal.port_a) annotation (Line(points={{-140,
          -1.5},{-120,-1.5},{-120,0},{-50,0}},
                                      color={0,127,255}));
  connect(TChiWatRet.y, bou2.T_in) annotation (Line(points={{-179,20},{-172,20},
          {-172,4},{-162,4}}, color={0,0,127}));
  connect(pum2Pum.port_a, senT2OutPum.port_b)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
  connect(resPum.port_a, pum2Pum.port_b)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  connect(dpSet.y, pum2Pum.dp_in) annotation (Line(points={{-178,-30},{-90,-30},
          {-90,-20},{-70,-20},{-70,-28}}, color={0,0,127}));
  connect(senT2OutVal.port_b, pum2Val.port_a)
    annotation (Line(points={{-50,40},{-60,40}}, color={0,127,255}));
  connect(pum2Val.port_b, resVal.port_a)
    annotation (Line(points={{-80,40},{-100,40}}, color={0,127,255}));
  connect(dpSet.y, pum2Val.dp_in) annotation (Line(points={{-178,-30},{-90,-30},
          {-90,60},{-70,60},{-70,52}}, color={0,0,127}));
  connect(resVal.port_b, bou2.ports[2]) annotation (Line(points={{-120,40},{
          -140,40},{-140,-0.5}},
                              color={0,127,255}));
  connect(yEva.y, hexVal.yValIsoEva_actual) annotation (Line(points={{-179,60},
          {-6,60},{-6,17},{18,17}}, color={0,0,127}));
  connect(yEva.y, hexPum.yValIsoEva_actual) annotation (Line(points={{-179,60},
          {-6.07143,60},{-6.07143,17.1429},{-6,17.1429},{-6,-63},{18,-63}},
        color={0,0,127}));
  connect(bou2.ports[3], resPum.port_b) annotation (Line(points={{-140,0.5},{
          -140,-2},{-130,-2},{-130,-40},{-120,-40}}, color={0,127,255}));
  connect(senT2InlPum.port_a, bou2.ports[4]) annotation (Line(points={{-50,-80},
          {-140,-80},{-140,1.5}},color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-120},{220,120}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Subsystems/Validation/WatersideEconomizer.mos"
      "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer\">
Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer</a>
in a configuration where the primary flow rate is modulated by means of a
two-way valve (see <code>hexVal</code>), and in a configuration where the
primary flow rate is modulated by means of a variable speed pump
(see <code>hexPum</code>).
</p>
</html>"));
end WatersideEconomizer;
