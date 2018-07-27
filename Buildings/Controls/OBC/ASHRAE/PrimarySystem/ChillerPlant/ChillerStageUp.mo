within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerStageUp "Sequences to control equipments when chiller stage up"
  parameter Integer num = 2
    "Total number of CW pumps";
  parameter Modelica.SIunits.TemperatureDifference dTAboSet = 0.55
    "Threshold value of CWRT above its setpoint";
  parameter Real minFanSpe
    "Minimum fan speed";
  parameter Real minFloSet[num] = {0, 100}
    "Minimum flow setpoint";
  parameter Modelica.SIunits.Time tMinFanSpe = 300
    "Threshold duration time of fan at minimum speed";
  parameter Modelica.SIunits.Time tFanOffMin = 180
    "Minimum fan cycle off time";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFan=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Fan controller"));
  parameter Real kFan(final unit="1")=0.5
    "Gain of controller for fan control"
    annotation(Dialog(group="Fan controller"));
  parameter Modelica.SIunits.Time TiFan=300
    "Time constant of integrator block for fan control"
    annotation(Dialog(group="Fan controller",
    enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdFan=0.1
    "Time constant of derivative block for fan control"
    annotation (Dialog(group="Fan controller",
      enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time byPasSetTim=300
    "Time to change minimum flow setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](final quantity="ElectricCurrent",
      final unit="A") "Current chiller demand measured by the current"
    annotation (Placement(transformation(extent={{-260,410},{-220,450}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chillers status" annotation (Placement(transformation(extent={{-260,370},{-220,
            410}}),      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Condense water isolation valve position" annotation (
      Placement(transformation(extent={{-260,70},{-220,110}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
    "Condenser water pump status" annotation (Placement(transformation(extent={{240,150},
            {260,170}}),            iconTransformation(extent={{100,40},{120,60}})));

  CDL.Interfaces.RealInput uChiWatIsoval(
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position" annotation (Placement(
        transformation(extent={{-260,-488},{-220,-448}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.BooleanInput uConWatPum[num] "Condenser water pump status"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Discrete.TriggeredSampler triSam[num]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{-140,420},{-120,440}})));
  CDL.Routing.BooleanReplicator                        booRep1(final nout=num)
                    "Replicate input "
    annotation (Placement(transformation(extent={{-100,470},{-80,490}})));
  CDL.Interfaces.RealOutput yChiCur[num](final quantity="ElectricCurrent",
      final unit="A") "Current to chillers" annotation (Placement(transformation(
          extent={{240,420},{260,440}}),iconTransformation(extent={{100,-60},{120,
            -40}})));
  CDL.Continuous.Gain gai[num](k=0.5) "Half of current load"
    annotation (Placement(transformation(extent={{100,420},{120,440}})));
  CDL.Continuous.Hysteresis hys[num](uLow=0.54, uHigh=0.56)
    "Check if actual demand is more than 0.55 of demand at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-40,350},{-20,370}})));
  CDL.Continuous.Division div[num]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{40,390},{60,410}})));
  CDL.Continuous.Sources.Constant con[num](k=0.2)
    "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,350},{-120,370}})));
  CDL.Logical.Switch swi[num]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,380},{-60,400}})));
  CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{0,350},{20,370}})));
  CDL.Logical.TrueDelay truDel "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{80,350},{100,370}})));
  CDL.Logical.MultiAnd mulAnd(nu=2)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  CDL.Interfaces.IntegerInput uChiSta "Current chiller stage" annotation (
      Placement(transformation(extent={{-260,460},{-220,500}}),
        iconTransformation(extent={{-254,-38},{-214,2}})));
  CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{-160,470},{-140,490}})));
  CDL.Routing.RealExtractor curMinSet
    "Targeted minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-80,290},{-60,310}})));
  CDL.Continuous.Sources.Constant con1[num](k=minFloSet)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-140,290},{-120,310}})));
  CDL.Integers.Add addInt(k2=-1) "One stage lower than current one"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  CDL.Integers.Sources.Constant conInt(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  CDL.Routing.RealExtractor oldMinSet "Minimum flow setpoint at old stage"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  CDL.Continuous.Line lin "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{0,240},{20,260}})));
  CDL.Continuous.Sources.Constant con2(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-40,290},{-20,310}})));
  CDL.Continuous.Sources.Constant con3(k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  CDL.Logical.Timer tim "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{0,290},{20,310}})));
  CDL.Interfaces.RealOutput yMinFloSet(
    final unit="m3/s") "Minimum flow setpoint" annotation (Placement(
        transformation(extent={{240,250},{260,270}}), iconTransformation(extent=
           {{100,-60},{120,-40}})));
  CDL.Continuous.Hysteresis hys2(uLow=byPassSetTim - 60 - 5, uHigh=byPassSetTim -
        60 + 5) "Check if it is 1 minute after new setpoint achieved"
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
  CDL.Integers.LessThreshold intLesThr(threshold=1) "Check if it is zero stage"
    annotation (Placement(transformation(extent={{60,260},{80,280}})));
  CDL.Logical.Switch swi1 "Switch to current stage setpoint"
    annotation (Placement(transformation(extent={{120,250},{140,270}})));
  CDL.Continuous.Sources.Constant con4(k=0)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));


  CDL.Interfaces.BooleanOutput yConWatIsoVal[num]
    "Condenser water isolation valve status" annotation (Placement(
        transformation(extent={{240,80},{260,100}}),    iconTransformation(
          extent={{100,40},{120,60}})));
  CDL.Continuous.Hysteresis hys1[num](uLow=0.1, uHigh=0.12)
    "Check if the enabled isolation valve is open more than 10%"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  CDL.Logical.LogicalSwitch logSwi7[num] "Logical switch"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  CDL.Logical.Sources.Constant con16[num](k=true) "Constant true"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  CDL.Logical.MultiAnd mulAnd3(nu=2)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Logical.TrueDelay truDel1(delayTime=30)
                               "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  enableNext enaPum(num=num) "Enable next pump"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  enableNext enaChiWatIso(num=num) "Enable next chilled water isolation valve"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Interfaces.RealInput uChiWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position" annotation (Placement(
        transformation(extent={{-260,-320},{-220,-280}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Logical.And and2[num]
    "Check change of the chilled water isolation valve vector"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  CDL.Logical.Not not2[num] "Logical not"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  CDL.Logical.And and1[num]
    "Check change of the chilled water isolation valve vector"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  CDL.Logical.Timer tim1
                        "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  CDL.Continuous.Line lin1
                          "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  CDL.Continuous.Sources.Constant con6(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  CDL.Continuous.Sources.Constant con7(k=turOnChiWatIsoTim)
    "Time to turn on chilled water isolation valve"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Continuous.Sources.Constant con8(k=1) "Constant 1"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Continuous.Sources.Constant con9(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Logical.Switch swi3[num]
    "Position setpoint of chilled water isolation valve"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  CDL.Continuous.Sources.Constant con10[num](k=0) "Constant 0"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  CDL.Continuous.Sources.Constant con11[num](k=1) "Constant 0"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  CDL.Logical.Switch swi2[num]
    "Position setpoint of chilled water isolation valve"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  CDL.Continuous.Sources.Constant con5[num](k=0) "Constant 0"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Routing.RealReplicator reaRep(nout=num) "Replicate real input"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  CDL.Continuous.Add add2[num]
    "Chilled water isolation valve position setpoint vector"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  CDL.Interfaces.RealOutput yChiWatIsoValSet[num](final min=0, final max=1,
      final unit="1") "Chilled water isolvation valve position setpoint"
    annotation (Placement(transformation(extent={{240,-120},{260,-100}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  CDL.Continuous.Hysteresis hys3[num](uLow=0.025, uHigh=0.05)
    "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-180,-310},{-160,-290}})));
  CDL.Continuous.Hysteresis hys4[num](uLow=0.925, uHigh=0.975)
    "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-180,-370},{-160,-350}})));
  CDL.Logical.And and3[num] "Logical and"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  CDL.Logical.Not not3[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,-340},{-100,-320}})));
  CDL.Logical.Not not4[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,-370},{-100,-350}})));
  CDL.Logical.And and4[num] "Logical and"
    annotation (Placement(transformation(extent={{-60,-350},{-40,-330}})));
  CDL.Logical.Or or2[num] "Logicla or"
    annotation (Placement(transformation(extent={{0,-330},{20,-310}})));
  CDL.Continuous.Greater gre "Check if input 1 is greater than input 2"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  CDL.Continuous.Sources.Constant con12(k=turOnChiWatIsoTim)
    "Chilled water isolation valve open time"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  CDL.Logical.MultiAnd mulAnd1(nu=num)
    annotation (Placement(transformation(extent={{40,-330},{60,-310}})));
  CDL.Logical.And and5 "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{100,-320},{120,-300}})));
equation

  connect(uChiCur, triSam.u)
    annotation (Line(points={{-240,430},{-142,430}},
                                                   color={0,0,127}));
  connect(booRep1.y, triSam.trigger) annotation (Line(points={{-79,480},{-60,480},
          {-60,460},{-160,460},{-160,400},{-130,400},{-130,418.2}},
                                                               color={255,0,255}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-119,430},{98,430}},  color={0,0,127}));
  connect(gai.y, yChiCur) annotation (Line(points={{121,430},{250,430}},
                      color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-240,390},{-82,390}},color={255,0,255}));
  connect(con.y, swi.u3) annotation (Line(points={{-119,360},{-100,360},{-100,382},
          {-82,382}}, color={0,0,127}));
  connect(uChiCur, div.u1) annotation (Line(points={{-240,430},{-200,430},{-200,
          406},{38,406}},                  color={0,0,127}));
  connect(swi.y, div.u2) annotation (Line(points={{-59,390},{20,390},{20,394},{38,
          394}},color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-19,360},{-2,360}},
                                              color={255,0,255}));
  connect(not1.y, mulAnd.u) annotation (Line(points={{21,360},{38,360}},
                      color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{61.7,360},{78,360}},
                                                 color={255,0,255}));
  connect(uChiSta, cha.u)
    annotation (Line(points={{-240,480},{-162,480}}, color={255,127,0}));
  connect(cha.up, booRep1.u) annotation (Line(points={{-139,486},{-120,486},{-120,
          480},{-102,480}}, color={255,0,255}));
  connect(con1.y,curMinSet. u)
    annotation (Line(points={{-119,300},{-82,300}}, color={0,0,127}));
  connect(uChiSta, addInt.u1) annotation (Line(points={{-240,480},{-180,480},{-180,
          280},{-150,280},{-150,236},{-142,236}}, color={255,127,0}));
  connect(conInt.y, addInt.u2) annotation (Line(points={{-159,230},{-150,230},{-150,
          224},{-142,224}}, color={255,127,0}));
  connect(con1.y, oldMinSet.u) annotation (Line(points={{-119,300},{-100,300},{-100,
          250},{-82,250}}, color={0,0,127}));
  connect(uChiSta,curMinSet. index) annotation (Line(points={{-240,480},{-180,480},
          {-180,280},{-70,280},{-70,288}}, color={255,127,0}));
  connect(div.y, hys.u) annotation (Line(points={{61,400},{80,400},{80,380},{-50,
          380},{-50,360},{-42,360}},
                              color={0,0,127}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-119,430},{-100,430},{-100,
          398},{-82,398}},
                         color={0,0,127}));
  connect(con2.y, lin.x1) annotation (Line(points={{-19,300},{-12,300},{-12,258},
          {-2,258}},color={0,0,127}));
  connect(con3.y, lin.x2) annotation (Line(points={{-19,230},{-12,230},{-12,246},
          {-2,246}}, color={0,0,127}));
  connect(truDel.y, tim.u) annotation (Line(points={{101,360},{120,360},{120,340},
          {-10,340},{-10,300},{-2,300}},
                                       color={255,0,255}));
  connect(tim.y, lin.u) annotation (Line(points={{21,300},{40,300},{40,278},{-8,
          278},{-8,250},{-2,250}},
                             color={0,0,127}));
  connect(oldMinSet.y, lin.f1) annotation (Line(points={{-59,250},{-12,250},{-12,
          254},{-2,254}}, color={0,0,127}));
  connect(tim.y, hys2.u) annotation (Line(points={{21,300},{40,300},{40,230},{78,
          230}}, color={0,0,127}));
  connect(addInt.y, oldMinSet.index) annotation (Line(points={{-119,230},{-70,230},
          {-70,238}},                      color={255,127,0}));
  connect(uChiSta, intLesThr.u) annotation (Line(points={{-240,480},{-180,480},{
          -180,320},{50,320},{50,270},{58,270}},
                                             color={255,127,0}));
  connect(con4.y, swi1.u1) annotation (Line(points={{81,300},{110,300},{110,268},
          {118,268}}, color={0,0,127}));
  connect(intLesThr.y, swi1.u2) annotation (Line(points={{81,270},{100,270},{100,
          260},{118,260}}, color={255,0,255}));
  connect(lin.y, swi1.u3) annotation (Line(points={{21,250},{100,250},{100,252},
          {118,252}}, color={0,0,127}));
  connect(swi1.y, yMinFloSet)
    annotation (Line(points={{141,260},{250,260}}, color={0,0,127}));
  connect(curMinSet.y, lin.f2) annotation (Line(points={{-59,300},{-50,300},{-50,
          260},{-16,260},{-16,242},{-2,242}}, color={0,0,127}));
  connect(uConWatIsoVal, hys1.u)
    annotation (Line(points={{-240,90},{-182,90}},     color={0,0,127}));
  connect(hys1.y, logSwi7.u1) annotation (Line(points={{-159,90},{-150,90},{-150,
          98},{-122,98}},          color={255,0,255}));
  connect(con16.y, logSwi7.u3) annotation (Line(points={{-159,60},{-140,60},{-140,
          82},{-122,82}},           color={255,0,255}));
  connect(logSwi7.y, mulAnd3.u) annotation (Line(points={{-99,90},{-82,90}},
                                              color={255,0,255}));
  connect(mulAnd3.y, truDel1.u)
    annotation (Line(points={{-58.3,90},{-42,90}}, color={255,0,255}));
  connect(uConWatPum, enaPum.uDevSta) annotation (Line(points={{-240,160},{-162,
          160},{-162,160},{-82,160}}, color={255,0,255}));
  connect(hys2.y, enaPum.uEnaNex) annotation (Line(points={{101,230},{120,230},{
          120,200},{-100,200},{-100,152},{-82,152}}, color={255,0,255}));
  connect(enaPum.yDevSta, yConWatPum)
    annotation (Line(points={{-59,160},{250,160}}, color={255,0,255}));
  connect(enaPum.yDevSta, yConWatIsoVal) annotation (Line(points={{-59,160},{180,
          160},{180,90},{250,90}}, color={255,0,255}));
  connect(uChi, enaChiWatIso.uDevSta) annotation (Line(points={{-240,390},{-200,
          390},{-200,-110},{-142,-110}}, color={255,0,255}));
  connect(truDel1.y, enaChiWatIso.uEnaNex) annotation (Line(points={{-19,90},{0,
          90},{0,40},{-160,40},{-160,-118},{-142,-118}}, color={255,0,255}));
  connect(enaPum.yDevSta, logSwi7.u2) annotation (Line(points={{-59,160},{-40,160},
          {-40,120},{-140,120},{-140,90},{-122,90}}, color={255,0,255}));
  connect(uChi, and2.u2) annotation (Line(points={{-240,390},{-200,390},{-200,-148},
          {-62,-148}}, color={255,0,255}));
  connect(enaChiWatIso.yDevSta, and2.u1) annotation (Line(points={{-119,-110},{-80,
          -110},{-80,-140},{-62,-140}},  color={255,0,255}));
  connect(and2.y, not2.u)
    annotation (Line(points={{-39,-140},{-22,-140}}, color={255,0,255}));
  connect(enaChiWatIso.yDevSta, and1.u1) annotation (Line(points={{-119,-110},{0,
          -110},{0,-70},{38,-70}},   color={255,0,255}));
  connect(not2.y, and1.u2) annotation (Line(points={{1,-140},{20,-140},{20,-78},
          {38,-78}}, color={255,0,255}));
  connect(truDel1.y, tim1.u) annotation (Line(points={{-19,90},{0,90},{0,40},{-160,
          40},{-160,-30},{-142,-30}}, color={255,0,255}));
  connect(con6.y, lin1.f1) annotation (Line(points={{-119,10},{-80,10},{-80,-26},
          {-2,-26}},  color={0,0,127}));
  connect(con9.y, lin1.x1) annotation (Line(points={{-39,10},{-20,10},{-20,-22},
          {-2,-22}},  color={0,0,127}));
  connect(con7.y, lin1.x2) annotation (Line(points={{-119,-70},{-80,-70},{-80,-34},
          {-2,-34}},       color={0,0,127}));
  connect(con8.y, lin1.f2) annotation (Line(points={{-39,-70},{-20,-70},{-20,-38},
          {-2,-38}},  color={0,0,127}));
  connect(tim1.y, lin1.u)
    annotation (Line(points={{-119,-30},{-2,-30}},  color={0,0,127}));
  connect(con10.y, swi3.u3) annotation (Line(points={{61,-200},{80,-200},{80,-188},
          {98,-188}}, color={0,0,127}));
  connect(con11.y, swi3.u1) annotation (Line(points={{61,-160},{80,-160},{80,-172},
          {98,-172}}, color={0,0,127}));
  connect(uChi, swi3.u2) annotation (Line(points={{-240,390},{-200,390},{-200,-180},
          {98,-180}}, color={255,0,255}));
  connect(lin1.y, reaRep.u) annotation (Line(points={{21,-30},{38,-30}},
                 color={0,0,127}));
  connect(reaRep.y, swi2.u1) annotation (Line(points={{61,-30},{80,-30},{80,-42},
          {118,-42}},color={0,0,127}));
  connect(and1.y, swi2.u2) annotation (Line(points={{61,-70},{80,-70},{80,-50},{
          118,-50}},color={255,0,255}));
  connect(con5.y, swi2.u3) annotation (Line(points={{61,-110},{100,-110},{100,-58},
          {118,-58}},color={0,0,127}));
  connect(swi3.y, add2.u2) annotation (Line(points={{121,-180},{160,-180},{160,-116},
          {178,-116}}, color={0,0,127}));
  connect(swi2.y, add2.u1) annotation (Line(points={{141,-50},{160,-50},{160,-104},
          {178,-104}}, color={0,0,127}));
  connect(add2.y, yChiWatIsoValSet)
    annotation (Line(points={{201,-110},{250,-110}}, color={0,0,127}));
  connect(uChiWatIsoVal, hys3.u)
    annotation (Line(points={{-240,-300},{-182,-300}}, color={0,0,127}));
  connect(uChiWatIsoVal, hys4.u) annotation (Line(points={{-240,-300},{-200,
          -300},{-200,-360},{-182,-360}},
                                    color={0,0,127}));
  connect(hys3.y, and3.u1)
    annotation (Line(points={{-159,-300},{-62,-300}}, color={255,0,255}));
  connect(hys4.y, and3.u2) annotation (Line(points={{-159,-360},{-140,-360},{
          -140,-308},{-62,-308}},
                             color={255,0,255}));
  connect(hys3.y, not3.u) annotation (Line(points={{-159,-300},{-130,-300},{
          -130,-330},{-122,-330}},
                              color={255,0,255}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-159,-360},{-122,-360}}, color={255,0,255}));
  connect(not3.y, and4.u1) annotation (Line(points={{-99,-330},{-80,-330},{-80,
          -340},{-62,-340}},
                       color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-99,-360},{-79.5,-360},{
          -79.5,-348},{-62,-348}},
                             color={255,0,255}));
  connect(and3.y, or2.u1) annotation (Line(points={{-39,-300},{-20,-300},{-20,
          -320},{-2,-320}},
                      color={255,0,255}));
  connect(and4.y, or2.u2) annotation (Line(points={{-39,-340},{-20,-340},{-20,
          -328},{-2,-328}},
                      color={255,0,255}));
  connect(tim1.y, gre.u1) annotation (Line(points={{-119,-30},{-100,-30},{-100,
          -240},{38,-240}},
                      color={0,0,127}));
  connect(con12.y, gre.u2) annotation (Line(points={{-39,-260},{-20,-260},{-20,
          -248},{38,-248}},
                      color={0,0,127}));
  connect(or2.y, mulAnd1.u) annotation (Line(points={{21,-320},{38,-320}},
                                color={255,0,255}));
  connect(gre.y, and5.u1) annotation (Line(points={{61,-240},{80,-240},{80,-310},
          {98,-310}}, color={255,0,255}));
  connect(mulAnd1.y, and5.u2) annotation (Line(points={{61.7,-320},{80,-320},{
          80,-318},{98,-318}}, color={255,0,255}));
annotation (
  defaultComponentName = "towFan",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-220,-500},{240,500}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,88},{-36,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPum"),
        Text(
          extent={{-104,48},{-64,36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="LIFT"),
        Text(
          extent={{-96,14},{-38,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSup"),
        Text(
          extent={{-96,-26},{-42,-48}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TConWatRet"),
        Text(
          extent={{-98,-70},{-48,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uFanSpe"),
        Text(
          extent={{68,58},{102,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFan"),
        Text(
          extent={{56,-42},{96,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFanSpe")}),
Documentation(info="<html>
<p>
Block that output cooling tower fan status <code>yFan</code> and speed 
<code>yFanSpe</code> according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.11.
</p>
<p>
a. Fans are controlled off of CW return temperature (leaving chiller) 
<code>TConWatRet</code>.
</p>
<p>
b. Tower fans are enabled when any CW pump is proven on and <code>TConWatRet</code>
rises above setpoint by 1 &deg;F (0.55  &deg;C).
</p>
<p>
c. If <code>TConWatRet</code> drops below setpoint and fans have been at minimum
speed <code>minFanSpe</code> for 5 minuntes (<code>tMinFanSpe</code>), fans
shall cycle off for at least 3 minutes (<code>tFanOffMin</code>) and until 
<code>TConWatRet</code> rises above setpoint by 1 &deg;F (0.55  &deg;C).
</p>
<p>
d. Condenser water return temperature setpoint shall be sum of <code>TChiWatSup</code>
and <code>dTRef</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 05, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStageUp;
