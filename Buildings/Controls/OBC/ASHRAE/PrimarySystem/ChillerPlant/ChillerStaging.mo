within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerStaging "Sequences to control chiller staging"

  parameter Integer num = 2 "Total number of chiller";
  parameter Modelica.SIunits.Temperature TLocChi
    "Chiller lockout temperature";
  parameter Real chiOnHou(
    final min=0,
    final max=24)
    "Daily scheduled chiller plant on time";
  parameter Real chiOffHou(
    final min=chiOnHou,
    final max=24)
    "Daily scheduled chiller plant off time";
  parameter Boolean use_simCoe = true
    "Indicate if use simplified coefficients to calculate SPLR";
  parameter Modelica.SIunits.Temperature TWetBul_nominal
    "Design wetbulb temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.TemperatureDifference APPROACH_nominal
    "Design tower leaving water temperature minus design wetbulb temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.TemperatureDifference towRan_nominal
    "Design tower entering minus leaving water temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.TemperatureDifference dTRefMin
    "Minimum LIFT at minimum load"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal
    "Design condenser water return temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal
    "Design chilled water supply temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Real intParLoaVal
    "Integrated part load value per AHRI 550/590, kW/ton"
    annotation(Dialog(group="Design conditions"));
  parameter Real chiEff
    "Chiller efficiency at AHRI conditions. kW/ton"
    annotation(Dialog(group="Design conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-300,124},{-260,164}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR
    "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-300,74},{-260,114}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes
    "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chiller status"
    annotation (Placement(transformation(extent={{-300,-180},{-260,-140}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta
    "Chiller stage output"
    annotation (Placement(transformation(extent={{260,-230},{280,-210}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiStaCha
    "Chiller stage change, up(1) or down(-1)"
    annotation (Placement(transformation(extent={{260,90},{280,110}}),
      iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
    "Difference between design and minimum LIFT"
    annotation (Placement(transformation(extent={{-180,240},{-160,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Division simE
    "Simplified coefficient E"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Difference of inputs"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Product simF
    "Simplified coefficient F"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeE(
    final k=0.057 - 0.000569*((TWetBul_nominal-273.15)*9/5+32) - 0.0645*intParLoaVal
                  - 0.000233*(APPROACH_nominal*9/5) - 0.000402*(towRan_nominal*9/5)
                  + 0.0399*chiEff)
    "Regressed coefficient E"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeF(
    final k=-1.06 + 0.0145*((TWetBul_nominal-273.15)*9/5+32) + 2.16*intParLoaVal
                  + 0.0068*(APPROACH_nominal*9/5) + 0.0117*(towRan_nominal*9/5)
                  - 1.33*chiEff)
    "Regressed coefficient F"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant simCoe(
    final k=use_simCoe)
    "Simplified cofficients indicator"
    annotation (Placement(transformation(extent={{-20,270},{0,290}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeE "Coefficient E"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeF "Coefficient F"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=-1)
    "Difference between condenser water return and chilled water supply temperature"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add staPLR "Staging part load ratio"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=300)
    "Sample input value every 5 minutes"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabCon(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;chiOnHou*3600,1; chiOffHou*3600,0; 24*3600,0])
    "Time table with chiller plant schedule"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=num)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count duration time when PLR becomes greater than SPLR"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.95 - 0.02,
    final uHigh=0.95 + 0.02)
    "Check if chilled water plant reset is greater than 0.95"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Count duration time when chilled water plant reset becomes greater than 0.95"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=-1)
    "Difference between condenser water return and chilled water supply temperature"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is greater than SPLR"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0.3 - 0.05,
    final uHigh=0.3 + 0.05)
    "Check if PLR is greater than 0.3"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if chilled water plant reset has been greater than 0.95 for more than 15 minutes"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been greater than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=0.5)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2
    "Count duration time when there is no chiller plant request"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=300 - 5,
    final uHigh=300 + 5)
    "Check if there is no chiller plant request for more than 5 minutes"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold outTemLoc(
    final threshold=TLocChi - 5*5/9)
    "Check if outdoor temperature is less than lockout temperature minus 5 degF"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is less than SPLR"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3 "Count duration time when PLR becomes less than SPLR"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been less than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold zerDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staDow(
    final p=-1, final k=1) "Stage down"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staUp(
    final k=1, final p=1) "Stage up"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold curZerSta(
    final threshold=0.5)
    "Check if it is stage zero now"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=TLocChi)
    "Check if outdoor temrature is greater than lockout temperature"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Check if schedule is active"
    annotation (Placement(transformation(extent={{-120,-280},{-100,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold oneUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Check if it is stage up"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 "Check if it is stage down"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dKtodF(final k=9/5)
    "Convert from degK difference to degF difference"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

protected
  parameter Modelica.SIunits.TemperatureDifference dTRef_nominal=
    TConWatRet_nominal - TChiWatSup_nominal
    "LIFT at design conditions "
    annotation(Dialog(group="Design conditions"));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLif(
    final k=dTRefMin*9/5)
    "Minimum LIFT at minimum load"
    annotation (Placement(transformation(extent={{-240,240},{-220,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desLif(
    final k=dTRef_nominal*9/5)
    "LIFT at design conditions"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.45)
    "Constant"
    annotation (Placement(transformation(extent={{-180,270},{-160,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=0.4)
    "Gain factor"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=1.4) "Gain factor"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=-1)
    "Gain factor"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSta(final k=0)
    "No stage change"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{220,90},{240,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staUpCon(final k=1)
    "Stage up indicator"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staDowCon(final k=-1)
    "Stage up indicator"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerSta(final k=0)
    "Stage zero"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[num]
    "Convert boolean to real number"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));

equation
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-199,-160},{-182,-160}}, color={0,0,127}));
  connect(minLif.y, add2.u1)
    annotation (Line(points={{-219,250},{-200,250},{-200,256},{-182,256}},
      color={0,0,127}));
  connect(desLif.y, add2.u2)
    annotation (Line(points={{-219,220},{-192,220},{-192,244},{-182,244}},
      color={0,0,127}));
  connect(add2.y, simE.u2)
    annotation (Line(points={{-159,250},{-140,250},{-140,244},{-122,244}},
      color={0,0,127}));
  connect(con.y, simE.u1)
    annotation (Line(points={{-159,280},{-140,280},{-140,256},{-122,256}},
      color={0,0,127}));
  connect(desLif.y, gai.u)
    annotation (Line(points={{-219,220},{-182,220}}, color={0,0,127}));
  connect(minLif.y, gai1.u)
    annotation (Line(points={{-219,250},{-200,250},{-200,190},{-182,190}},
      color={0,0,127}));
  connect(gai.y, add1.u1)
    annotation (Line(points={{-159,220},{-140,220},{-140,216},{-122,216}},
      color={0,0,127}));
  connect(gai1.y, add1.u2)
    annotation (Line(points={{-159,190},{-140,190},{-140,204},{-122,204}},
      color={0,0,127}));
  connect(simE.y, simF.u1)
    annotation (Line(points={{-99,250},{-80,250},{-80,216},{-62,216}},
      color={0,0,127}));
  connect(add1.y, simF.u2)
    annotation (Line(points={{-99,210},{-80,210},{-80,204},{-62,204}},
      color={0,0,127}));
  connect(simE.y, coeE.u1)
    annotation (Line(points={{-99,250},{20,250},{20,258},{38,258}},
      color={0,0,127}));
  connect(simF.y, coeF.u1)
    annotation (Line(points={{-39,210},{20,210},{20,218},{38,218}},
      color={0,0,127}));
  connect(simCoe.y, coeE.u2)
    annotation (Line(points={{1,280},{28,280},{28,250},{38,250}},
      color={255,0,255}));
  connect(simCoe.y, coeF.u2)
    annotation (Line(points={{1,280},{28,280},{28,210},{38,210}},
      color={255,0,255}));
  connect(regCoeE.y, coeE.u3)
    annotation (Line(points={{1,230},{20,230},{20,242},{38,242}},
      color={0,0,127}));
  connect(regCoeF.y, coeF.u3)
    annotation (Line(points={{1,190},{20,190},{20,202},{38,202}},
      color={0,0,127}));
  connect(TConWatRet, add3.u2)
    annotation (Line(points={{-280,144},{-242,144}},
      color={0,0,127}));
  connect(TChiWatSup, add3.u1)
    annotation (Line(points={{-280,180},{-250,180},{-250,156},{-242,156}},
      color={0,0,127}));
  connect(coeE.y, pro.u1)
    annotation (Line(points={{61,250},{80,250},{80,172},{-120,172},{-120,156},
      {-102,156}}, color={0,0,127}));
  connect(pro.y, staPLR.u2)
    annotation (Line(points={{-79,150},{-60,150},{-60,144},{-42,144}},
      color={0,0,127}));
  connect(coeF.y, staPLR.u1)
    annotation (Line(points={{61,210},{86,210},{86,168},{-60,168},{-60,156},{-42,156}},
      color={0,0,127}));
  connect(sam.y, pro.u2)
    annotation (Line(points={{-139,150},{-120,150},{-120,144},{-102,144}},
      color={0,0,127}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-280,-160},{-222,-160}}, color={255,0,255}));
  connect(uChiWatPlaRes, hys.u)
    annotation (Line(points={{-280,40},{-222,40}}, color={0,0,127}));
  connect(hys.y, tim1.u)
    annotation (Line(points={{-199,40},{-182,40}}, color={255,0,255}));
  connect(uPLR, add4.u2)
    annotation (Line(points={{-280,94},{-222,94}}, color={0,0,127}));
  connect(staPLR.y, add4.u1)
    annotation (Line(points={{-19,150},{0,150},{0,130},{-240,130},{-240,106},
      {-222,106}}, color={0,0,127}));
  connect(add4.y, hys1.u)
    annotation (Line(points={{-199,100},{-182,100}}, color={0,0,127}));
  connect(hys1.y, tim.u)
    annotation (Line(points={{-159,100},{-142,100}}, color={255,0,255}));
  connect(uPLR, hys2.u)
    annotation (Line(points={{-280,94},{-240,94},{-240,70},{-142,70}},
      color={0,0,127}));
  connect(tim1.y, hys3.u)
    annotation (Line(points={{-159,40},{-142,40}}, color={0,0,127}));
  connect(hys2.y, and2.u1)
    annotation (Line(points={{-119,70},{-100,70},{-100,60},{-82,60}},
      color={255,0,255}));
  connect(hys3.y, and2.u2)
    annotation (Line(points={{-119,40},{-99.5,40},{-99.5,52},{-82,52}},
      color={255,0,255}));
  connect(tim.y, hys4.u)
    annotation (Line(points={{-119,100},{-82,100}},color={0,0,127}));
  connect(hys4.y, or2.u1)
    annotation (Line(points={{-59,100},{-42,100}}, color={255,0,255}));
  connect(TChiWatSupResReq, intToRea.u)
    annotation (Line(points={{-280,-40},{-222,-40}}, color={255,127,0}));
  connect(intToRea.y, lesEquThr.u)
    annotation (Line(points={{-199,-40},{-182,-40}}, color={0,0,127}));
  connect(lesEquThr.y, tim2.u)
    annotation (Line(points={{-159,-40},{-122,-40}}, color={255,0,255}));
  connect(tim2.y, hys5.u)
    annotation (Line(points={{-99,-40},{-82,-40}}, color={0,0,127}));
  connect(TOut, outTemLoc.u)
    annotation (Line(points={{-280,-80},{-82,-80}}, color={0,0,127}));
  connect(timTabCon.y[1], lesEquThr1.u)
    annotation (Line(points={{-199,-120},{-182,-120}}, color={0,0,127}));
  connect(outTemLoc.y, or3.u2)
    annotation (Line(points={{-59,-80},{-42,-80}},color={255,0,255}));
  connect(lesEquThr1.y, or3.u3)
    annotation (Line(points={{-159,-120},{-50,-120}, {-50,-88},{-42,-88}},
      color={255,0,255}));
  connect(hys5.y, or3.u1)
    annotation (Line(points={{-59,-40},{-50,-40},{-50,-72},{-42,-72}},
      color={255,0,255}));
  connect(add4.y, gai2.u)
    annotation (Line(points={{-199,100},{-190,100},{-190,64},{-240,64},{-240,0},
      {-222,0}}, color={0,0,127}));
  connect(gai2.y, hys6.u)
    annotation (Line(points={{-199,0},{-182,0}}, color={0,0,127}));
  connect(hys6.y, tim3.u)
    annotation (Line(points={{-159,0},{-142,0}}, color={255,0,255}));
  connect(tim3.y, hys7.u)
    annotation (Line(points={{-119,0},{-82,0}}, color={0,0,127}));
  connect(or2.y, staUpHol.u)
    annotation (Line(points={{-19,100},{-10,100},{-10,70},{-1,70}},
      color={255,0,255}));
  connect(hys7.y, staDowHol.u)
    annotation (Line(points={{-59,0},{-1,0}}, color={255,0,255}));
  connect(or3.y, zerDowHol.u)
    annotation (Line(points={{-19,-80},{-1,-80}}, color={255,0,255}));
  connect(mulSum.y, staDow.u)
    annotation (Line(points={{-158.3,-160},{30,-160},{30,30},{38,30}},
      color={0,0,127}));
  connect(staDow.y, swi.u1)
    annotation (Line(points={{61,30},{72,30},{72,8},{98,8}},
      color={0,0,127}));
  connect(staDowHol.y, swi.u2)
    annotation (Line(points={{21,0},{98,0}}, color={255,0,255}));
  connect(mulSum.y, staUp.u)
    annotation (Line(points={{-158.3,-160},{30,-160},{30,100},{38,100}},
      color={0,0,127}));
  connect(staUp.y, swi1.u1)
    annotation (Line(points={{61,100},{80,100},{80,78},{98,78}},
      color={0,0,127}));
  connect(staUpHol.y, swi1.u2)
    annotation (Line(points={{21,70},{98,70}}, color={255,0,255}));
  connect(zerDowHol.y, swi2.u2)
    annotation (Line(points={{21,-80},{98,-80}}, color={255,0,255}));
  connect(zerSta.y, swi2.u1)
    annotation (Line(points={{61,-110},{72,-110},{72,-72},{98,-72}},
      color={0,0,127}));
  connect(mulSum.y, swi1.u3)
    annotation (Line(points={{-158.3,-160},{80,-160},{80,62},{98,62}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{121,70},{130,70},{130,50},{88,50},{88,-8},{98,-8}},
      color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{121,0},{130,0},{130,-50},{88,-50},{88,-88},{98,-88}},
      color={0,0,127}));
  connect(mulSum.y, curZerSta.u)
    annotation (Line(points={{-158.3,-160},{-120,-160},{-120,-190},{-62,-190}},
      color={0,0,127}));
  connect(lesEquThr.y, not1.u)
    annotation (Line(points={{-159,-40},{-136,-40},{-136,-210},{-122,-210}},
      color={255,0,255}));
  connect(TOut, greEquThr.u)
    annotation (Line(points={{-280,-80},{-140,-80},{-140,-240},{-122,-240}},
      color={0,0,127}));
  connect(lesEquThr1.y, not2.u)
    annotation (Line(points={{-159,-120},{-144,-120},{-144,-270},{-122,-270}},
      color={255,0,255}));
  connect(and2.y, or2.u2)
    annotation (Line(points={{-59,60},{-50,60},{-50,92},{-42,92}},
      color={255,0,255}));
  connect(not1.y, and3.u1)
    annotation (Line(points={{-99,-210},{-80,-210},{-80,-232},{-62,-232}},
      color={255,0,255}));
  connect(greEquThr.y, and3.u2)
    annotation (Line(points={{-99,-240},{-62,-240}},color={255,0,255}));
  connect(not2.y, and3.u3)
    annotation (Line(points={{-99,-270},{-80,-270},{-80,-248},{-62,-248}},
      color={255,0,255}));
  connect(and3.y, and1.u2)
    annotation (Line(points={{-39,-240},{-20,-240},{-20,-228},{-2,-228}},
      color={255,0,255}));
  connect(curZerSta.y, and1.u1)
    annotation (Line(points={{-39,-190},{-20,-190},{-20,-220},{-2,-220}},
      color={255,0,255}));
  connect(staOne.y, swi3.u1)
    annotation (Line(points={{61,-260},{72,-260},{72,-212},{98,-212}},
      color={0,0,127}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{121,-80},{130,-80},{130,-190},{88,-190},{88,-228},
      {98,-228}}, color={0,0,127}));
  connect(and1.y, oneUpHol.u)
    annotation (Line(points={{21,-220},{39,-220}}, color={255,0,255}));
  connect(oneUpHol.y, swi3.u2)
    annotation (Line(points={{61,-220},{98,-220}}, color={255,0,255}));
  connect(zerDowHol.y, or4.u2)
    annotation (Line(points={{21,-80},{60,-80},{60,-38},{158,-38}},
      color={255,0,255}));
  connect(staDowHol.y, or4.u1)
    annotation (Line(points={{21,0},{60,0},{60,-30},{158,-30}},
      color={255,0,255}));
  connect(oneUpHol.y, or1.u2)
    annotation (Line(points={{61,-220},{80,-220},{80,-170},{140,-170},{140,32},
      {158,32}}, color={255,0,255}));
  connect(staUpHol.y, or1.u1)
    annotation (Line(points={{21,70},{72,70},{72,40},{158,40}},
      color={255,0,255}));
  connect(or1.y, swi4.u2)
    annotation (Line(points={{181,40},{218,40}}, color={255,0,255}));
  connect(staUpCon.y, swi4.u1)
    annotation (Line(points={{181,70},{200,70},{200,48},{218,48}},
      color={0,0,127}));
  connect(staDowCon.y, swi5.u1)
    annotation (Line(points={{181,0},{200,0},{200,-22},{218,-22}},
      color={0,0,127}));
  connect(or4.y, swi5.u2)
    annotation (Line(points={{181,-30},{218,-30}}, color={255,0,255}));
  connect(conSta.y, swi5.u3)
    annotation (Line(points={{181,-70},{200,-70},{200,-38},{218,-38}},
      color={0,0,127}));
  connect(swi5.y, swi4.u3)
    annotation (Line(points={{241,-30},{250,-30},{250,10},{200,10},{200,32},
      {218,32}}, color={0,0,127}));
  connect(swi4.y, reaToInt.u)
    annotation (Line(points={{241,40},{250,40},{250,70},{210,70},{210,100},
      {218,100}}, color={0,0,127}));
  connect(reaToInt.y, yChiStaCha)
    annotation (Line(points={{241,100},{270,100}}, color={255,127,0}));
  connect(swi3.y, reaToInt1.u)
    annotation (Line(points={{121,-220},{178,-220}}, color={0,0,127}));
  connect(reaToInt1.y, yChiSta)
    annotation (Line(points={{201,-220},{270,-220}}, color={255,127,0}));
  connect(add3.y, dKtodF.u)
    annotation (Line(points={{-219,150},{-202,150}}, color={0,0,127}));
  connect(dKtodF.y, sam.u)
    annotation (Line(points={{-179,150},{-162,150}}, color={0,0,127}));

annotation (
  defaultComponentName="chiStaCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-260,-300},{260,300}}), graphics={Rectangle(
          extent={{-258,298},{238,142}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{110,238},{238,204}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate staging
part load ratio"),                   Rectangle(
          extent={{-258,118},{132,22}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-256,14},{132,-12}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-256,-26},{132,-134}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-258,-182},{132,-298}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{148,118},{252,-138}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{154,-98},{292,-136}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it is stage-up 
or stage-down"),
          Text(
          extent={{-130,-110},{24,-148}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage-down to 0 stage"),
          Text(
          extent={{-94,50},{14,16}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage-up"),
          Text(
          extent={{-246,-216},{-92,-254}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should 
stage-up 
from 0 to 1")}),
  Icon(graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,96},{-68,84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-100,8},{-38,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSup"),
        Text(
          extent={{-96,-50},{-10,-70}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSupResReq"),
        Text(
          extent={{66,-22},{96,-38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiSta"),
        Text(
          extent={{-98,66},{-66,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uPLR"),
        Text(
          extent={{-96,38},{-38,22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TConWatRet"),
        Text(
          extent={{-94,-24},{-22,-36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatPlaRes"),
        Text(
          extent={{-100,-84},{-74,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{52,40},{98,20}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiStaCha")}),
Documentation(info="<html>
<p>
According to ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL, 
Chapter 7, Appendix B, 1.01.B.3, this block outputs chiller plant stage control. 
When staging-up, <code>yChiStaCha</code> equals 1; when staging-down,
<code>yChiStaCha</code> equals -1. It also outputs which stage <code>yChiSta</code> 
will be.
</p>

</html>", revisions="<html>
<ul>
<li>
March 16, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStaging;
