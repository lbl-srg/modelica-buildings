within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Boolean have_WSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Boolean anyVsdCen = true
    "Plant contains at least one variable speed centrifugal chiller";

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index";

  parameter Modelica.SIunits.Power chiDesCap[nChi]
    "Design chiller capacities vector";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller minimum cycling loads vector";

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal";

  parameter Modelica.SIunits.Time avePer = 300
  "Time period for the capacity requirement rolling average";

  parameter Modelica.SIunits.Time delayStaCha = 900
  "Hold period for each stage change";

  parameter Modelica.SIunits.Time parLoaRatDelay = 900
    "Enable delay for operating and staging part load ratio condition";

  parameter Modelica.SIunits.Time faiSafTruDelay = 900
    "Enable delay for failsafe condition";

  parameter Modelica.SIunits.Time effConTruDelay = 900
    "Enable delay for efficiency condition";

  parameter Modelica.SIunits.Time shortTDelay = 600
    "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Modelica.SIunits.Time longTDelay = 1200
    "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Real posDisMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.8
    "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Constant speed centrifugal chiller type staging multiplier";

  parameter Real varSpeStaMin(
    final unit = "1",
    final min = 0.1,
    final max = 1)=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  parameter Real varSpeStaMax(
    final unit = "1",
    final min = varSpeStaMin,
    final max = 1)=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Modelica.SIunits.TemperatureDifference faiSafTDif = 1
    "Offset between the chilled water supply temperature and its setpoint for the failsafe condition";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump diferential static pressure and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint for staging down to WSE only";

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Hysteresis deadband for temperature";

  parameter Modelica.SIunits.PressureDifference faiSafDpDif = 2 * 6895
    "Offset between the chilled water differential pressure and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDifHys = 0.5 * 6895
    "Pressure difference hysteresis deadband";

  parameter Real effConSigDif = 0.05
    "Signal hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if have_WSE
    "WSE status"
    annotation (Placement(transformation(extent={{-280,-320},{-240,-280}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-280,-230},{-240,-190}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if have_WSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}}),
       iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if have_WSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-280,300},{-240,340}}),
        iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-280,230},{-240,270}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-280,200},{-240,240}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-280,150},{-240,190}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
    iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-280,270},{-240,310}}),
    iconTransformation(extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{400,-330},{440,-290}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final max=fill(nSta, nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{400,-110},{440,-70}}), iconTransformation(
          extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiTyp = chiTyp,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat)
    annotation (Placement(transformation(extent={{-160,-280},{-140,-260}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = delayStaCha)
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities cap(
    final nSta=nSta)
    annotation (Placement(transformation(extent={{-110,-240},{-90,-220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs(
    final anyVsdCen=anyVsdCen,
    final nSta=nSta,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax)
    annotation (Placement(transformation(extent={{-20,-260},{0,-240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up staUp(
    final have_WSE=have_WSE,
    final serChi=serChi,
    final effConTruDelay=effConTruDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final shortTDelay=shortTDelay,
    final longTDelay=longTDelay,
    final faiSafTDif=faiSafTDif,
    final TDifHys=TDifHys,
    final smallTDif=smallTDif,
    final largeTDif=largeTDif,
    final faiSafDpDif=faiSafDpDif,
    final dpDifHys=dpDifHys,
    final effConSigDif=effConSigDif) "Stage up conditions"
    annotation (Placement(transformation(extent={{60,-182},{80,-162}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final have_WSE=have_WSE,
    final serChi=serChi,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final faiSafTDif=faiSafTDif,
    final faiSafDpDif=faiSafDpDif,
    final TDif=TDif,
    final TDifHys=TDifHys) "Stage down conditions"
    annotation (Placement(transformation(extent={{60,-300},{80,-280}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha
    annotation (Placement(transformation(extent={{220,-260},{240,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage setpoint change trigger signal" annotation (Placement(transformation(
          extent={{400,-270},{440,-230}}), iconTransformation(extent={{100,50},
            {140,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla "Plant enable signal" annotation (Placement(
        transformation(extent={{-280,-160},{-240,-120}}), iconTransformation(
          extent={{-140,-230},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
  CDL.Logical.Switch                               switch1
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{340,-30},{360,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(final min=0, final max=nSta)
    "Initial chiller stage (at plant enable)" annotation (Placement(
        transformation(extent={{-280,-120},{-240,-80}}), iconTransformation(
          extent={{-140,-148},{-100,-108}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2 "Integer to real conversion"
    annotation (Placement(transformation(extent={{240,20},{260,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(trueHoldDuration=delayStaCha,
      falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  CDL.Logical.Switch                               switch2
    annotation (Placement(transformation(extent={{300,-30},{320,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol(trueHoldDuration=0,
                                      falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-260,-240},{-220,-240},{-220,-230},{-202,-230}},
          color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-178,-238},{-170,-238},
          {-170,-276},{-162,-276}},color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-260,-210},{-200,
          -210},{-200,242},{-162,242}},
                                  color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-260,
          320},{-208,320},{-208,259},{-162,259}},
                                             color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-260,250},{
          -212,250},{-212,254},{-162,254}},
                                       color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-260,220},
          {-204,220},{-204,249},{-162,249}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-178,-222},{-160,
          -222},{-160,-221},{-112,-221}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-178,-226},{-150,
          -226},{-150,-224},{-112,-224}}, color={0,0,127}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-138,-263},{-124,-263},{
          -124,-230},{-112,-230}},
                              color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-138,-266},{-120,-266},
          {-120,-233},{-112,-233}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-138,-271},{-118,-271},
          {-118,-236},{-112,-236}},color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-138,250},{-32,250},
          {-32,-236},{-22,-236}}, color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-88,-222},{-72,-222},
          {-72,-238},{-22,-238}}, color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-88,-226},{-74,-226},
          {-74,-240},{-22,-240}}, color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-88,-230},{-76,
          -230},{-76,-242},{-22,-242}},color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-88,-234},{-78,-234},
          {-78,-245},{-22,-245}}, color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-88,-238},{-80,-238},
          {-80,-247},{-22,-247}},      color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-260,20},{-40,20},{-40,
          -250},{-22,-250}},color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-260,-10},{-50,-10},
          {-50,-252},{-22,-252}},color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-260,-40},{-60,-40},
          {-60,-254},{-22,-254}},color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-178,-234},{-140,-234},
          {-140,-258},{-22,-258}},                     color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-138,-263},{-80,-263},{
          -80,-264},{-22,-264}},
          color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-138,-266},{-80,-266},
          {-80,-266},{-22,-266}}, color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-138,-274},{-116,-274},
          {-116,-239},{-112,-239}},color={255,0,255}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{2,-242},{26,-242},{26,
          -162},{58,-162}},  color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{2,-251},{28,-251},
          {28,-164},{58,-164}}, color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-260,320},
          {0,320},{0,-167},{58,-167}}, color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-260,290},{-220,
          290},{-220,210},{-2,210},{-2,-169},{58,-169}}, color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-260,170},
          {18,170},{18,-172},{58,-172}}, color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-260,140},{16,
          140},{16,-174},{58,-174}}, color={0,0,127}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{2,-246},{20,-246},
          {20,-280},{58,-280}}, color={0,0,127}));
  connect(staDow.uStaDow, PLRs.yStaDow) annotation (Line(points={{58,-282},{18,-282},
          {18,-253},{2,-253}}, color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-260,
          170},{16,170},{16,-285},{58,-285}}, color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-260,140},{
          12,140},{12,-287},{58,-287}}, color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-260,320},
          {10,320},{10,-290},{58,-290}}, color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-260,290},{-220,
          290},{-220,210},{8,210},{8,-292},{58,-292}}, color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-260,90},{6,90},{6,
          -294},{58,-294}}, color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-260,60},
          {4,60},{4,-296},{58,-296}}, color={0,0,127}));
  connect(staDow.uWseSta, uWseSta) annotation (Line(points={{58,-301},{-178,-301},
          {-178,-300},{-260,-300}}, color={255,0,255}));
  connect(staDow.y, or2.u2) annotation (Line(points={{82,-290},{120,-290},{120,-258},
          {138,-258}}, color={255,0,255}));
  connect(u, sta.u) annotation (Line(points={{-260,-70},{-166,-70},{-166,-264},
          {-162,-264}}, color={255,127,0}));
  connect(sta.yAvaCur, staUp.uAvaCur) annotation (Line(points={{-138,-277},{-80,
          -277},{-80,-270},{40,-270},{40,-181},{58,-181}}, color={255,0,255}));
  connect(sta.yChi, yChi) annotation (Line(points={{-138,-280},{-58,-280},{-58,
          -310},{420,-310}}, color={255,0,255}));
  connect(staUp.y, or2.u1) annotation (Line(points={{82,-172},{120,-172},{120,-250},
          {138,-250}},       color={255,0,255}));
  connect(u, cap.u) annotation (Line(points={{-260,-70},{-166,-70},{-166,-227},
          {-112,-227}}, color={255,127,0}));
  connect(u, PLRs.u) annotation (Line(points={{-260,-70},{-166,-70},{-166,-120},
          {-70,-120},{-70,-262},{-22,-262}},       color={255,127,0}));
  connect(u, staUp.u) annotation (Line(points={{-260,-70},{-166,-70},{-166,-120},
          {50,-120},{50,-178},{58,-178}},       color={255,127,0}));
  connect(u, staDow.u) annotation (Line(points={{-260,-70},{-166,-70},{-166,-299},
          {58,-299}},       color={255,127,0}));
  connect(reaToInt.y, ySta)
    annotation (Line(points={{362,-20},{370,-20},{370,-90},{420,-90}},
                                                   color={255,127,0}));
  connect(switch1.y, triSam.u)
    annotation (Line(points={{202,-100},{238,-100}},
                                                   color={0,0,127}));
  connect(intToRea1.y, switch1.u1) annotation (Line(points={{142,-60},{160,-60},
          {160,-92},{178,-92}}, color={0,0,127}));
  connect(intToRea.y, switch1.u3) annotation (Line(points={{142,-140},{160,-140},
          {160,-108},{178,-108}},
                                color={0,0,127}));
  connect(staUp.y, lat.u) annotation (Line(points={{82,-172},{100,-172},{100,-100},
          {118,-100}},     color={255,0,255}));
  connect(staDow.y, lat.clr) annotation (Line(points={{82,-290},{90,-290},{90,-106},
          {118,-106}},     color={255,0,255}));
  connect(sta.yUp, intToRea1.u) annotation (Line(points={{-138,-263},{-130,-263},
          {-130,-60},{118,-60}}, color={255,127,0}));
  connect(sta.yDown, intToRea.u) annotation (Line(points={{-138,-266},{-130,-266},
          {-130,-140},{118,-140}},       color={255,127,0}));
  connect(lat.y, switch1.u2)
    annotation (Line(points={{142,-100},{178,-100}},
                                                   color={255,0,255}));
  connect(uPla, edg.u) annotation (Line(points={{-260,-140},{-140,-140},{-140,
          -20},{58,-20}},
                     color={255,0,255}));
  connect(edg.y, holIniSta.u)
    annotation (Line(points={{82,-20},{118,-20}}, color={255,0,255}));
  connect(switch2.y, reaToInt.u)
    annotation (Line(points={{322,-20},{338,-20}}, color={0,0,127}));
  connect(triSam.y, switch2.u3) annotation (Line(points={{262,-100},{280,-100},
          {280,-28},{298,-28}},color={0,0,127}));
  connect(holIniSta.y, switch2.u2)
    annotation (Line(points={{142,-20},{298,-20}}, color={255,0,255}));
  connect(uIni, intToRea2.u) annotation (Line(points={{-260,-100},{-180,-100},{
          -180,30},{238,30}},
                         color={255,127,0}));
  connect(intToRea2.y, switch2.u1) annotation (Line(points={{262,30},{280,30},{
          280,-12},{298,-12}},
                           color={0,0,127}));
  connect(or2.y, staChaHol.u)
    annotation (Line(points={{162,-250},{178,-250}}, color={255,0,255}));
  connect(staChaHol.y, cha.u)
    annotation (Line(points={{202,-250},{218,-250}}, color={255,0,255}));
  connect(cha.y, triSam.trigger) annotation (Line(points={{242,-250},{250,-250},
          {250,-111.8},{250,-111.8}}, color={255,0,255}));
  connect(cha.y, y)
    annotation (Line(points={{242,-250},{420,-250}}, color={255,0,255}));
  annotation (defaultComponentName = "cha",
        Icon(graphics={
        Rectangle(
        extent={{-100,-160},{100,160}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,210},{110,172}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-240,-360},{400,340}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: elaborate

</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
