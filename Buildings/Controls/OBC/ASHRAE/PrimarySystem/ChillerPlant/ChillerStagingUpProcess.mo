within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerStagingUpProcess
  "Sequences to control equipments when chiller stage up"
  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";
  parameter Modelica.SIunits.Time holChiDemTim
    "Time to hold limited chiller demand";
  parameter Modelica.SIunits.Time byPasSetTim
    "Time to change minimum flow setpoint from old one to new one";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[num]
    "Minimum flow rate at each chiller stage";
  parameter Modelica.SIunits.Time turOnChiWatIsoTim
    "Time to open a new chilled water isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-280,440},{-240,480}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](
    final quantity="ElectricCurrent",
    final unit="A") "Chiller demand measured by electric current"
    annotation (Placement(transformation(extent={{-280,380},{-240,420}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chiller status"
     annotation (Placement(transformation(extent={{-280,340},{-240,380}}),
       iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[num]
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Condense water isolation valve position"
    annotation (Placement(transformation(extent={{-280,30},{-240,70}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-280,-330},{-240,-290}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiCur[num](
    final quantity="ElectricCurrent",
    final unit="A") "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{220,410},{240,430}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinFloSet(
    final unit="m3/s") "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{220,210},{240,230}}),
      iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{220,110},{240,130}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal[num]
    "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{220,40},{240,60}}),
      iconTransformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoValSet[num](
    final min=0,
    final max=1,
    final unit="1") "Chilled water isolvation valve position setpoint"
    annotation (Placement(transformation(extent={{220,-160},{240,-140}}),
      iconTransformation(extent={{100,-30},{120,-10}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[num]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{-160,390},{-140,410}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=num) "Replicate input "
    annotation (Placement(transformation(extent={{-120,470},{-100,490}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[num](
    each final k=0.5) "Half of current load"
    annotation (Placement(transformation(extent={{-80,390},{-60,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[num](
    each final uLow=0.54,
    each final uHigh=0.56)
    "Check if actual demand is more than 0.55 of demand at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div[num]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{20,360},{40,380}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[num](
    each final k=0.2)
    "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-160,320},{-140,340}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[num]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-100,350},{-80,370}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=holChiDemTim) "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{80,320},{100,340}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=num)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{40,320},{60,340}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check chiller stage change status"
    annotation (Placement(transformation(extent={{-180,450},{-160,470}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curMinSet(nin=num)
    "Targeted minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-120,250},{-100,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[num](
    final k=minFloSet)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt(final k2=-1)
    "One stage lower than current one"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-200,180},{-180,200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor oldMinSet(final nin=num)
    "Minimum flow setpoint at old stage"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-20,250},{0,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=byPasSetTim + 60 - 5,
    final uHigh=byPasSetTim + 60 + 5)
    "Check if it is 1 minute after new setpoint achieved"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
    final threshold=1)
    "Check if it is zero stage"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch to current stage setpoint"
    annotation (Placement(transformation(extent={{100,210},{120,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(final k=0)
    "Zero minimal flow setpoint when it is zero stage"
    annotation (Placement(transformation(extent={{40,250},{60,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[num](
    each final uLow=0.095,
    each final uHigh=0.105)
    "Check if the enabled isolation valve is open more than 10%"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi7[num] "Logical switch"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[num](
    each final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd3(final nu=num)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(final delayTime=30)
    "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.EnableNext enaPum(
    final num=num) "Enable next pump"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.EnableNext enaChiWatIso(
    final num=num) "Enable next chilled water isolation valve"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[num]
    "Check change of the chilled water isolation valve vector"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[num] "Logical not"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[num]
    "Check change of the chilled water isolation valve vector"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after starting CW pump and enabling CW isolation valve"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=turOnChiWatIsoTim)
    "Time to turn on chilled water isolation valve"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[num]
    "Position setpoint of chilled water isolation valve"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con10[num](
    each final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con11[num](
    each k=1) "Constant 0"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[num]
    "Position setpoint of chilled water isolation valve"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5[num](
    each final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=num)
    "Replicate real input"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[num]
    "Chilled water isolation valve position setpoint vector"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3[num](
    each final uLow=0.025,
    each final uHigh=0.05)
    "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[num](
    each final uLow=0.925,
    each final uHigh=0.975)
    "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-180,-380},{-160,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[num] "Logical and"
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,-350},{-100,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,-380},{-100,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[num] "Logical and"
    annotation (Placement(transformation(extent={{-60,-360},{-40,-340}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[num] "Logicla or"
    annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    each final uLow=turOnChiWatIsoTim - 5,
    each final uHigh=turOnChiWatIsoTim + 5)
    "Check if it has past the target time of open CHW isolation valve "
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(nu=num)
    annotation (Placement(transformation(extent={{42,-340},{62,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{102,-320},{122,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[num]
    "Chiller status"
    annotation (Placement(transformation(extent={{220,-450},{240,-430}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.EnableNext enaChi(
    num=num) "Enable next chiller"
    annotation (Placement(transformation(extent={{-100,-450},{-80,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[num]
    "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{180,410},{200,430}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{-60,450},{-40,470}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if it is before stage change or all other changes have been made"
    annotation (Placement(transformation(extent={{80,450},{100,470}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=num)
    "Replicate input "
    annotation (Placement(transformation(extent={{120,450},{140,470}})));

equation
  connect(uChiCur, triSam.u)
    annotation (Line(points={{-260,400},{-162,400}}, color={0,0,127}));
  connect(booRep1.y, triSam.trigger)
    annotation (Line(points={{-99,480},{-80,480},{-80,440},{-180,440},
      {-180,380},{-150,380},{-150,388.2}}, color={255,0,255}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-139,400},{-82,400}}, color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-260,360},{-102,360}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-139,330},{-120,330},{-120,352},{-102,352}},
      color={0,0,127}));
  connect(uChiCur, div.u1)
    annotation (Line(points={{-260,400},{-220,400},{-220,376},{18,376}},
      color={0,0,127}));
  connect(swi.y, div.u2)
    annotation (Line(points={{-79,360},{0,360},{0,364},{18,364}},
      color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-19,330},{-2,330}}, color={255,0,255}));
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{21,330},{38,330}}, color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{61.7,330},{78,330}}, color={255,0,255}));
  connect(uChiSta, cha.u)
    annotation (Line(points={{-260,460},{-182,460}}, color={255,127,0}));
  connect(cha.up, booRep1.u)
    annotation (Line(points={{-159,466},{-140,466},{-140,480},{-122,480}},
      color={255,0,255}));
  connect(con1.y,curMinSet. u)
    annotation (Line(points={{-159,260},{-122,260}},color={0,0,127}));
  connect(uChiSta, addInt.u1)
    annotation (Line(points={{-260,460},{-200,460},{-200,240},{-170,240},
      {-170,196},{-162,196}}, color={255,127,0}));
  connect(conInt.y, addInt.u2)
    annotation (Line(points={{-179,190},{-170,190},{-170,184},{-162,184}},
      color={255,127,0}));
  connect(con1.y, oldMinSet.u)
    annotation (Line(points={{-159,260},{-140,260},{-140,210},{-122,210}},
      color={0,0,127}));
  connect(uChiSta,curMinSet. index)
    annotation (Line(points={{-260,460},{-200,460},{-200,240},{-110,240},
      {-110,248}}, color={255,127,0}));
  connect(div.y, hys.u)
    annotation (Line(points={{41,370},{60,370},{60,352},{-60,352},{-60,330},
      {-42,330}}, color={0,0,127}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{-139,400},{-120,400},{-120,368},{-102,368}},
      color={0,0,127}));
  connect(con2.y, lin.x1)
    annotation (Line(points={{-59,260},{-46,260},{-46,218},{-22,218}},
      color={0,0,127}));
  connect(con3.y, lin.x2)
    annotation (Line(points={{-59,190},{-40,190},{-40,206},{-22,206}},
      color={0,0,127}));
  connect(truDel.y, tim.u)
    annotation (Line(points={{101,330},{120,330},{120,300},{-40,300},{-40,260},
      {-22,260}}, color={255,0,255}));
  connect(tim.y, lin.u)
    annotation (Line(points={{1,260},{20,260},{20,240},{-40,240},{-40,210},
      {-22,210}}, color={0,0,127}));
  connect(oldMinSet.y, lin.f1)
    annotation (Line(points={{-99,210},{-46,210},{-46,214},{-22,214}},
      color={0,0,127}));
  connect(tim.y, hys2.u)
    annotation (Line(points={{1,260},{20,260},{20,190},{58,190}},
      color={0,0,127}));
  connect(addInt.y, oldMinSet.index)
    annotation (Line(points={{-139,190},{-110,190},{-110,198}}, color={255,127,0}));
  connect(uChiSta, intLesThr.u)
    annotation (Line(points={{-260,460},{-200,460},{-200,280},{30,280},
      {30,230},{38,230}}, color={255,127,0}));
  connect(con4.y, swi1.u1)
    annotation (Line(points={{61,260},{90,260},{90,228},{98,228}}, color={0,0,127}));
  connect(intLesThr.y, swi1.u2)
    annotation (Line(points={{61,230},{80,230},{80,220},{98,220}}, color={255,0,255}));
  connect(lin.y, swi1.u3)
    annotation (Line(points={{1,210},{80,210},{80,212},{98,212}}, color={0,0,127}));
  connect(swi1.y, yMinFloSet)
    annotation (Line(points={{121,220},{230,220}}, color={0,0,127}));
  connect(curMinSet.y, lin.f2)
    annotation (Line(points={{-99,260},{-90,260},{-90,220},{-52,220},{-52,202},
      {-22,202}},color={0,0,127}));
  connect(uConWatIsoVal, hys1.u)
    annotation (Line(points={{-260,50},{-202,50}}, color={0,0,127}));
  connect(hys1.y, logSwi7.u1)
    annotation (Line(points={{-179,50},{-160,50},{-160,58},{-122,58}},
      color={255,0,255}));
  connect(con16.y, logSwi7.u3)
    annotation (Line(points={{-179,20},{-140,20},{-140,42},{-122,42}},
      color={255,0,255}));
  connect(logSwi7.y, mulAnd3.u)
    annotation (Line(points={{-99,50},{-62,50}}, color={255,0,255}));
  connect(mulAnd3.y, truDel1.u)
    annotation (Line(points={{-38.3,50},{-22,50}}, color={255,0,255}));
  connect(uConWatPum, enaPum.uDevSta)
    annotation (Line(points={{-260,120},{-102,120}}, color={255,0,255}));
  connect(hys2.y, enaPum.uEnaNex)
    annotation (Line(points={{81,190},{100,190},{100,160},{-120,160},{-120,112},
      {-102,112}}, color={255,0,255}));
  connect(enaPum.yDevSta, yConWatPum)
    annotation (Line(points={{-79,120},{230,120}}, color={255,0,255}));
  connect(enaPum.yDevSta, yConWatIsoVal)
    annotation (Line(points={{-79,120},{160,120},{160,50},{230,50}},
      color={255,0,255}));
  connect(uChi, enaChiWatIso.uDevSta)
    annotation (Line(points={{-260,360},{-220,360},{-220,-150},{-162,-150}},
      color={255,0,255}));
  connect(truDel1.y, enaChiWatIso.uEnaNex)
    annotation (Line(points={{1,50},{40,50},{40,0},{-180,0},{-180,-158},
      {-162,-158}}, color={255,0,255}));
  connect(enaPum.yDevSta, logSwi7.u2)
    annotation (Line(points={{-79,120},{-60,120},{-60,80},{-140,80},{-140,50},
      {-122,50}}, color={255,0,255}));
  connect(uChi, and2.u2)
    annotation (Line(points={{-260,360},{-220,360},{-220,-188},{-82,-188}},
      color={255,0,255}));
  connect(enaChiWatIso.yDevSta, and2.u1)
    annotation (Line(points={{-139,-150},{-100,-150},{-100,-180},{-82,-180}},
      color={255,0,255}));
  connect(and2.y, not2.u)
    annotation (Line(points={{-59,-180},{-42,-180}}, color={255,0,255}));
  connect(enaChiWatIso.yDevSta, and1.u1)
    annotation (Line(points={{-139,-150},{-20,-150},{-20,-110},{18,-110}},
      color={255,0,255}));
  connect(not2.y, and1.u2)
    annotation (Line(points={{-19,-180},{0,-180},{0,-118},{18,-118}},
      color={255,0,255}));
  connect(truDel1.y, tim1.u)
    annotation (Line(points={{1,50},{40,50},{40,0},{-180,0},{-180,-70},
      {-162,-70}}, color={255,0,255}));
  connect(con6.y, lin1.f1)
    annotation (Line(points={{-139,-30},{-100,-30},{-100,-66},{-22,-66}},
      color={0,0,127}));
  connect(con9.y, lin1.x1)
    annotation (Line(points={{-59,-30},{-40,-30},{-40,-62},{-22,-62}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-139,-110},{-100,-110},{-100,-74},{-22,-74}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{-59,-110},{-40,-110},{-40,-78},{-22,-78}},
      color={0,0,127}));
  connect(tim1.y, lin1.u)
    annotation (Line(points={{-139,-70},{-22,-70}}, color={0,0,127}));
  connect(con10.y, swi3.u3)
    annotation (Line(points={{41,-230},{60,-230},{60,-218},{78,-218}},
      color={0,0,127}));
  connect(con11.y, swi3.u1)
    annotation (Line(points={{41,-190},{60,-190},{60,-202},{78,-202}},
      color={0,0,127}));
  connect(uChi, swi3.u2)
    annotation (Line(points={{-260,360},{-220,360},{-220,-210},{78,-210}},
      color={255,0,255}));
  connect(lin1.y, reaRep.u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{41,-70},{60,-70},{60,-82},{98,-82}},
      color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{41,-110},{60,-110},{60,-90},{98,-90}},
      color={255,0,255}));
  connect(con5.y, swi2.u3)
    annotation (Line(points={{41,-150},{80,-150},{80,-98},{98,-98}},
      color={0,0,127}));
  connect(swi3.y, add2.u2)
    annotation (Line(points={{101,-210},{140,-210},{140,-156},{158,-156}},
      color={0,0,127}));
  connect(swi2.y, add2.u1)
    annotation (Line(points={{121,-90},{140,-90},{140,-144},{158,-144}},
      color={0,0,127}));
  connect(add2.y, yChiWatIsoValSet)
    annotation (Line(points={{181,-150},{230,-150}}, color={0,0,127}));
  connect(uChiWatIsoVal, hys3.u)
    annotation (Line(points={{-260,-310},{-182,-310}}, color={0,0,127}));
  connect(uChiWatIsoVal, hys4.u)
    annotation (Line(points={{-260,-310},{-200,-310},{-200,-370},{-182,-370}},
      color={0,0,127}));
  connect(hys3.y, and3.u1)
    annotation (Line(points={{-159,-310},{-62,-310}}, color={255,0,255}));
  connect(hys4.y, and3.u2)
    annotation (Line(points={{-159,-370},{-140,-370},{-140,-318},{-62,-318}},
      color={255,0,255}));
  connect(hys3.y, not3.u)
    annotation (Line(points={{-159,-310},{-130,-310},{-130,-340},{-122,-340}},
      color={255,0,255}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-159,-370},{-122,-370}}, color={255,0,255}));
  connect(not3.y, and4.u1)
    annotation (Line(points={{-99,-340},{-80,-340},{-80,-350},{-62,-350}},
      color={255,0,255}));
  connect(not4.y, and4.u2)
    annotation (Line(points={{-99,-370},{-79.5,-370},{-79.5,-358},{-62,-358}},
      color={255,0,255}));
  connect(and3.y, or2.u1)
    annotation (Line(points={{-39,-310},{-20,-310},{-20,-330},{-2,-330}},
      color={255,0,255}));
  connect(and4.y, or2.u2)
    annotation (Line(points={{-39,-350},{-20,-350},{-20,-338},{-2,-338}},
      color={255,0,255}));
  connect(or2.y, mulAnd1.u)
    annotation (Line(points={{21,-330},{40,-330}},  color={255,0,255}));
  connect(hys5.y, and5.u1)
    annotation (Line(points={{41,-270},{80,-270},{80,-310},{100,-310}},
      color={255,0,255}));
  connect(mulAnd1.y, and5.u2)
    annotation (Line(points={{63.7,-330},{80,-330},{80,-318},{100,-318}},
      color={255,0,255}));
  connect(uChi, enaChi.uDevSta)
    annotation (Line(points={{-260,360},{-220,360},{-220,-440},{-102,-440}},
      color={255,0,255}));
  connect(and5.y, enaChi.uEnaNex)
    annotation (Line(points={{123,-310},{140,-310},{140,-400},{-200,-400},
      {-200,-448},{-102,-448}},color={255,0,255}));
  connect(enaChi.yDevSta, yChi)
    annotation (Line(points={{-79,-440},{230,-440}}, color={255,0,255}));
  connect(cha.y, not5.u)
    annotation (Line(points={{-159,460},{-62,460}}, color={255,0,255}));
  connect(swi4.y, yChiCur)
    annotation (Line(points={{201,420},{230,420}}, color={0,0,127}));
  connect(not5.y, or1.u1)
    annotation (Line(points={{-39,460},{78,460}}, color={255,0,255}));
  connect(and5.y, or1.u2)
    annotation (Line(points={{123,-310},{136,-310},{136,440},{60,440},{60,452},
      {78,452}}, color={255,0,255}));
  connect(or1.y, booRep2.u)
    annotation (Line(points={{101,460},{118,460}}, color={255,0,255}));
  connect(booRep2.y, swi4.u2)
    annotation (Line(points={{141,460},{160,460},{160,420},{178,420}},
      color={255,0,255}));
  connect(gai.y, swi4.u3)
    annotation (Line(points={{-59,400},{60,400},{60,412},{178,412}},
      color={0,0,127}));
  connect(uChiCur, swi4.u1)
    annotation (Line(points={{-260,400},{-220,400},{-220,428},{178,428}},
      color={0,0,127}));
  connect(tim1.y, hys5.u)
    annotation (Line(points={{-139,-70},{-120,-70},{-120,-270},{18,-270}},
      color={0,0,127}));

annotation (
  defaultComponentName = "towFan",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-240,-480},{220,500}}), graphics={
                                             Rectangle(
          extent={{-238,498},{218,322}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,278},{218,182}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,158},{218,82}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,58},{218,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,-22},{218,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,-282},{218,-378}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-238,-402},{218,-458}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{38,500},{210,478}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if there is stage change, if it is stage up"),
          Text(
          extent={{66,412},{212,376}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Limit chiller demand to 0.5 of 
current load"),
          Text(
          extent={{-18,372},{214,334}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Ensure actual demand has been less than
0.55 by more than 5 minutes"),
          Text(
          extent={{64,278},{212,240}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Slowly change minimum 
flow rate setpoint"),
          Text(
          extent={{52,218},{210,180}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="After new setpoint is 
achieved, wait 1 minute"),
          Text(
          extent={{140,152},{212,140}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Start next CW pump"),
          Text(
          extent={{122,52},{212,30}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable CW isolation valve"),
          Text(
          extent={{-90,32},{212,4}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all the enabled CW isolation valves have
open more than 0.1, then wait 30 seconds"),
          Text(
          extent={{84,-34},{212,-68}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Slowly open next CHW 
isolation valve"),
          Text(
          extent={{-16,-340},{210,-372}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled CHW isolation valves 
have been fully open"),
          Text(
          extent={{154,-410},{214,-432}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Start next chiller")}),
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
          extent={{-102,86},{-76,78}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-96,-12},{-42,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPum"),
        Text(
          extent={{-96,48},{-66,36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiCur"),
        Text(
          extent={{-96,-46},{-32,-70}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatIsoVal"),
        Text(
          extent={{-96,-82},{-32,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{74,94},{102,84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{64,-54},{96,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiCur"),
        Text(
          extent={{-16,4.5},{16,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiSta",
          origin={-82,22.5},
          rotation=0),
        Text(
          extent={{44,68},{96,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yConWatPum"),
        Text(
          extent={{40,28},{98,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yConWatIsoVal"),
        Text(
          extent={{26,-14},{96,-28}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoValSet"),
        Text(
          extent={{56,-84},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yMinFloSet")}),
Documentation(info="<html>
<p>
Block that generates signals to control devices when there is chiller plant 
stage-up command, according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.4.
</p>
<p>Whenever there is a stage-up command (<code>uChiSta</code> increases):</p>
<p>
a. Command operating chillers (true elements in <code>uChi</code> vector) to 
reduce demand (currents) to 50% of their load (<code>uChiCur</code>). Wait until
actual demand becomes less than 55% up to a maximum of <code>holChiDemTim</code>
(e.g. 5 minutes) before proceeding.
</p>

<p>
b. Slowly change the minimum bypass controller setpoint <code>yMinFloSet</code> 
to that appropriate for the stage as indicated below. For example, this could 
be accomplished by resetting the setpoint X GPM/minute, where X = (NewSetpoint 
- OldSetpoint) / <code>byPasSetTim</code>. The minimum flow rate are as follows
(based on manufactures' minimum flow rate plus 10% to ensure control variations
do not cause flow to go below actual minimum):
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiiler stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>
<p>
After new setpoint is achieved wait 1 minute to allow loop to stabilize.
</p>

<p>
c. Start the next CW pump <code>uConWatPum</code> and enable the CW 
isolation/head pressure control valve <code>uConWatIsoVal</code>. Wait 30 seconds.
</p>

<p>
d. Slowly open CHW isolation valve of the chiller that is to be started,
e.g. change the open position setpoint <code>yChiWatIsoValSet</code>
to be nonzero. The purpose of slow-opening is to prevent sudden disruption to 
flow through active chillers. Valve timing <code>turOnChiWatIsoTim</code> to 
be determined in the field as that required to prevent nuisance trips.
</p>

<p>
e. Start the next stage chiller <code>uChi</code> after CHW isolation valve is fully open.
</p>

<p>
f. Release the demand limit <code>yChiCur</code>.
</p>

</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStagingUpProcess;
