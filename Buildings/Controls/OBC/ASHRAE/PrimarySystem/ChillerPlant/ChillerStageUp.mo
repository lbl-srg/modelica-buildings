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
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chillers status" annotation (Placement(transformation(extent={{-220,50},{-180,
            90}}),       iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[num](
    final unit="1",
    final min=0,
    final max=1) "Condense water isolation valve position" annotation (
      Placement(transformation(extent={{-220,-230},{-180,-190}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[num]
    "Condenser water pump status" annotation (Placement(transformation(extent={{
            180,-150},{200,-130}}), iconTransformation(extent={{100,40},{120,60}})));

  CDL.Interfaces.RealInput uChiWatIsoval(
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position" annotation (Placement(
        transformation(extent={{-220,-270},{-180,-230}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.BooleanInput uConWatPum[num] "Condenser water pump status"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Discrete.TriggeredSampler triSam[num]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Routing.BooleanReplicator                        booRep1(final nout=num)
                    "Replicate input "
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  CDL.Interfaces.RealOutput yChiCur[num](final quantity="ElectricCurrent",
      final unit="A") "Current to chillers" annotation (Placement(transformation(
          extent={{180,90},{200,110}}), iconTransformation(extent={{100,-60},{120,
            -40}})));
  CDL.Continuous.Gain gai[num](k=0.5) "Half of current load"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  CDL.Continuous.Hysteresis hys[num](uLow=0.54, uHigh=0.56)
    "Check if actual demand is more than 0.55 of demand at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Continuous.Division div[num]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  CDL.Continuous.Sources.Constant con[num](k=0.2)
    "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  CDL.Logical.Switch swi[num]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  CDL.Logical.TrueDelay truDel "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  CDL.Logical.MultiAnd mulAnd(nu=2)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  CDL.Interfaces.IntegerInput uChiSta "Current chiller stage" annotation (
      Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-254,-38},{-214,2}})));
  CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  CDL.Routing.RealExtractor curMinSet
    "Targeted minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Continuous.Sources.Constant con1[num](k=minFloSet)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  CDL.Integers.Add addInt(k2=-1) "One stage lower than current one"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  CDL.Integers.Sources.Constant conInt(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  CDL.Routing.RealExtractor oldMinSet "Minimum flow setpoint at old stage"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Line lin "Minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  CDL.Continuous.Sources.Constant con2(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  CDL.Continuous.Sources.Constant con3(k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  CDL.Logical.Timer tim "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  CDL.Interfaces.RealOutput yMinFloSet(
    final unit="m3/s") "Minimum flow setpoint" annotation (Placement(
        transformation(extent={{180,-70},{200,-50}}), iconTransformation(extent=
           {{100,-60},{120,-40}})));
  CDL.Continuous.Hysteresis hys2(uLow=byPassSetTim - 60 - 5, uHigh=byPassSetTim -
        60 + 5) "Check if it is 1 minute after new setpoint achieved"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Integers.LessThreshold intLesThr(threshold=1) "Check if it is zero stage"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  CDL.Logical.Switch swi1 "Switch to current stage setpoint"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  CDL.Continuous.Sources.Constant con4(k=0)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  CDL.Continuous.Sources.Constant con5[num](k=1)
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  CDL.Continuous.Sources.Constant con6[num](k=0)
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));
  CDL.Logical.Switch swi3[num]
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  CDL.Continuous.MultiSum mulSum(nin=2)
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Logical.Sources.Constant con7(k=true)
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
equation

  connect(uChiCur, triSam.u)
    annotation (Line(points={{-200,110},{-142,110}},
                                                   color={0,0,127}));
  connect(booRep1.y, triSam.trigger) annotation (Line(points={{-79,150},{-60,150},
          {-60,130},{-154,130},{-154,92},{-130,92},{-130,98.2}},
                                                               color={255,0,255}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-119,110},{98,110}},  color={0,0,127}));
  connect(gai.y, yChiCur) annotation (Line(points={{121,110},{140,110},{140,100},
          {190,100}}, color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-200,70},{-82,70}},  color={255,0,255}));
  connect(con.y, swi.u3) annotation (Line(points={{-119,40},{-100,40},{-100,62},
          {-82,62}},  color={0,0,127}));
  connect(uChiCur, div.u1) annotation (Line(points={{-200,110},{-160,110},{-160,
          86},{38,86}},                    color={0,0,127}));
  connect(swi.y, div.u2) annotation (Line(points={{-59,70},{20,70},{20,74},{38,74}},
                color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-19,40},{-2,40}},
                                              color={255,0,255}));
  connect(not1.y, mulAnd.u) annotation (Line(points={{21,40},{38,40}},
                      color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{61.7,40},{78,40}}, color={255,0,255}));
  connect(uChiSta, cha.u)
    annotation (Line(points={{-200,150},{-162,150}}, color={255,127,0}));
  connect(cha.up, booRep1.u) annotation (Line(points={{-139,156},{-120,156},{-120,
          150},{-102,150}}, color={255,0,255}));
  connect(con1.y,curMinSet. u)
    annotation (Line(points={{-119,-20},{-82,-20}}, color={0,0,127}));
  connect(uChiSta, addInt.u1) annotation (Line(points={{-200,150},{-170,150},{-170,
          -40},{-150,-40},{-150,-84},{-142,-84}}, color={255,127,0}));
  connect(conInt.y, addInt.u2) annotation (Line(points={{-159,-90},{-150,-90},{-150,
          -96},{-142,-96}}, color={255,127,0}));
  connect(con1.y, oldMinSet.u) annotation (Line(points={{-119,-20},{-100,-20},{-100,
          -70},{-82,-70}}, color={0,0,127}));
  connect(uChiSta,curMinSet. index) annotation (Line(points={{-200,150},{-170,150},
          {-170,-40},{-70,-40},{-70,-32}}, color={255,127,0}));
  connect(div.y, hys.u) annotation (Line(points={{61,80},{80,80},{80,60},{-50,60},
          {-50,40},{-42,40}}, color={0,0,127}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-119,110},{-100,110},{-100,
          78},{-82,78}}, color={0,0,127}));
  connect(con2.y, lin.x1) annotation (Line(points={{-19,-20},{-12,-20},{-12,-62},
          {-2,-62}},color={0,0,127}));
  connect(con3.y, lin.x2) annotation (Line(points={{-19,-90},{-12,-90},{-12,-74},
          {-2,-74}}, color={0,0,127}));
  connect(truDel.y, tim.u) annotation (Line(points={{101,40},{120,40},{120,20},{
          -10,20},{-10,-20},{-2,-20}}, color={255,0,255}));
  connect(tim.y, lin.u) annotation (Line(points={{21,-20},{40,-20},{40,-42},{-8,
          -42},{-8,-70},{-2,-70}},
                             color={0,0,127}));
  connect(oldMinSet.y, lin.f1) annotation (Line(points={{-59,-70},{-12,-70},{-12,
          -66},{-2,-66}}, color={0,0,127}));
  connect(tim.y, hys2.u) annotation (Line(points={{21,-20},{40,-20},{40,-90},{78,
          -90}}, color={0,0,127}));
  connect(addInt.y, oldMinSet.index) annotation (Line(points={{-119,-90},{-70,-90},
          {-70,-82}},                      color={255,127,0}));
  connect(uChiSta, intLesThr.u) annotation (Line(points={{-200,150},{-170,150},{
          -170,0},{50,0},{50,-50},{58,-50}}, color={255,127,0}));
  connect(con4.y, swi1.u1) annotation (Line(points={{81,-20},{110,-20},{110,-52},
          {118,-52}}, color={0,0,127}));
  connect(intLesThr.y, swi1.u2) annotation (Line(points={{81,-50},{100,-50},{100,
          -60},{118,-60}}, color={255,0,255}));
  connect(lin.y, swi1.u3) annotation (Line(points={{21,-70},{100,-70},{100,-68},
          {118,-68}}, color={0,0,127}));
  connect(swi1.y, yMinFloSet)
    annotation (Line(points={{141,-60},{190,-60}}, color={0,0,127}));
  connect(curMinSet.y, lin.f2) annotation (Line(points={{-59,-20},{-50,-20},{-50,
          -60},{-16,-60},{-16,-78},{-2,-78}}, color={0,0,127}));
  connect(con5.y, swi3.u1) annotation (Line(points={{-139,-130},{-120,-130},{-120,
          -142},{-102,-142}}, color={0,0,127}));
  connect(con6.y, swi3.u3) annotation (Line(points={{-139,-170},{-120,-170},{-120,
          -158},{-102,-158}}, color={0,0,127}));
  connect(uConWatPum, swi3.u2)
    annotation (Line(points={{-200,-150},{-102,-150}}, color={255,0,255}));
  connect(swi3.y, mulSum.u) annotation (Line(points={{-79,-150},{-70,-150},{-70,
          -150},{-62,-150}},          color={0,0,127}));
annotation (
  defaultComponentName = "towFan",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-260},{180,200}})),
    Icon(coordinateSystem(extent={{-180,-260},{180,200}}),
         graphics={
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
