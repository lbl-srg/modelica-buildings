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
    annotation (Placement(transformation(extent={{-442,-260},{-402,-220}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-442,-200},{-402,-160}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-442,-30},{-402,10}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if have_WSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-442,130},{-402,170}}),
       iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if have_WSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-442,100},{-402,140}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-442,0},{-402,40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-442,60},{-402,100}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-442,30},{-402,70}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-442,360},{-402,400}}),
        iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-442,290},{-402,330}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-442,260},{-402,300}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-442,210},{-402,250}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-442,180},{-402,220}}),
    iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-442,330},{-402,370}}),
    iconTransformation(extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{420,-280},{460,-240}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final max=fill(nSta, nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{420,40},{460,80}}),    iconTransformation(
          extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiTyp = chiTyp,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-362,-180},{-342,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat) "First higher and lower available stage index, end stage boolean flags and chiller status setpoints"
    annotation (Placement(transformation(extent={{-322,-220},{-302,-200}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = delayStaCha) "Capacity requirement"
    annotation (Placement(transformation(extent={{-322,300},{-302,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities cap(
    final nSta=nSta) "Design and minimum capacities for relevant chiller stages"
    annotation (Placement(transformation(extent={{-272,-180},{-252,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs(
    final anyVsdCen=anyVsdCen,
    final nSta=nSta,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax) "Operative and staging part load ratios"
    annotation (Placement(transformation(extent={{-182,-200},{-162,-180}})));

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
    annotation (Placement(transformation(extent={{-102,-122},{-82,-102}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final have_WSE=have_WSE,
    final serChi=serChi,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final faiSafTDif=faiSafTDif,
    final faiSafDpDif=faiSafDpDif,
    final TDif=TDif,
    final TDifHys=TDifHys) "Stage down conditions"
    annotation (Placement(transformation(extent={{-102,-240},{-82,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{8,-200},{28,-180}})));

  CDL.Logical.Edge                          edg1
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{98,-200},{118,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla "Plant enable signal"
                          annotation (Placement(
        transformation(extent={{-442,-100},{-402,-60}}),  iconTransformation(
          extent={{-140,-230},{-100,-190}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{138,-50},{158,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{58,-50},{78,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-2,-90},{18,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{320,50},{340,70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat(pre_y_start=true)
    annotation (Placement(transformation(extent={{-2,-50},{18,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(final min=0, final max=nSta)
    "Initial chiller stage (at plant enable)" annotation (Placement(
        transformation(extent={{-442,-60},{-402,-20}}),  iconTransformation(
          extent={{-140,-148},{-100,-108}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2 "Integer to real conversion"
    annotation (Placement(transformation(extent={{118,90},{138,110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(final
      trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{-2,50},{18,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch2
    annotation (Placement(transformation(extent={{200,50},{220,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol(final
      trueHoldDuration=0, final falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{58,-200},{78,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-62,50},{-42,70}})));

  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{146,-158},{166,-138}})));
  CDL.Logical.Edge                          edg2
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{98,-300},{118,-280}})));
  CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{140,-300},{160,-280}})));
  CDL.Logical.Timer tim(accumulate=false)
    annotation (Placement(transformation(extent={{100,-330},{120,-310}})));
  CDL.Logical.And and1
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{58,-302},{78,-282}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{218,-342},{238,-322}})));
  CDL.Continuous.LessEqualThreshold lesEquThr(threshold=delayStaCha)
    annotation (Placement(transformation(extent={{170,-340},{190,-320}})));
  CDL.Discrete.TriggeredSampler                        triSam1
    annotation (Placement(transformation(extent={{218,-100},{238,-80}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{188,-100},{208,-80}})));
  CDL.Continuous.GreaterThreshold greThr1(threshold=0.5)
    annotation (Placement(transformation(extent={{252,-100},{272,-80}})));
  CDL.Logical.Latch lat1
    annotation (Placement(transformation(extent={{132,50},{152,70}})));
  CDL.Logical.And and3
    "Ensures consecutive stage changes occur at steep load changes where a stage up or a stage down signal remains on after a single stage change as an another one is needed shortly after"
    annotation (Placement(transformation(extent={{268,-10},{288,10}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{198,0},{218,20}})));
  CDL.Logical.And and4
    annotation (Placement(transformation(extent={{198,-162},{218,-142}})));
  CDL.Interfaces.BooleanOutput y "Chiller stage change edge signal" annotation (
     Placement(transformation(extent={{420,-118},{460,-78}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{336,-88},{356,-68}})));
  CDL.Logical.And and5
    annotation (Placement(transformation(extent={{390,-106},{410,-86}})));
  CDL.Interfaces.BooleanInput chaPro "Stage change process status signal"
    annotation (Placement(transformation(extent={{-440,-140},{-400,-100}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-422,-180},{-382,-180},{-382,-170},{-364,-170}},
          color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-340,-178},{-332,-178},
          {-332,-216},{-324,-216}},color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-422,380},
          {-370,380},{-370,319},{-324,319}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-422,310},{-374,
          310},{-374,314},{-324,314}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-422,280},
          {-366,280},{-366,309},{-324,309}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-340,-162},{-322,
          -162},{-322,-161},{-274,-161}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-340,-166},{-312,
          -166},{-312,-164},{-274,-164}}, color={0,0,127}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-300,-203},{-286,-203},{-286,
          -170},{-274,-170}}, color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-300,-206},{-282,-206},
          {-282,-173},{-274,-173}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-300,-211},{-280,-211},{
          -280,-176},{-274,-176}}, color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-300,310},{-194,310},
          {-194,-176},{-184,-176}},
                                  color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-250,-162},{-234,-162},
          {-234,-178},{-184,-178}},
                                  color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-250,-166},{-236,
          -166},{-236,-180},{-184,-180}},
                                  color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-250,-170},{-238,
          -170},{-238,-182},{-184,-182}},
                                       color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-250,-174},{-240,-174},
          {-240,-185},{-184,-185}},
                                  color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-250,-178},{-242,
          -178},{-242,-187},{-184,-187}},
                                       color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-422,80},{-202,80},{-202,-190},
          {-184,-190}},     color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-422,50},{-212,50},{-212,
          -192},{-184,-192}},    color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-422,20},{-222,20},{-222,
          -194},{-184,-194}},    color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-340,-174},{-302,-174},
          {-302,-198},{-184,-198}},                    color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-300,-203},{-242,-203},{-242,
          -204},{-184,-204}},
          color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-300,-206},{-184,-206}},
                                  color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-300,-214},{-278,-214},{
          -278,-179},{-274,-179}}, color={255,0,255}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{-160,-182},{-136,-182},
          {-136,-102},{-104,-102}},
                             color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{-160,-191},{-134,
          -191},{-134,-104},{-104,-104}},
                                color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-422,380},
          {-162,380},{-162,-107},{-104,-107}},
                                       color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-422,350},{-382,
          350},{-382,270},{-164,270},{-164,-109},{-104,-109}},
                                                         color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-422,230},
          {-144,230},{-144,-112},{-104,-112}},
                                         color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-422,200},{-146,
          200},{-146,-114},{-104,-114}},
                                     color={0,0,127}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{-160,-186},{-142,
          -186},{-142,-220},{-104,-220}},
                                color={0,0,127}));
  connect(staDow.uStaDow, PLRs.yStaDow) annotation (Line(points={{-104,-222},{-144,
          -222},{-144,-193},{-160,-193}},
                               color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-422,
          230},{-146,230},{-146,-225},{-104,-225}},
                                              color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-422,200},{
          -150,200},{-150,-227},{-104,-227}},
                                        color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-422,380},
          {-152,380},{-152,-230},{-104,-230}},
                                         color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-422,350},{-382,
          350},{-382,270},{-154,270},{-154,-232},{-104,-232}},
                                                       color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-422,150},{-156,150},
          {-156,-234},{-104,-234}},
                            color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-422,120},
          {-158,120},{-158,-236},{-104,-236}},
                                      color={0,0,127}));
  connect(staDow.uWseSta, uWseSta) annotation (Line(points={{-104,-241},{-340,-241},
          {-340,-240},{-422,-240}}, color={255,0,255}));
  connect(staDow.y, or2.u2) annotation (Line(points={{-80,-230},{-2,-230},{-2,-198},
          {6,-198}},   color={255,0,255}));
  connect(u, sta.u) annotation (Line(points={{-422,-10},{-328,-10},{-328,-204},{
          -324,-204}},  color={255,127,0}));
  connect(sta.yAvaCur, staUp.uAvaCur) annotation (Line(points={{-300,-217},{-242,
          -217},{-242,-210},{-122,-210},{-122,-121},{-104,-121}},
                                                           color={255,0,255}));
  connect(sta.yChi, yChi) annotation (Line(points={{-300,-220},{-220,-220},{-220,
          -260},{440,-260}}, color={255,0,255}));
  connect(staUp.y, or2.u1) annotation (Line(points={{-80,-112},{-2,-112},{-2,-190},
          {6,-190}},         color={255,0,255}));
  connect(u, cap.u) annotation (Line(points={{-422,-10},{-328,-10},{-328,-167},{
          -274,-167}},  color={255,127,0}));
  connect(u, PLRs.u) annotation (Line(points={{-422,-10},{-328,-10},{-328,-60},{
          -232,-60},{-232,-202},{-184,-202}},      color={255,127,0}));
  connect(u, staUp.u) annotation (Line(points={{-422,-10},{-328,-10},{-328,-60},
          {-112,-60},{-112,-118},{-104,-118}},  color={255,127,0}));
  connect(u, staDow.u) annotation (Line(points={{-422,-10},{-328,-10},{-328,-239},
          {-104,-239}},     color={255,127,0}));
  connect(reaToInt.y, ySta)
    annotation (Line(points={{342,60},{440,60}},   color={255,127,0}));
  connect(switch1.y, triSam.u)
    annotation (Line(points={{80,-40},{136,-40}},  color={0,0,127}));
  connect(intToRea1.y, switch1.u1) annotation (Line(points={{20,0},{38,0},{38,-32},
          {56,-32}},            color={0,0,127}));
  connect(intToRea.y, switch1.u3) annotation (Line(points={{20,-80},{38,-80},{38,
          -48},{56,-48}},       color={0,0,127}));
  connect(staUp.y, lat.u) annotation (Line(points={{-80,-112},{-22,-112},{-22,-40},
          {-4,-40}},       color={255,0,255}));
  connect(staDow.y, lat.clr) annotation (Line(points={{-80,-230},{-32,-230},{-32,
          -46},{-4,-46}},  color={255,0,255}));
  connect(sta.yUp, intToRea1.u) annotation (Line(points={{-300,-203},{-292,-203},
          {-292,0},{-4,0}},      color={255,127,0}));
  connect(sta.yDown, intToRea.u) annotation (Line(points={{-300,-206},{-292,-206},
          {-292,-80},{-4,-80}},          color={255,127,0}));
  connect(lat.y, switch1.u2)
    annotation (Line(points={{20,-40},{56,-40}},   color={255,0,255}));
  connect(uPla, edg.u) annotation (Line(points={{-422,-80},{-302,-80},{-302,60},
          {-64,60}}, color={255,0,255}));
  connect(edg.y, holIniSta.u)
    annotation (Line(points={{-40,60},{-4,60}},   color={255,0,255}));
  connect(triSam.y, switch2.u3) annotation (Line(points={{160,-40},{168,-40},{168,
          52},{198,52}},       color={0,0,127}));
  connect(uIni, intToRea2.u) annotation (Line(points={{-422,-40},{-342,-40},{-342,
          100},{116,100}},
                         color={255,127,0}));
  connect(intToRea2.y, switch2.u1) annotation (Line(points={{140,100},{168,100},
          {168,68},{198,68}},
                           color={0,0,127}));
  connect(or2.y, staChaHol.u)
    annotation (Line(points={{30,-190},{56,-190}},   color={255,0,255}));
  connect(staChaHol.y, edg1.u)
    annotation (Line(points={{80,-190},{96,-190}},   color={255,0,255}));
  connect(edg1.y, or1.u1) annotation (Line(points={{120,-190},{132,-190},{132,-148},
          {144,-148}},       color={255,0,255}));
  connect(edg2.y, and2.u1) annotation (Line(points={{120,-290},{138,-290}},
                             color={255,0,255}));
  connect(and2.y, or1.u2) annotation (Line(points={{162,-290},{162,-172},{136,-172},
          {136,-156},{144,-156}},       color={255,0,255}));
  connect(or1.y, triSam.trigger) annotation (Line(points={{168,-148},{176,-148},
          {176,-78},{148,-78},{148,-51.8}}, color={255,0,255}));
  connect(or2.y, and2.u2) annotation (Line(points={{30,-190},{38,-190},{38,-336},
          {138,-336},{138,-298}},                  color={255,0,255}));
  connect(or2.y, and1.u1) annotation (Line(points={{30,-190},{42,-190},{42,-292},
          {56,-292}},        color={255,0,255}));
  connect(tim.y, lesEquThr.u) annotation (Line(points={{122,-320},{146,-320},{146,
          -330},{168,-330}},     color={0,0,127}));
  connect(lesEquThr.y, pre.u) annotation (Line(points={{192,-330},{216,-330},{216,
          -332}},     color={255,0,255}));
  connect(pre.y, and1.u2) annotation (Line(points={{240,-332},{240,-358},{46,-358},
          {46,-300},{56,-300}},         color={255,0,255}));
  connect(and1.y, tim.u) annotation (Line(points={{80,-292},{88,-292},{88,-320},
          {98,-320}},        color={255,0,255}));
  connect(and1.y, edg2.u) annotation (Line(points={{80,-292},{90,-292},{90,-290},
          {96,-290}},        color={255,0,255}));
  connect(triSam1.u, booToRea.y)
    annotation (Line(points={{216,-90},{210,-90}}, color={0,0,127}));
  connect(con.y, booToRea.u)
    annotation (Line(points={{82,-90},{186,-90}}, color={255,0,255}));
  connect(triSam1.y, greThr1.u)
    annotation (Line(points={{240,-90},{250,-90}}, color={0,0,127}));
  connect(lat1.y, switch2.u2)
    annotation (Line(points={{154,60},{198,60}}, color={255,0,255}));
  connect(edg.y, lat1.u) annotation (Line(points={{-40,60},{-22,60},{-22,80},{58,
          80},{58,60},{130,60}}, color={255,0,255}));
  connect(switch2.y, reaToInt.u)
    annotation (Line(points={{222,60},{318,60}}, color={0,0,127}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{274,-90},{284,-90},{284,
          -34},{248,-34},{248,-8},{266,-8}}, color={255,0,255}));
  connect(holIniSta.y, not1.u) annotation (Line(points={{20,60},{38,60},{38,20},
          {138,20},{138,10},{196,10}}, color={255,0,255}));
  connect(not1.y, and3.u1) annotation (Line(points={{220,10},{242,10},{242,0},{266,
          0}}, color={255,0,255}));
  connect(and3.y, lat1.clr) annotation (Line(points={{290,0},{302,0},{302,36},{100,
          36},{100,54},{130,54}}, color={255,0,255}));
  connect(and4.y, triSam1.trigger) annotation (Line(points={{220,-152},{228,-152},
          {228,-101.8}}, color={255,0,255}));
  connect(edg1.y, and4.u2) annotation (Line(points={{120,-190},{186,-190},{186,-160},
          {196,-160}}, color={255,0,255}));
  connect(not1.y, and4.u1) annotation (Line(points={{220,10},{228,10},{228,-60},
          {180,-60},{180,-152},{196,-152}}, color={255,0,255}));
  connect(lat1.y, not2.u) annotation (Line(points={{154,60},{240,60},{240,34},{318,
          34},{318,-78},{334,-78}}, color={255,0,255}));
  connect(y, and5.y) annotation (Line(points={{440,-98},{426,-98},{426,-96},{412,
          -96}}, color={255,0,255}));
  connect(not2.y, and5.u1) annotation (Line(points={{358,-78},{373,-78},{373,-96},
          {388,-96}}, color={255,0,255}));
  connect(or1.y, and5.u2) annotation (Line(points={{168,-148},{184,-148},{184,-226},
          {348,-226},{348,-104},{388,-104}}, color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-420,-120},{-350,
          -120},{-350,302},{-324,302}}, color={255,0,255}));
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
        extent={{-400,-420},{420,420}})),
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
