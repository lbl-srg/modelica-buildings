within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Up "Generates a stage up signal"
  parameter Boolean have_WSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Boolean have_serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Boolean have_locSen=false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller"
    annotation (Dialog(enable=not have_serChi));

  parameter Integer nRemSen=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(enable=not have_serChi));

  parameter Real effConTruDelay(
    final unit="s",
    final quantity="Time")=900
      "Enable delay for efficiency condition";

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time")=900
      "Enable delay for failsafe condition";

  parameter Real shortTDelay(
    final unit="s",
    final quantity="Time")=600
      "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Real longTDelay(
    final unit="s",
    final quantity="Time")=1200
      "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Real faiSafTDif(
    final unit="K",
    final quantity="TemperatureDifference")=1
      "Offset between the chilled water supply temperature and its setpoint";

  parameter Real TDifHys(
    final unit="K",
    final quantity="TemperatureDifference")=1
      "Hysteresis deadband for temperature";

  parameter Real smallTDif(
    final unit="K",
    final quantity="TemperatureDifference")=1
      "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Real largeTDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
      "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE));

  parameter Real faiSafDpDif(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=2 * 6895
      "Offset between the chilled water differential pressure and its setpoint";

  parameter Real dpDifHys(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=0.5 * 6895
      "Pressure difference hysteresis deadband";

  parameter Real effConSigDif(
    final min=0,
    final max=1,
    final unit="1") = 0.05
    "Signal hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(
    final unit="1")
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-200,180},{-160,220}}),
        iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUp(
    final unit="1")
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-200,150},{-160,190}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_local(
    final unit="Pa",
    final quantity="PressureDifference")
    if (not have_serChi) and have_locSen
    "Chilled water pump Diferential static pressure setpoint for local sensor"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_local(
    final unit="Pa",
    final quantity="PressureDifference") if (not have_serChi) and have_locSen
    "Chilled water pump Diferential static pressure"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference",nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure setpoint for remote sensor"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference",nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure from remote sensor"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
    iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-200,-90},{-160,-50}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Stage up signal"
    annotation (Placement(transformation(extent={{160,-200},{200,-160}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final have_serChi=have_serChi,
    final faiSafTruDelay=faiSafTruDelay,
    final have_locSen=have_locSen,
    final nRemSen=nRemSen,
    final TDif=faiSafTDif,
    final TDifHys=TDifHys,
    final dpDif=faiSafDpDif,
    final dpDifHys=dpDifHys)
    "Failsafe condition of the current stage"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition effCon(
    final effConTruDelay = effConTruDelay,
    final sigDif=effConSigDif)
    "Efficiency condition of the current stage"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp
    "Or for staging up"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Or for staging up"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if have_WSE
    "Switches staging up rules"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysTSup(
    final uLow=smallTDif - TDifHys,
    final uHigh=smallTDif,
    final pre_y_start=false) if have_WSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysTSup1(
    final uLow=largeTDif - TDifHys,
    final uHigh=largeTDif,
    final pre_y_start=false) if have_WSE
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Or orStaUp1 if have_WSE
    "Or for staging up"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 if have_WSE
    "Temperature difference"
    annotation (Placement(transformation(extent={{-110,-40},{-90,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=longTDelay,
    final delayOnInit=true)
    if have_WSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=shortTDelay,
    final delayOnInit=true)
    if have_WSE
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSE(
    final k=true) if not have_WSE
    "Replacement signal for when a plant does not have a WSE"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noUp(
    final k=false)
    "No stage up signal when it is in initial stage"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg "Rising edge"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "If it is in initial stage, there will be stage up signal when enabling plant"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));

equation
  connect(uOpe, effCon.uOpe) annotation (Line(points={{-180,200},{-150,200},{-150,
          185},{-102,185}},color={0,0,127}));
  connect(uStaUp, effCon.uStaUp) annotation (Line(points={{-180,170},{-150,170},
          {-150,175},{-102,175}},color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-180,
          -30},{-140,-30},{-140,109},{-102,109}}, color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-180,-70},
          {-130,-70},{-130,106},{-102,106}}, color={0,0,127}));
  connect(dpChiWatPumSet_local, faiSafCon.dpChiWatPumSet_local) annotation (
      Line(points={{-180,140},{-120,140},{-120,101},{-102,101}}, color={0,0,127}));
  connect(dpChiWatPum_local, faiSafCon.dpChiWatPum_local) annotation (Line(
        points={{-180,110},{-150,110},{-150,98},{-102,98}},   color={0,0,127}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-98,-100},{20,-100},
          {20,80},{78,80}}, color={255,0,255}));
  connect(orStaUp.y, logSwi.u1) annotation (Line(points={{42,120},{60,120},{60,88},
          {78,88}},  color={255,0,255}));
  connect(sub1.y, hysTSup1.u)
    annotation (Line(points={{-88,-30},{-80,-30},{-80,-40},{-62,-40}}, color={0,0,127}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-38,0},{-22,0}},    color={255,0,255}));
  connect(hysTSup1.y, truDel1.u)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
  connect(truDel.y, orStaUp1.u1) annotation (Line(points={{2,0},{38,0}},
          color={255,0,255}));
  connect(truDel1.y, orStaUp1.u2) annotation (Line(points={{2,-40},{10,-40},{10,
          -8},{38,-8}}, color={255,0,255}));
  connect(orStaUp1.y, logSwi.u3) annotation (Line(points={{62,0},{70,0},{70,72},
          {78,72}}, color={255,0,255}));
  connect(noWSE.y, logSwi.u2)
    annotation (Line(points={{2,80},{78,80}},   color={255,0,255}));
  connect(noWSE.y, logSwi.u3) annotation (Line(points={{2,80},{30,80},{30,72},{78,
          72}},    color={255,0,255}));
  connect(u, intGreThr.u)
    annotation (Line(points={{-180,-100},{-122,-100}}, color={255,127,0}));
  connect(sub1.y, hysTSup.u) annotation (Line(points={{-88,-30},{-80,-30},{-80,0},
          {-62,0}},  color={0,0,127}));
  connect(TChiWatSup, sub1.u1) annotation (Line(points={{-180,-70},{-130,-70},{-130,
          -24},{-112,-24}}, color={0,0,127}));
  connect(TChiWatSupSet, sub1.u2) annotation (Line(points={{-180,-30},{-140,-30},
          {-140,-36},{-112,-36}}, color={0,0,127}));
  connect(uAvaCur, not1.u)
    annotation (Line(points={{-180,20},{-122,20}},   color={255,0,255}));
  connect(dpChiWatPumSet_remote, faiSafCon.dpChiWatPumSet_remote) annotation (
      Line(points={{-180,80},{-150,80},{-150,94},{-102,94}},     color={0,0,127}));
  connect(dpChiWatPum_remote, faiSafCon.dpChiWatPum_remote) annotation (Line(
        points={{-180,50},{-120,50},{-120,91},{-102,91}},   color={0,0,127}));
  connect(edg.y, lat.u)
    annotation (Line(points={{2,-180},{38,-180}}, color={255,0,255}));
  connect(lat.y, logSwi1.u2)
    annotation (Line(points={{62,-180},{118,-180}}, color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{102,80},{110,80},{110,
          -188},{118,-188}}, color={255,0,255}));
  connect(logSwi1.y, y)
    annotation (Line(points={{142,-180},{180,-180}}, color={255,0,255}));
  connect(noUp.y, logSwi1.u1) annotation (Line(points={{62,-140},{100,-140},{100,
          -172},{118,-172}}, color={255,0,255}));
  connect(logSwi.y, lat.clr) annotation (Line(points={{102,80},{110,80},{110,-110},
          {20,-110},{20,-186},{38,-186}}, color={255,0,255}));
  connect(uPla, edg.u)
    annotation (Line(points={{-180,-180},{-22,-180}}, color={255,0,255}));
  connect(not1.y, orStaUp.u2) annotation (Line(points={{-98,20},{10,20},{10,112},
          {18,112}}, color={255,0,255}));
  connect(faiSafCon.y, or2.u2) annotation (Line(points={{-78,100},{-60,100},{-60,
          112},{-42,112}}, color={255,0,255}));
  connect(effCon.y, or2.u1) annotation (Line(points={{-78,180},{-60,180},{-60,120},
          {-42,120}}, color={255,0,255}));
  connect(or2.y, orStaUp.u1)
    annotation (Line(points={{-18,120},{18,120}}, color={255,0,255}));
  annotation (defaultComponentName = "staUp",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
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
        extent={{-160,-220},{160,220}})),
Documentation(info="<html>
<p>Outputs a boolean stage up signal <code>y</code> based on the
various plant operation conditions that get provided as input signals.
Implemented according to 1711 March 2020 Draft, section 5.2.4.15.
 and applies to primary-only plant with and without a WSE.
</p>
<p>
The stage up signal becomes <code>true</code> when:
</p>
<ul>
<li>
Current stage becomes unavailable, or
</li>
<li>
Efficiency condition is true, or
</li>
<li>
Failsafe condition is true.
</li>
</ul>
<p>
If <code>have_WSE</code> boolean flag is true, staging up from WSE only to the first available
stage occurs when the chilled water supply temperature is sufficienctly above its setpoint
for either a shorter or a longer time period
</p>
<p>
Note that when the plant is enabled in chiller mode, the stage up signal will keep
false. The plant will control by the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 15, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Up;
