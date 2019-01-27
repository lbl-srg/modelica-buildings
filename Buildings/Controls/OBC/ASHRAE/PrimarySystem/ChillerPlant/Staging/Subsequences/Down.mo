within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Down "Conditions to enable stage down"

  // fixme: pull OPRLup and OPRLdown out into chiller type staging packages
  parameter Integer numSta = 2
  "Number of stages";

  parameter Modelica.SIunits.Time delPer = 15*60
  "True delay period";

  parameter Modelica.SIunits.Time short = 10*60
  "Enable delay";

  parameter Modelica.SIunits.Time long = 20*60
  "Enable delay";

  parameter Modelica.SIunits.TemperatureDifference TDiff = 1
  "Offset between the predicted downstream WSE temperature and the chilled water supply temperature setpoint";

  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(
    transformation(extent={{-180,-20},{-140,20}}),    iconTransformation(
     extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
    iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.RealInput uOplr(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-180,90},{-140,130}}), iconTransformation(
          extent={{-120,80},{-100,100}})));
  CDL.Logical.And and0 "And for staging down"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  FailsafeCondition faiSafCon "Failsafe condition of the next lower stage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Interfaces.BooleanOutput y "Efficiency condition for chiller staging"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.IntegerInput                        uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-180,-190},{-140,-150}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Integers.GreaterThreshold intGreThr(threshold=1)
    "Switches staging down rules"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  CDL.Continuous.Hysteresis hysTSup(
    pre_y_start=false,
    final uLow=TDiff,
    final uHigh=TDiff + 1)
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Logical.And3
                 orStaUp1
                         "Or for staging up"
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));
  CDL.Interfaces.RealInput uOplrMin(final unit="1")
    "Minimum operating part load ratio at the current stage" annotation (
      Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uTWsePre(final unit="1")
    "Predicted waterside economizer outlet temperature"
                                                   annotation (Placement(
        transformation(extent={{-180,-60},{-140,-20}}),
                                                      iconTransformation(extent={{-120,60},
            {-100,80}})));
  CDL.Interfaces.BooleanInput uWseSta "Waterside economizer status" annotation (
     Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-298,-6},{-258,34}})));
  CDL.Interfaces.RealInput uTowFanSpeMax "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-184,-140},{-144,-100}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(
      extent={{-180,-120},{-140,-80}}),  iconTransformation(extent={{-120,-50},{
            -100,-30}})));
  CDL.Logical.Not not0 "Logical not"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  CDL.Interfaces.RealInput uOplrDow(final unit="1")
    "Operating part load ratio of the next stage down" annotation (Placement(
        transformation(extent={{-180,170},{-140,210}}),
                                                      iconTransformation(extent=
           {{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uSplrDow(final unit="1")
    "Staging part load ratio of the next stage down"
                                                   annotation (Placement(
        transformation(extent={{-180,130},{-140,170}}),
                                                      iconTransformation(extent=
           {{-120,70},{-100,90}})));
protected
  CDL.Continuous.Add add0(final k1=-1, final k2=1)
                "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Hysteresis                        hys(final uHigh=0.99, final
      uLow=0.98)     "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
protected
  CDL.Logical.TrueDelay truDel(final delayTime=delPer)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-28,-130},{-8,-110}})));
protected
  CDL.Logical.TrueDelay truDel1(final delayTime=delPer)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  CDL.Continuous.Hysteresis hysOplr(final uLow=0, final uHigh=0.05)
    "Checks if the current stage operating part load ratio exceeds the stage up part load ratio"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  CDL.Continuous.Add add(k1=-1, final k2=+1)
                                      "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
equation
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-160,
          -70},{-124,-70},{-124,30},{-102,30},{-102,29},{-81,29}},
                                              color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-160,30},
          {-130,30},{-130,24},{-106,24},{-106,23},{-81,23}},
                                                color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-160,0},
          {-88,0},{-88,21},{-81,21}},     color={0,0,127}));
  connect(faiSafCon.y, and0.u2) annotation (Line(points={{-59,30},{-30,30},{-30,
          2},{8,2}}, color={255,0,255}));
  connect(uChiSta, intGreThr.u)
    annotation (Line(points={{-160,-170},{-120,-170},{-120,-160},{-82,-160}},
                                                      color={255,127,0}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-59,-160},{40,-160},
          {40,0},{58,0}}, color={255,0,255}));
  connect(and0.y, logSwi.u1) annotation (Line(points={{31,10},{40,10},{40,8},{
          58,8}}, color={255,0,255}));
  connect(y, logSwi.y)
    annotation (Line(points={{110,0},{81,0}}, color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={0,0,127}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{71,-70},{80,-70},{80,
          -50},{50,-50},{50,-8},{58,-8}},
                                        color={255,0,255}));
  connect(uOplr, faiSafCon.uOplrUp) annotation (Line(points={{-160,110},{-100,
          110},{-100,38},{-81,38}},
                               color={0,0,127}));
  connect(uOplrMin, faiSafCon.uOplrUpMin) annotation (Line(points={{-160,80},{
          -110,80},{-110,34},{-81,34}},
                                   color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-160,-100},
          {-120,-100},{-120,27},{-81,27}}, color={0,0,127}));
  connect(TChiWatSupSet, add0.u2) annotation (Line(points={{-160,-70},{-90,-70},
          {-90,-56},{-82,-56}}, color={0,0,127}));
  connect(uTWsePre, add0.u1) annotation (Line(points={{-160,-40},{-100,-40},{
          -100,-44},{-82,-44}},
                           color={0,0,127}));
  connect(hys.y, not0.u)
    annotation (Line(points={{-69,-120},{-62,-120}}, color={255,0,255}));
  connect(not0.y, truDel.u)
    annotation (Line(points={{-39,-120},{-30,-120}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u) annotation (Line(points={{-164,-120},{-128,-120},
          {-128,-120},{-92,-120}}, color={0,0,127}));
  connect(truDel.y, orStaUp1.u2) annotation (Line(points={{-7,-120},{20,-120},{
          20,-70},{48,-70}}, color={255,0,255}));
  connect(uWseSta, orStaUp1.u3) annotation (Line(points={{-160,-140},{-66,-140},
          {-66,-136},{32,-136},{32,-78},{48,-78}}, color={255,0,255}));
  connect(hysTSup.y, orStaUp1.u1) annotation (Line(points={{-19,-50},{14,-50},{
          14,-62},{48,-62}}, color={255,0,255}));
  connect(hysOplr.y, truDel1.u)
    annotation (Line(points={{-39,170},{-22,170}}, color={255,0,255}));
  connect(add.y,hysOplr. u)
    annotation (Line(points={{-79,170},{-62,170}},
                                               color={0,0,127}));
  connect(uSplrDow, add.u2) annotation (Line(points={{-160,150},{-132,150},{
          -132,164},{-102,164}}, color={0,0,127}));
  connect(uOplrDow, add.u1) annotation (Line(points={{-160,190},{-132,190},{
          -132,176},{-102,176}}, color={0,0,127}));
  connect(truDel1.y, and0.u1) annotation (Line(points={{1,170},{10,170},{10,30},
          {-10,30},{-10,10},{8,10}}, color={255,0,255}));
  annotation (defaultComponentName = "staUp",
        Icon(coordinateSystem(extent={{-140,-180},{100,200}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-140,-180},{100,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

add WSE enable at plant enable part (input, output, predicted temperature) and at staging down from 1.
</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Down;
