within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model HeatExchanger "Base subsystem with district heat exchanger"
  extends Fluid.Interfaces.PartialFourPort;

  redeclare replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium model on district side of heat exchanger"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  redeclare replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium model on building side of heat exchanger"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean have_valDis
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side of heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side of heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side of heat exchanger"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side of heat exchanger"
    annotation (Dialog(group="Nominal conditions"));

  final Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate on district side of heat exchanger";
  final Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate on building side of heat exchanger";

  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  // COMPONENTS
  Controls.HeatExchanger conHex "District heat exchanger loop control"
    annotation (Placement(transformation(extent={{-40,124},{-20,144}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui,
    final dp1_nominal=if have_valDis then 0 else dp1Hex_nominal,
    final dp2_nominal=dp2Hex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal)
    "District heat exchanger"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Fluid.Movers.FlowControlled_m_flow pum2Hex(
    redeclare final package Medium = MediumBui,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10) "District heat exchanger secondary pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-60})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatEnt
    "Heat exchanger secondary water entering temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatLvg
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=m2Hex_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{32,130},{52,150}})));
  Fluid.Movers.FlowControlled_m_flow pum1Hex(
    redeclare final package Medium = MediumDis,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10) if not have_valDis
    "District heat exchanger primary pump"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1Hex(
    redeclare final package Medium = MediumDis,
    final m_flow_nominal=mDis_flow_nominal,
    dpValve_nominal=dp2Hex_nominal/9,
    final dpFixed_nominal=dp2Hex_nominal) if have_valDis
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatEnt
    "Heat exchanger primary water entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,40})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatLvg
    "Heat exchanger primary water leaving temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,20})));
equation
  if not have_valDis then
    connect(senT1HexWatLvg.port_b, port_b1)
      annotation (Line(points={{20,30},{20,60},{100,60}}, color={0,127,255}));
  else
    connect(port_a1, senT1HexWatEnt.port_a)
      annotation (Line(points={{-100,60},{-20,60},{-20,50}}, color={0,127,255}));
  end if;
  connect(uHeaRej, conHex.uHeaRej) annotation (Line(points={{-120,140},{-42,140}},
    color={255,0,255}));
  connect(uColRej, conHex.uColRej) annotation (Line(points={{-120,100},{-80,100},
    {-80,136},{-42,136}}, color={255,0,255}));
  connect(port_a2, pum2Hex.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
  connect(conHex.yPum2Hex, gai.u)
    annotation (Line(points={{-18,134},{22,134},{22,140},{30,140}},
      color={0,0,127}));
  connect(gai.y, pum2Hex.m_flow_in)
    annotation (Line(points={{54,140},{80,140},{80,-48}}, color={0,0,127}));
  connect(port_a1, pum1Hex.port_a)
    annotation (Line(points={{-100,60},{-94,60},{-94,80},{-70,80}},
      color={0,127,255}));
  connect(val1Hex.port_b, port_b1)
    annotation (Line(points={{70,80},{90,80},{90,60},{100,60}},
      color={0,127,255}));
  connect(hex.port_b1, senT1HexWatLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,10}}, color={0,127,255}));
  connect(hex.port_b2, senT2HexWatLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-10}}, color={0,127,255}));
  connect(pum2Hex.port_b, senT2HexWatEnt.port_a)
    annotation (Line(points={{70,-60},{20,-60},{20,-50}}, color={0,127,255}));
  connect(senT2HexWatEnt.port_b, hex.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}}, color={0,127,255}));
  connect(senT2HexWatLvg.port_b, port_b2) annotation (Line(points={{-20,-30},{-20,
    -60},{-100,-60}}, color={0,127,255}));
  connect(senT1HexWatEnt.port_b, hex.port_a1)
    annotation (Line(points={{-20,30},{-20,6},{-10,6}}, color={0,127,255}));
  connect(pum1Hex.port_b, senT1HexWatEnt.port_a)
    annotation (Line(points={{-50,80},{-20,80},{-20,50}}, color={0,127,255}));
  connect(val1Hex.port_a, senT1HexWatLvg.port_b)
    annotation (Line(points={{50,80},{20,80},{20,30}}, color={0,127,255}));
  annotation (
  defaultComponentName="hex",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
   graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})));
end HeatExchanger;
