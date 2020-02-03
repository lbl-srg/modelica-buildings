within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Up "Generates a stage up signal"
  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.Time upHolPer = 900
     "Time period for the value hold at stage up change";

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump Diferential static pressure and its setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigSta
    "Operating at the highest available stage"
    annotation (Placement(transformation(extent={{-180,-172},{-140,-132}}),
    iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta if    hasWSE
    "Chiller stage" annotation (Placement(transformation(extent={{-180,-140},{-140,
            -100}}), iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-180,168},{-140,208}}), iconTransformation(
          extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-180,138},{-140,178}}), iconTransformation(
          extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeUp(final unit="1")
    "Operating part load ratio of the next higher stage" annotation (Placement(
        transformation(extent={{-180,98},{-140,138}}), iconTransformation(
          extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeUpMin(final unit="1")
    "Minimum operating part load ratio at the next stage up" annotation (
      Placement(transformation(extent={{-180,68},{-140,108}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,18},{-140,58}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure"
    annotation (Placement(transformation(extent={{-180,-22},{-140,18}}),
    iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-62},{-140,-22}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-102},{-140,-62}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage up signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Logical.Not not2
    "If change is not in process or the hold time has expired the stage change is enabled"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif)
    "Failsafe condition of the current stage"
    annotation (Placement(transformation(extent={{-80,58},{-60,78}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.EfficiencyCondition effCon(
    final delayStaCha = delayStaCha)
    "Efficiency condition of the current stage"
    annotation (Placement(transformation(extent={{-80,158},{-60,178}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp "Or for staging up"
    annotation (Placement(transformation(extent={{0,68},{20,88}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{60,38},{80,58}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if hasWSE
    "Switches staging up rules"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=smallTDif,
    final uHigh=smallTDif + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup1(
    final uLow=largeTDif,
    final uHigh=largeTDif + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp1 if hasWSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{50,-42},{70,-22}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=longDelay, delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-22},{20,-2}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=shortDelay, delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-62},{20,-42}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSE(final k=true) if not hasWSE
    "Replacement signal if plant does not have WSE - assuming if plant gets enabled the lowest available stage should be engaged"
    annotation (Placement(transformation(extent={{0,38},{20,58}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,-162},{-60,-142}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Prevents stage up signal if operating at the highest available stage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=upHolPer,
    final falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));

equation
  connect(uOpe, effCon.uOpe) annotation (Line(points={{-160,188},{-130,188},{-130,
          173},{-82,173}}, color={0,0,127}));
  connect(uStaUp, effCon.uStaUp) annotation (Line(points={{-160,158},{-130,158},
          {-130,163},{-82,163}}, color={0,0,127}));
  connect(uOpeUp, faiSafCon.uOpeUp) annotation (Line(points={{-160,118},{-100,118},
          {-100,76},{-82,76}}, color={0,0,127}));
  connect(uOpeUpMin, faiSafCon.uOpeUpMin) annotation (Line(points={{-160,88},{-130,
          88},{-130,73},{-82,73}}, color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-160,
          -42},{-130,-42},{-130,70},{-82,70}},color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-160,-82},
          {-110,-82},{-110,66},{-82,66}},  color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-160,38},
          {-92,38},{-92,63},{-82,63}},color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-160,-2},
          {-90,-2},{-90,60},{-82,60}},      color={0,0,127}));
  connect(effCon.y, orStaUp.u1) annotation (Line(points={{-58,168},{-20,168},{-20,
          78},{-2,78}},    color={255,0,255}));
  connect(faiSafCon.y, orStaUp.u2) annotation (Line(points={{-58,68},{-30,68},{-30,
          70},{-2,70}},    color={255,0,255}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-58,-120},{40,-120},
          {40,48},{58,48}}, color={255,0,255}));
  connect(orStaUp.y, logSwi.u1) annotation (Line(points={{22,78},{30,78},{30,56},
          {58,56}},color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-58,-12},{-42,-12}}, color={0,0,127}));
  connect(TChiWatSupSet,add0. u1) annotation (Line(points={{-160,-42},{-90,-42},
          {-90,-6},{-82,-6}},     color={0,0,127}));
  connect(TChiWatSup,add0. u2) annotation (Line(points={{-160,-82},{-110,-82},{-110,
          -18},{-82,-18}},       color={0,0,127}));
  connect(add1.y, hysTSup1.u)
    annotation (Line(points={{-58,-52},{-42,-52}}, color={0,0,127}));
  connect(TChiWatSupSet,add1. u1) annotation (Line(points={{-160,-42},{-90,-42},
          {-90,-46},{-82,-46}},   color={0,0,127}));
  connect(TChiWatSup,add1. u2) annotation (Line(points={{-160,-82},{-110,-82},{-110,
          -58},{-82,-58}},       color={0,0,127}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-18,-12},{-2,-12}}, color={255,0,255}));
  connect(hysTSup1.y, truDel1.u)
    annotation (Line(points={{-18,-52},{-2,-52}}, color={255,0,255}));
  connect(truDel.y, orStaUp1.u1) annotation (Line(points={{22,-12},{30,-12},{30,
          -32},{48,-32}}, color={255,0,255}));
  connect(truDel1.y, orStaUp1.u2) annotation (Line(points={{22,-52},{30,-52},{30,
          -40},{48,-40}},   color={255,0,255}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{72,-32},{80,-32},{80,
          -12},{50,-12},{50,40},{58,40}},color={255,0,255}));
  connect(noWSE.y, logSwi.u2)
    annotation (Line(points={{22,48},{58,48}}, color={255,0,255}));
  connect(noWSE.y, logSwi.u3) annotation (Line(points={{22,48},{40,48},{40,40},{
          58,40}}, color={255,0,255}));
  connect(uHigSta, not1.u)
    annotation (Line(points={{-160,-152},{-82,-152}}, color={255,0,255}));
  connect(and3.y, y)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));
  connect(logSwi.y,and3. u1) annotation (Line(points={{82,48},{90,48},{90,8},{98,
          8}},    color={255,0,255}));
  connect(not1.y,and3. u2) annotation (Line(points={{-58,-152},{90,-152},{90,0},
          {98,0}},  color={255,0,255}));
  connect(chaPro, truFalHol.u) annotation (Line(points={{-160,-180},{-120,-180},
          {-120,-180},{-82,-180}}, color={255,0,255}));
  connect(truFalHol.y, not2.u)
    annotation (Line(points={{-58,-180},{-42,-180}}, color={255,0,255}));
  connect(not2.y, and3.u3) annotation (Line(points={{-18,-180},{94,-180},{94,-8},
          {98,-8}}, color={255,0,255}));
  connect(intGreThr.u, uSta)
    annotation (Line(points={{-82,-120},{-160,-120}}, color={255,127,0}));
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
        Line(points={{130,-48}}, color={0,0,127})}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-140,-200},{140,200}})),
Documentation(info="<html>
<p>
Outputs a boolean stage up signal <code>y<\code> based on the various plant operation 
conditions that get provided as input signals. The implementation is according to 
ASHRAE RP1711 section 5.2.4.13 
July Draft.
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
