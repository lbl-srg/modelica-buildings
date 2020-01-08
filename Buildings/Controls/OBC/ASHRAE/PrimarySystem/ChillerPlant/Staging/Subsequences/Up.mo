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
    annotation (Placement(transformation(extent={{-180,-190},{-140,-150}}),
    iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta if    hasWSE
    "Chiller stage" annotation (Placement(transformation(extent={{-180,-160},{-140,
            -120}}), iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-180,150},{-140,190}}), iconTransformation(
          extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-180,120},{-140,160}}), iconTransformation(
          extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeUp(final unit="1")
    "Operating part load ratio of the next higher stage" annotation (Placement(
        transformation(extent={{-180,80},{-140,120}}), iconTransformation(
          extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeUpMin(final unit="1")
    "Minimum operating part load ratio at the next stage up" annotation (
      Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
    iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage up signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif)
    "Failsafe condition of the current stage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.EfficiencyCondition effCon(
    final delayStaCha = delayStaCha)
    "Efficiency condition of the current stage"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp "Or for staging up"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if hasWSE
    "Switches staging up rules"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=smallTDif,
    final uHigh=smallTDif + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup1(
    final uLow=largeTDif,
    final uHigh=largeTDif + 1,
    final pre_y_start=false) if hasWSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp1 if hasWSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{50,-60},{70,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1,
    final k2=1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=longDelay, delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=shortDelay, delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSE(final k=true) if not hasWSE
    "Replacement signal if plant does not have WSE - assuming if plant gets enabled the lowest available stage should be engaged"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Prevents stage up signal if operating at the highest available stage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(uOpe, effCon.uOpe) annotation (Line(points={{-160,170},{-130,170},{-130,
          155},{-82,155}}, color={0,0,127}));
  connect(uStaUp, effCon.uStaUp) annotation (Line(points={{-160,140},{-130,140},
          {-130,145},{-82,145}}, color={0,0,127}));
  connect(uOpeUp, faiSafCon.uOpeUp) annotation (Line(points={{-160,100},{-100,100},
          {-100,58},{-82,58}}, color={0,0,127}));
  connect(uOpeUpMin, faiSafCon.uOpeUpMin) annotation (Line(points={{-160,70},{-130,
          70},{-130,55},{-82,55}}, color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-160,
          -60},{-130,-60},{-130,52},{-82,52}},color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-160,-100},
          {-110,-100},{-110,48},{-82,48}}, color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-160,20},
          {-92,20},{-92,45},{-82,45}},color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-160,
          -20},{-90,-20},{-90,42},{-82,42}},color={0,0,127}));
  connect(effCon.y, orStaUp.u1) annotation (Line(points={{-58,150},{-20,150},{
          -20,60},{-2,60}},color={255,0,255}));
  connect(faiSafCon.y, orStaUp.u2) annotation (Line(points={{-58,50},{-30,50},{
          -30,52},{-2,52}},color={255,0,255}));
  connect(uSta, intGreThr.u)
    annotation (Line(points={{-160,-140},{-82,-140}}, color={255,127,0}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-58,-140},{40,-140},
          {40,30},{58,30}}, color={255,0,255}));
  connect(orStaUp.y, logSwi.u1) annotation (Line(points={{22,60},{30,60},{30,38},
          {58,38}},color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={0,0,127}));
  connect(TChiWatSupSet,add0. u1) annotation (Line(points={{-160,-60},{-90,-60},
          {-90,-24},{-82,-24}},   color={0,0,127}));
  connect(TChiWatSup,add0. u2) annotation (Line(points={{-160,-100},{-110,-100},
          {-110,-36},{-82,-36}}, color={0,0,127}));
  connect(add1.y, hysTSup1.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={0,0,127}));
  connect(TChiWatSupSet,add1. u1) annotation (Line(points={{-160,-60},{-90,-60},
          {-90,-64},{-82,-64}},   color={0,0,127}));
  connect(TChiWatSup,add1. u2) annotation (Line(points={{-160,-100},{-110,-100},
          {-110,-76},{-82,-76}}, color={0,0,127}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-18,-30},{-2,-30}}, color={255,0,255}));
  connect(hysTSup1.y, truDel1.u)
    annotation (Line(points={{-18,-70},{-2,-70}}, color={255,0,255}));
  connect(truDel.y, orStaUp1.u1) annotation (Line(points={{22,-30},{30,-30},{30,
          -50},{48,-50}}, color={255,0,255}));
  connect(truDel1.y, orStaUp1.u2) annotation (Line(points={{22,-70},{30,-70},{
          30,-58},{48,-58}},color={255,0,255}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{72,-50},{80,-50},{80,
          -30},{50,-30},{50,22},{58,22}},color={255,0,255}));
  connect(noWSE.y, logSwi.u2)
    annotation (Line(points={{22,30},{58,30}}, color={255,0,255}));
  connect(noWSE.y, logSwi.u3) annotation (Line(points={{22,30},{40,30},{40,22},
          {58,22}},color={255,0,255}));
  connect(uHigSta, not1.u)
    annotation (Line(points={{-160,-170},{-82,-170}}, color={255,0,255}));
  connect(and2.y, y)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));
  connect(logSwi.y, and2.u1) annotation (Line(points={{82,30},{90,30},{90,0},{
          98,0}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-58,-170},{90,-170},{90,-8},
          {98,-8}}, color={255,0,255}));
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
        extent={{-140,-180},{140,180}})),
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
