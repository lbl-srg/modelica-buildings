within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Up "Stage up conditions"

  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.TemperatureDifference smallTDiff = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDiff = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDiff = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDiff = 2 * 6895
    "Offset between the chilled water pump differential static pressure and its setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta if hasWSE
    "Chiller stage"
    annotation (Placement(transformation(extent={{-180,-180},{-140,-140}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOplr(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-180,130},{-140,170}}),iconTransformation(
          extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSplrUp(final unit="1")
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
      iconTransformation(extent={{-120,70}, {-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOplrUp(final unit="1")
    "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOplrUpMin(final unit="1")
    "Minimum operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
    iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(
      extent={{-180,-140},{-140,-100}}), iconTransformation(extent={{-120,-30},
            {-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Efficiency condition for chiller staging"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDiff = TDiff,
    final dpDiff = dpDiff)
    "Failsafe condition of the current stage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.EfficiencyCondition effCon(
    final delayStaCha = delayStaCha)
    "Efficiency condition of the current stage"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp "Or for staging up"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if hasWSE
    "Switches staging up rules"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=smallTDiff,
    final uHigh=smallTDiff + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup1(
    final uLow=largeTDiff,
    final uHigh=largeTDiff + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp1 if  hasWSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=longDelay) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=shortDelay) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  CDL.Logical.Sources.Constant noWSE(final k=true) if not hasWSE
    "Replacement signal if plant does not have WSE"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(uOplr, effCon.uOplr) annotation (Line(points={{-160,150},{-130,150},{
          -130,135},{-81,135}}, color={0,0,127}));
  connect(uSplrUp, effCon.uSplrUp) annotation (Line(points={{-160,120},{-130,
          120},{-130,125},{-81,125}}, color={0,0,127}));
  connect(uOplrUp, faiSafCon.uOplrUp) annotation (Line(points={{-160,80},{-100,80},
          {-100,38},{-81,38}}, color={0,0,127}));
  connect(uOplrUpMin, faiSafCon.uOplrUpMin) annotation (Line(points={{-160,50},{
          -130,50},{-130,34},{-81,34}},color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-160,
          -80},{-130,-80},{-130,29},{-81,29}},color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-160,-120},
          {-110,-120},{-110,27},{-81,27}}, color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-160,0},
          {-92,0},{-92,23},{-81,23}}, color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-160,-40},
          {-90,-40},{-90,21},{-81,21}}, color={0,0,127}));
  connect(effCon.y, orStaUp.u1) annotation (Line(points={{-59,130},{-20,130},{-20,
          40},{-2,40}}, color={255,0,255}));
  connect(faiSafCon.y, orStaUp.u2) annotation (Line(points={{-59,30},{-30,30},{-30,
          32},{-2,32}}, color={255,0,255}));
  connect(uChiSta, intGreThr.u)
    annotation (Line(points={{-160,-160},{-82,-160}}, color={255,127,0}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-59,-160},{40,-160},
          {40,10},{58,10}}, color={255,0,255}));
  connect(orStaUp.y, logSwi.u1) annotation (Line(points={{21,40},{30,40},{30,18},
          {58,18}},
                  color={255,0,255}));
  connect(y, logSwi.y)
    annotation (Line(points={{110,0},{96,0},{96,10},{81,10}}, color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={0,0,127}));
  connect(TChiWatSupSet,add0. u1) annotation (Line(points={{-160,-80},{-90,-80},
          {-90,-44},{-82,-44}},   color={0,0,127}));
  connect(TChiWatSup,add0. u2) annotation (Line(points={{-160,-120},{-110,-120},
          {-110,-56},{-82,-56}}, color={0,0,127}));
  connect(add1.y, hysTSup1.u)
    annotation (Line(points={{-59,-90},{-42,-90}}, color={0,0,127}));
  connect(TChiWatSupSet,add1. u1) annotation (Line(points={{-160,-80},{-90,-80},
          {-90,-84},{-82,-84}},   color={0,0,127}));
  connect(TChiWatSup,add1. u2) annotation (Line(points={{-160,-120},{-110,-120},
          {-110,-96},{-82,-96}}, color={0,0,127}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-19,-50},{-2,-50}}, color={255,0,255}));
  connect(hysTSup1.y, truDel1.u)
    annotation (Line(points={{-19,-90},{-2,-90}}, color={255,0,255}));
  connect(truDel.y, orStaUp1.u1) annotation (Line(points={{21,-50},{30,-50},{30,
          -70},{48,-70}}, color={255,0,255}));
  connect(truDel1.y, orStaUp1.u2) annotation (Line(points={{21,-90},{30,-90},{30,
          -78},{48,-78}}, color={255,0,255}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{71,-70},{80,-70},{80,
          -50},{50,-50},{50,2},{58,2}}, color={255,0,255}));
  connect(noWSE.y, logSwi.u2)
    annotation (Line(points={{21,10},{58,10}}, color={255,0,255}));
  connect(noWSE.y, logSwi.u3) annotation (Line(points={{21,10},{40,10},{40,2},{58,
          2}}, color={255,0,255}));
  annotation (defaultComponentName = "staUp",
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
        Rectangle(extent={{-80,-10},{-20,-22}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-28},{-20,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-22},{-72,-28}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-22},{-24,-28}}, lineColor={0,0,127}),
        Rectangle(extent={{20,-10},{80,-22}}, lineColor={0,0,127}),
        Rectangle(extent={{20,-28},{80,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{24,-22},{28,-28}}, lineColor={0,0,127}),
        Rectangle(extent={{72,-22},{76,-28}}, lineColor={0,0,127}),
        Rectangle(extent={{20,30},{80,18}}, lineColor={0,0,127}),
        Rectangle(extent={{20,12},{80,0}}, lineColor={0,0,127}),
        Rectangle(extent={{24,18},{28,12}}, lineColor={0,0,127}),
        Rectangle(extent={{72,18},{76,12}}, lineColor={0,0,127}),
        Line(points={{130,-48}}, color={0,0,127})}),
                                          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-140,-180},{100,160}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change up enable signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Up;
