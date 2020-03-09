within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Down "Generates a stage down signal"
  parameter Modelica.SIunits.Time delayStaCha = 900
    "True delay period";

  parameter Modelica.SIunits.Time dowHolPer = 900
     "Time period for the value hold at stage down change";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDifHyst = 1
    "Hysteresis deadband for temperature";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump differential static pressure and its setpoint";

  parameter Boolean hasWSE = true
    "The chiller plant has a waterside economizer (WSE).";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if hasWSE
    "WSE status"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Chiller stage"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(final unit="1")
    "OPLR of the current stage"
    annotation (Placement(transformation(
          extent={{-220,110},{-180,150}}),iconTransformation(extent={{-140,110},
            {-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeMin(final unit="1")
    "Minimum OPLR at the current stage"
    annotation (
      Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeDow(final unit="1")
    "Next available stage down operating part load ratio (OPLR)"
     annotation (Placement(
        transformation(extent={{-220,190},{-180,230}}), iconTransformation(
          extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDow(final unit="1")
    "Next available stage down staging part load ratio (SPLR)"
    annotation (
      Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
    iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if hasWSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
       iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if hasWSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage down signal"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Logical.Not not2
    "If change is not in process or the hold time has expired the stage change is enabled"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
//protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif)
    "Failsafe condition of the next lower stage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Logical.And and0 "And for staging down"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=1)
    "Switches staging down rules"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=TDif,
    final uHigh=TDif + TDifHyst) if hasWSE
    "Checks if the predicted downstream WSE chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 if hasWSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0 if hasWSE
    "Logical not"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=1,
    final k2=-1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) if hasWSE
    "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delayStaCha,
    delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=delayStaCha,
    final delayOnInit=true)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDow(
    final uLow=0,
    final uHigh=0.05)
    "Checks if the operating PLR of the next available stage down exceeds the staging down PLR for that stage"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add(
    final k1=-1,
    final k2=+1)
    "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSEcoSig(final k=false) if
                     not hasWSE
    "Staging from 1 to 0 for plants without a WSE is depends on the plant disable sequence"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=dowHolPer,
    final falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
equation
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-200,
          -40},{-160,-40},{-160,52},{-82,52}},color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-200,50},
          {-170,50},{-170,45},{-82,45}}, color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-200,20},
          {-140,20},{-140,42},{-82,42}},color={0,0,127}));
  connect(u, intGreThr.u)
    annotation (Line(points={{-200,-160},{-122,-160}}, color={255,127,0}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(uOpe, faiSafCon.uOpeUp) annotation (Line(points={{-200,130},{-140,130},
          {-140,58},{-82,58}}, color={0,0,127}));
  connect(uOpeMin, faiSafCon.uOpeUpMin) annotation (Line(points={{-200,100},{-150,
          100},{-150,55},{-82,55}},color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-200,-10},
          {-150,-10},{-150,48},{-82,48}},  color={0,0,127}));
  connect(hys.y, not0.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u) annotation (
    Line(points={{-200,-100},{-122,-100}},color={0,0,127}));
  connect(uWseSta, and1.u3) annotation (Line(points={{-200,-130},{-30,-130},{-30,
          -68},{18,-68}},
                     color={255,0,255}));
  connect(hysTSup.y, and1.u1) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -52},{18,-52}}, color={255,0,255}));
  connect(uStaDow, add.u2) annotation (Line(points={{-200,170},{-172,170},{-172,
          184},{-82,184}}, color={0,0,127}));
  connect(uOpeDow, add.u1) annotation (Line(points={{-200,210},{-172,210},{-172,
          196},{-82,196}}, color={0,0,127}));
  connect(faiSafCon.y, not1.u)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,0,255}));
  connect(not1.y, and0.u2) annotation (Line(points={{-18,50},{0,50},{0,82},{18,82}},
                color={255,0,255}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-98,-160},{90,-160},
          {90,20},{98,20}},
                          color={255,0,255}));
  connect(not0.y, and1.u2) annotation (Line(points={{-58,-100},{0,-100},{0,-60},
          {18,-60}}, color={255,0,255}));
  connect(and1.y, truDel.u)
    annotation (Line(points={{42,-60},{58,-60}}, color={255,0,255}));
  connect(truDel.y, logSwi.u3) annotation (Line(points={{82,-60},{90,-60},{90,12},
          {98,12}}, color={255,0,255}));
  connect(add.y, hysDow.u)
    annotation (Line(points={{-58,190},{-42,190}}, color={0,0,127}));
  connect(and0.y, truDel1.u) annotation (Line(points={{42,90},{50,90},{50,50},{58,
          50}},    color={255,0,255}));
  connect(truDel1.y, logSwi.u1) annotation (Line(points={{82,50},{90,50},{90,28},
          {98,28}},color={255,0,255}));
  connect(hysDow.y, and0.u1) annotation (Line(points={{-18,190},{0,190},{0,90},{
          18,90}},  color={255,0,255}));
  connect(TChiWatSupSet, add0.u1) annotation (Line(points={{-200,-40},{-140,-40},
          {-140,-54},{-82,-54}}, color={0,0,127}));
  connect(TWsePre, add0.u2) annotation (Line(points={{-200,-70},{-140,-70},{-140,
          -66},{-82,-66}}, color={0,0,127}));
  connect(noWSEcoSig.y, logSwi.u3) annotation (Line(points={{42,10},{70,10},{70,
          12},{98,12}}, color={255,0,255}));
  connect(chaPro, truFalHol.u)
    annotation (Line(points={{-200,-200},{-122,-200}}, color={255,0,255}));
  connect(y, and2.y)
    annotation (Line(points={{190,0},{152,0}}, color={255,0,255}));
  connect(logSwi.y, and2.u1) annotation (Line(points={{122,20},{126,20},{126,0},
          {128,0}}, color={255,0,255}));
  connect(truFalHol.y, not2.u)
    annotation (Line(points={{-98,-200},{-82,-200}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-58,-200},{112,-200},{112,-8},
          {128,-8}}, color={255,0,255}));
  annotation (defaultComponentName = "staDow",
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
        Rectangle(extent={{-80,30},{-20,18}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,12},{-20,0}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,18},{-72,12}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,18},{-24,12}}, lineColor={0,0,127})}),
                                          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-240},{180,240}})),
Documentation(info="<html>
<p>
Outputs a boolean stage down signal <code>y<\code> based on the various plant operation 
conditions that get provided as input signals. The implementation is according to 
ASHRAE RP1711 section 5.2.4.13.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 02, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Down;
