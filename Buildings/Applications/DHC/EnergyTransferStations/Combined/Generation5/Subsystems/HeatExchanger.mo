within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Subsystems;
model HeatExchanger
  "Base subsystem for interconnection with district system based on intermediary heat exchanger"
  extends Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal=abs(QHex_flow_nominal / cp1_default /
                              (T_b1Hex_nominal - T_a1Hex_nominal)),
    final m2_flow_nominal=abs(QHex_flow_nominal / cp2_default /
                              (T_b2Hex_nominal - T_a2Hex_nominal)));
  parameter Boolean have_val1Hex
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpVal1Hex_nominal(displayUnit="Pa")=
    dp1Hex_nominal / 4
    "Nominal pressure drop of primary control valve"
    annotation(Dialog(enable=have_val1Hex, group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate (from district to building)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real spePum1HexMin(final unit="1") = 0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls", enable=not have_val1Hex));
  parameter Real yVal1HexMin(final unit="1") = 0.1
    "Minimum valve opening for temperature measurement (fractional)"
    annotation(Dialog(group="Controls", enable=have_val1Hex));
  parameter Real spePum2HexMin(final unit="1") = 0.1
    "Heat exchanger secondary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.TemperatureDifference dT2HexHeaSet
    "Heat exchanger secondary side deltaT set-point in heat rejection"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.TemperatureDifference dT2HexCooSet=
    T_b2Hex_nominal - T_a2Hex_nominal
    "Heat exchanger secondary side deltaT set-point in cold rejection"
    annotation (Dialog(group="Controls"));
  parameter Real k(final unit="1/K") = 0.1
    "Gain of controller"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.Time Ti(min=0) = 60
    "Time constant of integrator block"
    annotation (Dialog(group="Controls"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y2Sup
    "Control signal for secondary side (from supervisory)" annotation (
      Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(final unit="W")
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  // COMPONENTS
  Controls.HeatExchanger conHex(
    final have_val1Hex=have_val1Hex,
    final spePum1HexMin=spePum1HexMin,
    final spePum2HexMin=spePum2HexMin,
    final dT2HexHeaSet=dT2HexHeaSet,
    final dT2HexCooSet=dT2HexCooSet,
    final k=k,
    final Ti=Ti)
    "District heat exchanger loop controller"
    annotation (Placement(transformation(extent={{-40,122},{-20,142}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final dp1_nominal=if have_val1Hex then 0 else dp1Hex_nominal,
    final dp2_nominal=dp2Hex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=QHex_flow_nominal,
    final T_a1_nominal=T_a1Hex_nominal,
    final T_a2_nominal=T_a2Hex_nominal)
    "Heat exchanger"
    annotation (Placement(
      transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={0,0})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pum2Hex(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2Hex_nominal,
    final allowFlowReversal=allowFlowReversal2) "Secondary pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-60})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={20,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=m2_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pum1Hex(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1Hex_nominal,
    final allowFlowReversal=allowFlowReversal1) if not have_val1Hex
    "District heat exchanger primary pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1Hex(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpVal1Hex_nominal,
    final dpFixed_nominal=dp1Hex_nominal) if have_val1Hex
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatEnt(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water entering temperature"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,40})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatLvg(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water leaving temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=m1_flow_nominal) if not have_val1Hex
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-20,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=if have_val1Hex then 1 else 2)
    "Total pump power"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
protected
  final parameter Medium1.ThermodynamicState sta1_default = Medium1.setState_pTX(
    T=Medium1.T_default,
    p=Medium1.p_default,
    X=Medium1.X_default[1:Medium1.nXi])
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(sta1_default)
    "Specific heat capacity of the fluid";
  final parameter Medium2.ThermodynamicState sta2_default = Medium2.setState_pTX(
    T=Medium2.T_default,
    p=Medium2.p_default,
    X=Medium2.X_default[1:Medium2.nXi])
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium1.specificHeatCapacityCp(sta2_default)
    "Specific heat capacity of the fluid";
equation
  if not have_val1Hex then
    connect(senT1HexWatLvg.port_b, port_b1)
      annotation (Line(points={{20,30},{20,60},{100,60}}, color={0,127,255}));
  else
    connect(port_a1, senT1HexWatEnt.port_a)
      annotation (Line(points={{-100,60},{-20,60},{-20,50}}, color={0,127,255}));
  end if;
  connect(port_a2, pum2Hex.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
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
    annotation (Line(points={{-18,138},{60,138},{60,92}}, color={0,0,127}));
  connect(conHex.y1Hex, gai1.u) annotation (Line(points={{-18,138},{-10,138},{
          -10,100},{-18,100}},
                           color={0,0,127}));
  connect(gai1.y, pum1Hex.m_flow_in)
    annotation (Line(points={{-42,100},{-60,100},{-60,92}}, color={0,0,127}));
  connect(senT2HexWatLvg.T, conHex.T2HexWatLvg) annotation (Line(points={{-31,-20},
          {-80,-20},{-80,124},{-42,124}}, color={0,0,127}));
  connect(senT2HexWatEnt.T, conHex.T2HexWatEnt) annotation (Line(points={{9,-40},
          {-82,-40},{-82,129},{-42,129}}, color={0,0,127}));
  connect(pum1Hex.P, totPPum.u[2]) annotation (Line(points={{-49,89},{0,89},{0,40},
          {40,40},{40,0},{48,0}}, color={0,0,127}));
  connect(pum2Hex.P, totPPum.u[1]) annotation (Line(points={{69,-51},{40,-51},{40,
          0},{48,0}}, color={0,0,127}));
  connect(totPPum.y, PPum)
    annotation (Line(points={{72,0},{120,0}}, color={0,0,127}));
  connect(yValIso, conHex.yValIso) annotation (Line(points={{-120,100},{-96,100},
          {-96,135},{-42,135}},color={0,0,127}));
  connect(conHex.y2Hex, gai2.u) annotation (Line(points={{-18,126},{0,126},{0,
          100},{18,100}}, color={0,0,127}));
  connect(y2Sup, conHex.y2Sup) annotation (Line(points={{-120,140},{-60,140},{-60,
          140},{-42,140}},     color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,
            160}})));
end HeatExchanger;
