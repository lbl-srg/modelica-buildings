within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterWrapped
    "Wrapped heat pump water heater model"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
  final m1_flow_nominal=mAir_flow_nominal,
  final m2_flow_nominal=mWat_flow_nominal,
  redeclare package Medium1 = MediumAir,
  redeclare package Medium2 = MediumTan);

  package MediumAir = Buildings.Media.Air "Medium in the air";
  package MediumTan = Buildings.Media.Water "Medium in the tank";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of air"
  annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal
    "Nominal mass flow rate of domestic hot water"
  annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
  annotation(Dialog(group="Nominal conditions"));
  parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi(nSta=1)
    "Water heating coil data"
    annotation (Placement(transformation(extent={{56,20},{76,40}})));
  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterHeaterData
    datWT "Water tank data"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{24,20},{44,40}})),
      Dialog(group="Fan parameters"));

  Modelica.Blocks.Math.BooleanToReal yMov "Boolean to real for fan signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation)" annotation (Placement(
        transformation(extent={{-10,-90},{10,-70}}), iconTransformation(extent={
            {-10,-90},{10,-70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)" annotation (Placement(
        transformation(extent={{50,-10},{70,10}}), iconTransformation(extent={{50,
            -10},{70,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)" annotation (Placement(
        transformation(extent={{-10,70},{10,90}}), iconTransformation(extent={{-10,
            70},{10,90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea[datWT.nSegCon]
    "Heat input to the hot water tank"
    annotation (Placement(transformation(extent={{-26,-36},{-6,-16}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature tank sensor"
    annotation (Placement(transformation(extent={{-30,-56},{-50,-36}})));
  Modelica.Blocks.Math.Gain gai_m_flow(k=mAir_flow_nominal)
    "Nominal mass flow rate"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Heat pump water heater on/off signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TWat(
    final unit="K",
    displayUnit="degC") "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{100,-20},{120,0}}),
        iconTransformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Math.Add add "Addition of coil power and fan power"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Blocks.Sources.RealExpression QCon[datWT.nSegCon](y={-
        sinSpeDXCoo.dxCoi.Q_flow*datWT.conHeaFraSca[i] for i in 1:datWT.nSegCon})
    "Condenser heat for each node"
    annotation (Placement(transformation(extent={{-62,-36},{-42,-16}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TConWat[datWT.nSegCon]
    "Water temperatures that the condenser see"
    annotation (Placement(transformation(extent={{-30,-80},{-50,-60}})));
  Modelica.Blocks.Math.MultiSum TConWatAve(k=datWT.conHeaFraSca, nu=datWT.nSegCon)
    "Weighted average condenser water temperature"
    annotation (Placement(transformation(extent={{-54,-76},{-66,-64}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[datWT.nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed sinSpeDXCoo(
    datCoi=datCoi,
    redeclare package Medium = MediumAir,
    from_dp=true,
    dp_nominal=dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Fluid.Storage.StratifiedEnhanced tan(
    redeclare package Medium = MediumTan,
    m_flow_nominal=mWat_flow_nominal,
    VTan=datWT.VTan,
    hTan=datWT.hTan,
    dIns=datWT.dIns,
    kIns=datWT.kIns,
    nSeg=datWT.nSeg) "Water tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-26})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumAir,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=fanPer,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpAir_nominal)
    annotation (Placement(transformation(extent={{24,50},{44,70}})));


equation
  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(fan.port_b, port_b1)
    annotation (Line(points={{44,60},{100,60}}, color={0,127,255}));
  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-30,60},{24,60}}, color={0,127,255}));
  connect(port_a2, tan.port_b)
    annotation (Line(points={{100,-60},{36,-60},{36,-36}}, color={0,127,255}));
  connect(tan.port_a, port_b2) annotation (Line(points={{36,-16},{36,-10},{-80,-10},
          {-80,-60},{-100,-60}}, color={0,127,255}));
  connect(TSen.port, tan.heaPorVol[datWT.segTemSen]) annotation (Line(points={{-30,
          -46},{14,-46},{14,-26},{36,-26}}, color={191,0,0}));
  connect(tan.heaPorBot, heaPorBot) annotation (Line(points={{38,-33.4},{32,-33.4},
          {32,-80},{0,-80}}, color={191,0,0}));
  connect(tan.heaPorSid, heaPorSid) annotation (Line(points={{41.6,-26},{70,-26},
          {70,0},{60,0}}, color={191,0,0}));
  connect(tan.heaPorTop, heaPorTop) annotation (Line(points={{38,-18.6},{38,14},
          {0,14},{0,80}}, color={191,0,0}));
  connect(yMov.y, gai_m_flow.u)
    annotation (Line(points={{-39,20},{-32,20}},
                                              color={0,0,127}));
  connect(gai_m_flow.y, fan.m_flow_in) annotation (Line(points={{-9,20},{14,20},
          {14,76},{34,76},{34,72}}, color={0,0,127}));
  connect(TSen.T, TWat) annotation (Line(points={{-51,-46},{-70,-46},{-70,-10},
          {110,-10}},
               color={0,0,127}));
  connect(on, yMov.u) annotation (Line(points={{-120,0},{-76,0},{-76,20},{-62,
          20}},
        color={255,0,255}));
  connect(on, sinSpeDXCoo.on) annotation (Line(points={{-120,0},{-80,0},{-80,68},
          {-51,68}}, color={255,0,255}));
  connect(add.y, P) annotation (Line(points={{91,-40},{110,-40}}, color={0,0,127}));
  connect(add.u1, fan.P) annotation (Line(points={{68,-34},{48,-34},{48,69},{45,
          69}}, color={0,0,127}));
  connect(add.u2, sinSpeDXCoo.P) annotation (Line(points={{68,-46},{8,-46},{8,
          69},{-29,69}}, color={0,0,127}));
  connect(port_b2, port_b2) annotation (Line(points={{-100,-60},{-92,-60},{-92,
          -60},{-100,-60}}, color={0,127,255}));
  connect(hea.port, tan.heaPorVol[datWT.segTop:datWT.segBot])
    annotation (Line(points={{-6,-26},{36,-26}}, color={191,0,0}));
  connect(heaPorTop, heaPorTop)
    annotation (Line(points={{0,80},{0,80}}, color={191,0,0}));
  connect(QCon.y, hea.Q_flow)
    annotation (Line(points={{-41,-26},{-26,-26}}, color={0,0,127}));
  connect(TConWat.port, tan.heaPorVol[datWT.segTop:datWT.segBot]) annotation (
      Line(points={{-30,-70},{24,-70},{24,-26},{36,-26}}, color={191,0,0}));
  connect(TConWatAve.u, TConWat.T)
    annotation (Line(points={{-54,-70},{-51,-70}}, color={0,0,127}));
  connect(TConWatAve.y, sinSpeDXCoo.TOut) annotation (Line(points={{-67.02,-70},
          {-78,-70},{-78,63},{-51,63}}, color={0,0,127}));
  connect(tan.heaPorVol, heaPorVol) annotation (Line(points={{36,-26},{20,-26},{
          20,0},{0,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -80},{100,80}}),                                    graphics={
        Rectangle(
          extent={{-40,60},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{40,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,68},{50,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-60},{50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-40,68},{-50,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    experiment(
      StopTime=10800,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>This is a model of a heat pump water heater with wrapped condenser for thermal energy storage based on the EnergyPlus model WaterHeater:HeatPump:WrappedCondenser. </p>
<p>The system model is composed of the following component model: (1) A stratified water tank (2) A single speed wrapped water heating coil (3) A supply fan. </p>
<p>The following assumptions are made based on the EnergyPlus source codes:</p>
<ul>
<li>The condenser temperature of the water heating coil is the weighted average temperatures of the water tank nodes that the wrapped condenser coil sees.</li>
<li>The heat flow fraction into each tank node the condenser coil sees is assumed to be equal to the ratio of the condenser coil height in the tank node.</li>
</ul>
<p>Please note that the performance curve of the EIR for fluid temperatures needs to be given in this model while the EnergyPlus model requires the COP curve for fluid temperatures as the counterpart.</p>
</html>"));
end HeatPumpWaterHeaterWrapped;
