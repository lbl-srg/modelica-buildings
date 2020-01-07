within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Down "Generates a stage down signal"
  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "True delay period";

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
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u if hasWSE
    "Chiller stage"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(final unit="1")
    "OPLR of the current stage"
    annotation (Placement(transformation(
          extent={{-180,90},{-140,130}}), iconTransformation(extent={{-120,70},
            {-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeMin(final unit="1")
    "Minimum OPLR at the current stage"
    annotation (
      Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeDow(final unit="1")
    "Next available stage down operating part load ratio (OPLR)"
     annotation (Placement(
        transformation(extent={{-180,170},{-140,210}}), iconTransformation(
          extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDow(final unit="1")
    "Next available stage down staging part load ratio (SPLR)"
    annotation (
      Placement(transformation(extent={{-180,130},{-140,170}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
    iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
    iconTransformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if hasWSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
       iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if hasWSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage down signal"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition faiSafCon(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif)
    "Failsafe condition of the next lower stage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.And and0 "And for staging down"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=1) if hasWSE
    "Switches staging down rules"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=TDif,
    final uHigh=TDif + TDifHyst) if hasWSE
    "Checks if the predicted downstream WSE chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 if hasWSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0 if hasWSE
    "Logical not"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=1,
    final k2=-1) if hasWSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) if hasWSE
    "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delayStaCha,
    delayOnInit=true) if hasWSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=delayStaCha,
    final delayOnInit=true)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDow(
    final uLow=0,
    final uHigh=0.05)
    "Checks if the operating PLR of the next available stage down exceeds the staging down PLR for that stage"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add(
    final k1=-1,
    final k2=+1)
    "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSEcoSig(
    final k=true) if not hasWSE
    "Substitute signal for plants without a WSE"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

equation
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-160,
          -60},{-120,-60},{-120,32},{-82,32}},color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-160,30},
          {-130,30},{-130,25},{-82,25}}, color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-160,0},
          {-100,0},{-100,22},{-82,22}}, color={0,0,127}));
  connect(u, intGreThr.u)
    annotation (Line(points={{-160,-180},{-122,-180}}, color={255,127,0}));
  connect(y, logSwi.y)
    annotation (Line(points={{150,0},{122,0}},color={255,0,255}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(uOpe, faiSafCon.uOpeUp) annotation (Line(points={{-160,110},{-100,110},
          {-100,38},{-82,38}}, color={0,0,127}));
  connect(uOpeMin, faiSafCon.uOpeUpMin) annotation (Line(points={{-160,80},{-110,
          80},{-110,35},{-82,35}}, color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-160,-30},
          {-110,-30},{-110,28},{-82,28}},  color={0,0,127}));
  connect(hys.y, not0.u)
    annotation (Line(points={{-98,-120},{-82,-120}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u) annotation (
    Line(points={{-160,-120},{-122,-120}},color={0,0,127}));
  connect(uWseSta, and1.u3) annotation (Line(points={{-160,-150},{10,-150},{10,-88},
          {18,-88}}, color={255,0,255}));
  connect(hysTSup.y, and1.u1) annotation (Line(points={{-18,-80},{-10,-80},{-10,
          -72},{18,-72}}, color={255,0,255}));
  connect(uStaDow, add.u2) annotation (Line(points={{-160,150},{-132,150},{-132,
          164},{-82,164}}, color={0,0,127}));
  connect(uOpeDow, add.u1) annotation (Line(points={{-160,190},{-132,190},{-132,
          176},{-82,176}}, color={0,0,127}));
  connect(faiSafCon.y, not1.u)
    annotation (Line(points={{-58,30},{-42,30}}, color={255,0,255}));
  connect(not1.y, and0.u2) annotation (Line(points={{-18,30},{0,30},{0,62},{18,
          62}}, color={255,0,255}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-98,-180},{90,-180},
          {90,0},{98,0}}, color={255,0,255}));
  connect(not0.y, and1.u2) annotation (Line(points={{-58,-120},{0,-120},{0,-80},
          {18,-80}}, color={255,0,255}));
  connect(and1.y, truDel.u)
    annotation (Line(points={{42,-80},{58,-80}}, color={255,0,255}));
  connect(truDel.y, logSwi.u3) annotation (Line(points={{82,-80},{90,-80},{90,-8},
          {98,-8}}, color={255,0,255}));
  connect(add.y, hysDow.u)
    annotation (Line(points={{-58,170},{-42,170}}, color={0,0,127}));
  connect(and0.y, truDel1.u) annotation (Line(points={{42,70},{50,70},{50,30},{
          58,30}}, color={255,0,255}));
  connect(truDel1.y, logSwi.u1) annotation (Line(points={{82,30},{90,30},{90,8},
          {98,8}}, color={255,0,255}));
  connect(hysDow.y, and0.u1) annotation (Line(points={{-18,170},{0,170},{0,70},
          {18,70}}, color={255,0,255}));
  connect(TChiWatSupSet, add0.u1) annotation (Line(points={{-160,-60},{-100,-60},
          {-100,-74},{-82,-74}}, color={0,0,127}));
  connect(TWsePre, add0.u2) annotation (Line(points={{-160,-90},{-100,-90},{-100,
          -86},{-82,-86}}, color={0,0,127}));
  connect(noWSEcoSig.y, logSwi.u2) annotation (Line(points={{62,-20},{70,-20},{70,
          0},{98,0}}, color={255,0,255}));
  connect(noWSEcoSig.y, logSwi.u3) annotation (Line(points={{62,-20},{70,-20},{70,
          -8},{98,-8}}, color={255,0,255}));
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
        extent={{-140,-200},{140,200}})),
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
