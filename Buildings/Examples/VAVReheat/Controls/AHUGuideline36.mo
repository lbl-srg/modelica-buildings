within Buildings.Examples.VAVReheat.Controls;
model AHUGuideline36

  parameter Integer numZon(min=2) "Total number of served zones/VAV boxes";
  parameter Boolean have_occSen[numZon]=fill(false, numZon)
    "Set to true if zones have occupancy sensor";
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Area zonAre[numZon] "Area of each zone";

  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer hysteresis", enable = use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim = 180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer delays at disable"));
  parameter Modelica.SIunits.Time disDel = 15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer delays at disable"));
  parameter Real kPMod=1 "Proportional gain of modulation controller"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Controllers"));
  parameter Real retDamConSigMinMod(
    final min=0,
    final max=1,
    final unit="1") = 0.5 "Minimum modulation control loop signal for the RA damper - maximum for the OA damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real kPDamLim=1 "Proportional gain of damper limit controller"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Modelica.SIunits.Time TiDamLim=30 "Time constant of damper limit controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real conSigMinDamLim=0 "Lower limit of damper position limits control signal output"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real conSigMaxDamLim=1 "Upper limit of damper position limits control signal output"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real retDamConSigMinDamLim(
    final min=conSigMinDamLim,
    final max=conSigMaxDamLim,
    final unit="1")=0.5
    "Minimum control signal for the RA damper position limit - maximum for the OA damper position limit"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(unit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow outAirSetPoi(
    final zonAre=zonAre,
    final maxSysPriFlo=maxSysPriFlo,
    final minZonPriFlo=minZonPriFlo,
    final numZon=numZon,
    final have_occSen=have_occSen)   "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-20,8},{0,28}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    min=0,
    max=1,
    final unit="1") "Supply fan speed" annotation (Placement(transformation(
          extent={{100,50},{120,70}}), iconTransformation(extent={{100,-10},{120,
            10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
    iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
    iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller conEco(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final kPMod=kPMod,
    final TiMod=TiMod,
    final retDamConSigMinMod=retDamConSigMinMod,
    final kPDamLim=kPDamLim,
    final TiDamLim=TiDamLim,
    final conSigMinDamLim=conSigMinDamLim,
    final conSigMaxDamLim=conSigMaxDamLim,
    final retDamConSigMinDamLim=retDamConSigMinDamLim,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin)
           "Economizer controller"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K", final
      quantity="ThermodynamicTemperature")
    "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}}),
    iconTransformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(final unit="K",
      final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(final unit="K", final
      quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(
    extent={{-120,50},{-100,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(
    extent={{-120,218},{-100,238}}),
                                   iconTransformation(extent={{-120,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(final unit="m3/s",
      final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}}),
      iconTransformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}}),
      iconTransformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(numZon=numZon, maxDesPre=maxDesPre,
    have_perZonRehBox=true)  "Supply fan controller"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    conTSetSup "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(final unit="K",
      quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature" annotation (Placement(transformation(
          extent={{100,-130},{120,-110}}),
                                        iconTransformation(extent={{100,-130},{120,
            -110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}}),
        iconTransformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}}),
        iconTransformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[numZon]
    "Number of occupants"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon]
    "Measured zone air temperature" annotation (Placement(transformation(extent=
           {{-122,148},{-100,170}}), iconTransformation(extent={{-120,150},{
            -100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon]
    "Discharge air temperature" annotation (Placement(transformation(extent={{
            -122,168},{-100,190}}), iconTransformation(extent={{-120,170},{-100,
            190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winOpe[numZon](each final k=false)
    "Window opening signal"
    annotation (Placement(transformation(extent={{-52,70},{-32,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Supply air temperature cooling setpoint" annotation (Placement(
        transformation(extent={{-120,200},{-100,220}}), iconTransformation(
          extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum aveTHea(
    nin=1,
    k=fill(1.0/numZon, 1))      "Average of all heating setpoints"
    annotation (Placement(transformation(extent={{-40,218},{-20,238}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum aveTCoo(
    nin=1,
    k=fill(1.0/numZon, 1))      "Average of all cooling setpoints"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Average TZonSetAve
    "Average of all zone set points"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  parameter Modelica.SIunits.PressureDifference maxDesPre(min=0, displayUnit="Pa")=410
    "Duct design maximum static pressure";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    each final unit="m3/s",
    each quantity="VolumeFlowRate",
    min=0)
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan ON/OFF status"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
equation
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{81,-8},{92,-8},
          {92,0},{110,0}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{81,-12},{92,-12},
          {92,-60},{110,-60}}, color={0,0,127}));
  connect(conEco.uSupFan, conSupFan.ySupFan) annotation (Line(points={{59,-14},
          {40,-14},{40,57},{21,57}}, color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe) annotation (Line(points={{21,50},{
          80,50},{80,60},{110,60}}, color={0,0,127}));
  connect(TOut, conEco.TOut) annotation (Line(points={{-110,140},{-60,140},{-60,
          2},{59,2}}, color={0,0,127}));
  connect(conEco.TOutCut, TOutCut) annotation (Line(points={{59,0},{-62,0},{-62,
          120},{-110,120}}, color={0,0,127}));
  connect(conEco.hOut, hOut) annotation (Line(points={{59,-2},{-64,-2},{-64,100},
          {-110,100}}, color={0,0,127}));
  connect(conEco.hOutCut, hOutCut) annotation (Line(points={{59,-4},{-66,-4},{-66,
          80},{-110,80}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{59,-6},{-68,-6},{-68,60},
          {-110,60}}, color={0,0,127}));
  connect(conEco.THeaSet, THeaSet) annotation (Line(points={{59,-8},{-70,-8},{
          -70,228},{-110,228}},
                          color={0,0,127}));
  connect(conEco.VOut_flow, VOut_flow) annotation (Line(points={{59,-10},{-72,-10},
          {-72,20},{-110,20}}, color={0,0,127}));
  connect(conEco.uOpeMod, uOpeMod) annotation (Line(points={{59,-16},{-80,-16},{
          -80,-100},{-110,-100}},
                                color={255,127,0}));
  connect(conEco.uZonSta, uZonSta) annotation (Line(points={{59,-18},{-76,-18},{
          -76,-120},{-110,-120}}, color={255,127,0}));
  connect(conEco.uFreProSta, uFreProSta) annotation (Line(points={{59,-20},{-72,
          -20},{-72,-138},{-92,-138},{-92,-140},{-110,-140}}, color={255,127,0}));
  connect(conTSetSup.TSetSup, TSetSup) annotation (Line(points={{61,-50},{80,-50},
          {80,-120},{110,-120}},
                               color={0,0,127}));
  connect(conTSetSup.TOut, TOut) annotation (Line(points={{39,-46},{-60,-46},{-60,
          140},{-110,140}}, color={0,0,127}));
  connect(conTSetSup.uSupFan, conSupFan.ySupFan) annotation (Line(points={{39,-50},
          {30,-50},{30,57},{21,57}}, color={255,0,255}));
  connect(conTSetSup.uZonTemResReq, uZonTemResReq) annotation (Line(points={{39,-54},
          {-36,-54},{-36,-200},{-110,-200}},      color={255,127,0}));
  connect(conTSetSup.uOpeMod, uOpeMod) annotation (Line(points={{39,-58},{-68,-58},
          {-68,-100},{-110,-100}},
                                 color={255,127,0}));
  connect(conSupFan.uOpeMod, uOpeMod) annotation (Line(points={{-2,58},{-80,58},
          {-80,-100},{-110,-100}},
                                 color={255,127,0}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{-2,47},
          {-84,47},{-84,-240},{-110,-240}}, color={255,127,0}));
  connect(conSupFan.ducStaPre, ducStaPre) annotation (Line(points={{-2,42},{-92,
          42},{-92,-20},{-110,-20}}, color={0,0,127}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{59,-12},{42,-12},{42,18},{1,18}}, color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc) annotation (Line(points={{-21,26},{-88,26},{
          -88,40},{-110,40}},
                            color={0,0,127}));
  connect(outAirSetPoi.TZon, TZon) annotation (Line(points={{-21,23},{-58,23},{
          -58,159},{-111,159}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TDis) annotation (Line(points={{-21,20},{-54,20},{
          -54,179},{-111,179}}, color={0,0,127}));
  connect(conSupFan.ySupFan, outAirSetPoi.uSupFan) annotation (Line(points={{21,57},
          {30,57},{30,36},{-30,36},{-30,14},{-21,14}},     color={255,0,255}));
  connect(winOpe.y, outAirSetPoi.uWin) annotation (Line(points={{-31,80},{-26,80},
          {-26,16},{-21,16}},          color={255,0,255}));
  connect(aveTHea.u[1], THeaSet)
    annotation (Line(points={{-42,228},{-110,228}}, color={0,0,127}));
  connect(aveTCoo.u[1], TCooSet) annotation (Line(points={{-42,190},{-66,190},{
          -66,210},{-110,210}},
                            color={0,0,127}));
  connect(TZonSetAve.u1, aveTHea.y) annotation (Line(points={{-2,206},{-10,206},
          {-10,228},{-18.3,228}}, color={0,0,127}));
  connect(aveTCoo.y, TZonSetAve.u2) annotation (Line(points={{-18.3,190},{-12,190},
          {-12,194},{-2,194}}, color={0,0,127}));
  connect(conTSetSup.TSetZones, TZonSetAve.y) annotation (Line(points={{39,-42},
          {36,-42},{36,200.2},{21,200.2}}, color={0,0,127}));
  connect(outAirSetPoi.VBox_flow, VBox_flow) annotation (Line(points={{-21,9},{-56,
          9},{-56,-40},{-110,-40}},      color={0,0,127}));
  connect(conSupFan.VBox_flow, VBox_flow) annotation (Line(points={{-2,53},{-28,
          53},{-52,53},{-52,54},{-52,-40},{-110,-40}},
                 color={0,0,127}));
  connect(conSupFan.ySupFan, ySupFan) annotation (Line(points={{21,57},{30,57},{
          30,-180},{110,-180}}, color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, uOpeMod) annotation (Line(points={{-21,12},{-80,
          12},{-80,-100},{-110,-100}}, color={255,127,0}));
  annotation (
    defaultComponentName="conAHU",
    Diagram(coordinateSystem(extent={{-100,-260},{100,280}},
          initialScale=0.2)), Icon(coordinateSystem(extent={{-100,-260},{100,280}},
          initialScale=0.2), graphics={Rectangle(
          extent={{100,280},{-100,-260}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-158,330},{142,290}},
        textString="%name",
        lineColor={0,0,255})}));
end AHUGuideline36;
