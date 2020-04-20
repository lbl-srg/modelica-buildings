within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model HeatExchanger "Base subsystem with district heat exchanger"
  extends Fluid.Interfaces.PartialFourPort(
    allowFlowReversal=false);
  parameter Modelica.SIunits.TemperatureDifference dTGeo
    "Temperature difference between entering and leaving water of the borefield";
  parameter Modelica.SIunits.Length xBorFie
    "Borefield length";
  parameter Modelica.SIunits.Length yBorFie
    "Borefield width";
  parameter Modelica.SIunits.Pressure dpBorFie_nominal
    "Pressure losses for the entire borefield";
  parameter Modelica.SIunits.Radius rTub =  0.05
   "Outer radius of the tubes";
  final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal=
    m_flow_nominal / nBorHol
    "Borehole nominal mass flow rate";
  final parameter Modelica.SIunits.Length dBorHol = 5
    "Distance between two boreholes";
  final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
    "Number of boreholes in x-direction";
  final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
    "Number of boreholes in y-direction";
  final parameter Integer nBorHol = nXBorHol*nYBorHol
   "Number of boreholes";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Controls.HeatExchanger conHex "District heat exchanger loop control"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    use_Q_flow_nominal=false,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=false,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=dpHex_nominal,
    eps_nominal=eps_nominal,
    dp2_nominal=dpHex_nominal,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mHex_flow_nominal)
    "District heat exchanger"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));

  Fluid.Movers.FlowControlled_m_flow pum2Hex(
    redeclare final package Medium = Medium,
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
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatLvg
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=m2Hex_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{32,110},{52,130}})));
  Fluid.Movers.FlowControlled_m_flow pum1Hex(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10) "District heat exchanger primary pump" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-80,60})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
equation
  connect(uHeaRej, conHex.uHeaRej) annotation (Line(points={{-120,140},{-80,140},
          {-80,126},{-12,126}}, color={255,0,255}));
  connect(uColRej, conHex.uColRej) annotation (Line(points={{-120,100},{-80,100},
          {-80,122},{-12,122}}, color={255,0,255}));
  connect(port_a2, pum2Hex.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
  connect(hex.port_a2, senT2HexWatEnt.port_b) annotation (Line(points={{10,-6},{
          20,-6},{20,-60},{30,-60}}, color={0,127,255}));
  connect(senT2HexWatEnt.port_a, pum2Hex.port_b)
    annotation (Line(points={{50,-60},{70,-60}}, color={0,127,255}));
  connect(hex.port_b2, senT2HexWatLvg.port_a) annotation (Line(points={{-10,-6},
          {-20,-6},{-20,-60},{-30,-60}}, color={0,127,255}));
  connect(senT2HexWatLvg.port_b, port_b2)
    annotation (Line(points={{-50,-60},{-100,-60}}, color={0,127,255}));
  connect(senT2HexWatLvg.T, conHex.T2HexWatLvg) annotation (Line(points={{-40,-49},
          {-40,104},{-64,104},{-64,114},{-12,114}}, color={0,0,127}));
  connect(senT2HexWatEnt.T, conHex.T2HexWatEnt) annotation (Line(points={{40,-49},
          {40,100},{-68,100},{-68,118},{-12,118}}, color={0,0,127}));
  connect(conHex.yPum2Hex, gai.u)
    annotation (Line(points={{12,120},{30,120}}, color={0,0,127}));
  connect(gai.y, pum2Hex.m_flow_in)
    annotation (Line(points={{54,120},{80,120},{80,-48}}, color={0,0,127}));
  connect(port_a1, pum1Hex.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(pum1Hex.port_b, hex.port_a1) annotation (Line(points={{-70,60},{-20,
          60},{-20,6},{-10,6}}, color={0,127,255}));
  connect(hex.port_b1, val.port_a) annotation (Line(points={{10,6},{20,6},{20,
          60},{50,60}}, color={0,127,255}));
  connect(val.port_b, port_b1)
    annotation (Line(points={{70,60},{100,60}}, color={0,127,255}));
  annotation (
  defaultComponentName="bor",
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
