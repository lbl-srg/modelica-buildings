within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Validation;
model HeatExchanger
  "Validation of the base subsystem model with district heat exchanger"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Primary boundary conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,-62})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Secondary boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-62})));
  Modelica.Blocks.Sources.BooleanExpression uHeaRej(
    y=time >= 3000)
    "Heat rejection enable signal"
    annotation (Placement(transformation(extent={{-230,110},{-210,130}})));
  Modelica.Blocks.Sources.BooleanExpression uEnaColRej(
    y=time >= 1000 and time < 3000)
    "Cold rejection enable signal"
    annotation (Placement(transformation(extent={{-230,90},{-210,110}})));
  Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.HeatExchanger hexPum(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    show_T=true,
    conCon=Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration.Pump,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    QHex_flow_nominal=1E6,
    T_a1Hex_nominal=281.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=279.15,
    dT1HexSet=abs(
      hexPum.T_b1Hex_nominal-hexPum.T_a1Hex_nominal) .* {1+1/3,1})
    "Heat exchanger with primary pump"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Fluid.Sensors.TemperatureTwoPort senT1OutPum(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary outlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={70,-80})));
  Fluid.Sensors.TemperatureTwoPort senT1InlPum(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary inlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={70,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2OutPum(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexPum.m1_flow_nominal)
    "Secondary outlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-70,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2InlPum(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexPum.m1_flow_nominal)
    "Secondary inlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-70,-80})));
  Fluid.Sources.Boundary_pT bou2Val(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Secondary boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,20})));
  Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.HeatExchanger hexVal(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    show_T=true,
    conCon=Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration.TwoWayValve,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    QHex_flow_nominal=1E6,
    T_a1Hex_nominal=281.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=279.15,
    dT1HexSet=abs(
      hexVal.T_b1Hex_nominal-hexVal.T_a1Hex_nominal) .* {1+1/3,1})
    "Heat exchanger with primary control valve"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Fluid.Sources.Boundary_pT bou1Val(
    redeclare package Medium=Medium,
    p=Medium.p_default+30E3,
    use_T_in=true,
    nPorts=1)
    "Primary boundary conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={112,40})));
  Fluid.Sources.Boundary_pT bou1Val1(
    redeclare package Medium=Medium,
    nPorts=1)
    "Primary boundary conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,0})));
  Fluid.Sensors.TemperatureTwoPort senT1InlVal(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary inlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={70,40})));
  Fluid.Sensors.TemperatureTwoPort senT1OutVal(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary outlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={70,0})));
  Fluid.Sensors.TemperatureTwoPort senT2OutVal(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexVal.m1_flow_nominal)
    "Secondary outlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-70,40})));
  Fluid.Sensors.TemperatureTwoPort senT2InlVal(
    redeclare final package Medium=Medium,
    m_flow_nominal=hexVal.m1_flow_nominal)
    "Secondary inlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-70,0})));
  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={50,20})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Modelica.Blocks.Sources.RealExpression yValIsoCon(
    y=if time >= 2500 then
        1
      else
        0)
    "Condenser loop isolation valve opening"
    annotation (Placement(transformation(extent={{-230,70},{-210,90}})));
  Modelica.Blocks.Sources.RealExpression yValIsoEva(
    y=if time >= 500 then
        1
      else
        0)
    "Evaporator loop isolation valve opening"
    annotation (Placement(transformation(extent={{-230,50},{-210,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=0.5,
    freqHz=1e-3,
    offset=0.5)
    "Control signal"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Modelica.Blocks.Sources.TimeTable TColVal(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,6;
      2,6;
      3,16;
      4.5,16;
      5,6;
      10,6],
    timeScale=1000,
    offset=273.15)
    "Cold side temperature values"
    annotation (Placement(transformation(extent={{-230,-50},{-210,-30}})));
  Modelica.Blocks.Sources.TimeTable THotVal(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,45;
      2,45;
      3,55;
      4.5,55;
      5,25;
      10,25],
    timeScale=1000,
    offset=273.15)
    "Hot side temperature values"
    annotation (Placement(transformation(extent={{-230,-90},{-210,-70}})));
  Modelica.Blocks.Sources.TimeTable TDisVal(
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
    offset=273.15)
    "District water temperature values"
    annotation (Placement(transformation(extent={{170,-70},{150,-50}})));
equation
  connect(swi.y,bou2.T_in)
    annotation (Line(points={{-138,-60},{-130,-60},{-130,-58},{-122,-58}},color={0,0,127}));
  connect(uEnaColRej.y,swi.u2)
    annotation (Line(points={{-209,100},{-180,100},{-180,40},{-160,40},{-160,-40},{-170,-40},{-170,-60},{-162,-60}},color={255,0,255}));
  connect(hexPum.port_b1,senT1OutPum.port_a)
    annotation (Line(points={{10,-54},{40,-54},{40,-80},{60,-80}},color={0,127,255}));
  connect(senT1OutPum.port_b,bou1.ports[1])
    annotation (Line(points={{80,-80},{100,-80},{100,-60}},color={0,127,255}));
  connect(hexPum.port_a1,senT1InlPum.port_b)
    annotation (Line(points={{-10,-54},{-20,-54},{-20,-40},{60,-40}},color={0,127,255}));
  connect(senT1InlPum.port_a,bou1.ports[2])
    annotation (Line(points={{80,-40},{100,-40},{100,-64}},color={0,127,255}));
  connect(hexPum.port_b2,senT2OutPum.port_a)
    annotation (Line(points={{-10,-66},{-40,-66},{-40,-40},{-60,-40}},color={0,127,255}));
  connect(senT2OutPum.port_b,bou2.ports[1])
    annotation (Line(points={{-80,-40},{-100,-40},{-100,-60}},color={0,127,255}));
  connect(bou2.ports[2],senT2InlPum.port_a)
    annotation (Line(points={{-100,-64},{-100,-80},{-80,-80}},color={0,127,255}));
  connect(senT2InlPum.port_b,hexPum.port_a2)
    annotation (Line(points={{-60,-80},{20,-80},{20,-66},{10,-66}},color={0,127,255}));
  connect(swi.y,bou2Val.T_in)
    annotation (Line(points={{-138,-60},{-130,-60},{-130,24},{-122,24}},color={0,0,127}));
  connect(hexVal.port_a1,senT1InlVal.port_b)
    annotation (Line(points={{-10,26},{-20,26},{-20,40},{60,40}},color={0,127,255}));
  connect(senT1InlVal.port_a,bou1Val.ports[1])
    annotation (Line(points={{80,40},{102,40}},color={0,127,255}));
  connect(bou1Val1.ports[1],senT1OutVal.port_b)
    annotation (Line(points={{100,0},{80,0}},color={0,127,255}));
  connect(senT1OutVal.port_a,hexVal.port_b1)
    annotation (Line(points={{60,0},{30,0},{30,26},{10,26}},color={0,127,255}));
  connect(hexVal.port_a2,senT2InlVal.port_b)
    annotation (Line(points={{10,14},{20,14},{20,0},{-60,0}},color={0,127,255}));
  connect(senT2InlVal.port_a,bou2Val.ports[1])
    annotation (Line(points={{-80,0},{-100,0},{-100,22}},color={0,127,255}));
  connect(bou2Val.ports[2],senT2OutVal.port_b)
    annotation (Line(points={{-100,18},{-100,40},{-80,40}},color={0,127,255}));
  connect(senT2OutVal.port_a,hexVal.port_b2)
    annotation (Line(points={{-60,40},{-40,40},{-40,14},{-10,14}},color={0,127,255}));
  connect(hexVal.port_a1,senRelPre.port_a)
    annotation (Line(points={{-10,26},{-20,26},{-20,40},{50,40},{50,30}},color={0,127,255}));
  connect(senRelPre.port_b,senT1OutVal.port_a)
    annotation (Line(points={{50,10},{50,0},{60,0}},color={0,127,255}));
  connect(uEnaColRej.y,or2.u2)
    annotation (Line(points={{-209,100},{-180,100},{-180,92},{-162,92}},color={255,0,255}));
  connect(uHeaRej.y,or2.u1)
    annotation (Line(points={{-209,120},{-170,120},{-170,100},{-162,100}},color={255,0,255}));
  connect(yValIsoCon.y,hexVal.yValIso_actual[1])
    annotation (Line(points={{-209,80},{-32,80},{-32,17},{-12,17}},color={0,0,127}));
  connect(yValIsoCon.y,hexPum.yValIso_actual[1])
    annotation (Line(points={{-209,80},{-32,80},{-32,-63},{-12,-63}},color={0,0,127}));
  connect(yValIsoEva.y,hexVal.yValIso_actual[2])
    annotation (Line(points={{-209,60},{-36,60},{-36,19},{-12,19}},color={0,0,127}));
  connect(yValIsoEva.y,hexPum.yValIso_actual[2])
    annotation (Line(points={{-209,60},{-36,60},{-36,-61},{-12,-61}},color={0,0,127}));
  connect(or2.y,swi1.u2)
    annotation (Line(points={{-138,100},{-62,100}},color={255,0,255}));
  connect(sin1.y,swi1.u1)
    annotation (Line(points={{-98,160},{-80,160},{-80,108},{-62,108}},color={0,0,127}));
  connect(zer.y,swi1.u3)
    annotation (Line(points={{-98,120},{-90,120},{-90,92},{-62,92}},color={0,0,127}));
  connect(swi1.y,hexVal.u)
    annotation (Line(points={{-38,100},{-28,100},{-28,22},{-12,22}},color={0,0,127}));
  connect(swi1.y,hexPum.u)
    annotation (Line(points={{-38,100},{-28,100},{-28,-58},{-12,-58}},color={0,0,127}));
  connect(TColVal.y,swi.u1)
    annotation (Line(points={{-209,-40},{-180,-40},{-180,-52},{-162,-52}},color={0,0,127}));
  connect(THotVal.y,swi.u3)
    annotation (Line(points={{-209,-80},{-180,-80},{-180,-68},{-162,-68}},color={0,0,127}));
  connect(TDisVal.y,bou1.T_in)
    annotation (Line(points={{149,-60},{140,-60},{140,-58},{122,-58}},color={0,0,127}));
  connect(TDisVal.y,bou1Val.T_in)
    annotation (Line(points={{149,-60},{140,-60},{140,44},{124,44}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-240,-180},{240,180}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Generation5/Subsystems/Validation/HeatExchanger.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.HeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.HeatExchanger</a>
in a configuration where the primary flow rate is modulated by means of a
two-way valve (see <code>hexVal</code>), and in a configuration where the
primary flow rate is modulated by means of a variable speed pump
(see <code>hexPum</code>).
</p>
</html>"));
end HeatExchanger;
