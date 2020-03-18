within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Up "Generates a stage up signal"
  parameter Boolean have_WSE = true
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
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
    iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-220,-210},{-180,-170}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u if       have_WSE
    "Chiller stage" annotation (Placement(transformation(extent={{-220,-110},{
            -180,-70}}),
                    iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-220,190},{-180,230}}), iconTransformation(
          extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-220,160},{-180,200}}), iconTransformation(
          extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure setpoint"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
    iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage up signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "If change is not in process or the hold time has expired the stage change is enabled"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));

//protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif)
    "Failsafe condition of the current stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.EfficiencyCondition effCon(
    final delayStaCha = delayStaCha)
    "Efficiency condition of the current stage"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp "Or for staging up"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if have_WSE
    "Switches staging up rules"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=smallTDif,
    final uHigh=smallTDif + 1,
    final pre_y_start=false) if have_WSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup1(
    final uLow=largeTDif,
    final uHigh=largeTDif + 1,
    final pre_y_start=false) if have_WSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp1 if have_WSE "Or for staging up"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) if have_WSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1,
    final k2=1) if have_WSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=longDelay, delayOnInit=true) if have_WSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=shortDelay, delayOnInit=true) if have_WSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSE(final k=true) if not have_WSE
    "Replacement signal if plant does not have WSE - assuming if plant gets enabled the lowest available stage should be engaged"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Prevents stage up signal if operating at the highest available stage"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=upHolPer,
    final falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));

  CDL.Logical.Or orAva if                           have_WSE
    "Demand stage up if current stage becomes unavailable"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  CDL.Interfaces.BooleanInput                        uAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
equation
  connect(uOpe, effCon.uOpe) annotation (Line(points={{-200,210},{-170,210},{-170,
          195},{-122,195}},color={0,0,127}));
  connect(uStaUp, effCon.uStaUp) annotation (Line(points={{-200,180},{-170,180},
          {-170,185},{-122,185}},color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-200,
          -20},{-170,-20},{-170,92},{-122,92}},
                                              color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-200,-60},
          {-150,-60},{-150,88},{-122,88}}, color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-200,60},
          {-132,60},{-132,85},{-122,85}},
                                      color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-200,20},
          {-130,20},{-130,82},{-122,82}},   color={0,0,127}));
  connect(effCon.y, orStaUp.u1) annotation (Line(points={{-98,190},{-60,190},{-60,
          110},{-42,110}}, color={255,0,255}));
  connect(faiSafCon.y, orStaUp.u2) annotation (Line(points={{-98,90},{-70,90},{-70,
          102},{-42,102}}, color={255,0,255}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-98,-90},{-8,-90},{
          -8,70},{38,70}},  color={255,0,255}));
  connect(orStaUp.y, logSwi.u1) annotation (Line(points={{-18,110},{-10,110},{-10,
          78},{38,78}},
                   color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-98,10},{-82,10}},   color={0,0,127}));
  connect(TChiWatSupSet,add0. u1) annotation (Line(points={{-200,-20},{-130,-20},
          {-130,16},{-122,16}},   color={0,0,127}));
  connect(TChiWatSup,add0. u2) annotation (Line(points={{-200,-60},{-150,-60},{
          -150,4},{-122,4}},     color={0,0,127}));
  connect(add1.y, hysTSup1.u)
    annotation (Line(points={{-98,-30},{-82,-30}}, color={0,0,127}));
  connect(TChiWatSupSet,add1. u1) annotation (Line(points={{-200,-20},{-130,-20},
          {-130,-24},{-122,-24}}, color={0,0,127}));
  connect(TChiWatSup,add1. u2) annotation (Line(points={{-200,-60},{-150,-60},{
          -150,-36},{-122,-36}}, color={0,0,127}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-58,10},{-42,10}},  color={255,0,255}));
  connect(hysTSup1.y, truDel1.u)
    annotation (Line(points={{-58,-30},{-42,-30}},color={255,0,255}));
  connect(truDel.y, orStaUp1.u1) annotation (Line(points={{-18,10},{-10,10},{-10,
          -10},{-2,-10}}, color={255,0,255}));
  connect(truDel1.y, orStaUp1.u2) annotation (Line(points={{-18,-30},{-10,-30},{
          -10,-18},{-2,-18}},
                            color={255,0,255}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{22,-10},{30,-10},{30,
          62},{38,62}},                  color={255,0,255}));
  connect(noWSE.y, logSwi.u2)
    annotation (Line(points={{-18,70},{38,70}},color={255,0,255}));
  connect(noWSE.y, logSwi.u3) annotation (Line(points={{-18,70},{10,70},{10,62},
          {38,62}},color={255,0,255}));
  connect(logSwi.y,and3. u1) annotation (Line(points={{62,70},{70,70},{70,8},{78,
          8}},    color={255,0,255}));
  connect(not1.y,and3. u2) annotation (Line(points={{-98,-160},{60,-160},{60,0},
          {78,0}},  color={255,0,255}));
  connect(chaPro, truFalHol.u) annotation (Line(points={{-200,-190},{-122,-190}},
                                   color={255,0,255}));
  connect(truFalHol.y, not2.u)
    annotation (Line(points={{-98,-190},{-82,-190}}, color={255,0,255}));
  connect(not2.y, and3.u3) annotation (Line(points={{-58,-190},{70,-190},{70,-8},
          {78,-8}}, color={255,0,255}));
  connect(and3.y, orAva.u1)
    annotation (Line(points={{102,0},{118,0}}, color={255,0,255}));
  connect(not3.y, orAva.u2) annotation (Line(points={{-98,-220},{110,-220},{110,
          -8},{118,-8}}, color={255,0,255}));
  connect(orAva.y, y)
    annotation (Line(points={{142,0},{180,0}}, color={255,0,255}));
  connect(u, intGreThr.u)
    annotation (Line(points={{-200,-90},{-122,-90}}, color={255,127,0}));
  connect(uHigSta, not1.u)
    annotation (Line(points={{-200,-160},{-122,-160}}, color={255,0,255}));
  connect(uAvaCur, faiSafCon.uAvaCur) annotation (Line(points={{-200,-130},{
          -140,-130},{-140,78},{-122,78}}, color={255,0,255}));
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
        extent={{-180,-240},{160,240}})),
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
