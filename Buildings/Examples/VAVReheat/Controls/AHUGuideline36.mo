within Buildings.Examples.VAVReheat.Controls;
model AHUGuideline36

  parameter Integer numZon(min=2) "Total number of served zones/VAV boxes";
  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";

  parameter Boolean have_occSen[numZon]
    "Set to true if zones have occupancy sensor";
  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal";
  parameter Real kPTSup=0.05
    "Gain of controller for supply air temperature signal"
        annotation (Dialog(group="Supply air temperature loop control gains"));
  parameter Modelica.SIunits.Time TiTSup=300
    "Time constant of integrator block for supply temperature control signal"
    annotation (Dialog(group="Supply air temperature loop control gains"));
  parameter Real kPMinOut=0.05 "Proportional gain of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer control gains"));
  parameter Modelica.SIunits.Time TiMinOut=120
    "Time constant of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer control gains"));

  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1.";

  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Area zonAre[numZon] "Area of each zone";

  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit" annotation (
      Evaluate=true, Dialog(tab="Advanced", group="Economizer hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits" annotation (
      Evaluate=true, Dialog(
      tab="Advanced",
      group="Economizer hysteresis",
      enable=use_enthalpy));

  parameter Modelica.SIunits.Time retDamFulOpeTim=180 "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations" annotation (Evaluate=true,
      Dialog(tab="Advanced", group="Economizer delays at disable"));
  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Evaluate=true,Dialog(tab="Advanced", group=
          "Economizer delays at disable"));

  parameter Modelica.SIunits.PressureDifference maxDesPre(
    min=0,
    displayUnit="Pa") = 410 "Duct design maximum static pressure";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    each final unit="m3/s",
    each quantity="VolumeFlowRate",
    min=0)
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}}),
        iconTransformation(extent={{-220,-60},{-200,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan status, true if fan should be on"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    controllerType=controllerType,
    k=kPTSup,
    Ti=TiTSup,
    yMax=1,
    yMin=-1,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0)
    "Controller for supply air temperature control signal (to be used by heating coil, cooling coil and economizer)"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{200,-140},{220,-120}}),
        iconTransformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Control signal for cooling"
    annotation (Placement(transformation(extent={{200,-200},{220,-180}}),
        iconTransformation(extent={{200,-200},{220,-180}})));
  parameter Real yMinDamLim=0
    "Lower limit of damper position limits control signal output" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Economizer control gains"));
  parameter Real yMaxDamLim=1
    "Upper limit of damper position limits control signal output" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Economizer control gains"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Ecnomizer physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Ecnomizer physical damper position limits"));


  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));
  parameter Real kPFre = 1
    "Proportional gain for mixed air temperature tracking for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(unit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    min=0,
    max=1,
    final unit="1") "Supply fan speed" annotation (Placement(transformation(
          extent={{200,100},{220,120}}),
                                       iconTransformation(extent={{200,112},{220,
            132}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position" annotation (Placement(
        transformation(extent={{200,-10},{220,10}}), iconTransformation(extent={{200,-10},
            {220,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position" annotation (Placement(
        transformation(extent={{200,50},{220,70}}),   iconTransformation(extent={{200,50},
            {220,70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSetPoi(
    final zonAre=zonAre,
    final maxSysPriFlo=maxSysPriFlo,
    final minZonPriFlo=minZonPriFlo,
    final numZon=numZon,
    final have_occSen=have_occSen)
    "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller
    conEco(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final kPMinOut=kPMinOut,
    final TiMinOut=TiMinOut,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=(uHeaMax + uCooMin)/2,
    final uRetDamMin=(uHeaMax + uCooMin)/2,
    final TFreSet=TFreSet,
    final kPFre=kPFre) "Economizer controller"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K", final
      quantity="ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}}),
        iconTransformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(final unit="K",
      final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}}),
        iconTransformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}}),
        iconTransformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}}),
        iconTransformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(final unit="K", final
      quantity="ThermodynamicTemperature") "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}}),
        iconTransformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Zone air temperature heating setpoint"   annotation (Placement(
        transformation(extent={{-220,218},{-200,238}}), iconTransformation(
          extent={{-220,230},{-200,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(final unit="m3/s",
      final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate" annotation (Placement(
        transformation(extent={{-220,10},{-200,30}}), iconTransformation(extent={{-220,
            -10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request" annotation (Placement(
        transformation(extent={{-220,-210},{-200,-190}}), iconTransformation(
          extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests" annotation (Placement(transformation(
          extent={{-220,-250},{-200,-230}}), iconTransformation(extent={{-220,-250},
            {-200,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[numZon]
    "Number of occupants" annotation (Placement(transformation(extent={{-220,30},
            {-200,50}}), iconTransformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon]
    "Measured zone air temperature" annotation (Placement(transformation(extent={{-222,
            148},{-200,170}}),       iconTransformation(extent={{-220,150},{-200,
            170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon]
    "Discharge air temperature" annotation (Placement(transformation(extent={{-222,
            168},{-200,190}}), iconTransformation(extent={{-220,170},{-200,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature" annotation (Placement(transformation(
          extent={{200,-80},{220,-60}}),   iconTransformation(extent={{200,-80},
            {220,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winOpe[numZon](each final
            k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-52,130},{-32,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Zone air temperature cooling setpoint"   annotation (Placement(
        transformation(extent={{-220,200},{-200,220}}), iconTransformation(
          extent={{-220,200},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Zone state signal" annotation (Placement(transformation(extent={{-220,-130},
            {-200,-110}}), iconTransformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status" annotation (Placement(transformation(extent={{-220,
            -150},{-200,-130}}), iconTransformation(extent={{-220,-150},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal" annotation (Placement(transformation(
          extent={{-220,-110},{-200,-90}}), iconTransformation(extent={{-220,-110},
            {-200,-90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(
    numZon=numZon,
    maxDesPre=maxDesPre,
    have_perZonRehBox=true,
    final samplePeriod=samplePeriod,
    iniSet=60)                       "Supply fan controller"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    conTSetSup(final samplePeriod=samplePeriod)
    "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{50,-60},{70,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Average TZonSetAve
    "Average of all zone set points"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{62,-100},{82,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero control signal"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{80,-240},{100,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain conSigTSupInv(final k=-1)
    "Inverts control signal"
    annotation (Placement(transformation(extent={{-8,-100},{12,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigHea(final limitBelow=false,
      final limitAbove=true) "Heating control signal"
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigCoo(final limitBelow=true,
      final limitAbove=false) "Cooling control signal"
    annotation (Placement(transformation(extent={{140,-200},{160,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant negOne(final k=-1)
    "Negative unity signal"
    annotation (Placement(transformation(extent={{70,-170},{90,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uHeaMaxCon(final k=
        uHeaMax) "Constant signal to map control action"
    annotation (Placement(transformation(extent={{40,-144},{60,-124}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooMinCon(final k=
        uCooMin) "Constant signal to map control action"
    annotation (Placement(transformation(extent={{40,-192},{60,-172}})));
equation
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{80.625,15},{
          180,15},{180,0},{210,0}},
                           color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{80.625,5},{
          160,5},{160,60},{210,60}},color={0,0,127}));
  connect(conEco.uSupFan, conSupFan.ySupFan) annotation (Line(points={{59.375,
          6.25},{40,6.25},{40,117},{21,117}},
                                     color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe) annotation (Line(points={{21,110},{210,
          110}},                    color={0,0,127}));
  connect(TOut, conEco.TOut) annotation (Line(points={{-210,140},{-60,140},{-60,
          18.75},{59.375,18.75}},
                      color={0,0,127}));
  connect(conEco.TOutCut, TOutCut) annotation (Line(points={{59.375,17.5},{-64,
          17.5},{-64,120},{-210,120}},
                            color={0,0,127}));
  connect(conEco.hOut, hOut) annotation (Line(points={{59.375,16.25},{-66,16.25},
          {-66,100},{-210,100}},
                       color={0,0,127}));
  connect(conEco.hOutCut, hOutCut) annotation (Line(points={{59.375,15},{-66,15},
          {-66,80},{-210,80}},
                          color={0,0,127}));
  connect(conEco.VOut_flow, VOut_flow) annotation (Line(points={{59.375,11.25},
          {-72,11.25},{-72,20},{-210,20}},
                               color={0,0,127}));
  connect(conEco.uOpeMod, uOpeMod) annotation (Line(points={{59.375,3.75},{-80,
          3.75},{-80,-100},{-210,-100}},
                                   color={255,127,0}));
  connect(conEco.uZonSta, uZonSta) annotation (Line(points={{59.375,2.5},{-76,
          2.5},{-76,-120},{-210,-120}},
                                  color={255,127,0}));
  connect(conEco.uFreProSta, uFreProSta) annotation (Line(points={{59.375,1.25},
          {-72,1.25},{-72,-138},{-92,-138},{-92,-140},{-210,-140}},
                                                              color={255,127,0}));
  connect(conTSetSup.TSetSup, TSetSup) annotation (Line(points={{71,-50},{180,-50},
          {180,-70},{210,-70}},  color={0,0,127}));
  connect(conTSetSup.TOut, TOut) annotation (Line(points={{49,-46},{-60,-46},{-60,
          140},{-210,140}}, color={0,0,127}));
  connect(conTSetSup.uSupFan, conSupFan.ySupFan) annotation (Line(points={{49,-50},
          {30,-50},{30,117},{21,117}},
                                     color={255,0,255}));
  connect(conTSetSup.uZonTemResReq, uZonTemResReq) annotation (Line(points={{49,-54},
          {-62,-54},{-62,-200},{-210,-200}},      color={255,127,0}));
  connect(conTSetSup.uOpeMod, uOpeMod) annotation (Line(points={{49,-58},{-68,-58},
          {-68,-100},{-210,-100}}, color={255,127,0}));
  connect(conSupFan.uOpeMod, uOpeMod) annotation (Line(points={{-2,118},{-80,118},
          {-80,-100},{-210,-100}}, color={255,127,0}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{-2,107},
          {-84,107},{-84,-240},{-210,-240}},    color={255,127,0}));
  connect(conSupFan.ducStaPre, ducStaPre) annotation (Line(points={{-2,102},{-180,
          102},{-180,-20},{-210,-20}},
                                     color={0,0,127}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{59.375,10},{20,10},{20,50},{1,50}},
                                                      color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc) annotation (Line(points={{-21,58},{-88,58},{-88,
          40},{-210,40}},     color={0,0,127}));
  connect(outAirSetPoi.TZon, TZon) annotation (Line(points={{-21,55},{-58,55},{-58,
          159},{-211,159}},     color={0,0,127}));
  connect(outAirSetPoi.TDis, TDis) annotation (Line(points={{-21,52},{-54,52},{-54,
          179},{-211,179}},     color={0,0,127}));
  connect(conSupFan.ySupFan, outAirSetPoi.uSupFan) annotation (Line(points={{21,117},
          {30,117},{30,88},{-30,88},{-30,46},{-21,46}},    color={255,0,255}));
  connect(winOpe.y, outAirSetPoi.uWin) annotation (Line(points={{-31,140},{-26,140},
          {-26,48},{-21,48}},     color={255,0,255}));
  connect(conTSetSup.TSetZones, TZonSetAve.y) annotation (Line(points={{49,-42},
          {36,-42},{36,220.2},{21,220.2}}, color={0,0,127}));
  connect(outAirSetPoi.VBox_flow, VBox_flow) annotation (Line(points={{-21,41},{
          -56,41},{-56,-40},{-210,-40}},color={0,0,127}));
  connect(conSupFan.VBox_flow, VBox_flow) annotation (Line(points={{-2,113},{-52,
          113},{-52,-40},{-210,-40}},                  color={0,0,127}));
  connect(conSupFan.ySupFan, ySupFan) annotation (Line(points={{21,117},{30,117},
          {30,180},{210,180}},  color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, uOpeMod) annotation (Line(points={{-21,44},{-80,
          44},{-80,-100},{-210,-100}}, color={255,127,0}));
  connect(TZonSetAve.u2, TCooSet)
    annotation (Line(points={{-2,214},{-106,214},{-106,210},{-210,210}},
                                                             color={0,0,127}));
  connect(TZonSetAve.u1, THeaSet) annotation (Line(points={{-2,226},{-54,226},{-54,
          228},{-210,228}},     color={0,0,127}));
  connect(conTSetSup.TSetSup, conTSup.u_s) annotation (Line(points={{71,-50},{
          84,-50},{84,-68},{-46,-68},{-46,-90},{-42,-90}},
                                                        color={0,0,127}));
  connect(conTSup.u_m, TSup) annotation (Line(points={{-30,-102},{-30,-112},{
          -160,-112},{-160,60},{-210,60}},
                                     color={0,0,127}));
  connect(conSupFan.ySupFan, swi.u2) annotation (Line(points={{21,117},{30,117},
          {30,-90},{60,-90}},                   color={255,0,255}));
  connect(conEco.uTSup, swi.y) annotation (Line(points={{59.375,13.125},{50,
          13.125},{50,-20},{100,-20},{100,-90},{83,-90}},
                     color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-19,-210},{20,-210},{20,-98},
          {60,-98}}, color={0,0,127}));
  connect(conSigTSupInv.u, conTSup.y)
    annotation (Line(points={{-10,-90},{-19,-90}}, color={0,0,127}));
  connect(conSigTSupInv.y, swi.u1) annotation (Line(points={{13,-90},{20,-90},{20,
          -82},{60,-82}}, color={0,0,127}));
  connect(yHea, conSigHea.y)
    annotation (Line(points={{210,-130},{161,-130}}, color={0,0,127}));
  connect(yCoo, conSigCoo.y)
    annotation (Line(points={{210,-190},{161,-190}}, color={0,0,127}));
  connect(conSigHea.x1, negOne.y) annotation (Line(points={{138,-122},{110,-122},
          {110,-160},{91,-160}}, color={0,0,127}));
  connect(conSigHea.f1, one.y) annotation (Line(points={{138,-126},{120,-126},{
          120,-230},{101,-230}}, color={0,0,127}));
  connect(swi.y, conSigHea.u) annotation (Line(points={{83,-90},{100,-90},{100,
          -130},{138,-130}}, color={0,0,127}));
  connect(conSigHea.x2, uHeaMaxCon.y) annotation (Line(points={{138,-134},{61,-134}},
                                       color={0,0,127}));
  connect(conSigHea.f2, zer.y) annotation (Line(points={{138,-138},{116,-138},{
          116,-210},{-19,-210}}, color={0,0,127}));
  connect(conSigCoo.x1, uCooMinCon.y)
    annotation (Line(points={{138,-182},{61,-182}}, color={0,0,127}));
  connect(zer.y, conSigCoo.f1) annotation (Line(points={{-19,-210},{116,-210},{
          116,-186},{138,-186}}, color={0,0,127}));
  connect(conSigCoo.u, swi.y) annotation (Line(points={{138,-190},{100,-190},{
          100,-90},{83,-90}}, color={0,0,127}));
  connect(conSigCoo.x2, one.y) annotation (Line(points={{138,-194},{120,-194},{
          120,-230},{101,-230}}, color={0,0,127}));
  connect(conSigCoo.f2, one.y) annotation (Line(points={{138,-198},{120,-198},{
          120,-230},{101,-230}}, color={0,0,127}));
  connect(conEco.TMix, TMix) annotation (Line(points={{59.375,8.125},{-190,8.125},
          {-190,-70},{-210,-70}}, color={0,0,127}));
  connect(conSupFan.ySupFan, conTSup.trigger) annotation (Line(points={{21,117},
          {30,117},{30,-108},{-38,-108},{-38,-102}}, color={255,0,255}));
  annotation (
    defaultComponentName="conAHU",
    Diagram(coordinateSystem(extent={{-200,-260},{200,280}}, initialScale=0.2)),
    Icon(coordinateSystem(extent={{-200,-260},{200,280}}, initialScale=0.2),
        graphics={Rectangle(
          extent={{200,280},{-200,-260}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-148,328},{152,288}},
          textString="%name",
          lineColor={0,0,255})}));
end AHUGuideline36;
