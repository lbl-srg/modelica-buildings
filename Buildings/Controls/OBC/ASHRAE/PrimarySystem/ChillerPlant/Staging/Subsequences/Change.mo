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

  CDL.Interfaces.BooleanInput uUp "Stage up status" annotation (Placement(
        transformation(extent={{-320,-78},{-280,-38}}), iconTransformation(
          extent={{100,-90},{140,-50}})));
  CDL.Interfaces.IntegerOutput yAvaUp(final min=0, final max=nSta)
    "Next available higher stage" annotation (Placement(transformation(extent={
            {-334,80},{-294,120}}), iconTransformation(extent={{100,50},{140,90}})));
  CDL.Interfaces.IntegerOutput yAvaDow(final min=0, final max=nSta)
    "Next available lower stage" annotation (Placement(transformation(extent={{
            -330,30},{-290,70}}), iconTransformation(extent={{100,20},{140,60}})));
  CDL.Interfaces.BooleanInput uDow "Stage down signal" annotation (Placement(
        transformation(extent={{-300,-172},{-260,-132}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  CDL.Logical.Or                        or2 "Logical or"
    annotation (Placement(transformation(extent={{-150,-116},{-130,-96}})));
  CDL.Logical.Edge                          edg1
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{-60,-116},{-40,-96}})));
  CDL.Discrete.TriggeredSampler                        triSam
    annotation (Placement(transformation(extent={{-20,34},{0,54}})));
  CDL.Logical.Switch                        switch1
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  CDL.Conversions.IntegerToReal                        intToRea
    annotation (Placement(transformation(extent={{-158,-6},{-138,14}})));
  CDL.Conversions.RealToInteger                        reaToInt
    annotation (Placement(transformation(extent={{162,134},{182,154}})));
  CDL.Conversions.IntegerToReal                        intToRea1
    annotation (Placement(transformation(extent={{-158,74},{-138,94}})));
  CDL.Logical.Latch                        lat(pre_y_start=true)
    annotation (Placement(transformation(extent={{-158,34},{-138,54}})));
  CDL.Conversions.IntegerToReal                        intToRea2 "Integer to real conversion"
    annotation (Placement(transformation(extent={{-40,174},{-20,194}})));
  CDL.Logical.TrueFalseHold                        holIniSta(final
      trueHoldDuration=delayStaCha, final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{-158,134},{-138,154}})));
  CDL.Logical.Switch                        switch2
    annotation (Placement(transformation(extent={{44,174},{64,194}})));
  CDL.Logical.TrueFalseHold                        staChaHol(final
      trueHoldDuration=0, final falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{-100,-116},{-80,-96}})));
  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{-12,-74},{8,-54}})));
  CDL.Logical.Edge                          edg2
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{-26,-206},{-6,-186}})));
  CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{12,-216},{32,-196}})));
  CDL.Logical.Timer tim(accumulate=false)
    annotation (Placement(transformation(extent={{-58,-246},{-38,-226}})));
  CDL.Logical.And and1
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{-100,-218},{-80,-198}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{60,-258},{80,-238}})));
  CDL.Continuous.LessEqualThreshold lesEquThr(threshold=delayStaCha)
    annotation (Placement(transformation(extent={{12,-256},{32,-236}})));
  CDL.Discrete.TriggeredSampler                        triSam1
    annotation (Placement(transformation(extent={{62,-16},{82,4}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-58,-16},{-38,4}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-18,-16},{2,4}})));
  CDL.Continuous.GreaterThreshold greThr1(threshold=0.5)
    annotation (Placement(transformation(extent={{102,-16},{122,4}})));
  CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the initial stage phase is over"
    annotation (Placement(transformation(extent={{-26,134},{-6,154}})));
  CDL.Logical.And and3
    annotation (Placement(transformation(extent={{102,74},{122,94}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,84},{60,104}})));
  CDL.Logical.And and4
    annotation (Placement(transformation(extent={{40,-78},{60,-58}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{162,-6},{182,14}})));
  CDL.Logical.And and5
    annotation (Placement(transformation(extent={{220,-26},{240,-6}})));
  CDL.Logical.TrueFalseHold                        staChaHol1(final
      trueHoldDuration=delayStaCha, final falseHoldDuration=0)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{-58,-206},{-38,-186}})));
  ChillerIndices chiInd(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{220,-186},{240,-166}})));
  CDL.Interfaces.BooleanOutput                        yChi[nChi]
    "Chiller status setpoint vector for the current chiller stage setpoint"
    annotation (Placement(transformation(extent={{262,-196},{302,-156}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  CDL.Interfaces.IntegerOutput                        ySta(final max=fill(nSta,
        nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{262,124},{302,164}}),  iconTransformation(
          extent={{100,-20},{140,20}})));
  CDL.Interfaces.IntegerInput                        uIni(final min=0, final
      max=nSta)
    "Initial chiller stage (at plant enable)" annotation (Placement(
        transformation(extent={{-98,164},{-58,204}}),    iconTransformation(
          extent={{-140,-148},{-100,-108}})));
  CDL.Interfaces.BooleanOutput y "Chiller stage change edge signal" annotation (
     Placement(transformation(extent={{262,-34},{302,6}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  CDL.Interfaces.BooleanInput                        uPla "Plant enable signal"
                          annotation (Placement(
        transformation(extent={{-306,126},{-266,166}}),   iconTransformation(
          extent={{-140,-230},{-100,-190}})));
  CDL.Logical.Edge                        edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-218,134},{-198,154}})));
equation
  connect(reaToInt.y,ySta)
    annotation (Line(points={{184,144},{282,144}}, color={255,127,0}));
  connect(switch1.y,triSam. u)
    annotation (Line(points={{-78,44},{-22,44}},   color={0,0,127}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-136,84},{-120,84},
          {-120,52},{-102,52}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-136,4},{-120,4},{
          -120,36},{-102,36}},  color={0,0,127}));
  connect(lat.y,switch1. u2)
    annotation (Line(points={{-136,44},{-102,44}}, color={255,0,255}));
  connect(edg.y,holIniSta. u)
    annotation (Line(points={{-196,144},{-160,144}},
                                                  color={255,0,255}));
  connect(triSam.y,switch2. u3) annotation (Line(points={{2,44},{10,44},{10,176},
          {42,176}},           color={0,0,127}));
  connect(uIni,intToRea2. u) annotation (Line(points={{-78,184},{-42,184}},
                         color={255,127,0}));
  connect(intToRea2.y,switch2. u1) annotation (Line(points={{-18,184},{10,184},
          {10,192},{42,192}},
                           color={0,0,127}));
  connect(or2.y,staChaHol. u)
    annotation (Line(points={{-128,-106},{-102,-106}},
                                                     color={255,0,255}));
  connect(staChaHol.y,edg1. u)
    annotation (Line(points={{-78,-106},{-62,-106}}, color={255,0,255}));
  connect(edg1.y,or1. u1) annotation (Line(points={{-38,-106},{-26,-106},{-26,
          -64},{-14,-64}},   color={255,0,255}));
  connect(edg2.y,and2. u1) annotation (Line(points={{-4,-196},{6,-196},{6,-206},
          {10,-206}},        color={255,0,255}));
  connect(and2.y,or1. u2) annotation (Line(points={{34,-206},{48,-206},{48,-88},
          {-22,-88},{-22,-72},{-14,-72}},
                                        color={255,0,255}));
  connect(or1.y,triSam. trigger) annotation (Line(points={{10,-64},{16,-64},{16,
          24},{-10,24},{-10,32.2}},         color={255,0,255}));
  connect(or2.y,and2. u2) annotation (Line(points={{-128,-106},{-120,-106},{
          -120,-254},{-18,-254},{-18,-224},{10,-224},{10,-214}},
                                                   color={255,0,255}));
  connect(or2.y,and1. u1) annotation (Line(points={{-128,-106},{-116,-106},{
          -116,-208},{-102,-208}},
                             color={255,0,255}));
  connect(tim.y,lesEquThr. u) annotation (Line(points={{-36,-236},{-12,-236},{
          -12,-246},{10,-246}},  color={0,0,127}));
  connect(lesEquThr.y,pre. u) annotation (Line(points={{34,-246},{58,-246},{58,
          -248}},     color={255,0,255}));
  connect(pre.y,and1. u2) annotation (Line(points={{82,-248},{82,-274},{-112,
          -274},{-112,-216},{-102,-216}},
                                        color={255,0,255}));
  connect(and1.y,tim. u) annotation (Line(points={{-78,-208},{-70,-208},{-70,
          -236},{-60,-236}}, color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{60,-6},{4,-6}},      color={0,0,127}));
  connect(con.y,booToRea. u)
    annotation (Line(points={{-36,-6},{-20,-6}},  color={255,0,255}));
  connect(triSam1.y,greThr1. u)
    annotation (Line(points={{84,-6},{100,-6}},    color={0,0,127}));
  connect(lat1.y,switch2. u2)
    annotation (Line(points={{-4,144},{32,144},{32,184},{42,184}},
                                                 color={255,0,255}));
  connect(edg.y,lat1. u) annotation (Line(points={{-196,144},{-180,144},{-180,
          164},{-100,164},{-100,144},{-28,144}},
                                 color={255,0,255}));
  connect(switch2.y,reaToInt. u)
    annotation (Line(points={{66,184},{112,184},{112,144},{160,144}},
                                                 color={0,0,127}));
  connect(greThr1.y,and3. u2) annotation (Line(points={{124,-6},{136,-6},{136,
          58},{82,58},{82,76},{100,76}},     color={255,0,255}));
  connect(holIniSta.y,not1. u) annotation (Line(points={{-136,144},{-120,144},{
          -120,104},{-20,104},{-20,94},{38,94}},
                                       color={255,0,255}));
  connect(not1.y,and3. u1) annotation (Line(points={{62,94},{84,94},{84,84},{
          100,84}},
               color={255,0,255}));
  connect(and3.y,lat1. clr) annotation (Line(points={{124,84},{132,84},{132,124},
          {-38,124},{-38,138},{-28,138}},
                                      color={255,0,255}));
  connect(and4.y,triSam1. trigger) annotation (Line(points={{62,-68},{72,-68},{
          72,-17.8}},    color={255,0,255}));
  connect(edg1.y,and4. u2) annotation (Line(points={{-38,-106},{28,-106},{28,
          -76},{38,-76}},
                       color={255,0,255}));
  connect(not1.y,and4. u1) annotation (Line(points={{62,94},{70,94},{70,24},{22,
          24},{22,-68},{38,-68}},           color={255,0,255}));
  connect(lat1.y,not2. u) annotation (Line(points={{-4,144},{20,144},{20,134},{
          142,134},{142,4},{160,4}},    color={255,0,255}));
  connect(y,and5. y) annotation (Line(points={{282,-14},{268,-14},{268,-16},{
          242,-16}},
                 color={255,0,255}));
  connect(not2.y,and5. u1) annotation (Line(points={{184,4},{202,4},{202,-16},{
          218,-16}},  color={255,0,255}));
  connect(or1.y,and5. u2) annotation (Line(points={{10,-64},{26,-64},{26,-142},
          {202,-142},{202,-24},{218,-24}},   color={255,0,255}));
  connect(and1.y,staChaHol1. u) annotation (Line(points={{-78,-208},{-70,-208},
          {-70,-196},{-60,-196}},
                               color={255,0,255}));
  connect(staChaHol1.y,edg2. u)
    annotation (Line(points={{-36,-196},{-28,-196}}, color={255,0,255}));
  connect(chiInd.yChi, yChi)
    annotation (Line(points={{242,-176},{282,-176}}, color={255,0,255}));
  connect(reaToInt.y, chiInd.u) annotation (Line(points={{184,144},{208,144},{
          208,-176},{218,-176}}, color={255,127,0}));
  connect(edg.u, uPla) annotation (Line(points={{-220,144},{-231,144},{-231,146},
          {-286,146}}, color={255,0,255}));
  connect(uUp, lat.u) annotation (Line(points={{-300,-58},{-224,-58},{-224,44},
          {-160,44}}, color={255,0,255}));
  connect(uDow, lat.clr) annotation (Line(points={{-280,-152},{-214,-152},{-214,
          38},{-160,38}}, color={255,0,255}));
  connect(uUp, or2.u1) annotation (Line(points={{-300,-58},{-220,-58},{-220,-48},
          {-168,-48},{-168,-106},{-152,-106}}, color={255,0,255}));
  connect(uDow, or2.u2) annotation (Line(points={{-280,-152},{-160,-152},{-160,
          -114},{-152,-114}}, color={255,0,255}));
  connect(yAvaUp, intToRea1.u) annotation (Line(points={{-314,100},{-240,100},{
          -240,84},{-160,84}}, color={255,127,0}));
  connect(yAvaDow, intToRea.u) annotation (Line(points={{-310,50},{-236,50},{
          -236,4},{-160,4}}, color={255,127,0}));
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

fixme

</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
