within Buildings.Fluid.CHPs;
model ThermalElectricalFollowing
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final vol(V=per.MCcw/rhoWat/cWat),
    final dp_nominal=3458*m_flow_nominal + 5282 "The correlation between nominal pressure drop and mass flow rate is derived from manufacturers data");

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "CHP unit performance data"
    annotation (choicesAllMatching=true, Placement(transformation(
      extent={{140,340},{160,360}})));

  parameter Boolean optionalFollowing = true
    "Set to true for switching between thermal and electrical following, to false for electrical following only";
  parameter Modelica.SIunits.Temperature TEngIni = Medium.T_default
    "Initial engine temperature";
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));
  parameter Controls.OBC.CDL.Types.SimpleController watOutCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing and
      (watOutCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
       watOutCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing and
      (watOutCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
       watOutCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing));
  parameter Real yMin=0 "Lower limit of output"
    annotation (Dialog(group="Cooling water outlet temperature controller",
      enable=optionalFollowing));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatOutSet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if optionalFollowing
    "Water outlet set point temperature, which is input signal for thermal following"
    annotation (Placement(transformation(extent={{-220,330},{-180,370}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput theFol if optionalFollowing
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
    final unit="kg/s", final quantity="MassFlowRate") if per.coolingWaterControl
    "Water mass flow rate set point based on internal control" annotation (
      Placement(transformation(extent={{180,120},{220,160}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCon(
    final unit="W",
    final quantity="Power")
    "Power consumption during stand-by and cool-down modes"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNet(
    final unit="W",
    final quantity="Power")
    "Electric power generation"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel flow rate"
    annotation (Placement(transformation(extent={{180,0},{220,40}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QWat_flow(final unit="W",
      final quantity="HeatFlowRate")
    "Heat transfer rate to the water control volume" annotation (Placement(
        transformation(extent={{180,-120},{220,-80}}), iconTransformation(
          extent={{100,-110},{140,-70}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneCon(
    final per = per) "Energy conversion"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.CHPs.BaseClasses.EngineTemperature eng(
    final UAhx=per.UAhx,
    final UAlos=per.UAlos,
    final MCeng=per.MCeng,
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
    final dPEleLim=per.dPEleLim,
    final dPEleMax=per.dPEleMax)
    "Power after applied constraints"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Fluid.CHPs.BaseClasses.WaterFlowControl conWat(final per=per) if
    per.coolingWaterControl
    "Internal controller for water flow rate"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));
  Modelica.Blocks.Sources.RealExpression mWat_flow(
    final y=port_a.m_flow) "Water flow rate"
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
  Buildings.Controls.OBC.CDL.Continuous.LimPID cooWatCon(
    final controllerType=watOutCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if optionalFollowing
    "Cooling water outplet controller"
    annotation (Placement(transformation(extent={{-80,340},{-60,360}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold neeFolThe(
    final threshold=273.15 + 1) if optionalFollowing
    "Check if it should active thermal following"
    annotation (Placement(transformation(extent={{-80,300},{-60,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) if optionalFollowing "Constant zero"
    annotation (Placement(transformation(extent={{-40,270},{-20,290}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 if optionalFollowing
    "Check if there is a need for heat generation"
    annotation (Placement(transformation(extent={{20,300},{40,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain elePowDem(
    final k=per.PEleMax) if optionalFollowing
    "Electric power demand if thermal following"
    annotation (Placement(transformation(extent={{-40,340},{-20,360}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between thermal and electrical following"
    annotation (Placement(transformation(extent={{100,250},{120,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant optFol(
    final k=false) if not optionalFollowing
    "Feed false to switch block if no optional following"
    annotation (Placement(transformation(extent={{40,230},{60,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0) if not optionalFollowing "Constant zero"
    annotation (Placement(transformation(extent={{40,270},{60,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=-1)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{140,300},{160,320}})));
protected
  constant Modelica.SIunits.Density rhoWat=1000 "Water density";
  constant Modelica.SIunits.SpecificHeatCapacity cWat=4180 "Water specific heat";
equation
  connect(fil.PEle, hys.u) annotation (Line(points={{-118,90},{-80,90},{-80,110},
          {-62,110}}, color={0,0,127}));
  connect(runSig.y, opeMod.runSig) annotation (Line(points={{2,130},{10,130},{
          10,164},{48,164}},
                          color={255,0,255}));
  connect(conWat.PEle, fil.PEle) annotation (Line(points={{118,140},{90,140},{90,
          90},{-118,90}},  color={0,0,127}));
  connect(mWat_flow.y, eneCon.mWat_flow) annotation (Line(points={{-119,40},{-100,
          40},{-100,25},{-62,25}}, color={0,0,127}));
  connect(eng.TEng, eneCon.TEng) annotation (Line(points={{22,-130},{30,-130},{30,
          -40},{-80,-40},{-80,21},{-62,21}}, color={0,0,127}));
  connect(mWat_flow.y, opeMod.mWat_flow) annotation (Line(points={{-119,40},{
          -100,40},{-100,68},{20,68},{20,161},{48,161}},
                                                      color={0,0,127}));
  connect(TWatIn.y, conWat.TWatIn) annotation (Line(points={{-119,60},{100,60},{
          100,133},{118,133}},color={0,0,127}));
  connect(eneCon.TWatIn, TWatIn.y) annotation (Line(points={{-62,30},{-90,30},{-90,
          60},{-119,60}}, color={0,0,127}));
  connect(conWat.mWatSet_flow, mWatSet_flow)
    annotation (Line(points={{142,140},{200,140}}, color={0,0,127}));
  connect(hys.y, runSig.u2) annotation (Line(points={{-38,110},{-30,110},{-30,122},
          {-22,122}}, color={255,0,255}));
  connect(opeMod.opeMod, eneCon.opeMod) annotation (Line(points={{71,160},{80,
          160},{80,80},{-70,80},{-70,39},{-61,39}},
                                                 color={0,127,0}));
  connect(opeMod.avaSig, avaSig) annotation (Line(points={{48,167},{-30,167},{
          -30,140},{-200,140}},
                            color={255,0,255}));
  connect(runSig.u1, avaSig) annotation (Line(points={{-22,130},{-30,130},{-30,140},
          {-200,140}}, color={255,0,255}));
  connect(conWat.opeMod, opeMod.opeMod) annotation (Line(points={{119,147},{80,
          147},{80,160},{71,160}},
                              color={0,127,0}));
  connect(TWatOut.T, assWatTem.TWat) annotation (Line(points={{80,-60},{118,-60}},
          color={0,0,127}));
  connect(eneCon.mFue_flow, mFue_flow) annotation (Line(points={{-38,33},{160,33},
          {160,20},{200,20}},color={0,0,127}));
  connect(eneCon.PEleNet, PEleNet) annotation (Line(points={{-38,38},{160,38},{160,
          60},{200,60}}, color={0,0,127}));
  connect(mFue_flow, mFue_flow) annotation (Line(points={{200,20},{200,20}},
          color={0,0,127}));
  connect(TWatOut.port, vol.heatPort) annotation (Line(points={{60,-60},{-20,
          -60},{-20,-10},{-9,-10}}, color={191,0,0}));
  connect(powCon.opeMod, opeMod.opeMod) annotation (Line(points={{119,100},{80,
          100},{80,160},{71,160}},
                              color={0,127,0}));
  connect(powCon.PCon, PCon) annotation (Line(points={{142,100},{200,100}},
          color={0,0,127}));
  connect(TRoo, QLos.port_b) annotation (Line(points={{-180,-140},{-70,-140}},
          color={191,0,0}));
  connect(eng.TRoo, QLos.port_a) annotation (Line(points={{0,-124.2},{-28,-124.2},
          {-28,-140},{-50,-140}}, color={191,0,0}));
  connect(fil.PEle, eneCon.PEle) annotation (Line(points={{-118,90},{-80,90},{-80,
          35},{-62,35}}, color={0,0,127}));
  connect(watHea.port_b, eng.TWat) annotation (Line(points={{-20,-110},{-20,-136},
          {0,-136}}, color={191,0,0}));
  connect(vol.heatPort, watHea.port_a) annotation (Line(points={{-9,-10},{-20,-10},
          {-20,-90}}, color={191,0,0}));
  connect(eneCon.QGen_flow, eng.QGen_flow) annotation (Line(points={{-38,22},{-20,22},{-20,
          -8},{-40,-8},{-40,-130},{-2,-130}}, color={0,0,127}));
  connect(eng.TEng, opeMod.TEng) annotation (Line(points={{22,-130},{24,-130},{
          24,158},{48,158}},
                          color={0,0,127}));
  connect(TWatOutSet, cooWatCon.u_s) annotation (Line(points={{-200,350},{-82,350}},
          color={0,0,127}));
  connect(cooWatCon.y, elePowDem.u) annotation (Line(points={{-58,350},{-42,350}},
          color={0,0,127}));
  connect(TWatOutSet, neeFolThe.u) annotation (Line(points={{-200,350},{-160,350},
          {-160,310},{-82,310}}, color={0,0,127}));
  connect(neeFolThe.y, swi1.u2) annotation (Line(points={{-58,310},{18,310}},
          color={255,0,255}));
  connect(elePowDem.y, swi1.u1) annotation (Line(points={{-18,350},{0,350},{0,318},
          {18,318}}, color={0,0,127}));
  connect(zer.y, swi1.u3) annotation (Line(points={{-18,280},{0,280},{0,302},{18,
          302}}, color={0,0,127}));
  connect(theFol, swi.u2) annotation (Line(points={{-200,260},{98,260}},
          color={255,0,255}));
  connect(swi1.y, swi.u1) annotation (Line(points={{42,310},{80,310},{80,268},{
          98,268}},
                 color={0,0,127}));
  connect(PEleDem, swi.u3) annotation (Line(points={{-200,200},{90,200},{90,252},
          {98,252}}, color={0,0,127}));
  connect(TWatOut.T, cooWatCon.u_m) annotation (Line(points={{80,-60},{100,-60},
          {100,-80},{-150,-80},{-150,330},{-70,330},{-70,338}}, color={0,0,127}));
  connect(watHea.Q_flow, gai.u) annotation (Line(points={{-10,-100},{118,-100}},
          color={0,0,127}));
  connect(gai.y, QWat_flow)
    annotation (Line(points={{142,-100},{200,-100}}, color={0,0,127}));

  connect(zer1.y, swi.u1) annotation (Line(points={{62,280},{80,280},{80,268},{
          98,268}},
                 color={0,0,127}));
  connect(optFol.y, swi.u2) annotation (Line(points={{62,240},{80,240},{80,260},
          {98,260}}, color={255,0,255}));
  connect(swi.y, fil.PEleDem) annotation (Line(points={{122,260},{160,260},{160,
          180},{-160,180},{-160,90},{-142,90}}, color={0,0,127}));
  connect(eneCon.PEleNet, opeMod.PEleNet) annotation (Line(points={{-38,38},{28,
          38},{28,155},{48,155}}, color={0,0,127}));
  connect(PEleDem, opeMod.PEle) annotation (Line(points={{-200,200},{40,200},{
          40,152},{48,152}}, color={0,0,127}));
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
<h4>Model topology</h4>
<p>
Three control volumes are used to model the cogeneration unit dynamic thermal
characteristics.
</p>
<ul>
<li>
The <i>energy conversion control volume</i>
(<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversion\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversion</a>)
represents the engine working fluid, combustion gases and engine alternator. It
feeds information from the engine unit performance map into the thermal model.
</li>
<li>
The <i>thermal mass control volume</i>
(<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EngineConVol\">
Buildings.Fluid.CHPs.BaseClasses.EngineConVol</a>)
represents the aggregated thermal capacitance
associated with the engine block and the majority of the heat exchanger shells.
</li>
<li>
The <i>cooling water control volume</i> (<code>vol</code>)
represents the cooling water flowing
through the device and the elements of the heat exchanger in immediate thermal
contact.
</li>
</ul>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/control_volumes.png\"
     alt=\"Control_Volumes.png\" />
</p>
<p>
Depending on the current mode, control signals and plant boundary conditions, the
CHP plant switches between six possible operating modes: <i>off</i> mode,
<i>stand-by</i> mode, <i>pump-on</i> mode, <i>warm-up</i> mode,
<i>normal operation</i> mode, <i>cool-down</i> mode. The mode switch control is
implemented in <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.Controller\">
Buildings.Fluid.CHPs.BaseClasses.Controller</a>.
</p>
<h4>Limitations</h4>
<p>
In the early stages of a project, the advantages of this modeling approach
over a detailed modeling are the model simplicity, the ease of calibration
and much less data collection. The disadvantages, however, are:
</p>
<ul>
<li>
Although the model structure reflects the underlying physical processes, the
model parameterization relies entirely on empirical data.
</li>
<li>
Once calibrated, the model is applicable to only one engine and fuel type, and
each new cogeneration device must be characterized in a laboratory environment.
</li>
</ul>
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
February 14, 2020, by Jianjun Hu:<br/>
Added documentation.
</li>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalElectricalFollowing;
