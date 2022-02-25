within Buildings.Fluid.CHPs;
model ThermalElectricalFollowing "CHP model that can be thermal or electrical load following"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare Buildings.Fluid.MixingVolumes.MixingVolume vol(
      final V=per.capHeaRec/rhoWat/cWat),
    final dp_nominal=3458*m_flow_nominal + 5282 "The correlation between nominal pressure drop and mass flow rate is derived from manufacturers data");

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "CHP unit performance data"
    annotation (choicesAllMatching=true, Placement(transformation(
      extent={{140,340},{160,360}})));

  parameter Boolean switchThermalElectricalFollowing = true
    "Set to true for switching between thermal and electrical following, to false for electrical following only";
  parameter Modelica.Units.SI.Temperature TEngIni=Medium.T_default
    "Initial engine temperature";
  parameter Modelica.Units.SI.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));
  parameter Controls.OBC.CDL.Types.SimpleController watOutCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=switchThermalElectricalFollowing));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=switchThermalElectricalFollowing));
  parameter Modelica.Units.SI.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Cooling water outlet temperature controller",
        enable=switchThermalElectricalFollowing and (watOutCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or watOutCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.Units.SI.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Cooling water outlet temperature controller",
        enable=switchThermalElectricalFollowing and (watOutCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or watOutCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatOutSet(
    final unit="K",
    displayUnit="degC") if switchThermalElectricalFollowing
    "Water outlet set point temperature, which is input signal for thermal following"
    annotation (Placement(transformation(extent={{-220,330},{-180,370}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput theFol if switchThermalElectricalFollowing
    "Enable thermal following, false if electrical following"
    annotation (Placement(transformation(extent={{-220,240},{-180,280}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleDem(
    final unit="W",
    final quantity="Power")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput avaSig
    "True when the plant is available"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature"
    annotation (Placement(transformation(extent={{-190,-150},{-170,-130}}),
      iconTransformation(extent={{-110,-80},{-90,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mWatSet_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") if per.compute_coolingWaterFlowRate
    "Water mass flow rate set point based on internal control"
    annotation (
      Placement(transformation(extent={{180,120},{220,160}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCon(
    final unit="W",
    final quantity="Power")
    "Power consumption during stand-by and cool-down modes"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNet(
    final unit="W",
    final quantity="Power")
    "Electric power generation"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{180,0},{220,40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QWat_flow(
    final unit="W",
    final quantity="HeatFlowRate")
    "Heat transfer rate to the water control volume"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneCon(
    final per = per) "Energy conversion"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.CHPs.BaseClasses.EngineTemperature eng(
    final UAHex=per.UAHex,
    final UALos=per.UALos,
    final capEng=per.capEng,
    final TEngIni=TEngIni) "Engine control volume"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller opeMod(
    final per=per,
    final waitTime=waitTime) "Current operation mode"
    annotation (Placement(transformation(extent={{50,150},{70,170}})));
  Buildings.Controls.OBC.CDL.Logical.And runSig "Run if avaFlag and PEleDem non zero"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=per.PEleMax/2*10^(-3),
    final uHigh=per.PEleMax*10^(-3)) "Determine if demand larger than zero"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Fluid.CHPs.BaseClasses.FilterPower fil(
    final PEleMax=per.PEleMax,
    final PEleMin=per.PEleMin,
    final use_powerRateLimit=per.use_powerRateLimit,
    final dPEleMax=per.dPEleMax)
    "Power after applied constraints"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Fluid.CHPs.BaseClasses.WaterFlowControl conWat(final per=per)
    if per.compute_coolingWaterFlowRate
    "Internal controller for water mass flow rate"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));
  Modelica.Blocks.Sources.RealExpression mWat_flow(
    final y=port_a.m_flow) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Modelica.Blocks.Sources.RealExpression TWatIn(
    final y=Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Fluid.CHPs.BaseClasses.AssertWaterTemperature assWatTem(
    final TWatMax=per.TWatMax)
    "Assert if water temperature is outside boundaries"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TWatOut
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor watHea
    "Heat transfer from the water control volume"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=-90, origin={-20,-100})));
  Buildings.Fluid.CHPs.BaseClasses.PowerConsumption powCon(
    final PStaBy=per.PStaBy,
    final PCooDow=per.PCooDow) "Power consumption during stand-by and cool-down modes"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QLos
    "Heat transfer to the surrounding"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=180, origin={-60,-140})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset cooWatCon(
    final controllerType=watOutCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0) if switchThermalElectricalFollowing
    "Cooling water outplet controller"
    annotation (Placement(transformation(extent={{-60,340},{-40,360}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter elePowDem(
    final k=per.PEleMax) if switchThermalElectricalFollowing
    "Electric power demand if thermal following"
    annotation (Placement(transformation(extent={{0,340},{20,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between thermal and electrical following"
    annotation (Placement(transformation(extent={{100,250},{120,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant optFol(
    final k=false) if not switchThermalElectricalFollowing
    "Feed false to switch block if no optional following"
    annotation (Placement(transformation(extent={{40,230},{60,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0) if not switchThermalElectricalFollowing "Constant zero"
    annotation (Placement(transformation(extent={{40,270},{60,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=-1)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{140,300},{160,320}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooSen
    "Room temperature"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
protected
  constant Modelica.Units.SI.Density rhoWat=1000 "Water density";
  constant Modelica.Units.SI.SpecificHeatCapacity cWat=4180
    "Water specific heat";
equation
  connect(fil.PEle, hys.u) annotation (Line(points={{-118,90},{-80,90},{-80,110},
          {-62,110}}, color={0,0,127}));
  connect(runSig.y, opeMod.runSig) annotation (Line(points={{2,130},{10,130},{
          10,164},{48,164}}, color={255,0,255}));
  connect(conWat.PEle, fil.PEle) annotation (Line(points={{118,140},{90,140},{90,
          90},{-118,90}},  color={0,0,127}));
  connect(mWat_flow.y, eneCon.mWat_flow) annotation (Line(points={{-119,40},{
          -100,40},{-100,32},{-62,32}}, color={0,0,127}));
  connect(eng.TEng, eneCon.TEng) annotation (Line(points={{22,-130},{30,-130},{
          30,-40},{-80,-40},{-80,23},{-62,23}}, color={0,0,127}));
  connect(mWat_flow.y, opeMod.mWat_flow) annotation (Line(points={{-119,40},{
          -100,40},{-100,68},{20,68},{20,161},{48,161}}, color={0,0,127}));
  connect(TWatIn.y, conWat.TWatIn) annotation (Line(points={{-119,60},{100,60},{
          100,133},{118,133}},color={0,0,127}));
  connect(eneCon.TWatIn, TWatIn.y) annotation (Line(points={{-62,29},{-90,29},{
          -90,60},{-119,60}}, color={0,0,127}));
  connect(conWat.mWatSet_flow, mWatSet_flow)
    annotation (Line(points={{142,140},{200,140}}, color={0,0,127}));
  connect(hys.y, runSig.u2) annotation (Line(points={{-38,110},{-30,110},{-30,122},
          {-22,122}}, color={255,0,255}));
  connect(opeMod.opeMod, eneCon.opeMod) annotation (Line(points={{71,160},{80,160},
          {80,80},{-70,80},{-70,35},{-61,35}},   color={0,127,0}));
  connect(opeMod.avaSig, avaSig) annotation (Line(points={{48,167},{-30,167},{
          -30,140},{-200,140}}, color={255,0,255}));
  connect(runSig.u1, avaSig) annotation (Line(points={{-22,130},{-30,130},{-30,140},
          {-200,140}}, color={255,0,255}));
  connect(conWat.opeMod, opeMod.opeMod) annotation (Line(points={{119,147},{80,
          147},{80,160},{71,160}}, color={0,127,0}));
  connect(TWatOut.T, assWatTem.TWat) annotation (Line(points={{81,-60},{118,-60}},
          color={0,0,127}));
  connect(eneCon.mFue_flow, mFue_flow) annotation (Line(points={{-38,33},{160,33},
          {160,20},{200,20}},color={0,0,127}));
  connect(eneCon.PEleNet, PEleNet) annotation (Line(points={{-38,38},{160,38},{160,
          60},{200,60}}, color={0,0,127}));
  connect(TWatOut.port, vol.heatPort) annotation (Line(points={{60,-60},{-20,
          -60},{-20,-10},{-9,-10}}, color={191,0,0}));
  connect(powCon.opeMod, opeMod.opeMod) annotation (Line(points={{119,100},{80,
          100},{80,160},{71,160}}, color={0,127,0}));
  connect(powCon.PCon, PCon) annotation (Line(points={{142,100},{200,100}},
          color={0,0,127}));
  connect(TRoo, QLos.port_b) annotation (Line(points={{-180,-140},{-70,-140}},
          color={191,0,0}));
  connect(eng.TRoo, QLos.port_a) annotation (Line(points={{0,-124.2},{-28,-124.2},
          {-28,-140},{-50,-140}}, color={191,0,0}));
  connect(fil.PEle, eneCon.PEle) annotation (Line(points={{-118,90},{-80,90},{-80,
          38},{-62,38}}, color={0,0,127}));
  connect(watHea.port_b, eng.TWat) annotation (Line(points={{-20,-110},{-20,-136},
          {0,-136}}, color={191,0,0}));
  connect(vol.heatPort, watHea.port_a) annotation (Line(points={{-9,-10},{-20,-10},
          {-20,-90}}, color={191,0,0}));
  connect(eneCon.QGen_flow, eng.QGen_flow) annotation (Line(points={{-38,22},{-20,22},{-20,
          -8},{-40,-8},{-40,-130},{-2,-130}}, color={0,0,127}));
  connect(eng.TEng, opeMod.TEng) annotation (Line(points={{22,-130},{24,-130},{
          24,158},{48,158}}, color={0,0,127}));
  connect(TWatOutSet, cooWatCon.u_s) annotation (Line(points={{-200,350},{-62,
          350}}, color={0,0,127}));
  connect(cooWatCon.y, elePowDem.u) annotation (Line(points={{-38,350},{-2,350}},
          color={0,0,127}));
  connect(theFol, swi.u2) annotation (Line(points={{-200,260},{98,260}},
          color={255,0,255}));
  connect(PEleDem, swi.u3) annotation (Line(points={{-200,200},{90,200},{90,252},
          {98,252}}, color={0,0,127}));
  connect(TWatOut.T, cooWatCon.u_m) annotation (Line(points={{81,-60},{100,-60},
          {100,-80},{-150,-80},{-150,330},{-50,330},{-50,338}}, color={0,0,127}));
  connect(watHea.Q_flow, gai.u) annotation (Line(points={{-9,-100},{118,-100}},
          color={0,0,127}));
  connect(gai.y, QWat_flow)
    annotation (Line(points={{142,-100},{200,-100}}, color={0,0,127}));
  connect(zer1.y, swi.u1) annotation (Line(points={{62,280},{80,280},{80,268},{
          98,268}}, color={0,0,127}));
  connect(optFol.y, swi.u2) annotation (Line(points={{62,240},{80,240},{80,260},
          {98,260}}, color={255,0,255}));
  connect(swi.y, fil.PEleDem) annotation (Line(points={{122,260},{160,260},{160,
          180},{-160,180},{-160,90},{-142,90}}, color={0,0,127}));
  connect(eneCon.PEleNet, opeMod.PEleNet) annotation (Line(points={{-38,38},{28,
          38},{28,155},{48,155}}, color={0,0,127}));
  connect(PEleDem, opeMod.PEle) annotation (Line(points={{-200,200},{40,200},{
          40,152},{48,152}}, color={0,0,127}));
  connect(TRoo, TRooSen.port) annotation (Line(points={{-180,-140},{-160,-140},
          {-160,-120},{-140,-120}}, color={191,0,0}));
  connect(TRooSen.T, eneCon.TRoo) annotation (Line(points={{-119,-120},{-90,-120},
          {-90,26},{-62,26}},       color={0,0,127}));
  connect(theFol, cooWatCon.trigger) annotation (Line(points={{-200,260},{-56,260},
          {-56,338}}, color={255,0,255}));
  connect(elePowDem.y, swi.u1) annotation (Line(points={{22,350},{80,350},{80,
          268},{98,268}}, color={0,0,127}));

annotation (
  defaultComponentName="eleFol",
  Diagram(coordinateSystem(extent={{-180,-160},{180,380}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(
    extent={{-100,-100},{100,100}}, lineColor={0,0,127})}),
    Documentation(info="<html>
<p>
This model for combined heat and power device uses empirical data contained within
a \"performance map\" to represent device-specific performance characteristics
coupled with thermally massive elements to characterize the device's dynamic thermal
performance. It was developed based on the specification described in
Beausoleil-Morrison (2007).
</p>
<h4>Model applicability</h4>
<p>
The model is primarily intended to predict the energy performance of
combustion-based cogeneration devices, such as internal combustion engine and
Stirling engine units.
However, the general model specification makes it applicable to any device
simultaneously producing heat and power from which heat is recovered as hot water,
as long as recalibration is undertaken.
Fuel cell based micro-cogeneration technology is outside of the modeling scope.
</p>
<p>
The parameters required to define the governing equations can be determined
from bench testing with only non intrusive measurements (e.g. fuel flow rate,
cooling water flow rates and temperature, electrical production).
The ability to reuse and recalibrate the component models or sub-models
ensures that they are applicable to future generations of cogeneration devices.
<h4>Model topology</h4>
<p>
Three control volumes are used to model the cogeneration unit dynamic thermal
characteristics.
</p>
<ul>
<li>
The <i>energy conversion control volume</i>
represents the engine working fluid, combustion gases and engine alternator. It
feeds information from the engine unit performance map into the thermal model, see
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversion\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversion</a>.
</li>
<li>
The <i>thermal mass control volume</i> represents the aggregated thermal capacitance
associated with the engine block and the majority of the heat exchanger shells, see
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EngineTemperature\">
Buildings.Fluid.CHPs.BaseClasses.EngineTemperature</a>.
</li>
<li>
The <i>cooling water control volume</i> represents the cooling water flowing
through the device and the elements of the heat exchanger in immediate thermal
contact.
</li>
</ul>
<p align=\"center\">
<br/>
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/control_volumes.png\"
     alt=\"Control_Volumes.png\" />
<br/>
</p>
<p>
Depending on the current mode, control signals and plant boundary conditions, the
CHP unit switches between six possible operating modes: <i>off</i> mode,
<i>stand-by</i> mode, <i>pump-on</i> mode, <i>warm-up</i> mode,
<i>normal operation</i> mode, <i>cool-down</i> mode. The mode switch control is
implemented in <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.Controller\">
Buildings.Fluid.CHPs.BaseClasses.Controller</a>.
</p>
<h4>References</h4>
<p>
Beausoleil-Morrison, Ian and Kelly, Nick, 2007. <i>Specifications for modelling fuel cell
and combustion-based residential cogeneration device within whole-building simulation
programs</i>, Section III. <a href=\"https://strathprints.strath.ac.uk/6704/\">
[Report]</a>
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 8, 2020, by Antoine Gautier:<br/>
Refactored implementation.
</li>
<li>
February 14, 2020, by Jianjun Hu:<br/>
Added documentation.
</li>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalElectricalFollowing;
