within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Down "Generates a stage down signal"

  parameter Boolean have_WSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Real parLoaRatDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay for operating and staging part load ratio condition";

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay for failsafe condition";

  parameter Modelica.SIunits.TemperatureDifference faiSafTDif = 1
    "Offset between the chilled water supply temperature and its setpoint for the failsafe condition";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Hysteresis deadband for temperature"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Modelica.SIunits.PressureDifference faiSafDpDif = 2 * 6895
    "Offset between the chilled water pump differential static pressure and its setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if have_WSE
    "WSE status"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Chiller stage"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeDow(final unit="1")
    "Next available stage down operating part load ratio (OPLR)"
     annotation (Placement(
        transformation(extent={{-220,190},{-180,230}}), iconTransformation(
          extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDow(final unit="1")
    "Next available stage down staging part load ratio (SPLR)"
    annotation (
      Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
    iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1") if have_WSE
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
       iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax if have_WSE
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Stage down signal"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final serChi=serChi,
    final faiSafTruDelay=faiSafTruDelay,
    final TDif=TDif,
    final dpDif=faiSafDpDif)
    "Failsafe condition of the next lower stage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Logical.And and0 "And for staging down"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=1)
    "Switches staging down rules"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=TDif - TDifHys,
    final uHigh=TDif) if have_WSE
    "Checks if the predicted downstream WSE chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 if have_WSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0 if have_WSE
    "Outputs true if signal is below maximum"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=1,
    final k2=-1) if have_WSE
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) if have_WSE
    "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=parLoaRatDelay,
    final delayOnInit=true)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDow(
    final uLow=0,
    final uHigh=0.05)
    "Checks if the operating PLR of the next available stage down exceeds the staging down PLR for that stage"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add(
    final k1=-1,
    final k2=+1)
    "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSEcoSig(
    final k=false) if not have_WSE
    "Staging from 1 to 0 for plants without a WSE is depends on the plant disable sequence"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-200,
          -40},{-160,-40},{-160,56},{-82,56}},color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-200,
          110},{-170,110},{-170,48},{-82,48}},
                                         color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-200,70},
          {-140,70},{-140,44},{-82,44}},color={0,0,127}));
  connect(u, intGreThr.u)
    annotation (Line(points={{-200,-160},{-122,-160}}, color={255,127,0}));
  connect(add0.y,hysTSup. u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-200,30},{
          -150,30},{-150,52},{-82,52}},    color={0,0,127}));
  connect(hys.y, not0.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u) annotation (
    Line(points={{-200,-100},{-122,-100}},color={0,0,127}));
  connect(uWseSta, and1.u3) annotation (Line(points={{-200,-130},{10,-130},{10,
          -68},{18,-68}},
                     color={255,0,255}));
  connect(hysTSup.y, and1.u1) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -52},{18,-52}}, color={255,0,255}));
  connect(uStaDow, add.u2) annotation (Line(points={{-200,170},{-172,170},{-172,
          184},{-122,184}},color={0,0,127}));
  connect(uOpeDow, add.u1) annotation (Line(points={{-200,210},{-172,210},{-172,
          196},{-122,196}},color={0,0,127}));
  connect(not1.y, and0.u2) annotation (Line(points={{-18,50},{0,50},{0,82},{18,82}},
                color={255,0,255}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-98,-160},{90,-160},
          {90,0},{98,0}}, color={255,0,255}));
  connect(not0.y, and1.u2) annotation (Line(points={{-58,-100},{0,-100},{0,-60},
          {18,-60}}, color={255,0,255}));
  connect(add.y, hysDow.u)
    annotation (Line(points={{-98,190},{-82,190}}, color={0,0,127}));
  connect(TChiWatSupSet, add0.u1) annotation (Line(points={{-200,-40},{-140,-40},
          {-140,-54},{-82,-54}}, color={0,0,127}));
  connect(TWsePre, add0.u2) annotation (Line(points={{-200,-70},{-140,-70},{-140,
          -66},{-82,-66}}, color={0,0,127}));
  connect(noWSEcoSig.y, logSwi.u3) annotation (Line(points={{42,-10},{70,-10},{70,
          -8},{98,-8}}, color={255,0,255}));
  connect(hysDow.y, truDel1.u)
    annotation (Line(points={{-58,190},{-42,190}}, color={255,0,255}));
  connect(truDel1.y, and0.u1) annotation (Line(points={{-18,190},{0,190},{0,90},
          {18,90}}, color={255,0,255}));
  connect(and0.y, logSwi.u1) annotation (Line(points={{42,90},{70,90},{70,8},{98,
          8}}, color={255,0,255}));
  connect(logSwi.y, y)
    annotation (Line(points={{122,0},{190,0}}, color={255,0,255}));
  connect(and1.y, logSwi.u3) annotation (Line(points={{42,-60},{80,-60},{80,-8},
          {98,-8}}, color={255,0,255}));
  connect(faiSafCon.y, not1.u)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,0,255}));
  annotation (defaultComponentName = "staDow",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,154},{100,116}},
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
        extent={{-180,-200},{180,240}})),
Documentation(info="<html>
<p>
Outputs a boolean stage down signal <code>y</code> when:
</p>
<ul>
<li>
Operating <code>uOpeDow</code> part load ratio of the next available stage down is below 
its staging <code>uStaDow</code> part load ratio for at least <code>parLoaRatDelay</code>, and
</li>
<li>
Failsafe condition is not <code>true</code>.
</li>
</ul>
<p>
If the plant has a WSE, staging from the lowest available chiller stage to 
WSE stage occurs when:
<ul>
<li>
WSE is enabled, and
</li>
<li>
The predicted WSE return temperature <code>TWsePre</code> is sufficently under the 
chilled water supply temperature setpoint <code>TChiWatSupSet</code> for defined periods of time, and 
</li>
<li>
Maximum cooling tower fan speed <code>uTowFanSpeMax</code> is below 100%
</li>
</ul>
<p>
The implementation is according to ASHRAE RP1711 March 2020 draft, section 5.2.4.15.
and can be used for both primary-only plants with and without a WSE.
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
