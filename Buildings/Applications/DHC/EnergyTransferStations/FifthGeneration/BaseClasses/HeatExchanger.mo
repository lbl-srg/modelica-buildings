within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model HeatExchanger "Base subsystem with district heat exchanger"
  extends Fluid.Interfaces.PartialFourPortInterface;

  parameter Boolean have_valDis
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal
    "Nominal pressure drop on primary side of heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal
    "Nominal pressure drop on secondary side of heat exchanger"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValDis_nominal = dp1Hex_nominal / 4
    "Nominal pressure drop of primary control valve"
    annotation(Dialog(enable=have_valDis, group="Nominal condition"));
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
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side of heat exchanger"
    annotation (Dialog(group="Nominal condition"));

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
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final dp1_nominal=if have_valDis then 0 else dp1Hex_nominal,
    final dp2_nominal=dp2Hex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal)
    "Heat exchanger"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Fluid.Movers.FlowControlled_m_flow pum2Hex(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2Hex_flow_nominal,
    final dp_nominal=dp2Hex_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Secondary pump"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-60})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2Hex_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2Hex_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=m2Hex_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Pump_m_flow pum1Hex(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1Hex_flow_nominal,
    final dp_nominal=dp1Hex_nominal,
    final allowFlowReversal=allowFlowReversal1) if not have_valDis
    "District heat exchanger primary pump"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1Hex(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1Hex_flow_nominal,
    final dpValve_nominal=dpValDis_nominal,
    final dpFixed_nominal=dp1Hex_nominal) if have_valDis
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatEnt(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water entering temperature"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,40})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatLvg(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water leaving temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=m1Hex_flow_nominal) if not have_valDis
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-20,90},{-40,110}})));
equation
  if not have_valDis then
    connect(senT1HexWatLvg.port_b, port_b1)
      annotation (Line(points={{20,30},{20,60},{100,60}}, color={0,127,255}));
  else
    connect(port_a1, senT1HexWatEnt.port_a)
      annotation (Line(points={{-100,60},{-20,60},{-20,50}}, color={0,127,255}));
  end if;
  connect(uHeaRej, conHex.uHeaRej) annotation (Line(points={{-120,140},{-90,140},
          {-90,142},{-42,142}},
    color={255,0,255}));
  connect(uColRej, conHex.uColRej) annotation (Line(points={{-120,100},{-88,100},
          {-88,139},{-42,139}},
                          color={255,0,255}));
  connect(port_a2, pum2Hex.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
  connect(conHex.y2Hex, gai2.u) annotation (Line(points={{-18,128},{10,128},{10,
          100},{18,100}}, color={0,0,127}));
  connect(gai2.y, pum2Hex.m_flow_in)
    annotation (Line(points={{42,100},{80,100},{80,-48}}, color={0,0,127}));
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
  connect(conHex.y1Hex, val1Hex.y)
    annotation (Line(points={{-18,140},{60,140},{60,92}}, color={0,0,127}));
  connect(conHex.y1Hex, gai1.u) annotation (Line(points={{-18,140},{-10,140},{-10,
          100},{-18,100}}, color={0,0,127}));
  connect(gai1.y, pum1Hex.m_flow_in)
    annotation (Line(points={{-42,100},{-60,100},{-60,92}}, color={0,0,127}));
  connect(senT1HexWatEnt.T, conHex.T1HexWatEnt) annotation (Line(points={{-31,40},
          {-86,40},{-86,136},{-42,136}}, color={0,0,127}));
  connect(senT1HexWatLvg.T, conHex.T1HexWatLvg) annotation (Line(points={{9,20},
          {-84,20},{-84,133},{-42,133}}, color={0,0,127}));
  connect(senT2HexWatLvg.T, conHex.T2HexWatLvg) annotation (Line(points={{-31,-20},
          {-80,-20},{-80,127},{-42,127}}, color={0,0,127}));
  connect(senT2HexWatEnt.T, conHex.T2HexWatEnt) annotation (Line(points={{9,-40},
          {-82,-40},{-82,130},{-42,130}}, color={0,0,127}));
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
