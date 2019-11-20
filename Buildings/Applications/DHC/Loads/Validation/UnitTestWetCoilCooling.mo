within Buildings.Applications.DHC.Loads.Validation;
model UnitTestWetCoilCooling
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Fluid in the pipes";
  package Medium2 = Buildings.Media.Air "Moist air";
  parameter Modelica.SIunits.HeatFlowRate Q_flow2_nominal = -1000
    "Heat flow rate transferred to the load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal = 1
    "Load side mass flow rate at nominal conditions";
  parameter Modelica.SIunits.Temperature T1_a_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(7)
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T1_b_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(12)
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T2_a_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(20)
    "Load side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T2_b_nominal(displayUnit="degC")=
    T2_a_nominal + Q_flow2_nominal / m_flow2_nominal / cp2_nominal;  // In case of purely sensible heat transfer.
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal = abs(
    Q_flow2_nominal / cp1_nominal / (T1_a_nominal - T1_b_nominal))
    "Source side mass flow rate at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(Medium1.p_default, T1_a_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T2_a_nominal))
    "Load side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMin_nominal=
      min(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMax_nominal=
      max(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
    "Maximum capacity flow rate at nominal conditions";
  parameter Real Z = CMin_nominal / CMax_nominal
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  parameter Modelica.SIunits.ThermalConductance UA_nominal=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=abs(Q_flow2_nominal / (CMin_nominal * (T1_a_nominal - T2_a_nominal))),
    Z=Z,
    flowRegime=Integer(hexCon)) * CMin_nominal
    "Thermal conductance at nominal conditions";
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1, nPorts=1)
              "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-40})));
  Buildings.Fluid.Sources.MassFlowSource_T sup1(
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    m_flow=hexWetNtu.m1_flow_nominal,
    T=T1_a_nominal,
    nPorts=1) "Supply for heating water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,-40})));
  Buildings.Fluid.Sources.MassFlowSource_T sup2(
    redeclare package Medium = Medium2,
    m_flow=m_flow2_nominal,
    T=T2_a_nominal,
    nPorts=1) "Supply"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,40})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = Medium2, nPorts=1) "Sink"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ySou(
    amplitude=0.5,
    freqHz=0.001,
    phase=1.5707963267949,
    offset=0.5,
    startTime=1000)
                annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Fluid.HeatExchangers.WetEffectivenessNTU_Fuzzy hexWetNtu(
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    final configuration=hexCon,
    final m1_flow_nominal=m_flow1_nominal,
    final m2_flow_nominal=m_flow2_nominal,
    each final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UA_nominal,
    each final allowFlowReversal1=false,
    each final allowFlowReversal2=false) annotation (Placement(transformation(extent={{18,10},{38,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=hexWetNtu.m1_flow_nominal)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi annotation (Placement(transformation(extent={{-92,-70},{-72,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time < 1000)
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
equation
  connect(sup2.ports[1], hexWetNtu.port_a2)
    annotation (Line(points={{80,40},{60,40},{60,6},{38,6}}, color={0,127,255}));
  connect(hexWetNtu.port_b1, sin1.ports[1])
    annotation (Line(points={{38,-6},{60,-6},{60,-40},{80,-40}}, color={0,127,255}));
  connect(hexWetNtu.port_b2, sin2.ports[1])
    annotation (Line(points={{18,6},{0,6},{0,40},{-140,40}},    color={0,127,255}));
  connect(sup1.ports[1], hexWetNtu.port_a1)
    annotation (Line(points={{-8,-40},{0,-40},{0,-6},{18,-6}},color={0,127,255}));
  connect(gai.y, sup1.m_flow_in) annotation (Line(points={{-38,-60},{-38,-32},{-30,-32}}, color={0,0,127}));
  connect(ySou.y, swi.u3) annotation (Line(points={{-138,-90},{-100,-90},{-100,-68},{-94,-68}}, color={0,0,127}));
  connect(gai.u, swi.y) annotation (Line(points={{-62,-60},{-70,-60}}, color={0,0,127}));
  connect(con.y, swi.u1) annotation (Line(points={{-138,-30},{-100,-30},{-100,-52},{-94,-52}}, color={0,0,127}));
  connect(swi.u2, booleanExpression.y) annotation (Line(points={{-94,-60},{-139,-60}}, color={255,0,255}));
  annotation (
  experiment(
    StopTime=2000),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{120,60}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Validation/UnitTestWetCoilCooling.mos"
        "Simulate and plot"));
end UnitTestWetCoilCooling;
