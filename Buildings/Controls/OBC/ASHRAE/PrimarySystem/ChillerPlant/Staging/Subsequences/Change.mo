within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Boolean have_WSE = false
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Boolean anyVsdCen = false
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
    annotation (Placement(transformation(extent={{-320,-260},{-280,-220}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-320,-200},{-280,-160}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-320,-170},{-280,-130}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-320,-30},{-280,10}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if have_WSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-320,130},{-280,170}}),
       iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if have_WSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-320,100},{-280,140}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-320,0},{-280,40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-320,60},{-280,100}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-320,360},{-280,400}}),
        iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-320,290},{-280,330}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-320,260},{-280,300}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-320,180},{-280,220}}),
    iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-320,330},{-280,370}}),
    iconTransformation(extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{440,-270},{480,-230}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final max=fill(nSta, nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{440,40},{480,80}}),    iconTransformation(
          extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiTyp = chiTyp,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-240,-180},{-220,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat) "First higher and lower available stage index, end stage boolean flags and chiller status setpoints"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = delayStaCha) "Capacity requirement"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities cap(
    final nSta=nSta) "Design and minimum capacities for relevant chiller stages"
    annotation (Placement(transformation(extent={{-150,-180},{-130,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs(
    final anyVsdCen=anyVsdCen,
    final nSta=nSta,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax) "Operative and staging part load ratios"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));

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
    annotation (Placement(transformation(extent={{20,-122},{40,-102}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final have_WSE=have_WSE,
    final serChi=serChi,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final faiSafTDif=faiSafTDif,
    final faiSafDpDif=faiSafDpDif,
    final TDif=TDif,
    final TDifHys=TDifHys) "Stage down conditions"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{140,-200},{160,-180}})));

  CDL.Logical.Edge                          edg1
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{220,-200},{240,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage setpoint change trigger signal" annotation (Placement(transformation(
          extent={{440,-210},{480,-170}}), iconTransformation(extent={{100,50},
            {140,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal" annotation (Placement(
        transformation(extent={{-320,-100},{-280,-60}}),  iconTransformation(
          extent={{-140,-230},{-100,-190}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{240,-50},{260,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{340,50},{360,70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat(pre_y_start=true)
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(final min=0, final max=nSta)
    "Initial chiller stage (at plant enable)" annotation (Placement(
        transformation(extent={{-320,-60},{-280,-20}}),  iconTransformation(
          extent={{-140,-148},{-100,-108}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2 "Integer to real conversion"
    annotation (Placement(transformation(extent={{240,90},{260,110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(final
      trueHoldDuration=2*delayStaCha,
    final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch2
    annotation (Placement(transformation(extent={{300,50},{320,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol(final
      trueHoldDuration=0, final falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{268,-158},{288,-138}})));
  CDL.Logical.Edge                          edg2
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{220,-298},{240,-278}})));
  CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{272,-302},{292,-282}})));
  CDL.Logical.TrueDelay                            staChaHol1(delayTime=
        delayStaCha, delayOnInit=true)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{188,-294},{208,-274}})));
equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-300,-180},{-260,-180},{-260,-170},{-242,-170}},
          color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-218,-178},{-210,-178},
          {-210,-216},{-202,-216}},color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-300,-150},{-240,-150},
          {-240,302},{-202,302}}, color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-300,380},
          {-248,380},{-248,319},{-202,319}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-300,310},{-252,
          310},{-252,314},{-202,314}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-300,280},
          {-244,280},{-244,309},{-202,309}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-218,-162},{-200,
          -162},{-200,-161},{-152,-161}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-218,-166},{-190,
          -166},{-190,-164},{-152,-164}}, color={0,0,127}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-178,-203},{-164,-203},{-164,
          -170},{-152,-170}}, color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-178,-206},{-160,-206},
          {-160,-173},{-152,-173}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-178,-211},{-158,-211},{
          -158,-176},{-152,-176}}, color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-178,310},{-72,310},
          {-72,-176},{-62,-176}}, color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-128,-162},{-112,-162},
          {-112,-178},{-62,-178}},color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-128,-166},{-114,
          -166},{-114,-180},{-62,-180}},
                                  color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-128,-170},{-116,
          -170},{-116,-182},{-62,-182}},
                                       color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-128,-174},{-118,-174},
          {-118,-185},{-62,-185}},color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-128,-178},{-120,
          -178},{-120,-187},{-62,-187}},
                                       color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-300,80},{-80,80},{-80,-190},
          {-62,-190}},      color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-300,50},{-90,50},{-90,
          -192},{-62,-192}},     color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-300,20},{-100,20},{-100,
          -194},{-62,-194}},     color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-218,-174},{-180,-174},
          {-180,-198},{-62,-198}},                     color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-178,-203},{-120,-203},{-120,
          -204},{-62,-204}},
          color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-178,-206},{-62,-206}},
                                  color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-178,-214},{-156,-214},{
          -156,-179},{-152,-179}}, color={255,0,255}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{-38,-182},{-14,-182},
          {-14,-102},{18,-102}},
                             color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{-38,-191},{-12,-191},
          {-12,-104},{18,-104}},color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-300,380},
          {-40,380},{-40,-107},{18,-107}},
                                       color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-300,350},{-260,
          350},{-260,270},{-42,270},{-42,-109},{18,-109}},
                                                         color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-300,230},
          {-22,230},{-22,-112},{18,-112}},
                                         color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-300,200},{-24,
          200},{-24,-114},{18,-114}},color={0,0,127}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{-38,-186},{-20,
          -186},{-20,-220},{18,-220}},
                                color={0,0,127}));
  connect(staDow.uStaDow, PLRs.yStaDow) annotation (Line(points={{18,-222},{-22,
          -222},{-22,-193},{-38,-193}},
                               color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-300,
          230},{-24,230},{-24,-225},{18,-225}},
                                              color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-300,200},{
          -28,200},{-28,-227},{18,-227}},
                                        color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-300,380},
          {-30,380},{-30,-230},{18,-230}},
                                         color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-300,350},{-260,
          350},{-260,270},{-32,270},{-32,-232},{18,-232}},
                                                       color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-300,150},{-34,150},
          {-34,-234},{18,-234}},
                            color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-300,120},
          {-36,120},{-36,-236},{18,-236}},
                                      color={0,0,127}));
  connect(staDow.uWseSta, uWseSta) annotation (Line(points={{18,-241},{-218,-241},
          {-218,-240},{-300,-240}}, color={255,0,255}));
  connect(staDow.y, or2.u2) annotation (Line(points={{42,-230},{120,-230},{120,-198},
          {138,-198}}, color={255,0,255}));
  connect(u, sta.u) annotation (Line(points={{-300,-10},{-206,-10},{-206,-204},{
          -202,-204}},  color={255,127,0}));
  connect(sta.yAvaCur, staUp.uAvaCur) annotation (Line(points={{-178,-217},{-120,
          -217},{-120,-210},{0,-210},{0,-121},{18,-121}},  color={255,0,255}));
  connect(sta.yChi, yChi) annotation (Line(points={{-178,-220},{-98,-220},{-98,-250},
          {460,-250}},       color={255,0,255}));
  connect(staUp.y, or2.u1) annotation (Line(points={{42,-112},{120,-112},{120,-190},
          {138,-190}},       color={255,0,255}));
  connect(u, cap.u) annotation (Line(points={{-300,-10},{-206,-10},{-206,-167},{
          -152,-167}},  color={255,127,0}));
  connect(u, PLRs.u) annotation (Line(points={{-300,-10},{-206,-10},{-206,-60},{
          -110,-60},{-110,-202},{-62,-202}},       color={255,127,0}));
  connect(u, staUp.u) annotation (Line(points={{-300,-10},{-206,-10},{-206,-60},
          {10,-60},{10,-118},{18,-118}},        color={255,127,0}));
  connect(u, staDow.u) annotation (Line(points={{-300,-10},{-206,-10},{-206,-239},
          {18,-239}},       color={255,127,0}));
  connect(reaToInt.y, ySta)
    annotation (Line(points={{362,60},{460,60}},   color={255,127,0}));
  connect(switch1.y, triSam.u)
    annotation (Line(points={{202,-40},{238,-40}}, color={0,0,127}));
  connect(intToRea1.y, switch1.u1) annotation (Line(points={{142,0},{160,0},{160,
          -32},{178,-32}},      color={0,0,127}));
  connect(intToRea.y, switch1.u3) annotation (Line(points={{142,-80},{160,-80},{
          160,-48},{178,-48}},  color={0,0,127}));
  connect(staUp.y, lat.u) annotation (Line(points={{42,-112},{100,-112},{100,-40},
          {118,-40}},      color={255,0,255}));
  connect(staDow.y, lat.clr) annotation (Line(points={{42,-230},{90,-230},{90,-46},
          {118,-46}},      color={255,0,255}));
  connect(sta.yUp, intToRea1.u) annotation (Line(points={{-178,-203},{-170,-203},
          {-170,0},{118,0}},     color={255,127,0}));
  connect(sta.yDown, intToRea.u) annotation (Line(points={{-178,-206},{-170,-206},
          {-170,-80},{118,-80}},         color={255,127,0}));
  connect(lat.y, switch1.u2)
    annotation (Line(points={{142,-40},{178,-40}}, color={255,0,255}));
  connect(uPla, edg.u) annotation (Line(points={{-300,-80},{-180,-80},{-180,60},
          {58,60}},  color={255,0,255}));
  connect(edg.y, holIniSta.u)
    annotation (Line(points={{82,60},{118,60}},   color={255,0,255}));
  connect(switch2.y, reaToInt.u)
    annotation (Line(points={{322,60},{338,60}},   color={0,0,127}));
  connect(triSam.y, switch2.u3) annotation (Line(points={{262,-40},{280,-40},{280,
          52},{298,52}},       color={0,0,127}));
  connect(holIniSta.y, switch2.u2)
    annotation (Line(points={{142,60},{298,60}},   color={255,0,255}));
  connect(uIni, intToRea2.u) annotation (Line(points={{-300,-40},{-220,-40},{-220,
          100},{238,100}},
                         color={255,127,0}));
  connect(intToRea2.y, switch2.u1) annotation (Line(points={{262,100},{280,100},
          {280,68},{298,68}},
                           color={0,0,127}));
  connect(or2.y, staChaHol.u)
    annotation (Line(points={{162,-190},{178,-190}}, color={255,0,255}));
  connect(edg1.y, y)
    annotation (Line(points={{242,-190},{460,-190}}, color={255,0,255}));
  connect(staChaHol.y, edg1.u)
    annotation (Line(points={{202,-190},{218,-190}}, color={255,0,255}));
  connect(edg1.y, or1.u1) annotation (Line(points={{242,-190},{254,-190},{254,
          -148},{266,-148}}, color={255,0,255}));
  connect(edg2.y, and2.u1) annotation (Line(points={{242,-288},{258,-288},{258,
          -292},{270,-292}}, color={255,0,255}));
  connect(and2.y, or1.u2) annotation (Line(points={{294,-292},{294,-172},{258,
          -172},{258,-156},{266,-156}}, color={255,0,255}));
  connect(or1.y, triSam.trigger) annotation (Line(points={{290,-148},{298,-148},
          {298,-88},{250,-88},{250,-51.8}}, color={255,0,255}));
  connect(or2.y, and2.u2) annotation (Line(points={{162,-190},{168,-190},{168,
          -336},{260,-336},{260,-300},{270,-300}}, color={255,0,255}));
  connect(edg2.u, staChaHol1.y) annotation (Line(points={{218,-288},{214,-288},
          {214,-284},{210,-284}}, color={255,0,255}));
  connect(or2.y, staChaHol1.u) annotation (Line(points={{162,-190},{178,-190},{
          178,-284},{186,-284}}, color={255,0,255}));
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
        extent={{-280,-420},{440,420}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: elaborate

tasks:
- pull stage change assignment stage into a separate block
- stage up t to +1 if no higher available, persist (according to Brandon)
  

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
