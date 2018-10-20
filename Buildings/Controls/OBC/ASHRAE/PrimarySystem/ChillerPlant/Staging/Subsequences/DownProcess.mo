within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block DownProcess
  "Sequences to control equipments when chiller stage down"
  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";
  parameter Modelica.SIunits.ElectricCurrent lowChiCur = 0.05
    "Low limit to check if the chiller is running";
  parameter Modelica.SIunits.Time turOffChiWatIsoTim = 300
    "Time to close chilled water isolation valve";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to change minimum flow setpoint from old one to new one";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[num] = {0.0089, 0.0177}
    "Minimum flow rate at each chiller stage";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-260,360},{-220,400}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](
    final quantity="ElectricCurrent",
    final unit="A") "Chiller demand measured by electric current"
    annotation (Placement(transformation(extent={{-260,250},{-220,290}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num] "Chiller status"
     annotation (Placement(transformation(extent={{-260,310},{-220,350}}),
       iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[num]
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-260,-230},{-220,-190}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Condense water isolation valve position"
    annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[num](
    final unit="1",
    final min=0,
    final max=1) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-260,-290},{-220,-250}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal[num]
    "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{240,-90},{260,-70}}),
      iconTransformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoValSet[num](
    final min=0,
    final max=1,
    final unit="1") "Chilled water isolvation valve position setpoint"
    annotation (Placement(transformation(extent={{240,80},{260,100}}),
      iconTransformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinFloSet(
    final unit="m3/s") "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{240,-390},{260,-370}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check chiller stage change status"
    annotation (Placement(transformation(extent={{-160,370},{-140,390}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[num]
    "Chiller status"
    annotation (Placement(transformation(extent={{240,320},{260,340}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[num](
    final uLow=lowChiCur,
    final uHigh=lowChiCur + 0.2)
    "Check if the chiller current becomes zero"
    annotation (Placement(transformation(extent={{-160,260},{-140,280}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,290},{-60,310}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,260},{-60,280}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[num] "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[num](
    each final uLow=0.05,
    each final uHigh=0.1)
    "Check if isolation valve is not closed"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[num] "Logical switch"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=num)
    "Replicate real input"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[num] "Logical switch"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[num] "Add inputs"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{100,290},{120,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatIsoValSta[num]
    "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[num]
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2[num](
    final uLow=0.05, final uHigh=0.1)
    "Check if isolation valve is not closed"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[num]
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curMinSet(final nin=num)
    "Targeted minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-100,-350},{-80,-330}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor oldMinSet(
    final nin=num)
    "Minimum flow setpoint at old stage"
    annotation (Placement(transformation(extent={{-100,-400},{-80,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{0,-400},{20,-380}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after fully closed CW isolation valve"
    annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
    final threshold=1)
    "Check if it is zero stage"
    annotation (Placement(transformation(extent={{60,-380},{80,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch to current stage setpoint"
    annotation (Placement(transformation(extent={{120,-390},{140,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[num](uLow=0.05, uHigh=0.1)
    "Check if isolation valve is not closed"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7[num]
    "Convert boolean intput to integer"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[num]
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-20,-270},{0,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "One stage lower than current one"
    annotation (Placement(transformation(extent={{-140,-420},{-120,-400}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-180,-420},{-160,-400}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=turOffChiWatIsoTim)
    "Total time to turn off chiller water isolation valve"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0) "Consant 0"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4[num](
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5[num](
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6[num](
    final k=minFloSet)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-160,-350},{-140,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,-350},{-40,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-60,-420},{-40,-400}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
    "Zero minimal flow setpoint when it is zero stage"
    annotation (Placement(transformation(extent={{60,-350},{80,-330}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if chilled water isolation valve has been disabled"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Check if chilled water isolation valve has been disabled"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Check if chilled water isolation valve has been disabled"
    annotation (Placement(transformation(extent={{100,-270},{120,-250}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nu=num)
    "Check if the disabled chiller has been really disabled"
    annotation (Placement(transformation(extent={{20,290},{40,310}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nu=num)
    "Check if the disabled chiller has been really disabled"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(final nu=num)
    "Check if the disabled isolation valve has been really disabled"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd3(final nu=num)
    "Check if the disabled chiller has been really disabled"
    annotation (Placement(transformation(extent={{20,-270},{40,-250}})));

equation
  connect(uChiSta, cha.u)
    annotation (Line(points={{-240,380},{-162,380}}, color={255,127,0}));
  connect(uChi, disLat.uDevSta)
    annotation (Line(points={{-240,330},{-142,330}}, color={255,0,255}));
  connect(cha.down, disLat.uDis)
    annotation (Line(points={{-139,374},{-120,374},{-120,360},{-200,360},
      {-200,322},{-142,322}}, color={255,0,255}));
  connect(disLat.yDevSta, yChi)
    annotation (Line(points={{-119,330},{250,330}}, color={255,0,255}));
  connect(uChiCur, hys.u)
    annotation (Line(points={{-240,270},{-162,270}}, color={0,0,127}));
  connect(disLat.yDevSta, booToInt.u)
    annotation (Line(points={{-119,330},{-100,330},{-100,300},{-82,300}},
      color={255,0,255}));
  connect(hys.y, booToInt1.u)
    annotation (Line(points={{-139,270},{-82,270}},  color={255,0,255}));
  connect(booToInt1.y, intEqu.u2)
    annotation (Line(points={{-59,270},{-40,270},{-40,292},{-22,292}},
      color={255,127,0}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{-59,300},{-22,300}}, color={255,127,0}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{1,300},{18,300}}, color={255,0,255}));
  connect(con.y, lin1.x1)
    annotation (Line(points={{-79,220},{-60,220},{-60,188},{-42,188}},
      color={0,0,127}));
  connect(con1.y, lin1.f1)
    annotation (Line(points={{-139,220},{-120,220},{-120,184},{-42,184}},
      color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-139,180},{-42,180}}, color={0,0,127}));
  connect(con2.y, lin1.x2)
    annotation (Line(points={{-139,140},{-120,140},{-120,176},{-42,176}},
      color={0,0,127}));
  connect(con3.y, lin1.f2)
    annotation (Line(points={{-79,140},{-60,140},{-60,172},{-42,172}},
      color={0,0,127}));
  connect(uChiWatIsoVal, hys1.u)
    annotation (Line(points={{-240,70},{-182,70}}, color={0,0,127}));
  connect(hys1.y, disLat2.uDevSta)
    annotation (Line(points={{-159,70},{-152,70},{-152,100},{-142,100}},
      color={255,0,255}));
  connect(lin1.y, reaRep.u)
    annotation (Line(points={{-19,180},{18,180}}, color={0,0,127}));
  connect(disLat2.yDevSta, swi1.u2)
    annotation (Line(points={{-119,100},{-100,100},{-100,40},{78,40}},
      color={255,0,255}));
  connect(uChiWatIsoVal, swi1.u1)
    annotation (Line(points={{-240,70},{-196,70},{-196,48},{78,48}},
      color={0,0,127}));
  connect(con5.y, swi1.u3)
    annotation (Line(points={{41,20},{60,20},{60,32},{78,32}},
      color={0,0,127}));
  connect(swi1.y, add2.u2)
    annotation (Line(points={{101,40},{120,40},{120,84},{138,84}},
      color={0,0,127}));
  connect(swi.y, add2.u1)
    annotation (Line(points={{101,120},{120,120},{120,96},{138,96}},
      color={0,0,127}));
  connect(add2.y, yChiWatIsoValSet)
    annotation (Line(points={{161,90},{250,90}},   color={0,0,127}));
  connect(cha.down, and5.u1)
    annotation (Line(points={{-139,374},{80,374},{80,300},{98,300}},
      color={255,0,255}));
  connect(mulAnd.y, and5.u2)
    annotation (Line(points={{41.7,300},{60,300},{60,292},{98,292}},
      color={255,0,255}));
  connect(and5.y, tim.u)
    annotation (Line(points={{121,300},{180,300},{180,250},{-180,250},
      {-180,180},{-162,180}},color={255,0,255}));
  connect(and5.y, disLat2.uDis)
    annotation (Line(points={{121,300},{180,300},{180,250},{-180,250},
      {-180,92},{-142,92}}, color={255,0,255}));
  connect(disLat2.yDevSta, booToInt3.u)
    annotation (Line(points={{-119,100},{-82,100}}, color={255,0,255}));
  connect(hys1.y, booToInt2.u)
    annotation (Line(points={{-159,70},{-82,70}}, color={255,0,255}));
  connect(booToInt3.y, intEqu1.u1)
    annotation (Line(points={{-59,100},{-22,100}}, color={255,127,0}));
  connect(booToInt2.y, intEqu1.u2)
    annotation (Line(points={{-59,70},{-40,70},{-40,92},{-22,92}},
      color={255,127,0}));
  connect(intEqu1.y, mulAnd1.u)
    annotation (Line(points={{1,100},{10,100},{10,-20},{18,-20}},
      color={255,0,255}));
  connect(mulAnd1.y, and3.u2)
    annotation (Line(points={{41.7,-20},{60,-20},{60,-28},{98,-28}},
      color={255,0,255}));
  connect(and5.y, and3.u1)
    annotation (Line(points={{121,300},{180,300},{180,0},{80,0},{80,-20},
      {98,-20}},color={255,0,255}));
  connect(uConWatIsoValSta, disLat3.uDevSta)
    annotation (Line(points={{-240,-80},{-142,-80}}, color={255,0,255}));
  connect(and3.y, disLat3.uDis)
    annotation (Line(points={{121,-20},{140,-20},{140,-52},{-160,-52},
      {-160,-88},{-142,-88}}, color={255,0,255}));
  connect(disLat3.yDevSta, yConWatIsoVal)
    annotation (Line(points={{-119,-80},{250,-80}}, color={255,0,255}));
  connect(uConWatIsoVal, hys2.u)
    annotation (Line(points={{-240,-140},{-182,-140}}, color={0,0,127}));
  connect(disLat3.yDevSta, booToInt4.u)
    annotation (Line(points={{-119,-80},{-100,-80},{-100,-110},{-82,-110}},
      color={255,0,255}));
  connect(hys2.y, booToInt5.u)
    annotation (Line(points={{-159,-140},{-82,-140}}, color={255,0,255}));
  connect(booToInt4.y, intEqu2.u1)
    annotation (Line(points={{-59,-110},{-40,-110},{-40,-130},{-22,-130}},
      color={255,127,0}));
  connect(booToInt5.y, intEqu2.u2)
    annotation (Line(points={{-59,-140},{-40,-140},{-40,-138},{-22,-138}},
      color={255,127,0}));
  connect(intEqu2.y, mulAnd2.u)
    annotation (Line(points={{1,-130},{18,-130}}, color={255,0,255}));
  connect(uConWatPum, disLat4.uDevSta)
    annotation (Line(points={{-240,-210},{-142,-210}}, color={255,0,255}));
  connect(and3.y, and4.u1)
    annotation (Line(points={{121,-20},{140,-20},{140,-100},{80,-100},
      {80,-130},{98,-130}}, color={255,0,255}));
  connect(mulAnd2.y, and4.u2)
    annotation (Line(points={{41.7,-130},{60,-130},{60,-138},{98,-138}},
      color={255,0,255}));
  connect(and4.y, disLat4.uDis)
    annotation (Line(points={{121,-130},{140,-130},{140,-160},{-160,-160},
      {-160,-218},{-142,-218}}, color={255,0,255}));
  connect(disLat4.yDevSta, yConWatPum)
    annotation (Line(points={{-119,-210},{250,-210}}, color={255,0,255}));
  connect(con6.y,curMinSet. u)
    annotation (Line(points={{-139,-340},{-102,-340}}, color={0,0,127}));
  connect(conInt.y,addInt. u2)
    annotation (Line(points={{-159,-410},{-150,-410},{-150,-416},{-142,-416}},
      color={255,127,0}));
  connect(con6.y,oldMinSet. u)
    annotation (Line(points={{-139,-340},{-120,-340},{-120,-390},{-102,-390}},
      color={0,0,127}));
  connect(con7.y,lin. x1)
    annotation (Line(points={{-39,-340},{-26,-340},{-26,-382},{-2,-382}},
      color={0,0,127}));
  connect(con8.y,lin. x2)
    annotation (Line(points={{-39,-410},{-20,-410},{-20,-394},{-2,-394}},
      color={0,0,127}));
  connect(tim1.y, lin.u)
    annotation (Line(points={{21,-340},{40,-340},{40,-360},{-20,-360},
      {-20,-390},{-2,-390}}, color={0,0,127}));
  connect(oldMinSet.y,lin. f1)
    annotation (Line(points={{-79,-390},{-26,-390},{-26,-386},{-2,-386}},
      color={0,0,127}));
  connect(addInt.y,oldMinSet. index)
    annotation (Line(points={{-119,-410},{-90,-410},{-90,-402}},
      color={255,127,0}));
  connect(con9.y,swi2. u1)
    annotation (Line(points={{81,-340},{110,-340},{110,-372},{118,-372}},
      color={0,0,127}));
  connect(intLesThr.y,swi2. u2)
    annotation (Line(points={{81,-370},{100,-370},{100,-380},{118,-380}},
      color={255,0,255}));
  connect(lin.y,swi2. u3)
    annotation (Line(points={{21,-390},{100,-390},{100,-388},{118,-388}},
      color={0,0,127}));
  connect(swi2.y,yMinFloSet)
    annotation (Line(points={{141,-380},{250,-380}}, color={0,0,127}));
  connect(curMinSet.y,lin. f2)
    annotation (Line(points={{-79,-340},{-70,-340},{-70,-380},{-32,-380},
      {-32,-398},{-2,-398}}, color={0,0,127}));
  connect(uConWatPumSpe, hys4.u)
    annotation (Line(points={{-240,-270},{-182,-270}}, color={0,0,127}));
  connect(hys4.y, booToInt7.u)
    annotation (Line(points={{-159,-270},{-82,-270}}, color={255,0,255}));
  connect(disLat4.yDevSta, booToInt6.u)
    annotation (Line(points={{-119,-210},{-100,-210},{-100,-240},{-82,-240}},
      color={255,0,255}));
  connect(booToInt6.y, intEqu3.u1)
    annotation (Line(points={{-59,-240},{-40,-240}, {-40,-260},{-22,-260}},
      color={255,127,0}));
  connect(booToInt7.y, intEqu3.u2)
    annotation (Line(points={{-59,-270},{-40,-270},{-40,-268},{-22,-268}},
      color={255,127,0}));
  connect(intEqu3.y, mulAnd3.u)
    annotation (Line(points={{1,-260},{18,-260}}, color={255,0,255}));
  connect(mulAnd3.y, and6.u2)
    annotation (Line(points={{41.7,-260},{60,-260},{60,-268},{98,-268}},
      color={255,0,255}));
  connect(and4.y, and6.u1)
    annotation (Line(points={{121,-130},{140,-130},{140,-160},{80,-160},
      {80,-260},{98,-260}}, color={255,0,255}));
  connect(and6.y, tim1.u)
    annotation (Line(points={{121,-260},{140,-260},{140,-300},{-20,-300},
      {-20,-340},{-2,-340}}, color={255,0,255}));
  connect(uChiSta, addInt.u1)
    annotation (Line(points={{-240,380},{-204,380},{-204,-360},{-152,-360},
      {-152,-404},{-142,-404}}, color={255,127,0}));
  connect(uChiSta, curMinSet.index)
    annotation (Line(points={{-240,380},{-204,380},{-204,-360},{-90,-360},
      {-90,-352}}, color={255,127,0}));
  connect(uChiSta, intLesThr.u)
    annotation (Line(points={{-240,380},{-204,380},{-204,-320},{50,-320},
      {50,-370},{58,-370}}, color={255,127,0}));
  connect(intEqu1.y, swi.u2)
    annotation (Line(points={{1,100},{20,100},{20,120},{78,120}}, color={255,0,255}));
  connect(con4.y, swi.u1)
    annotation (Line(points={{41,80},{52,80},{52,128},{78,128}}, color={0,0,127}));
  connect(reaRep.y, swi.u3)
    annotation (Line(points={{41,180},{60,180},{60,112},{78,112}}, color={0,0,127}));

annotation (
  defaultComponentName = "staDow",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-220,-440},{240,440}}), graphics={
                                             Rectangle(
          extent={{-218,-322},{238,-418}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{84,-322},{232,-360}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Slowly change minimum 
flow rate setpoint"),                        Rectangle(
          extent={{-218,-202},{238,-298}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{110,-214},{232,-250}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Shut off last stage condenser 
water pump"),                                Rectangle(
          extent={{-218,-62},{238,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{138,-100},{236,-128}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Dsiable CW isolation valve"),
                                             Rectangle(
          extent={{-218,238},{238,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{58,232},{222,186}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Close isolation valve
of the closed chiller"),                     Rectangle(
          extent={{-218,418},{238,262}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{110,414},{222,382}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Shut off last stage chiller")}),
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
          extent={{-96,66},{-74,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-96,-82},{-30,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpe"),
        Text(
          extent={{-96,48},{-66,36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiCur"),
        Text(
          extent={{-96,-12},{-28,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatIsoValSta"),
        Text(
          extent={{-96,18},{-34,8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{74,74},{102,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{-16,4.5},{16,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiSta",
          origin={-82,92.5},
          rotation=0),
        Text(
          extent={{44,-52},{96,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yConWatPum"),
        Text(
          extent={{40,-12},{98,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yConWatIsoVal"),
        Text(
          extent={{26,26},{96,12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoValSet"),
        Text(
          extent={{56,-84},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yMinFloSet"),
        Text(
          extent={{-96,-62},{-46,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPum"),
        Text(
          extent={{-96,-32},{-36,-42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatIsoVal")}),
Documentation(info="<html>
<p>
Block that generates signals to control devices when there is chiller plant 
stage-down command, according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.5.
</p>
<p>Whenever there is a stage-down command (<code>uChiSta</code> decrease):</p>
<p>
a. Shut off last stage chiller
</p>

<p>
b. When the controller of the chiller being shut off (<code>uChiCur</code> 
becoms less than <code>lowChiCur</code>) indicates no request for 
chilled water flow, slowly close the chiller's chilled water isolation valve
to avoid sudden change in flow through other operating chiller. For example, 
this could be accomplished by closing the valve in <code>turOffChiWatIsoTim</code>.
</p>

<p>
c. Disable condenser water isolation valve and when it is fully closed, shut
off last stage condenser water pump.
</p>

<p>
d. Change the minimum by pass controller setpoint to that appropriate for the
stage. For example, this could be accomplished by resetting the setpoint 
X GPM/second, where X = (NewSetpoint - OldSetpoint) / <code>byPasSetTim</code>. 
The minimum flow rate are as follows (based on manufactures' minimum flow rate 
plus 10% to ensure control variations
do not cause flow to go below actual minimum):
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
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

</html>",
revisions="<html>
<ul>
<li>
August 18, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DownProcess;
