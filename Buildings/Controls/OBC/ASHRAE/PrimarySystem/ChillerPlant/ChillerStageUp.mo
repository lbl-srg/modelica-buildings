within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerStageUp "Sequences to control equipments when chiller stage up"
  parameter Integer num = 2
    "Total number of CW pumps";
  parameter Modelica.SIunits.TemperatureDifference dTAboSet = 0.55
    "Threshold value of CWRT above its setpoint";
  parameter Real minFanSpe
    "Minimum fan speed";
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uByPasFlo(final quantity=
        "VolumeFlowRate", final unit="m3/s") "By pass flow rate" annotation (
      Placement(transformation(extent={{-220,-50},{-180,-10}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCur[num](final quantity="ElectricCurrent",
      final unit="A") "Current chiller demand measured by the current"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[num]
    "Chillers status" annotation (Placement(transformation(extent={{-220,40},{-180,
            80}}),       iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal(
    final unit="1",
    final min=0,
    final max=1) "Condense water isolation valve position" annotation (
      Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
     final unit="1",
     final min=0,
     final max=1) "Fan speed"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}}),
      iconTransformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan "Fan status"
    annotation (Placement(transformation(extent={{180,50},{200,70}}),
      iconTransformation(extent={{100,40},{120,60}})));

  CDL.Interfaces.IntegerInput uChiStaCha
    "Chiller stage chaging, 1: stage up; -1 stage down; 0: no change"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-254,-38},{-214,2}})));
  CDL.Interfaces.RealInput uChiWatIsoval(
    final unit="1",
    final min=0,
    final max=1) "Chilled water isolation valve position" annotation (Placement(
        transformation(extent={{-220,-180},{-180,-140}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.BooleanInput uConWatPum[num] "Condenser water pump status"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput uConWatPumSpe[num](
    final unit="1",
    final min=0,
    final max=1) "Condenser water pump speed" annotation (Placement(
        transformation(extent={{-220,-120},{-180,-80}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Integers.GreaterThreshold intGreThr "Check if it is stage-up"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  CDL.Discrete.TriggeredSampler triSam[num]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Routing.BooleanReplicator                        booRep1(final nout=num)
                    "Replicate input "
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  CDL.Interfaces.RealOutput yChiCur[num](final quantity="ElectricCurrent",
      final unit="A") "Current to chillers" annotation (Placement(transformation(
          extent={{180,90},{200,110}}), iconTransformation(extent={{100,-60},{120,
            -40}})));
  CDL.Continuous.Gain gai[num](k=0.5) "Half of current load"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  CDL.Continuous.Hysteresis hys[num](uLow=0.54, uHigh=0.56)
    "Check if actual demand is more than 0.55 of demand at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  CDL.Continuous.Division div[num]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  CDL.Continuous.Sources.Constant con[num](k=0.2)
    "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  CDL.Logical.Switch swi[num]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  CDL.Logical.TrueDelay truDel "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  CDL.Logical.MultiAnd mulAnd(nu=2)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  CDL.Interfaces.IntegerInput uChiSta "Current chiller stage" annotation (
      Placement(transformation(extent={{-220,-10},{-180,30}}),
        iconTransformation(extent={{-254,-38},{-214,2}})));
  CDL.Continuous.Gain byPasFloSet[num](k=minByPas)
    "Minimum by-pass flow setpoint array"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation

  connect(uChiStaCha, intGreThr.u)
    annotation (Line(points={{-200,150},{-162,150}}, color={255,127,0}));
  connect(uChiCur, triSam.u)
    annotation (Line(points={{-200,110},{-142,110}},
                                                   color={0,0,127}));
  connect(booRep1.y, triSam.trigger) annotation (Line(points={{-59,150},{-40,
          150},{-40,130},{-154,130},{-154,92},{-130,92},{-130,98.2}},
                                                               color={255,0,255}));
  connect(intGreThr.y, edg.u)
    annotation (Line(points={{-139,150},{-122,150}}, color={255,0,255}));
  connect(edg.y, booRep1.u)
    annotation (Line(points={{-99,150},{-82,150}}, color={255,0,255}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-119,110},{-82,110}}, color={0,0,127}));
  connect(gai.y, yChiCur) annotation (Line(points={{-59,110},{-20,110},{-20,100},
          {190,100}}, color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-200,60},{-122,60}}, color={255,0,255}));
  connect(con.y, swi.u3) annotation (Line(points={{-139,40},{-130,40},{-130,52},
          {-122,52}}, color={0,0,127}));
  connect(uChiCur, div.u1) annotation (Line(points={{-200,110},{-160,110},{-160,
          82},{-80,82},{-80,66},{-62,66}}, color={0,0,127}));
  connect(swi.y, div.u2) annotation (Line(points={{-99,60},{-80,60},{-80,54},{-62,
          54}}, color={0,0,127}));
  connect(triSam.y, swi.u1) annotation (Line(points={{-119,110},{-100,110},{
          -100,78},{-160,78},{-160,68},{-122,68}},
                                              color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-39,60},{-22,60}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{1,60},{18,60}}, color={255,0,255}));
  connect(not1.y, mulAnd.u) annotation (Line(points={{41,60},{50,60},{50,60},{
          58,60}},    color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{81.7,60},{98,60}}, color={255,0,255}));
annotation (
  defaultComponentName = "towFan",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-220},{180,160}})),
    Icon(coordinateSystem(extent={{-180,-220},{180,160}}),
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
