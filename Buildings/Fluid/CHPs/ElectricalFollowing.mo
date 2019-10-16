within Buildings.Fluid.CHPs;
model ElectricalFollowing
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final vol(V=per.MCcw/rhoWat/cWat),
    final dp_nominal=3458*m_flow_nominal + 5282);

  redeclare package Medium = Buildings.Media.Water;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    annotation (choicesAllMatching=true, Placement(transformation(
      extent={{-80,-80},{-60,-60}})));
  parameter Modelica.SIunits.Temperature TEngIni = Medium.T_default "Initial engine temperature";
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.BooleanInput avaSig
    "True when the plant is available"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput PEleDem(final unit="W")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-140,130},{-100,170}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput mWatSet(final unit="kg/s") if per.coolingWaterControl
    "Water flow rate set point based on internal control"
    annotation (Placement(transformation(extent={{100,160},{140,200}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCon(final unit="W")
    "Power consumption during stand-by and cool-down modes"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput PEleNet(final unit="W")
    "Electric power generation"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(final unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QWat(final unit="W")
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Fluid.CHPs.BaseClasses.Controller opeMod(
    final per=per,
    final waitTime=waitTime) "Current operation mode"
    annotation (Placement(transformation(extent={{30,170},{50,190}})));
  Modelica.Blocks.Logical.And runSig "Run if avaFlag and PEleDem non zero"
    annotation (Placement(transformation(extent={{-10,160},{10,180}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    uLow=per.PEleMax/2*10^(-3),
    uHigh=per.PEleMax*10^(-3)) "Determine if demand larger than zero"
    annotation (Placement(transformation(extent={{-50,152},{-30,172}})));
  Buildings.Fluid.CHPs.BaseClasses.FilterPower fil(
    final per=per) "Power after applied constrains"
    annotation (Placement(transformation(extent={{-90,140},{-70,160}})));
  Buildings.Fluid.CHPs.BaseClasses.WaterInternalControl conWat(
    final per=per) if per.coolingWaterControl
    "Internal controller for water flow rate"
    annotation (Placement(transformation(extent={{74,170},{94,190}})));
  Modelica.Blocks.Sources.RealExpression mWat_flow(
    final y=port_a.m_flow) "Water flow rate"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneCon(
    final per=per,
    redeclare package Medium =Medium) "Energy conversion"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  Buildings.Fluid.CHPs.BaseClasses.EngineConVol eng(
    final per=per,
    redeclare package Medium = Medium,
    final TEngIni=TEngIni) "Engine control volume"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression TWatIn(
    final y=Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Fluid.CHPs.BaseClasses.AssertWatTem assWatTem(
    final per=per)
    "Assert if water temperature is outside boundaries"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TWatOut
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QWat1
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=-90,origin={-20,20})));
  Buildings.Fluid.CHPs.BaseClasses.PowerConsumption powCon(
    final per=per) "Power consumption during stand-by and cool-down modes"
    annotation (Placement(transformation(extent={{72,130},{92,150}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QLos
    "Heat transfer to the surrounding"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=180, origin={-80,-40})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

protected
  constant Modelica.SIunits.Density rhoWat=1000 "Water density";
  constant Modelica.SIunits.SpecificHeatCapacity cWat=4180 "Water specific heat";

equation
  connect(fil.PEle, hys.u) annotation (Line(points={{-69,150},{-60,150},{-60,162},
          {-52,162}},   color={0,0,127}));
  connect(runSig.y, opeMod.runSig) annotation (Line(points={{11,170},{16,170},{
          16,184},{28,184}},
                          color={255,0,255}));
  connect(eneCon.QGen, eng.QGen) annotation (Line(points={{-29,84},{-20,84},{-20,
          50},{-1,50}}, color={0,0,127}));
  connect(conWat.PEle, fil.PEle) annotation (Line(points={{72,180},{60,180},{60,
          150},{-69,150}}, color={0,0,127}));
  connect(mWat_flow.y, eneCon.mWat_flow) annotation (Line(points={{-79,100},{-74,
          100},{-74,86},{-52,86}}, color={0,0,127}));
  connect(eng.TEng, eneCon.TEng) annotation (Line(points={{21,50},{24,50},{24,70},
          {-70,70},{-70,82},{-52,82}}, color={0,0,127}));
  connect(eng.TEng, opeMod.TEng) annotation (Line(points={{21,50},{24,50},{24,
          172},{28,172}},
                     color={0,0,127}));
  connect(mWat_flow.y, opeMod.mWat_flow) annotation (Line(points={{-79,100},{
          -74,100},{-74,134},{20,134},{20,176},{28,176}},
                                                      color={0,0,127}));
  connect(TWatIn.y, conWat.TWatIn) annotation (Line(points={{-79,120},{64,120},{
          64,174},{72,174}},  color={0,0,127}));
  connect(eneCon.TWatIn, TWatIn.y) annotation (Line(points={{-52,90},{-66,90},{-66,
          120},{-79,120}}, color={0,0,127}));
  connect(conWat.mWatSet, mWatSet) annotation (Line(points={{95,180},{120,180}},
          color={0,0,127}));
  connect(hys.y, runSig.u2) annotation (Line(points={{-29,162},{-12,162}},
          color={255,0,255}));
  connect(opeMod.opeMod, eneCon.opeMod) annotation (Line(points={{51,180},{56,180},
          {56,126},{-60,126},{-60,98},{-52,98}}, color={0,127,0}));
  connect(fil.PEleDem, PEleDem) annotation (Line(points={{-92,150},{-120,150}},
          color={0,0,127}));
  connect(opeMod.avaSig, avaSig) annotation (Line(points={{28,188},{-20,188},{
          -20,180},{-120,180}},
                            color={255,0,255}));
  connect(runSig.u1, avaSig) annotation (Line(points={{-12,170},{-20,170},{-20,180},
          {-120,180}}, color={255,0,255}));
  connect(conWat.opeMod, opeMod.opeMod) annotation (Line(points={{72,186},{56,186},
          {56,180},{51,180}}, color={0,127,0}));
  connect(TWatOut.T, assWatTem.TWat) annotation (Line(points={{30,-50},{38,-50}},
          color={0,0,127}));
  connect(eneCon.mFue_flow, mFue_flow) annotation (Line(points={{-29,92},{40,92},
          {40,60},{120,60}}, color={0,0,127}));
  connect(eneCon.PEleNet, PEleNet) annotation (Line(points={{-29,96},{40,96},{
          40,100},{120,100}},  color={0,0,127}));
  connect(mFue_flow, mFue_flow) annotation (Line(points={{120,60},{120,60}},
          color={0,0,127}));
  connect(TWatOut.port, vol.heatPort) annotation (Line(points={{10,-50},{-20,-50},
          {-20,-10},{-9,-10}},color={191,0,0}));
  connect(QWat1.Q_flow, QWat) annotation (Line(points={{-10,20},{120,20}},
          color={0,0,127}));
  connect(powCon.opeMod, opeMod.opeMod) annotation (Line(points={{70,140},{56,140},
          {56,180},{51,180}}, color={0,127,0}));
  connect(powCon.PCon, PCon) annotation (Line(points={{93,140},{100,140},{100,
          138},{106,138},{106,140},{120,140}}, color={0,0,127}));
  connect(TRoo, QLos.port_b) annotation (Line(points={{-100,-40},{-90,-40}},
          color={191,0,0}));
  connect(eng.TRoo, QLos.port_a) annotation (Line(points={{0,55.8},{-66,55.8},{-66,
          -40},{-70,-40}}, color={191,0,0}));
  connect(vol.heatPort, QWat1.port_b) annotation (Line(points={{-9,-10},{-20,-10},
          {-20,10}}, color={191,0,0}));
  connect(QWat1.port_a,eng.TWat) annotation (Line(points={{-20,30},{-20,44},
          {0,44}}, color={191,0,0}));
  connect(fil.PEle, eneCon.PEle) annotation (Line(points={{-69,150},{-60,150},{-60,
          130},{-70,130},{-70,94},{-52,94}}, color={0,0,127}));

annotation (
  defaultComponentName="eleFol",
  Diagram(coordinateSystem(extent={{-100,-100},{100,200}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127})}),
    Documentation(info="<html>
<p>
Add description of the model. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricalFollowing;
