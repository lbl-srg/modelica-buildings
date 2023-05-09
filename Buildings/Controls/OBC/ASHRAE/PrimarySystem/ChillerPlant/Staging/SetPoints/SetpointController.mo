within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints;
block SetpointController
  "Calculates the chiller stage status setpoint signal"

  parameter Boolean have_WSE = false
    "true = plant has a WSE, false = plant does not have WSE"
    annotation (Dialog(tab="General", group="Plant configuration parameters"));

  parameter Boolean have_serChi = false
    "true = series chillers plant; false = parallel chillers plant"
    annotation (Dialog(tab="General", group="Plant configuration parameters"));

  parameter Boolean have_locSen=false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller"
    annotation (Dialog(tab="General", group="Plant configuration parameters", enable=not have_serChi));

  parameter Integer nRemSen=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(tab="General", group="Plant configuration parameters", enable=not have_serChi));

  parameter Boolean anyVsdCen=false
    "Plant contains at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Plant configuration parameters"));

  parameter Integer nChi = 2
    "Number of chillers"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Real chiDesCap[nChi](
    final unit=fill("W",nChi),
    displayUnit=fill("W",nChi))
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Real chiMinCap[nChi](
    final unit=fill("W",nChi),
    displayUnit=fill("W",nChi))
    "Chiller minimum cycling loads vector"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Chiller configuration parameters"));

  parameter Real avePer(unit="s")=300
      "Time period for the capacity requirement rolling average"
    annotation (Dialog(tab="Time parameters", group="Hold and delay parameters"));

  parameter Real delayStaCha(
    unit="s",
    displayUnit="h")=900
      "Hold period for each stage change"
    annotation (Dialog(tab="Time parameters", group="Hold and delay parameters"));

  parameter Real parLoaRatDelay(
    unit="s",
    displayUnit="h")=900
      "Enable delay for operating and staging part load ratio condition"
    annotation (Dialog(tab="Time parameters", group="Hold and delay parameters"));

  parameter Real faiSafTruDelay(
    unit="s",
    displayUnit="h")=900
      "Enable delay for failsafe condition"
    annotation (Dialog(tab="Time parameters", group="Hold and delay parameters"));

  parameter Real effConTruDelay(
    unit="s",
    displayUnit="h")=900
      "Enable delay for efficiency condition"
    annotation (Dialog(tab="Time parameters", group="Hold and delay parameters"));

  parameter Real shortTDelay(
    unit="s",
    displayUnit="h")=600
      "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Time parameters", group="Hold and delay parameters"));

  parameter Real longTDelay(
    unit="s",
    displayUnit="h")=1200
      "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Time parameters", group="Hold and delay parameters"));

  parameter Real posDisMult(unit="1")=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Conditionals", group="Staging part load ratio parameters"));

  parameter Real conSpeCenMult(unit="1")=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Conditionals", group="Staging part load ratio parameters"));

  parameter Real anyOutOfScoMult(unit="1")=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Conditionals", group="Staging part load ratio parameters"));

  parameter Real varSpeStaMin(unit="1")=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Conditionals", group="Staging part load ratio parameters"));

  parameter Real varSpeStaMax(unit="1")=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Conditionals", group="Staging part load ratio parameters"));

  parameter Real smallTDif(
    unit="K",
    displayUnit="degC")=1
      "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Conditionals", group="Value comparison parameters"));

  parameter Real largeTDif(
    unit="K",
    displayUnit="degC")=2
      "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Conditionals", group="Value comparison parameters"));

  parameter Real faiSafTDif(
    unit="K",
    displayUnit="degC")=1
      "Offset between the chilled water supply temperature and its setpoint for the failsafe condition"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real dpDif(
    unit="Pa",
    displayUnit="Pa")=2*6895
      "Offset between the chilled water pump diferential static pressure and its setpoint"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real TDif(
    unit="K",
    displayUnit="degC")=1
      "Offset between the chilled water supply temperature and its setpoint for staging down to WSE only"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real TDifHys(
    unit="K",
    displayUnit="degC")=1
      "Hysteresis deadband for temperature"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real faiSafDpDif(
    unit="Pa",
    displayUnit="Pa")=2*6895
      "Offset between the chilled water differential pressure and its setpoint"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real dpDifHys(
    unit="Pa",
    displayUnit="Pa")=0.5*6895
      "Pressure difference hysteresis deadband"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  parameter Real effConSigDif(unit="1")=0.05
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Conditionals", group="Value comparison parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla "Plant enable signal"
    annotation (Placement(
        transformation(extent={{-440,-120},{-400,-80}}), iconTransformation(
          extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro "Stage change process status signal"
    annotation (Placement(transformation(extent={{-440,-160},{-400,-120}}),
        iconTransformation(extent={{-140,150},{-100,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if have_WSE
    "WSE status"
    annotation (Placement(transformation(extent={{-442,-280},{-402,-240}}),
        iconTransformation(extent={{-140,170},{-100,210}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-442,-220},{-402,-180}}),
        iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min=0,
    final max=nSta)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-440,
            -80},{-400,-40}}), iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final quantity="ThermodynamicTemperature",
    final unit="K") if have_WSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-440,70},{-400,110}}),
       iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if have_WSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-440,40},{-400,80}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-440,-30},{-400,10}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-440,0},{-400,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-442,350},{-402,390}}),
        iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-440,280},{-400,320}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-440,250},{-400,290}}),
        iconTransformation(extent={{-140,-230},{-100,-190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_local(
    final unit="Pa",
    final quantity="PressureDifference")
    if (not have_serChi) and have_locSen
    "Chilled water pump differential static pressure setpoint for local sensor"
    annotation (Placement(transformation(extent={{-440,220},{-400,260}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_local(
    final unit="Pa",
    final quantity="PressureDifference") if (not have_serChi) and have_locSen
    "Chilled water pump differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-440,190},{-400,230}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference",nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure setpoint for remote sensor"
    annotation (Placement(transformation(extent={{-440,160},{-400,200}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference",nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure from remote sensor"
    annotation (Placement(transformation(extent={{-440,130},{-400,170}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-442,320},{-402,360}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar if have_WSE
    "Tuning parameter as at last plant disable"
    annotation (Placement(transformation(extent={{-440,100},{-400,140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-440,380},{-400,420}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiSet[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{120,-280},{160,-240}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Chiller stage change edge signal"
    annotation (Placement(transformation(extent={{120,-160},{160,-120}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Chiller stage up change edge signal"
    annotation (Placement(transformation(extent={{120,-120},{160,-80}}),
        iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Chiller stage down change edge signal"
    annotation (Placement(transformation(extent={{120,-220},{160,-180}}),
        iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIni
    "Initial chiller plant stage"
    annotation (Placement(transformation(extent={{120,280},{160,320}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max=nSta)
    "Chiller stage integer setpoint"
    annotation (Placement(transformation(extent={{120,220},{160,260}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Stage up signal"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{100,160},{140,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{120,22},{156,58}}),
      iconTransformation(extent={{100,130},{140,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeParLoaRatMin(
    final unit="1",
    final min=0)
    "Minimum operating part load ratio at current stage"
    annotation (Placement(transformation(extent={{120,320},{160,360}}),
        iconTransformation(extent={{100,-202},{140,-162}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapReq(
    final quantity="HeatFlowRate",
    final unit="W")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{120,370},{160,410}}),
      iconTransformation(extent={{100,-230},{140,-190}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up staUp(
    final have_WSE=have_WSE,
    final have_serChi=have_serChi,
    final have_locSen=have_locSen,
    final nRemSen=nRemSen,
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
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down staDow(
    final have_WSE=have_WSE,
    final have_serChi=have_serChi,
    final have_locSen=have_locSen,
    final nRemSen=nRemSen,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final faiSafTDif=faiSafTDif,
    final faiSafDpDif=faiSafDpDif,
    final TDif=TDif,
    final TDifHys=TDifHys) "Stage down conditions"
    annotation (Placement(transformation(extent={{-100,-240},{-80,-220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = delayStaCha) "Capacity requirement"
    annotation (Placement(transformation(extent={{-320,300},{-300,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Capacities cap(
    final nSta=nSta) "Design and minimum capacities for relevant chiller stages"
    annotation (Placement(transformation(extent={{-270,-180},{-250,-160}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial iniSta(
    final have_WSE=have_WSE) "Initia stage"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiTyp = chiTyp,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-360,-180},{-340,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat) "First higher and lower available stage index, end stage boolean flags and chiller status setpoints"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs(
    final anyVsdCen=anyVsdCen,
    final nSta=nSta,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final anyOutOfScoMult=anyOutOfScoMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax) "Operative and staging part load ratios"
    annotation (Placement(transformation(extent={{-182,-200},{-162,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Change cha(
    final nSta=nSta,
    final delayStaCha=delayStaCha) "Stage change assignment"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat) "Calculates chiller status setpoint vector"
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract lift if anyVsdCen
    "Calculates chiller lift for variable speed centrifugal chiller containing configurations"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));

equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-422,-200},{-382,-200},{-382,-170},{-362,-170}},
          color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-338,-178},{-332,-178},
          {-332,-216},{-322,-216}},color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-422,370},
          {-360,370},{-360,319},{-322,319}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-420,300},{-374,
          300},{-374,314},{-322,314}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-420,270},
          {-370,270},{-370,309},{-322,309}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-338,-162},{-322,
          -162},{-322,-161},{-272,-161}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-338,-166},{-312,
          -166},{-312,-164},{-272,-164}}, color={0,0,127}));
  connect(sta.yAvaUp, cap.uUp) annotation (Line(points={{-298,-203},{-286,-203},
          {-286,-170},{-272,-170}}, color={255,127,0}));
  connect(sta.yAvaDow, cap.uDown) annotation (Line(points={{-298,-206},{-282,-206},
          {-282,-173},{-272,-173}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-298,-211},{-280,-211},
          {-280,-176},{-272,-176}},color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-298,310},{-194,310},
          {-194,-166},{-184,-166}},
                                  color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-248,-162},{-234,
          -162},{-234,-168},{-184,-168}},
                                  color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-248,-166},{
          -236,-166},{-236,-170},{-184,-170}},
                                  color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-248,-170},{
          -238,-170},{-238,-172},{-184,-172}},
                                       color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-248,-174},{-240,
          -174},{-240,-175},{-184,-175}},
                                  color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-248,-178},{
          -242,-178},{-242,-177},{-184,-177}},
                                       color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-420,20},{-212,20},{
          -212,-182},{-184,-182}},
                                 color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-420,-10},{-222,-10},
          {-222,-184},{-184,-184}},
                                 color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-338,-174},{-302,-174},
          {-302,-188},{-184,-188}},                    color={255,127,0}));
  connect(sta.yAvaUp, PLRs.uUp) annotation (Line(points={{-298,-203},{-242,-203},
          {-242,-194},{-184,-194}}, color={255,127,0}));
  connect(sta.yAvaDow, PLRs.uDown)
    annotation (Line(points={{-298,-206},{-242,-206},{-242,-196},{-184,-196}},
                                                       color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-298,-214},{-278,-214},
          {-278,-179},{-272,-179}},color={255,0,255}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{-160,-172},{-136,
          -172},{-136,-99},{-102,-99}},
                             color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{-160,-181},{-134,
          -181},{-134,-101},{-102,-101}},
                                color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-422,
          370},{-162,370},{-162,-103},{-102,-103}},
                                       color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-422,340},{
          -386,340},{-386,284},{-164,284},{-164,-105},{-102,-105}},
                                                         color={0,0,127}));
  connect(dpChiWatPumSet_local, staUp.dpChiWatPumSet_local) annotation (Line(
        points={{-420,240},{-144,240},{-144,-107},{-102,-107}}, color={0,0,127}));
  connect(dpChiWatPum_local, staUp.dpChiWatPum_local) annotation (Line(points={{-420,
          210},{-146,210},{-146,-109},{-102,-109}},      color={0,0,127}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{-160,-176},{
          -142,-176},{-142,-219},{-102,-219}},
                                color={0,0,127}));
  connect(staDow.uStaDow, PLRs.yStaDow) annotation (Line(points={{-102,-221},{
          -144,-221},{-144,-183},{-160,-183}},
                               color={0,0,127}));
  connect(dpChiWatPumSet_local, staDow.dpChiWatPumSet_local) annotation (Line(
        points={{-420,240},{-144,240},{-144,-223},{-102,-223}}, color={0,0,127}));
  connect(dpChiWatPum_local, staDow.dpChiWatPum_local) annotation (Line(points={
          {-420,210},{-146,210},{-146,-225},{-102,-225}}, color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-422,370},
          {-152,370},{-152,-231.2},{-102,-231.2}},
                                         color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-422,340},{-386,
          340},{-386,284},{-154,284},{-154,-233.2},{-102,-233.2}},
                                                       color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-420,90},{-156,90},
          {-156,-235.2},{-102,-235.2}},
                            color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-420,60},
          {-158,60},{-158,-237.2},{-102,-237.2}},
                                      color={0,0,127}));
  connect(staDow.uWseSta, uWseSta) annotation (Line(points={{-102,-241},{-340,-241},
          {-340,-260},{-422,-260}}, color={255,0,255}));
  connect(uSta, sta.u) annotation (Line(points={{-420,-60},{-328,-60},{-328,-204},
          {-322,-204}}, color={255,127,0}));
  connect(sta.yAvaCur, staUp.uAvaCur) annotation (Line(points={{-298,-217},{
          -242,-217},{-242,-210},{-122,-210},{-122,-117},{-102,-117}},
                                                           color={255,0,255}));
  connect(uSta, cap.u) annotation (Line(points={{-420,-60},{-328,-60},{-328,-167},
          {-272,-167}}, color={255,127,0}));
  connect(uSta, PLRs.u) annotation (Line(points={{-420,-60},{-232,-60},{-232,
          -192},{-184,-192}},
                        color={255,127,0}));
  connect(uSta, staUp.u) annotation (Line(points={{-420,-60},{-112,-60},{-112,
          -115},{-102,-115}},
                        color={255,127,0}));
  connect(uSta, staDow.u) annotation (Line(points={{-420,-60},{-328,-60},{-328,-239},
          {-102,-239}}, color={255,127,0}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-420,-140},{-350,
          -140},{-350,302},{-322,302}}, color={255,0,255}));
  connect(sta.yAvaUp, cha.uAvaUp) annotation (Line(points={{-298,-203},{-292,-203},
          {-292,-148},{-40,-148},{-40,-164},{-22,-164}}, color={255,127,0}));
  connect(sta.yAvaDow, cha.uAvaDow) annotation (Line(points={{-298,-206},{-290,-206},
          {-290,-150},{-44,-150},{-44,-168},{-22,-168}}, color={255,127,0}));
  connect(staUp.y, cha.uUp) annotation (Line(points={{-78,-110},{-50,-110},{-50,
          -172},{-22,-172}}, color={255,0,255}));
  connect(staDow.y, cha.uDow) annotation (Line(points={{-78,-230},{-60,-230},{
          -60,-176},{-22,-176}},
                             color={255,0,255}));
  connect(uPla, cha.uPla) annotation (Line(points={{-420,-100},{-280,-100},{
          -280,-140},{-70,-140},{-70,-180},{-22,-180}},
                                             color={255,0,255}));
  connect(cha.ySta, ySta) annotation (Line(points={{2,-166},{20,-166},{20,240},{
          140,240}}, color={255,127,0}));
  connect(cha.yChaEdg, yChaEdg) annotation (Line(points={{2,-174},{80,-174},{80,
          -140},{140,-140}},     color={255,0,255}));
  connect(chiInd.yChi, yChiSet) annotation (Line(points={{62,-230},{80,-230},{
          80,-260},{140,-260}}, color={255,0,255}));
  connect(cha.ySta, chiInd.u) annotation (Line(points={{2,-166},{20,-166},{20,
          -230},{38,-230}},  color={255,127,0}));
  connect(TChiWatSupSet, iniSta.TChiWatSupSet) annotation (Line(points={{-422,370},
          {-100,370},{-100,113},{-82,113}}, color={0,0,127}));
  connect(uTunPar, iniSta.uTunPar) annotation (Line(points={{-420,120},{-104,120},
          {-104,116},{-82,116}}, color={0,0,127}));
  connect(iniSta.yIni, cha.uIni) annotation (Line(points={{-59,110},{-30,110},{-30,
          -160},{-22,-160}}, color={255,127,0}));
  connect(TOutWet, iniSta.TOutWet) annotation (Line(points={{-420,400},{-96,400},
          {-96,119},{-82,119}}, color={0,0,127}));
  connect(sta.yAvaUp, iniSta.uUp) annotation (Line(points={{-298,-203},{-294,-203},
          {-294,110},{-82,110}}, color={255,127,0}));
  connect(uPla, iniSta.uPla) annotation (Line(points={{-420,-100},{-280,-100},{-280,
          104},{-82,104}}, color={255,0,255}));
  connect(cha.yChaUpEdg, yChaUpEdg) annotation (Line(points={{2,-170},{60,-170},
          {60,-100},{140,-100}},
                               color={255,0,255}));
  connect(cha.yChaDowEdg, yChaDowEdg) annotation (Line(points={{2,-178},{60,
          -178},{60,-200},{140,-200}},
                                  color={255,0,255}));
  connect(PLRs.yOpeMin, yOpeParLoaRatMin) annotation (Line(points={{-160,-187},
          {-130,-187},{-130,340},{140,340}},
                               color={0,0,127}));
  connect(staUp.y, yUp) annotation (Line(points={{-78,-110},{-50,-110},{-50,80},
          {140,80}}, color={255,0,255}));
  connect(staDow.y, yDow) annotation (Line(points={{-78,-230},{-60,-230},{-60,
          40},{138,40}}, color={255,0,255}));
  connect(TChiWatRet, lift.u1) annotation (Line(points={{-420,300},{-388,300},{-388,
          46},{-262,46}}, color={0,0,127}));
  connect(TChiWatSupSet, lift.u2) annotation (Line(points={{-422,370},{-360,370},
          {-360,34},{-262,34}}, color={0,0,127}));
  connect(PLRs.uLif, lift.y) annotation (Line(points={{-184,-180},{-202,-180},{
          -202,40},{-238,40}},
                          color={0,0,127}));
  connect(capReq.y, yCapReq) annotation (Line(points={{-298,310},{-194,310},{-194,
          390},{140,390}}, color={0,0,127}));
  connect(dpChiWatPumSet_remote, staUp.dpChiWatPumSet_remote) annotation (Line(
        points={{-420,180},{-148,180},{-148,-111},{-102,-111}}, color={0,0,127}));
  connect(dpChiWatPumSet_remote, staDow.dpChiWatPumSet_remote) annotation (Line(
        points={{-420,180},{-148,180},{-148,-227},{-102,-227}}, color={0,0,127}));
  connect(dpChiWatPum_remote, staUp.dpChiWatPum_remote) annotation (Line(points={{-420,
          150},{-150,150},{-150,-113},{-102,-113}},       color={0,0,127}));
  connect(dpChiWatPum_remote, staDow.dpChiWatPum_remote) annotation (Line(
        points={{-420,150},{-150,150},{-150,-229},{-102,-229}}, color={0,0,127}));
  connect(iniSta.yIni, yIni) annotation (Line(points={{-59,110},{-30,110},{-30,300},
          {140,300}}, color={255,127,0}));
  connect(uPla, staUp.uPla) annotation (Line(points={{-420,-100},{-280,-100},{
          -280,-119},{-102,-119}}, color={255,0,255}));
  annotation (defaultComponentName = "staSetCon",
        Icon(coordinateSystem(extent={{-100,-220},{100,200}}, initialScale=0.2),
        graphics={
        Rectangle(
        extent={{-100,-220},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,85},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,244},{108,206}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,88},{-8,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSupSet"),
        Text(
          extent={{-96,66},{-24,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSup"),
        Text(
          extent={{-96,-182},{-40,-198}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TWsePre"),
        Text(
          extent={{-98,-160},{-24,-178}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatRet"),
        Text(
          extent={{-98,-196},{-14,-222}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-96,-128},{8,-152}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTowFanSpeMax"),
        Text(
          extent={{-94,-10},{0,-32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet_local",
          visible=(not have_serChi) and have_locSen),
        Text(
          extent={{-96,-28},{-10,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPum_local",
          visible=(not have_serChi) and have_locSen),
        Text(
          extent={{-96,8},{-48,-10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uLifMin",
          visible=anyVsdCen),
        Text(
          extent={{-96,32},{-46,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uLifMax",
          visible=anyVsdCen),
        Text(
          extent={{-98,112},{-68,92}},
          textColor={244,125,35},
          pattern=LinePattern.Dash,
          textString="uSta"),
        Text(
          extent={{-98,200},{-46,180}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="uWseSta"),
        Text(
          extent={{-100,180},{-50,164}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="chaPro"),
        Text(
          extent={{-96,142},{-68,120}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="uPla"),
        Text(
          extent={{-96,160},{-44,142}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="uChiAva"),
        Text(
          extent={{62,-116},{94,-100}},
          textColor={244,125,35},
          pattern=LinePattern.Dash,
          textString="ySta"),
        Text(
          extent={{42,74},{94,50}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yChaEdg"),
        Text(
          extent={{40,-24},{92,-52}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yChiSet[]"),
        Text(
          extent={{-98,-110},{-48,-126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTunPar"),
        Text(
          extent={{-98,-90},{-46,-108}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOutWet"),
        Text(
          extent={{28,112},{94,70}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yChaUpEdg"),
        Text(
          extent={{16,50},{94,14}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yChaDowEdg"),
        Text(
          extent={{-12,-154},{96,-200}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOpeParLoaRatMin"),
        Text(
          extent={{54,194},{98,170}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{52,164},{100,140}},
          textColor={217,67,180},
          pattern=LinePattern.Dash,
          textString="yDow"),
        Text(
          extent={{42,-198},{94,-220}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCapReq"),
        Text(
          extent={{-96,-48},{8,-72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet_remote",
          visible=(not have_serChi) and (not have_locSen)),
        Text(
          extent={{-96,-68},{8,-92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPum_remote",
          visible=(not have_serChi) and (not have_locSen)),
        Text(
          extent={{62,-98},{94,-82}},
          textColor={244,125,35},
          pattern=LinePattern.Dash,
          textString="yIni")}),  Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-400,-300},{120,420}})),
Documentation(info="<html>
<p>
The sequence is a chiller stage status setpoint controller that outputs the
chiller stage integer index <code>ySta</code>, chiller stage change trigger signal
<code>y</code> and a chiller status vector for the current stage <code>yChi</code>.
</p>
<p>
Implemented according to ASHRAE RP-1711 March 2020 Draft, section 5.2.4.1 - 17.
</p>
<p>
The controller contains the following subsequences:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a> to calculate
the capacity requirement
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator</a> to allow the user
to provide the chiller plant configuration parameters such as chiller design and minimal capacities and types. It
calculates the design and minimal stage capacities, stage type and stage availability
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status</a> to calculate
for instance the next higher and lower available stages
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Capacities</a> to calculate
design and minimal stage capacities for current and next available higher and lower stage
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios</a> to calculate
operating and staging part load ratios for current and next available higher and lower stage
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up</a> to generate
a stage up signal
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down</a> to generate
a stage down signal
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Change</a> to set the stage
based on the initial stage signal and stage up and down signals
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices</a> to generate
the chiller index vector for a given stage
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end SetpointController;
