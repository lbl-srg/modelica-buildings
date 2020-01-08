within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

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
  "Time period for the rolling average";

  parameter Modelica.SIunits.Time holPer = 900
  "Time period for the value hold at stage change";

  parameter Boolean anyVsdCen = true
    "Plant contains at least one variable speed centrifugal chiller";

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

  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump Diferential static pressure and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDifHyst = 1
    "Hysteresis deadband for temperature";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{-120,-280},{-100,-260}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = holPer)
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput                        chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-240,-230},{-200,-190}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TChiWatSupSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        VChiWat_flow(final quantity="VolumeFlowRate",
      final unit="m3/s")
                       "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Capacities cap(nSta=nSta)
    annotation (Placement(transformation(extent={{-70,-240},{-50,-220}})));
  PartLoadRatios PLRs(
    anyVsdCen=anyVsdCen,
    nSta=nSta,
    posDisMult=posDisMult,
    conSpeCenMult=conSpeCenMult,
    varSpeStaMin=varSpeStaMin,
    varSpeStaMax=varSpeStaMax)
    annotation (Placement(transformation(extent={{20,-258},{40,-238}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        uLifMin(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        uLif(final unit="K", final
      quantity="ThermodynamicTemperature") if     anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-240,-30},{-200,10}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        uLifMax(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Up staUp(
    hasWSE=hasWSE,
    delayStaCha=delayStaCha,
    shortDelay=shortDelay,
    longDelay=longDelay,
    smallTDif=smallTDif,
    largeTDif=largeTDif,
    TDif=TDif,
    dpDif=dpDif)
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        dpChiWatPumSet(final unit="Pa",
      final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-240,260},{-200,300}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        dpChiWatPum(final unit="Pa",
      final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-240,230},{-200,270}}),
    iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TChiWatSup(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,150},{-200,190}}),
    iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput                        uHigSta
    "Operating at the highest available stage"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
    iconTransformation(extent={{-140,-170},{-100,-130}})));
  Down staDow(
    delayStaCha=delayStaCha,
    TDif=TDif,
    TDifHyst=TDifHyst,
    dpDif=dpDif,
    hasWSE=hasWSE)
    annotation (Placement(transformation(extent={{100,-300},{120,-280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TWsePre(final unit="1") if
                       hasWSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
       iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        uTowFanSpeMax if hasWSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput                        uWseSta if hasWSE
    "WSE status"
    annotation (Placement(transformation(extent={{-240,-320},{-200,-280}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));
  CDL.Logical.Change cha
    annotation (Placement(transformation(extent={{220,-260},{240,-240}})));
  CDL.Interfaces.BooleanOutput yCha "Stage change setpoint trigger signal"
    annotation (Placement(transformation(extent={{300,-270},{340,-230}}),
        iconTransformation(extent={{100,50},{140,90}})));
  CDL.Integers.OnCounter onCouUp "Counts stage up signal rising edges"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  CDL.Integers.OnCounter onCouDown "Counts stage down signal rising edges"
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));
  CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  CDL.Integers.LessEqualThreshold intLesEquThr(threshold=0)
    annotation (Placement(transformation(extent={{220,-120},{240,-100}})));
  CDL.Interfaces.IntegerInput                        u(final min=0, final max=
        nSta)       "Chiller stage"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  CDL.Interfaces.IntegerOutput y(final max=fill(nSta, nSta))
    "Chiller stage setpoint" annotation (Placement(transformation(extent={{300,-150},
            {340,-110}}), iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.BooleanOutput                        yChi[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{300,-330},{340,-290}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{250,-120},{270,-100}})));
equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-220,-240},{-192,-240},{-192,-230},{-162,-230}},
                                                     color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-138,-238},{-130,-238},
          {-130,-276},{-122,-276}},
                            color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-220,-210},{-160,-210},
          {-160,132},{-122,132}}, color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-220,200},
          {-168,200},{-168,149},{-122,149}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-220,130},{-168,
          130},{-168,144},{-122,144}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-220,100},
          {-164,100},{-164,139},{-122,139}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-138,-222},{-120,
          -222},{-120,-221},{-72,-221}},
                                  color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-138,-226},{-110,
          -226},{-110,-224},{-72,-224}},
                                  color={0,0,127}));
  connect(sta.y, cap.u) annotation (Line(points={{-98,-261},{-88,-261},{-88,-227},
          {-72,-227}}, color={255,127,0}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-98,-264},{-84,-264},{-84,
          -230},{-72,-230}},color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-98,-267},{-80,-267},{
          -80,-233},{-72,-233}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-98,-273},{-78,-273},{-78,
          -236},{-72,-236}},color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-98,140},{8,140},{8,
          -234},{18,-234}},       color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-48,-222},{-32,-222},
          {-32,-236},{18,-236}},  color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-48,-226},{-34,-226},
          {-34,-238},{18,-238}},       color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-48,-230},{-36,
          -230},{-36,-240},{18,-240}}, color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-48,-234},{-38,-234},
          {-38,-243},{18,-243}},  color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-48,-238},{-40,-238},
          {-40,-245},{18,-245}},       color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-220,-10},{0,-10},{0,-248},
          {18,-248}},       color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-220,-40},{-10,-40},{
          -10,-250},{18,-250}},
                            color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-220,-70},{-20,-70},{
          -20,-252},{18,-252}},
                            color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-138,-234},{-100,-234},
          {-100,-256},{18,-256}},                      color={255,127,0}));
  connect(sta.y, PLRs.u) annotation (Line(points={{-98,-261},{-50,-261},{-50,-260},
          {18,-260}},  color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-98,-264},{-44,-264},{-44,
          -262},{18,-262}}, color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-98,-267},{-40,-267},
          {-40,-264},{18,-264}},  color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-98,-276},{-76,-276},{-76,
          -239},{-72,-239}},
                      color={255,0,255}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{42,-240},{66,-240},{66,
          -200},{98,-200}},         color={0,0,127}));
  connect(PLRs.yOpeUp, staUp.uOpeUp) annotation (Line(points={{42,-242},{70,-242},
          {70,-205},{98,-205}},           color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{42,-249},{68,-249},
          {68,-202},{98,-202}},           color={0,0,127}));
  connect(staUp.uOpeUpMin, PLRs.yOpeUpMin) annotation (Line(points={{98,-207},{72,
          -207},{72,-257},{42,-257}},           color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-220,200},
          {40,200},{40,-210},{98,-210}},      color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-220,170},{-180,
          170},{-180,90},{38,90},{38,-212},{98,-212}},      color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-220,280},
          {58,280},{58,-215},{98,-215}},       color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-220,250},{56,
          250},{56,-217},{98,-217}},     color={0,0,127}));
  connect(staUp.uHigSta, uHigSta) annotation (Line(points={{98,-222},{20,-222},{
          20,-180},{-220,-180}},    color={255,0,255}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{42,-244},{60,-244},
          {60,-282},{98,-282}},           color={0,0,127}));
  connect(staDow.uStaDow, PLRs.yStaDow) annotation (Line(points={{98,-284},{58,-284},
          {58,-251},{42,-251}},           color={0,0,127}));
  connect(PLRs.yOpe, staDow.uOpe) annotation (Line(points={{42,-240},{62,-240},{
          62,-277},{98,-277}},      color={0,0,127}));
  connect(staDow.uOpeMin, PLRs.yOpeMin) annotation (Line(points={{98,-279},{54,-279},
          {54,-255},{42,-255}},           color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-220,
          280},{56,280},{56,-287},{98,-287}},       color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-220,250},{
          52,250},{52,-289},{98,-289}},       color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-220,200},
          {50,200},{50,-292},{98,-292}},      color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-220,170},{-180,
          170},{-180,90},{48,90},{48,-294},{98,-294}},    color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-220,60},{46,60},{46,
          -296},{98,-296}},         color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-220,30},
          {44,30},{44,-298},{98,-298}},        color={0,0,127}));
  connect(staDow.uWseSta, uWseSta) annotation (Line(points={{98,-302},{-190,-302},
          {-190,-300},{-220,-300}}, color={255,0,255}));
  connect(staUp.y, or2.u1) annotation (Line(points={{122,-210},{160,-210},{160,-250},
          {178,-250}}, color={255,0,255}));
  connect(staDow.y, or2.u2) annotation (Line(points={{122,-290},{160,-290},{160,
          -258},{178,-258}}, color={255,0,255}));
  connect(or2.y, cha.u)
    annotation (Line(points={{202,-250},{218,-250}}, color={255,0,255}));
  connect(cha.y, yCha)
    annotation (Line(points={{242,-250},{320,-250}}, color={255,0,255}));
  connect(staUp.y, onCouUp.trigger) annotation (Line(points={{122,-210},{128,-210},
          {128,-90},{138,-90}}, color={255,0,255}));
  connect(staDow.y, onCouDown.trigger) annotation (Line(points={{122,-290},{132,
          -290},{132,-130},{138,-130}}, color={255,0,255}));
  connect(onCouDown.y, addInt.u2) annotation (Line(points={{162,-130},{172,-130},
          {172,-116},{178,-116}}, color={255,127,0}));
  connect(onCouUp.y, addInt.u1) annotation (Line(points={{162,-90},{172,-90},{172,
          -104},{178,-104}}, color={255,127,0}));
  connect(addInt.y, intLesEquThr.u)
    annotation (Line(points={{202,-110},{218,-110}}, color={255,127,0}));
  connect(u, sta.u) annotation (Line(points={{-220,-120},{-126,-120},{-126,-264},
          {-122,-264}}, color={255,127,0}));
  connect(addInt.y, y) annotation (Line(points={{202,-110},{210,-110},{210,-130},
          {320,-130}}, color={255,127,0}));
  connect(sta.yChi, yChi) annotation (Line(points={{-98,-279},{-60,-279},{-60,-310},
          {320,-310}}, color={255,0,255}));
  connect(sta.y, staDow.u) annotation (Line(points={{-98,-261},{-68,-261},{-68,-300},
          {98,-300}}, color={255,127,0}));
  connect(sta.y, staUp.uSta) annotation (Line(points={{-98,-261},{-92,-261},{-92,
          -210},{30,-210},{30,-220},{98,-220}}, color={255,127,0}));
  connect(intLesEquThr.y, pre.u)
    annotation (Line(points={{242,-110},{248,-110}}, color={255,0,255}));
  connect(pre.y, onCouUp.reset) annotation (Line(points={{272,-110},{280,-110},
          {280,-52},{110,-52},{110,-108},{150,-108},{150,-102}}, color={255,0,
          255}));
  connect(pre.y, onCouDown.reset) annotation (Line(points={{272,-110},{276,-110},
          {276,-34},{100,-34},{100,-150},{150,-150},{150,-142}}, color={255,0,
          255}));
  annotation (defaultComponentName = "cha",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-200,-340},{300,340}})),
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
