within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerStaging "Sequences to control chiller staging"

  parameter Integer num = 2 "Total number of chiller";
  parameter Modelica.SIunits.Temperature TLocChi
    "Chiller lockout temperature";
  parameter Real chiOnHou(
    final min=0,
    final max=24) = 5
    "Chiller plant on time"
    annotation(Dialog(group="Plant schedule"));
  parameter Real chiOffHou(
    final min=chiOnHou,
    final max=24) = 22
    "Chiller plant off time"
    annotation(Dialog(group="Plant schedule"));

  parameter Boolean use_simCoe = true
    "Indicate if use simplified coefficients to calculate SPLR"
    annotation(Dialog(group="SPLR coefficients calculation"));
  parameter Modelica.SIunits.Temperature TWetBul_nominal = 298.15
    "Design wetbulb temperature"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Modelica.SIunits.TemperatureDifference APPROACH_nominal = 5
    "Design tower leaving water temperature minus design wetbulb temperature"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Modelica.SIunits.TemperatureDifference towRan_nominal = 6
    "Design tower entering minus leaving water temperature"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Modelica.SIunits.TemperatureDifference dTRefMin = 5
    "Minimum LIFT at minimum load"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal = 303.15
    "Design condenser water return temperature"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal = 280.15
    "Design chilled water supply temperature"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Real intParLoaVal = 1
    "Integrated part load value per AHRI 550/590, kW/ton"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));
  parameter Real chiEff = 0.8
    "Chiller efficiency at AHRI conditions, kW/ton"
    annotation(Dialog(group="SPLR coefficients calculation", enable = not use_simCoe));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-320,200},{-280,240}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-320,164},{-280,204}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR
    "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-320,114},{-280,154}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes
    "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-320,60},{-280,100}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-320,-140},{-280,-100}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chiller status"
    annotation (Placement(transformation(extent={{-320,-220},{-280,-180}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-320,-100},{-280,-60}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta
    "Chiller stage output"
    annotation (Placement(transformation(extent={{280,-230},{300,-210}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiStaCha
    "Chiller stage change, up(1) or down(-1)"
    annotation (Placement(transformation(extent={{280,130},{300,150}}),
      iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
    "Difference between design and minimum LIFT"
    annotation (Placement(transformation(extent={{-200,280},{-180,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Division simE
    "Simplified coefficient E"
    annotation (Placement(transformation(extent={{-140,280},{-120,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Difference of inputs"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Product simF
    "Simplified coefficient F"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeE(
    final k=0.057 - 0.000569*((TWetBul_nominal-273.15)*9/5+32) - 0.0645*intParLoaVal
                  - 0.000233*(APPROACH_nominal*9/5) - 0.000402*(towRan_nominal*9/5)
                  + 0.0399*chiEff)
    "Regressed coefficient E"
    annotation (Placement(transformation(extent={{-40,260},{-20,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeF(
    final k=-1.06 + 0.0145*((TWetBul_nominal-273.15)*9/5+32) + 2.16*intParLoaVal
                  + 0.0068*(APPROACH_nominal*9/5) + 0.0117*(towRan_nominal*9/5)
                  - 1.33*chiEff)
    "Regressed coefficient F"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant simCoe(
    final k=use_simCoe)
    "Simplified cofficients indicator"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeE "Coefficient E"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeF "Coefficient F"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=-1)
    "Difference between condenser water return and chilled water supply temperature"
    annotation (Placement(transformation(extent={{-260,180},{-240,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Add staPLR "Staging part load ratio"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=300)
    "Sample input value every 5 minutes"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabCon(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;chiOnHou*3600,1; chiOffHou*3600,0; 24*3600,0])
    "Time table with chiller plant schedule"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=num)
    "Current chiller stage, it equals to total number of operating chillers"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count duration time when PLR becomes greater than SPLR"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.95 - 0.02,
    final uHigh=0.95 + 0.02)
    "Check if chilled water plant reset is greater than 0.95"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Count duration time when chilled water plant reset becomes greater than 0.95"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=-1)
    "Difference between stage PLR and current PLR"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is greater than SPLR"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0.3 - 0.05,
    final uHigh=0.3 + 0.05)
    "Check if PLR is greater than 0.3"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if chilled water plant reset has been greater than 0.95 for more than 15 minutes"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Stage up"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been greater than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2
    "Count duration time when there is no chiller plant request"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=300 - 5,
    final uHigh=300 + 5)
    "Check if there is no chiller plant request for more than 5 minutes"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is less than SPLR"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3
    "Count duration time when PLR becomes less than SPLR"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been less than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold zerDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staDow(
    final p=-1, final k=1) "Stage down"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staUp(
    final k=1, final p=1) "Stage up"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{120,130},{140,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold curZerSta(
    final threshold=0.5)
    "Check if it is stage zero now"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-140,-260},{-120,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Check if schedule is active"
    annotation (Placement(transformation(extent={{-140,-320},{-120,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    annotation (Placement(transformation(extent={{-80,-290},{-60,-270}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold oneUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Check if it is stage up"
    annotation (Placement(transformation(extent={{180,70},{200,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 "Check if it is stage down"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    annotation (Placement(transformation(extent={{240,-40},{260,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6
    "Ensure no further stage-up when current stage is already the highest stage"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold higSta(
    final threshold=num)
    "Check if current stage is highest stage minus 1"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold staOneChe(
    final threshold=0)
    "Check if current stage is having at least 1 chiller operating"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7
    "Ensure no further stage-down when current stage is already stage 1"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dKtodF(final k=9/5)
    "Convert from degK difference to degF difference"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(threshold=1)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys8(
    final uLow=TLocChi - 1*5/9,
    final uHigh=TLocChi + 1*5/9)
    "Check if outdoor temrature is greater than lockout temperature"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final uLow=TLocChi - 5.5*5/9,
    final uHigh=TLocChi + 5.5*5/9)
    "Check if outdoor temperature is less than lockout temperature minus 5 degF"
    annotation (Placement(transformation(extent={{-138,-130},{-118,-110}})));

protected
  parameter Modelica.SIunits.TemperatureDifference dTRef_nominal=
    TConWatRet_nominal - TChiWatSup_nominal
    "LIFT at design conditions "
    annotation(Dialog(group="Design conditions"));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLif(
    final k=dTRefMin*9/5)
    "Minimum LIFT at minimum load"
    annotation (Placement(transformation(extent={{-260,280},{-240,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desLif(
    final k=dTRef_nominal*9/5)
    "LIFT at design conditions"
    annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.45)
    "Constant"
    annotation (Placement(transformation(extent={{-200,310},{-180,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=0.4)
    "Gain factor"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=1.4) "Gain factor"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=-1)
    "Gain factor"
    annotation (Placement(transformation(extent={{-240,20},{-220,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSta(final k=0)
    "No stage change"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{240,130},{260,150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{200,-230},{220,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staUpCon(final k=1)
    "Stage up indicator"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staDowCon(final k=-1)
    "Stage up indicator"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{20,-270},{40,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerSta(final k=0)
    "Stage zero"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[num]
    "Convert boolean to real number"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));

equation
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-219,-200},{-202,-200}}, color={0,0,127}));
  connect(minLif.y, add2.u1)
    annotation (Line(points={{-239,290},{-220,290},{-220,296},{-202,296}},
      color={0,0,127}));
  connect(desLif.y, add2.u2)
    annotation (Line(points={{-239,260},{-212,260},{-212,284},{-202,284}},
      color={0,0,127}));
  connect(add2.y, simE.u2)
    annotation (Line(points={{-179,290},{-160,290},{-160,284},{-142,284}},
      color={0,0,127}));
  connect(con.y, simE.u1)
    annotation (Line(points={{-179,320},{-160,320},{-160,296},{-142,296}},
      color={0,0,127}));
  connect(desLif.y, gai.u)
    annotation (Line(points={{-239,260},{-202,260}}, color={0,0,127}));
  connect(minLif.y, gai1.u)
    annotation (Line(points={{-239,290},{-220,290},{-220,230},{-202,230}},
      color={0,0,127}));
  connect(gai.y, add1.u1)
    annotation (Line(points={{-179,260},{-160,260},{-160,256},{-142,256}},
      color={0,0,127}));
  connect(gai1.y, add1.u2)
    annotation (Line(points={{-179,230},{-160,230},{-160,244},{-142,244}},
      color={0,0,127}));
  connect(simE.y, simF.u1)
    annotation (Line(points={{-119,290},{-100,290},{-100,256},{-82,256}},
      color={0,0,127}));
  connect(add1.y, simF.u2)
    annotation (Line(points={{-119,250},{-100,250},{-100,244},{-82,244}},
      color={0,0,127}));
  connect(simE.y, coeE.u1)
    annotation (Line(points={{-119,290},{0,290},{0,298},{18,298}},
      color={0,0,127}));
  connect(simF.y, coeF.u1)
    annotation (Line(points={{-59,250},{0,250},{0,258},{18,258}},
      color={0,0,127}));
  connect(simCoe.y, coeE.u2)
    annotation (Line(points={{-19,320},{8,320},{8,290},{18,290}},
      color={255,0,255}));
  connect(simCoe.y, coeF.u2)
    annotation (Line(points={{-19,320},{8,320},{8,250},{18,250}},
      color={255,0,255}));
  connect(regCoeE.y, coeE.u3)
    annotation (Line(points={{-19,270},{0,270},{0,282},{18,282}},
      color={0,0,127}));
  connect(regCoeF.y, coeF.u3)
    annotation (Line(points={{-19,230},{0,230},{0,242},{18,242}},
      color={0,0,127}));
  connect(TConWatRet, add3.u2)
    annotation (Line(points={{-300,184},{-262,184}},
      color={0,0,127}));
  connect(TChiWatSup, add3.u1)
    annotation (Line(points={{-300,220},{-270,220},{-270,196},{-262,196}},
      color={0,0,127}));
  connect(coeE.y, pro.u1)
    annotation (Line(points={{41,290},{60,290},{60,212},{-140,212},{-140,196},
      {-122,196}}, color={0,0,127}));
  connect(pro.y, staPLR.u2)
    annotation (Line(points={{-99,190},{-80,190},{-80,184},{-62,184}},
      color={0,0,127}));
  connect(coeF.y, staPLR.u1)
    annotation (Line(points={{41,250},{66,250},{66,208},{-80,208},{-80,196},
      {-62,196}}, color={0,0,127}));
  connect(sam.y, pro.u2)
    annotation (Line(points={{-159,190},{-140,190},{-140,184},{-122,184}},
      color={0,0,127}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-300,-200},{-242,-200}}, color={255,0,255}));
  connect(uChiWatPlaRes, hys.u)
    annotation (Line(points={{-300,80},{-242,80}}, color={0,0,127}));
  connect(hys.y, tim1.u)
    annotation (Line(points={{-219,80},{-202,80}}, color={255,0,255}));
  connect(uPLR, add4.u2)
    annotation (Line(points={{-300,134},{-242,134}}, color={0,0,127}));
  connect(staPLR.y, add4.u1)
    annotation (Line(points={{-39,190},{-20,190},{-20,162},{-260,162},
      {-260,146},{-242,146}}, color={0,0,127}));
  connect(add4.y, hys1.u)
    annotation (Line(points={{-219,140},{-202,140}}, color={0,0,127}));
  connect(hys1.y, tim.u)
    annotation (Line(points={{-179,140},{-162,140}}, color={255,0,255}));
  connect(uPLR, hys2.u)
    annotation (Line(points={{-300,134},{-260,134},{-260,110},{-162,110}},
      color={0,0,127}));
  connect(tim1.y, hys3.u)
    annotation (Line(points={{-179,80},{-162,80}}, color={0,0,127}));
  connect(hys2.y, and2.u1)
    annotation (Line(points={{-139,110},{-130,110},{-130,100},{-122,100}},
      color={255,0,255}));
  connect(hys3.y, and2.u2)
    annotation (Line(points={{-139,80},{-129.5,80},{-129.5,92},{-122,92}},
      color={255,0,255}));
  connect(tim.y, hys4.u)
    annotation (Line(points={{-139,140},{-122,140}}, color={0,0,127}));
  connect(hys4.y, or2.u1)
    annotation (Line(points={{-99,140},{-82,140}}, color={255,0,255}));
  connect(tim2.y, hys5.u)
    annotation (Line(points={{-119,-80},{-102,-80}}, color={0,0,127}));
  connect(timTabCon.y[1], lesEquThr1.u)
    annotation (Line(points={{-219,-160},{-202,-160}}, color={0,0,127}));
  connect(lesEquThr1.y, or3.u3)
    annotation (Line(points={{-179,-160},{-80,-160},{-80,-118},{-62,-118}},
      color={255,0,255}));
  connect(add4.y, gai2.u)
    annotation (Line(points={{-219,140},{-210,140},{-210,104},{-260,104},{-260,30},
      {-242,30}}, color={0,0,127}));
  connect(gai2.y, hys6.u)
    annotation (Line(points={{-219,30},{-202,30}}, color={0,0,127}));
  connect(hys6.y, tim3.u)
    annotation (Line(points={{-179,30},{-162,30}}, color={255,0,255}));
  connect(tim3.y, hys7.u)
    annotation (Line(points={{-139,30},{-122,30}}, color={0,0,127}));
  connect(or2.y, staUpHol.u)
    annotation (Line(points={{-59,140},{-1,140}},
      color={255,0,255}));
  connect(hys7.y, staDowHol.u)
    annotation (Line(points={{-99,30},{-1,30}}, color={255,0,255}));
  connect(or3.y, zerDowHol.u)
    annotation (Line(points={{-39,-110},{-28,-110},{-28,-80},{39,-80}},
      color={255,0,255}));
  connect(staDowHol.y, swi.u2)
    annotation (Line(points={{21,30},{118,30}}, color={255,0,255}));
  connect(staUpHol.y, swi1.u2)
    annotation (Line(points={{21,140},{118,140}}, color={255,0,255}));
  connect(zerDowHol.y, swi2.u2)
    annotation (Line(points={{61,-80},{118,-80}},color={255,0,255}));
  connect(zerSta.y, swi2.u1)
    annotation (Line(points={{61,-110},{92,-110},{92,-72},{118,-72}},
      color={0,0,127}));
  connect(mulSum.y, swi1.u3)
    annotation (Line(points={{-178.3,-200},{100,-200},{100,132},{118,132}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{141,140},{150,140},{150,80},{108,80},{108,22},
      {118,22}}, color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{141,30},{150,30},{150,-50},{108,-50},{108,-88},
      {118,-88}}, color={0,0,127}));
  connect(mulSum.y, curZerSta.u)
    annotation (Line(points={{-178.3,-200},{-140,-200},{-140,-230},{-82,-230}},
      color={0,0,127}));
  connect(lesEquThr1.y, not2.u)
    annotation (Line(points={{-179,-160},{-164,-160},{-164,-310},{-142,-310}},
      color={255,0,255}));
  connect(and2.y, or2.u2)
    annotation (Line(points={{-99,100},{-90,100},{-90,132},{-82,132}},
      color={255,0,255}));
  connect(not1.y, and3.u1)
    annotation (Line(points={{-119,-250},{-100,-250},{-100,-272},{-82,-272}},
      color={255,0,255}));
  connect(not2.y, and3.u3)
    annotation (Line(points={{-119,-310},{-100,-310},{-100,-288},{-82,-288}},
      color={255,0,255}));
  connect(and3.y, and1.u2)
    annotation (Line(points={{-59,-280},{-40,-280},{-40,-228},{-22,-228}},
      color={255,0,255}));
  connect(curZerSta.y, and1.u1)
    annotation (Line(points={{-59,-230},{-40,-230},{-40,-220},{-22,-220}},
      color={255,0,255}));
  connect(staOne.y, swi3.u1)
    annotation (Line(points={{41,-260},{52,-260},{52,-212},{78,-212}},
      color={0,0,127}));
  connect(and1.y, oneUpHol.u)
    annotation (Line(points={{1,-220},{19,-220}},  color={255,0,255}));
  connect(oneUpHol.y, swi3.u2)
    annotation (Line(points={{41,-220},{78,-220}}, color={255,0,255}));
  connect(zerDowHol.y, or4.u2)
    annotation (Line(points={{61,-80},{80,-80},{80,-38},{178,-38}},
      color={255,0,255}));
  connect(or1.y, swi4.u2)
    annotation (Line(points={{201,80},{238,80}}, color={255,0,255}));
  connect(staUpCon.y, swi4.u1)
    annotation (Line(points={{201,110},{220,110},{220,88},{238,88}},
      color={0,0,127}));
  connect(staDowCon.y, swi5.u1)
    annotation (Line(points={{201,0},{220,0},{220,-22},{238,-22}},
      color={0,0,127}));
  connect(or4.y, swi5.u2)
    annotation (Line(points={{201,-30},{238,-30}}, color={255,0,255}));
  connect(conSta.y, swi5.u3)
    annotation (Line(points={{201,-70},{220,-70},{220,-38},{238,-38}},
      color={0,0,127}));
  connect(swi5.y, swi4.u3)
    annotation (Line(points={{261,-30},{270,-30},{270,10},{220,10},{220,72},
      {238,72}}, color={0,0,127}));
  connect(swi4.y, reaToInt.u)
    annotation (Line(points={{261,80},{270,80},{270,110},{230,110},{230,140},
      {238,140}},  color={0,0,127}));
  connect(reaToInt.y, yChiStaCha)
    annotation (Line(points={{261,140},{290,140}}, color={255,127,0}));
  connect(swi3.y, reaToInt1.u)
    annotation (Line(points={{101,-220},{198,-220}}, color={0,0,127}));
  connect(reaToInt1.y, yChiSta)
    annotation (Line(points={{221,-220},{290,-220}}, color={255,127,0}));
  connect(add3.y, dKtodF.u)
    annotation (Line(points={{-239,190},{-222,190}}, color={0,0,127}));
  connect(dKtodF.y, sam.u)
    annotation (Line(points={{-199,190},{-182,190}}, color={0,0,127}));
  connect(hys5.y, or3.u1)
    annotation (Line(points={{-79,-80},{-70,-80},{-70,-102},{-62,-102}},
      color={255,0,255}));
  connect(mulSum.y, staUp.u)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,110},{-2,110}},
      color={0,0,127}));
  connect(mulSum.y, higSta.u)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,80},{-2,80}},
      color={0,0,127}));
  connect(higSta.y, swi6.u2)
    annotation (Line(points={{21,80},{40,80},{40,90},{58,90}},
      color={255,0,255}));
  connect(staUp.y, swi6.u1)
    annotation (Line(points={{21,110},{30,110},{30,98},{58,98}},
      color={0,0,127}));
  connect(mulSum.y, swi6.u3)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,60},{50,60},{50,82},
      {58,82}}, color={0,0,127}));
  connect(swi6.y, swi1.u1)
    annotation (Line(points={{81,90},{94,90},{94,148},{118,148}},
      color={0,0,127}));
  connect(higSta.y, and4.u2)
    annotation (Line(points={{21,80},{40,80},{40,112},{58,112}},
      color={255,0,255}));
  connect(staUpHol.y, and4.u1)
    annotation (Line(points={{21,140},{40,140},{40,120},{58,120}},
      color={255,0,255}));
  connect(and4.y, or1.u1)
    annotation (Line(points={{81,120},{160,120},{160,80},{178,80}},
      color={255,0,255}));
  connect(mulSum.y, staDow.u)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,0},{-2,0}},
      color={0,0,127}));
  connect(mulSum.y, staOneChe.u)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,-30},{-2,-30}},
      color={0,0,127}));
  connect(staDow.y, swi7.u1)
    annotation (Line(points={{21,0},{30,0},{30,-12},{58,-12}},
      color={0,0,127}));
  connect(staOneChe.y, swi7.u2)
    annotation (Line(points={{21,-30},{40,-30},{40,-20},{58,-20}},
      color={255,0,255}));
  connect(mulSum.y, swi7.u3)
    annotation (Line(points={{-178.3,-200},{-20,-200},{-20,-52},{50,-52},
      {50,-28},{58,-28}}, color={0,0,127}));
  connect(and5.y, or4.u1)
    annotation (Line(points={{81,10},{168,10},{168,-30},{178,-30}},
      color={255,0,255}));
  connect(swi7.y, swi.u1)
    annotation (Line(points={{81,-20},{94,-20},{94,38},{118,38}},
      color={0,0,127}));
  connect(staOneChe.y, and5.u2)
    annotation (Line(points={{21,-30},{40,-30},{40,2},{58,2}},
      color={255,0,255}));
  connect(staDowHol.y, and5.u1)
    annotation (Line(points={{21,30},{40,30},{40,10},{58,10}},
      color={255,0,255}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{141,-80},{150,-80},{150,-180},{68,-180},{68,-228},
      {78,-228}}, color={0,0,127}));
  connect(oneUpHol.y, or1.u2)
    annotation (Line(points={{41,-220},{60,-220},{60,-240},{160,-240},{160,72},
      {178,72}}, color={255,0,255}));
  connect(TChiWatSupResReq, intLesThr.u)
    annotation (Line(points={{-300,-80},{-242,-80}}, color={255,127,0}));
  connect(intLesThr.y, tim2.u)
    annotation (Line(points={{-219,-80},{-142,-80}}, color={255,0,255}));
  connect(intLesThr.y, not1.u)
    annotation (Line(points={{-219,-80},{-156,-80},{-156,-250},{-142,-250}},
      color={255,0,255}));
  connect(TOut, hys8.u)
    annotation (Line(points={{-300,-120},{-160,-120},{-160,-280},{-142,-280}},
      color={0,0,127}));
  connect(hys8.y, and3.u2)
    annotation (Line(points={{-119,-280},{-100,-280},{-100,-280},{-82,-280}},
      color={255,0,255}));
  connect(TOut, hys9.u)
    annotation (Line(points={{-300,-120},{-140,-120}}, color={0,0,127}));
  connect(hys9.y, or3.u2)
    annotation (Line(points={{-117,-120},{-100,-120},{-100,-110},{-62,-110}},
      color={255,0,255}));

annotation (
  defaultComponentName="chiStaCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-280,-320},{280,340}}), graphics={Rectangle(
          extent={{182,158},{278,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-278,-202},{138,-318}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-278,-62},{138,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-278,338},{218,182}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{82,280},{230,236}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate staging
part load ratio (SPLR)"),
          Text(
          extent={{188,-96},{326,-134}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it stages up 
or stages down"),
          Text(
          extent={{-116,-150},{44,-190}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage down to 0 stage"),
          Text(
          extent={{-38,-286},{126,-310}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage up from 0 to 1"),
                                             Rectangle(
          extent={{-278,158},{138,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-140,88},{-22,54}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage up"),
                                             Rectangle(
          extent={{-278,38},{138,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-164,-8},{-30,-44}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage down")}),
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
<p>
1. Chillers shall be lead-lag alternated. If a chiller is in alarm, its chilled
water isolation value shall be closed.
</p>
<p>
2. Chillers are staged in part based on load calculated from BTU meter except
for 15 minutes after a stage-up or stage-down transition, freeze calculated 
load at the value at the initiation of the transition. This allows steady-state
to be achieved and ensures a minimum on- and off-time before changing stages.
</p>
<p>
3. Staging shall be as followings. Timers shall reset to zero after every 
stage change. Each stage shall have a minimum runtime of 15 minutes (including
stage 0). Plant part load ratio <code>uPLR</code> is calcualted load divided
by total chiller design load. Lockout temperature <code>TLocChi</code> shall
be 60 &deg;F (15.56 &deg;C) and it is adjustable. The chiller plant shall be 
shall include an enabling schedule that allows operators to lock out the plant
during off-hours (<code>chiOffHou</code> ~ <code>chiOnHou</code>), e.g. to allow
off-hour operation of HVAC systems except the chiller plant; the default 
schedule shall be 24/7 (adjustable). The staging part load ratio (SPLR) shall be
calculated every 5 minutes as:
</p>
<pre>
  SPLR = E*(TConWatRet-TChiWatSup) + F
</pre>
<p>
where coeffcient E and F can be found as followings:
</p>
<ul>
<li>If <code>use_simCoe</code> is false. The cofficients will be calculated with
the regressed equations (use with care):
</li>
</ul>
<pre>
  E = 0.057 - 0.000569*((TWetBul_nominal-273.15)*9/5+32) - 0.0645*intParLoaVal
            - 0.000233*(APPROACH_nominal*9/5) - 0.000402*(towRan_nominal*9/5)
            + 0.0399*chiEff)
</pre>
<pre>
  F = -1.06 + 0.0145*((TWetBul_nominal-273.15)*9/5+32) + 2.16*intParLoaVal
            + 0.0068*(APPROACH_nominal*9/5) + 0.0117*(towRan_nominal*9/5)
            - 1.33*chiEff)
</pre>
<ul>
<li>If <code>use_simCoe</code> is true. The cofficients will be calculated with
the simplified equations:
</li>
</ul>
<pre>
  E = 0.45/(dTRef_nominal-dTRefMin)
</pre>
<pre>
  F = E*(0.4*dTRef_nominal-1.4*dTRefMin)
</pre>
<p>
This chiller staging strategy assumes that the plant has <code>num</code> 
chillers with same capacity.
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th> Stage </th> 
<th> Chillers on </th> 
<th> Nominal capacity </th> 
<th colspan=\"2\"> Stage up to next stage if either </th> 
<th> Stage down to lower stage if </th> </tr>
<tr>
<td>0</td>
<td>All off</td>
<td>0</td>
<td>--</td>
<td><code>TChiWatSupResReq</code> &gt; 0 and <code>TOut</code> &gt; <code>TLocChi</code> and schedule is active</td>
<td>--</td></tr>
<tr>
<td>1</td>
<td>Lead chiller 1</td>
<td>1/<code>num</code></td>
<td>for 15 minutes, <code>uPLR</code> &gt; SPLR</td>
<td><code>uChiWatPlaRes</code> = 100 for 15 minutes, and <code>uPLR</code> &gt; 30%</td>
<td><code>TChiWatSupResReq</code> = 0 for 5 minuts, or <code>TOut</code> &lt; (<code>TLocChi</code>-5F), or schedule is inactive</td></tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td></tr>
<tr>
<td>i</td>
<td>Lead chillers 1~i</td>
<td>i/<code>num</code></td>
<td>for 15 minutes, <code>uPLR</code> &gt; SPLR</td>
<td><code>uChiWatPlaRes</code> = 100 for 15 minutes, and <code>uPLR</code> &gt; 30%</td>
<td><code>TChiWatSupResReq</code> = 0 for 5 minuts, or <code>TOut</code> &lt; (<code>TLocChi</code>-5F), or schedule is inactive</td></tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td></tr>
<tr>
<td>num</td>
<td>All chiller</td>
<td>100%</td>
<td>--</td>
<td>--</td><td>for 15 minutes <code>uPLR</code> &lt; SPLR</td></tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStaging;
