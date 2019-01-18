within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block ChangeOld
  "Stage operating part load ratio (current, up, down and minimum), will be replaced by a generic change sequence"

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-240,200},{-200,240}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-240,164},{-200,204}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR
    "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes
    "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chiller status"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta
    "Chiller stage output"
    annotation (Placement(transformation(extent={{240,-270},{260,-250}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
    "Difference between design and minimum LIFT"
    annotation (Placement(transformation(extent={{-120,280},{-100,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Division simE
    "Simplified coefficient E"
    annotation (Placement(transformation(extent={{-60,280},{-40,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Difference of inputs"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Product simF
    "Simplified coefficient F"
    annotation (Placement(transformation(extent={{0,240},{20,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeE(
    final k=0.057 - 0.000569*((TWetBul_nominal-273.15)*9/5+32) - 0.0645*intParLoaVal
                  - 0.000233*(APPROACH_nominal*9/5) - 0.000402*(towRan_nominal*9/5)
                  + 0.0399*chiEff)
    "Regressed coefficient E"
    annotation (Placement(transformation(extent={{40,260},{60,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regCoeF(
    final k=-1.06 + 0.0145*((TWetBul_nominal-273.15)*9/5+32) + 2.16*intParLoaVal
                  + 0.0068*(APPROACH_nominal*9/5) + 0.0117*(towRan_nominal*9/5)
                  - 1.33*chiEff)
    "Regressed coefficient F"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant simCoe(
    final k=use_simCoe)
    "Simplified cofficients indicator"
    annotation (Placement(transformation(extent={{40,310},{60,330}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeE "Coefficient E"
    annotation (Placement(transformation(extent={{100,280},{120,300}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeF "Coefficient F"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=-1)
    "Difference between condenser water return and chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Add staPLR "Staging part load ratio"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=300)
    "Sample input value every 5 minutes"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabCon(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;chiOnHou*3600,1; chiOffHou*3600,0; 24*3600,0])
    "Time table with chiller plant schedule"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=num)
    "Current chiller stage, it equals to total number of operating chillers"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count duration time when PLR becomes greater than SPLR"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.95 - 0.02,
    final uHigh=0.95 + 0.02)
    "Check if chilled water plant reset is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Count duration time when chilled water plant reset becomes greater than 0.95"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=-1)
    "Difference between stage PLR and current PLR"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is greater than SPLR"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0.3 - 0.05,
    final uHigh=0.3 + 0.05)
    "Check if PLR is greater than 0.3"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if chilled water plant reset has been greater than 0.95 for more than 15 minutes"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Stage up"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been greater than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2
    "Count duration time when there is no chiller plant request"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=300 - 5,
    final uHigh=300 + 5)
    "Check if there is no chiller plant request for more than 5 minutes"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    final uLow=-0.05,
    final uHigh=0.05)
    "Check if PLR is less than SPLR"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3
    "Count duration time when PLR becomes less than SPLR"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    final uLow=900 - 5,
    final uHigh=900 + 5)
    "Check if PLR has been less than SPLR for more than 15 minutes"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold zerDowHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staDow(
    final p=-1, final k=1) "Stage down"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{200,20},{220,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter staUp(
    final k=1, final p=1) "Stage up"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{200,130},{220,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold curZerSta(
    final threshold=0.5)
    "Check if it is stage zero now"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Chiller plant request is non-zero"
    annotation (Placement(transformation(extent={{-60,-260},{-40,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Check if schedule is active"
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{60,-230},{80,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold oneUpHol(
    final trueHoldDuration=900)
    "Ensure each stage has a minimum runtime of 15 minutes"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6
    "Ensure no further stage-up when current stage is already the highest stage"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold higSta(
    final threshold=num - 1)
    "Check if current stage is highest stage minus 1"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold staOneChe(
    final threshold=1)
    "Check if current stage is having at least 1 chiller operating"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7
    "Ensure no further stage-down when current stage is already stage 1"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dKtodF(final k=9/5)
    "Convert from degK difference to degF difference"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  CDL.Integers.LessEqualThreshold                   intLesEquThr(threshold=0)
    "Check if there is no chiller plant request"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys8(
    final uLow=TLocChi - 1*5/9,
    final uHigh=TLocChi + 1*5/9)
    "Check if outdoor temrature is greater than lockout temperature"
    annotation (Placement(transformation(extent={{-60,-290},{-40,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final uLow=TLocChi - 5.5*5/9,
    final uHigh=TLocChi - 4.5*5/9)
    "Check if outdoor temperature is greater than lockout temperature minus 5 degF"
    annotation (Placement(transformation(extent={{-58,-130},{-38,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
protected
  parameter Modelica.SIunits.TemperatureDifference dTRef_nominal=
    TConWatRet_nominal - TChiWatSup_nominal
    "LIFT at design conditions "
    annotation(Dialog(group="Design conditions"));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLif(
    final k=dTRefMin*9/5)
    "Minimum LIFT at minimum load"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desLif(
    final k=dTRef_nominal*9/5)
    "LIFT at design conditions"
    annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.45)
    "Constant"
    annotation (Placement(transformation(extent={{-120,310},{-100,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=0.4)
    "Gain factor"
    annotation (Placement(transformation(extent={{-120,250},{-100,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=1.4) "Gain factor"
    annotation (Placement(transformation(extent={{-120,220},{-100,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=-1)
    "Gain factor"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{100,-270},{120,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerSta(final k=0)
    "Stage zero"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[num]
    "Convert boolean to real number"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));

equation
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-139,-200},{-122,-200}}, color={0,0,127}));
  connect(minLif.y, add2.u1)
    annotation (Line(points={{-159,290},{-140,290},{-140,296},{-122,296}},
      color={0,0,127}));
  connect(desLif.y, add2.u2)
    annotation (Line(points={{-159,260},{-132,260},{-132,284},{-122,284}},
      color={0,0,127}));
  connect(add2.y, simE.u2)
    annotation (Line(points={{-99,290},{-80,290},{-80,284},{-62,284}},
      color={0,0,127}));
  connect(con.y, simE.u1)
    annotation (Line(points={{-99,320},{-80,320},{-80,296},{-62,296}},
      color={0,0,127}));
  connect(desLif.y, gai.u)
    annotation (Line(points={{-159,260},{-122,260}}, color={0,0,127}));
  connect(minLif.y, gai1.u)
    annotation (Line(points={{-159,290},{-140,290},{-140,230},{-122,230}},
      color={0,0,127}));
  connect(gai.y, add1.u1)
    annotation (Line(points={{-99,260},{-80,260},{-80,256},{-62,256}},
      color={0,0,127}));
  connect(gai1.y, add1.u2)
    annotation (Line(points={{-99,230},{-80,230},{-80,244},{-62,244}},
      color={0,0,127}));
  connect(simE.y, simF.u1)
    annotation (Line(points={{-39,290},{-20,290},{-20,256},{-2,256}},
      color={0,0,127}));
  connect(add1.y, simF.u2)
    annotation (Line(points={{-39,250},{-20,250},{-20,244},{-2,244}},
      color={0,0,127}));
  connect(simE.y, coeE.u1)
    annotation (Line(points={{-39,290},{80,290},{80,298},{98,298}},
      color={0,0,127}));
  connect(simF.y, coeF.u1)
    annotation (Line(points={{21,250},{80,250},{80,258},{98,258}},
      color={0,0,127}));
  connect(simCoe.y, coeE.u2)
    annotation (Line(points={{61,320},{88,320},{88,290},{98,290}},
      color={255,0,255}));
  connect(simCoe.y, coeF.u2)
    annotation (Line(points={{61,320},{88,320},{88,250},{98,250}},
      color={255,0,255}));
  connect(regCoeE.y, coeE.u3)
    annotation (Line(points={{61,270},{80,270},{80,282},{98,282}},
      color={0,0,127}));
  connect(regCoeF.y, coeF.u3)
    annotation (Line(points={{61,230},{80,230},{80,242},{98,242}},
      color={0,0,127}));
  connect(TConWatRet, add3.u2)
    annotation (Line(points={{-220,184},{-182,184}},
      color={0,0,127}));
  connect(TChiWatSup, add3.u1)
    annotation (Line(points={{-220,220},{-190,220},{-190,196},{-182,196}},
      color={0,0,127}));
  connect(coeE.y, pro.u1)
    annotation (Line(points={{121,290},{140,290},{140,212},{-60,212},{-60,196},
      {-42,196}}, color={0,0,127}));
  connect(pro.y, staPLR.u2)
    annotation (Line(points={{-19,190},{0,190},{0,184},{18,184}},
      color={0,0,127}));
  connect(coeF.y, staPLR.u1)
    annotation (Line(points={{121,250},{146,250},{146,208},{0,208},{0,196},
      {18,196}}, color={0,0,127}));
  connect(sam.y, pro.u2)
    annotation (Line(points={{-79,190},{-60,190},{-60,184},{-42,184}},
      color={0,0,127}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-220,-200},{-162,-200}}, color={255,0,255}));
  connect(uChiWatPlaRes, hys.u)
    annotation (Line(points={{-220,80},{-162,80}}, color={0,0,127}));
  connect(hys.y, tim1.u)
    annotation (Line(points={{-139,80},{-122,80}}, color={255,0,255}));
  connect(uPLR, add4.u2)
    annotation (Line(points={{-220,140},{-180,140},{-180,134},{-162,134}},
      color={0,0,127}));
  connect(staPLR.y, add4.u1)
    annotation (Line(points={{41,190},{60,190},{60,162},{-180,162},{-180,146},
      {-162,146}}, color={0,0,127}));
  connect(add4.y, hys1.u)
    annotation (Line(points={{-139,140},{-122,140}}, color={0,0,127}));
  connect(hys1.y, tim.u)
    annotation (Line(points={{-99,140},{-82,140}},   color={255,0,255}));
  connect(uPLR, hys2.u)
    annotation (Line(points={{-220,140},{-180,140},{-180,110},{-82,110}},
      color={0,0,127}));
  connect(tim1.y, hys3.u)
    annotation (Line(points={{-99,80},{-82,80}},   color={0,0,127}));
  connect(hys2.y, and2.u1)
    annotation (Line(points={{-59,110},{-50,110},{-50,100},{-42,100}},
      color={255,0,255}));
  connect(hys3.y, and2.u2)
    annotation (Line(points={{-59,80},{-49.5,80},{-49.5,92},{-42,92}},
      color={255,0,255}));
  connect(tim.y, hys4.u)
    annotation (Line(points={{-59,140},{-42,140}},   color={0,0,127}));
  connect(hys4.y, or2.u1)
    annotation (Line(points={{-19,140},{-2,140}},  color={255,0,255}));
  connect(tim2.y, hys5.u)
    annotation (Line(points={{-39,-80},{-22,-80}},   color={0,0,127}));
  connect(timTabCon.y[1], lesEquThr1.u)
    annotation (Line(points={{-139,-160},{-122,-160}}, color={0,0,127}));
  connect(lesEquThr1.y, or3.u3)
    annotation (Line(points={{-99,-160},{10,-160},{10,-118},{18,-118}},
      color={255,0,255}));
  connect(add4.y, gai2.u)
    annotation (Line(points={{-139,140},{-130,140},{-130,104},{-180,104},{-180,30},
      {-162,30}}, color={0,0,127}));
  connect(gai2.y, hys6.u)
    annotation (Line(points={{-139,30},{-122,30}}, color={0,0,127}));
  connect(hys6.y, tim3.u)
    annotation (Line(points={{-99,30},{-82,30}},   color={255,0,255}));
  connect(tim3.y, hys7.u)
    annotation (Line(points={{-59,30},{-42,30}},   color={0,0,127}));
  connect(or2.y, staUpHol.u)
    annotation (Line(points={{21,140},{79,140}},
      color={255,0,255}));
  connect(or3.y, zerDowHol.u)
    annotation (Line(points={{41,-110},{52,-110},{52,-80},{119,-80}},
      color={255,0,255}));
  connect(staDowHol.y, swi.u2)
    annotation (Line(points={{161,30},{198,30}},color={255,0,255}));
  connect(staUpHol.y, swi1.u2)
    annotation (Line(points={{101,140},{198,140}},color={255,0,255}));
  connect(zerDowHol.y, swi2.u2)
    annotation (Line(points={{141,-80},{198,-80}}, color={255,0,255}));
  connect(zerSta.y, swi2.u1)
    annotation (Line(points={{141,-110},{172,-110},{172,-72},{198,-72}},
      color={0,0,127}));
  connect(mulSum.y, swi1.u3)
    annotation (Line(points={{-99,-200},{180,-200},{180,132},{198,132}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{221,140},{230,140},{230,80},{188,80},{188,22},
      {198,22}},  color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{221,30},{230,30},{230,-50},{188,-50},{188,-88},
      {198,-88}},  color={0,0,127}));
  connect(mulSum.y, curZerSta.u)
    annotation (Line(points={{-99,-200},{-60,-200},{-60,-230},{-2,-230}},
      color={0,0,127}));
  connect(lesEquThr1.y, not2.u)
    annotation (Line(points={{-99,-160},{-84,-160},{-84,-310},{-62,-310}},
      color={255,0,255}));
  connect(and2.y, or2.u2)
    annotation (Line(points={{-19,100},{-10,100},{-10,132},{-2,132}},
      color={255,0,255}));
  connect(not1.y, and3.u1)
    annotation (Line(points={{-39,-250},{-20,-250},{-20,-272},{-2,-272}},
      color={255,0,255}));
  connect(not2.y, and3.u3)
    annotation (Line(points={{-39,-310},{-20,-310},{-20,-288},{-2,-288}},
      color={255,0,255}));
  connect(and3.y, and1.u2)
    annotation (Line(points={{21,-280},{48,-280},{48,-228},{58,-228}},
      color={255,0,255}));
  connect(curZerSta.y, and1.u1)
    annotation (Line(points={{21,-230},{40,-230},{40,-220},{58,-220}},
      color={255,0,255}));
  connect(staOne.y, swi3.u1)
    annotation (Line(points={{121,-260},{132,-260},{132,-212},{158,-212}},
      color={0,0,127}));
  connect(and1.y, oneUpHol.u)
    annotation (Line(points={{81,-220},{99,-220}}, color={255,0,255}));
  connect(oneUpHol.y, swi3.u2)
    annotation (Line(points={{121,-220},{158,-220}}, color={255,0,255}));
  connect(reaToInt1.y, yChiSta)
    annotation (Line(points={{181,-260},{250,-260}}, color={255,127,0}));
  connect(add3.y, dKtodF.u)
    annotation (Line(points={{-159,190},{-142,190}}, color={0,0,127}));
  connect(dKtodF.y, sam.u)
    annotation (Line(points={{-119,190},{-102,190}}, color={0,0,127}));
  connect(hys5.y, or3.u1)
    annotation (Line(points={{1,-80},{10,-80},{10,-102},{18,-102}},
      color={255,0,255}));
  connect(mulSum.y, staUp.u)
    annotation (Line(points={{-99,-200},{60,-200},{60,110},{78,110}},
      color={0,0,127}));
  connect(mulSum.y, higSta.u)
    annotation (Line(points={{-99,-200},{60,-200},{60,80},{78,80}},
      color={0,0,127}));
  connect(higSta.y, swi6.u2)
    annotation (Line(points={{101,80},{120,80},{120,90},{138,90}},
      color={255,0,255}));
  connect(staUp.y, swi6.u1)
    annotation (Line(points={{101,110},{110,110},{110,98},{138,98}},
      color={0,0,127}));
  connect(mulSum.y, swi6.u3)
    annotation (Line(points={{-99,-200},{60,-200},{60,60},{130,60},{130,82},{138,
          82}},  color={0,0,127}));
  connect(swi6.y, swi1.u1)
    annotation (Line(points={{161,90},{174,90},{174,148},{198,148}},
      color={0,0,127}));
  connect(mulSum.y, staDow.u)
    annotation (Line(points={{-99,-200},{60,-200},{60,0},{78,0}},
      color={0,0,127}));
  connect(mulSum.y, staOneChe.u)
    annotation (Line(points={{-99,-200},{60,-200},{60,-30},{78,-30}},
      color={0,0,127}));
  connect(staDow.y, swi7.u1)
    annotation (Line(points={{101,0},{110,0},{110,-12},{138,-12}},
      color={0,0,127}));
  connect(staOneChe.y, swi7.u2)
    annotation (Line(points={{101,-30},{120,-30},{120,-20},{138,-20}},
      color={255,0,255}));
  connect(mulSum.y, swi7.u3)
    annotation (Line(points={{-99,-200},{60,-200},{60,-52},{130,-52},{130,-28},{
          138,-28}},        color={0,0,127}));
  connect(swi7.y, swi.u1)
    annotation (Line(points={{161,-20},{174,-20},{174,38},{198,38}},
      color={0,0,127}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{221,-80},{230,-80},{230,-180},{148,-180},
      {148,-228},{158,-228}}, color={0,0,127}));
  connect(TChiWatSupResReq, intLesEquThr.u)
    annotation (Line(points={{-220,-80},{-162,-80}}, color={255,127,0}));
  connect(intLesEquThr.y, tim2.u)
    annotation (Line(points={{-139,-80},{-62,-80}}, color={255,0,255}));
  connect(intLesEquThr.y, not1.u)
    annotation (Line(points={{-139,-80},{-76,-80},{-76,-250},{-62,-250}},
      color={255,0,255}));
  connect(TOut, hys8.u)
    annotation (Line(points={{-220,-120},{-80,-120},{-80,-280},{-62,-280}},
      color={0,0,127}));
  connect(hys8.y, and3.u2)
    annotation (Line(points={{-39,-280},{-2,-280}},
      color={255,0,255}));
  connect(TOut, hys9.u)
    annotation (Line(points={{-220,-120},{-60,-120}},  color={0,0,127}));
  connect(swi3.y, reaToInt1.u)
    annotation (Line(points={{181,-220},{200,-220},{200,-240},{140,-240},
      {140,-260},{158,-260}}, color={0,0,127}));
  connect(not3.y, or3.u2)
    annotation (Line(points={{1,-110},{18,-110}}, color={255,0,255}));
  connect(hys9.y, not3.u)
    annotation (Line(points={{-37,-120},{-32,-120},{-32,-110},{-22,-110}},
      color={255,0,255}));
  connect(hys7.y, and4.u1)
    annotation (Line(points={{-19,30},{78,30}}, color={255,0,255}));
  connect(and4.y, staDowHol.u)
    annotation (Line(points={{101,30},{139,30}}, color={255,0,255}));
  connect(staOneChe.y, and4.u2)
    annotation (Line(points={{101,-30},{120,-30},{120,16},{70,16},{70,22},{78,
          22}}, color={255,0,255}));

annotation (
  defaultComponentName="chiStaCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-200,-320},{240,340}}), graphics={Rectangle(
          extent={{-198,-202},{218,-318}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-198,-62},{218,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-198,338},{218,182}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,344},{214,300}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Calculate staging
part load ratio (SPLR)"),
          Text(
          extent={{-36,-150},{124,-190}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage down to 0 stage"),
          Text(
          extent={{42,-286},{206,-310}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage up from 0 to 1"),
                                             Rectangle(
          extent={{-198,158},{218,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-60,88},{58,54}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it should stage up"),
                                             Rectangle(
          extent={{-198,38},{218,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-84,-8},{50,-44}},
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
          extent={{66,8},{96,-8}},
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
          textString="uChi")}),
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
end ChangeOld;
