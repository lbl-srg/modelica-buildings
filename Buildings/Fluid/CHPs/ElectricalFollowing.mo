within Buildings.Fluid.CHPs;
model ElectricalFollowing
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final vol(V=per.MCcw/rhoWat/cWat),
    final dp_nominal=3458*m_flow_nominal + 5282);
  redeclare package Medium = Buildings.Media.Water;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-98,-98},{-78,
            -78}})));
  parameter Modelica.SIunits.Temperature TEngIni = Medium.T_default "Initial engine temperature";
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires" annotation (Dialog(tab="Dynamics"));


  Modelica.Blocks.Interfaces.BooleanInput avaSig annotation (Placement(
        transformation(extent={{-140,120},{-100,160}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput PEleDem(unit="W")
    "Electric power demand" annotation (Placement(transformation(extent={{-140,80},
            {-100,120}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature" annotation (Placement(transformation(
          extent={{-116,-50},{-96,-30}}), iconTransformation(extent={{-120,-40},
            {-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput mWatSet(unit="kg/s") if  per.coolingWaterControl
    "Water flow rate set point based on internal control" annotation (Placement(
        transformation(extent={{100,124},{120,144}}), iconTransformation(extent={{100,80},
            {120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCon(unit="W")
    "Power consumption during stand-by and cool-down modes" annotation (
      Placement(transformation(extent={{100,94},{120,114}}), iconTransformation(
          extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput PEleNet(unit="W")
    "Electric power generation" annotation (Placement(transformation(extent={{100,
            74},{120,94}}), iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{100,54},{120,74}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QWat(unit="W")
    "Heat transfer to the water control volume" annotation (Placement(
        transformation(extent={{100,8},{120,28}}), iconTransformation(extent={{100,
            -90},{120,-70}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-68,-97},{-48,-77}})));
  CHPs.BaseClasses.Controller conMain(per=per, waitTime=waitTime)
                                               "Main controller"
    annotation (Placement(transformation(extent={{30,124},{50,144}})));
  Modelica.Blocks.Logical.And runSig "Run if avaFlag and PEleDem non zero"
    annotation (Placement(transformation(extent={{-8,122},{4,134}})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=per.PEleMax/2*10^(-3), uHigh=per.PEleMax
        *10^(-3)) "Determine if demand larger than zero"
    annotation (Placement(transformation(extent={{-40,116},{-26,130}})));
  CHPs.BaseClasses.FilterPower fil(per=per) "Power after applied constrains"
    annotation (Placement(transformation(extent={{-88,90},{-68,110}})));
  CHPs.BaseClasses.WaterInternalControl conWat(per=per) if per.coolingWaterControl
    "Internal controller for water flow rate"
    annotation (Placement(transformation(extent={{74,124},{94,144}})));
  Modelica.Blocks.Sources.RealExpression mWat_flow(y=port_a.m_flow)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-98,32},{-78,52}})));
  CHPs.BaseClasses.EnergyConversion eneCon(per=per, redeclare package Medium =
        Medium) "Energy conversion"
    annotation (Placement(transformation(extent={{-50,36},{-30,56}})));
  CHPs.BaseClasses.EngineConVol eng(
    per=per,
    redeclare package Medium = Medium,
    TEngIni=TEngIni) "Engine control volume"
    annotation (Placement(transformation(extent={{-8,38},{12,58}})));
  Modelica.Blocks.Sources.RealExpression TWatIn(y=Medium.temperature(
        Medium.setState_phX(port_a.p, inStream(port_a.h_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-98,50},{-78,70}})));
  CHPs.BaseClasses.AssertWatTem assWatTem(per=per)
    "Assert if water temperature is outside boundaries"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TWatOut
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{8,-60},{28,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QWat1
    "Heat transfer to the water control volume" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-8,18})));

  BaseClasses.PowerConsumption powCon(per=per)
    annotation (Placement(transformation(extent={{72,94},{92,114}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QLos
    "Heat transfer to the surrounding" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-58,-40})));
protected
  constant Modelica.SIunits.Density rhoWat=1000 "Water density";
  constant Modelica.SIunits.SpecificHeatCapacity cWat=4180
    "Water specific heat";

equation
  connect(fil.PEle, hys.u) annotation (Line(points={{-67,100},{-60,100},{-60,
          123},{-41.4,123}},
                        color={0,0,127}));
  connect(runSig.y, conMain.runSig) annotation (Line(points={{4.6,128},{16,128},
          {16,136},{29,136}},color={255,0,255}));
  connect(eneCon.QGen, eng.QGen) annotation (Line(points={{-29,40},{-14,40},{-14,
          48},{-9,48}}, color={0,0,127}));
  connect(eneCon.PEle, hys.u) annotation (Line(points={{-52,50},{-70,50},{-70,80},
          {-60,80},{-60,123},{-41.4,123}}, color={0,0,127}));
  connect(conWat.PEle, fil.PEle) annotation (Line(points={{72,134},{60,134},{60,
          80},{-60,80},{-60,100},{-67,100}},
                                         color={0,0,127}));
  connect(mWat_flow.y, eneCon.mWat_flow)
    annotation (Line(points={{-77,42},{-52,42}}, color={0,0,127}));
  connect(eng.TEng, eneCon.TEng) annotation (Line(points={{13,48},{24,48},{24,30},
          {-70,30},{-70,38},{-52,38}}, color={0,0,127}));
  connect(eng.TEng, conMain.TEng) annotation (Line(points={{13,48},{24,48},{24,128},
          {29,128}}, color={0,0,127}));
  connect(mWat_flow.y, conMain.mWat_flow) annotation (Line(points={{-77,42},{-74,
          42},{-74,84},{20,84},{20,132},{29,132}}, color={0,0,127}));
  connect(TWatIn.y, conWat.TWatIn) annotation (Line(points={{-77,60},{-66,60},{-66,
          72},{64,72},{64,128},{72,128}}, color={0,0,127}));
  connect(eneCon.TWatIn, TWatIn.y) annotation (Line(points={{-52,46},{-66,46},{-66,
          60},{-77,60}}, color={0,0,127}));
  connect(conWat.mWatSet, mWatSet)
    annotation (Line(points={{95,134},{110,134}}, color={0,0,127}));
  connect(hys.y, runSig.u2) annotation (Line(points={{-25.3,123},{-18,123},{-18,
          123.2},{-9.2,123.2}},
                         color={255,0,255}));
  connect(conMain.opeMod, eneCon.opeMod) annotation (Line(points={{51,134},{56,134},
          {56,76},{-60,76},{-60,54},{-52,54}}, color={0,127,0}));
  connect(fil.PEleDem, PEleDem)
    annotation (Line(points={{-90,100},{-120,100}}, color={0,0,127}));
  connect(conMain.avaSig, avaSig)
    annotation (Line(points={{29,140},{-120,140}}, color={255,0,255}));
  connect(runSig.u1, avaSig) annotation (Line(points={{-9.2,128},{-20,128},{-20,
          140},{-120,140}}, color={255,0,255}));
  connect(conWat.opeMod, conMain.opeMod) annotation (Line(points={{72,140},{56,140},
          {56,134},{51,134}}, color={0,127,0}));
  connect(TWatOut.T, assWatTem.TWat)
    annotation (Line(points={{28,-50},{38,-50}}, color={0,0,127}));
  connect(eneCon.mFue_flow, mFue_flow) annotation (Line(points={{-29,48},{-26,48},
          {-26,64},{110,64}}, color={0,0,127}));
  connect(eneCon.PEleNet, PEleNet) annotation (Line(points={{-29,52},{-28,52},{-28,
          68},{80,68},{80,84},{110,84}}, color={0,0,127}));
  connect(mFue_flow, mFue_flow)
    annotation (Line(points={{110,64},{110,64}}, color={0,0,127}));
  connect(TWatOut.port, vol.heatPort) annotation (Line(points={{8,-50},{-8,-50},
          {-8,-10},{-9,-10}}, color={191,0,0}));
  connect(QWat1.port_a, eng.QWat) annotation (Line(points={{-8,28},{-8,36},{-8,42},
          {-9,42}}, color={191,0,0}));
  connect(QWat1.port_b, vol.heatPort) annotation (Line(points={{-8,8},{-8,-2},{-8,
          -10},{-9,-10}}, color={191,0,0}));
  connect(QWat1.Q_flow, QWat)
    annotation (Line(points={{2,18},{110,18}}, color={0,0,127}));
  connect(powCon.opeMod, conMain.opeMod) annotation (Line(points={{70,104},{56,104},
          {56,134},{51,134}}, color={0,127,0}));
  connect(powCon.PCon, PCon)
    annotation (Line(points={{93,104},{110,104}}, color={0,0,127}));
  connect(TRoo, QLos.port_b)
    annotation (Line(points={{-106,-40},{-68,-40}}, color={191,0,0}));
  connect(eng.TRoo, QLos.port_a) annotation (Line(points={{-9,54},{-22,54},{-22,
          -40},{-48,-40}}, color={191,0,0}));
  annotation (
    defaultComponentName="eleFol",
    Diagram(coordinateSystem(extent={{-100,-100},{100,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
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
