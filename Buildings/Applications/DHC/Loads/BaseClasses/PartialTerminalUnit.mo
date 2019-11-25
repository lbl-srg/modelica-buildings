within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Prtial model for HVAC terminal unit"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow1_nominal,
    final allowFlowReversal=false);
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Buildings.Media.Air
    "Load side medium"
    annotation(choices(
      choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa") = 0
    "Source side pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal(
    min=0, displayUnit="Pa") = 0
    "Load side pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
   parameter Modelica.SIunits.Temperature T_b1_nominal(
     min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
     "Source side return temperature at nominal conditions"
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
    "Sensible thermal power exchanged with the load i at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
// Computed parameters
  final parameter Modelica.SIunits.MassFlowRate m_flow1_nominal=abs(
    Q_flow_nominal / cp1_nominal / (T_a1_nominal - T_b1_nominal))
    "Source side total mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.ThermalConductance UA_nominal=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=Q_flow_nominal / abs(CMin_nominal * (T_a1_nominal - T_a2_nominal)),
      Z=Z,
      flowRegime=Integer(hexCon)) * CMin_nominal
    "Thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSet "Setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,200}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow1Req(
    quantity="MassFlowRate") "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,180},{140,220}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(min=0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(
      extent={{90,70},{110,90}}),     iconTransformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(max=0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,70},{-110,90}}),
      iconTransformation(extent={{-90,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow1Act(quantity="HeatFlowRate")
    "Heat flow rate transferred to the source"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiNom(k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexCon,
    final m1_flow_nominal=m_flow1_nominal,
    final m2_flow_nominal=m_flow2_nominal,
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
  annotation (Placement(transformation(extent={{-10,16},{10,-4}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=hex.Q1_flow)
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort THexInl(redeclare final package Medium = Medium2)
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
protected
  parameter Modelica.SIunits.ThermalConductance CMin_nominal=
    if abs(m_flow2_nominal) < Modelica.Constants.eps then
      m_flow1_nominal * cp1_nominal else
      min(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMax_nominal=
    if abs(m_flow2_nominal) < Modelica.Constants.eps then
      Modelica.Constants.inf else
      max(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
    "Maximum capacity flow rate at nominal conditions";
  parameter Real Z=if abs(m_flow2_nominal) < Modelica.Constants.eps then 0 else
      CMin_nominal / CMax_nominal
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(Medium1.p_default, T_a1_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T_a2_nominal))
    "Load side specific heat capacity at nominal conditions";
equation
  connect(gaiNom.y, m_flow1Req) annotation (Line(points={{82,200},{120,200}}, color={0,0,127}));
  connect(port_a, hex.port_a1) annotation (Line(points={{-100,0},{-10,0}},                   color={0,127,255}));
  connect(hex.port_b1, port_b) annotation (Line(points={{10,0},{100,0}},                 color={0,127,255}));
  connect(Q_flow1Act, realExpression.y) annotation (Line(points={{120,-140},{81,-140}}, color={0,0,127}));
  connect(hex.port_a2, THexInl.port_b) annotation (Line(points={{10,12},{20,12},{20,20}},
                                                                                  color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95})}),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{100,220}})));
end PartialTerminalUnit;
