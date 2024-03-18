within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block FailsafeCondition
  "Failsafe condition used in staging up and down"

  parameter Boolean have_serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Boolean have_locSen = false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller"
    annotation (Dialog(enable=not have_serChi));

  parameter Integer nRemSen=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(enable=not have_serChi));

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
      "Enable delay";

  parameter Real TDif(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=1
      "Offset between the chilled water supply temperature and its setpoint";

  parameter Real TDifHys(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=1
      "Temperature hysteresis deadband";

  parameter Real dpDif(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=2 * 6895
      "Offset between the chilled water differential pressure and its setpoint";

  parameter Real dpDifHys(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=0.5 * 6895
      "Pressure difference hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_local(
    final unit="Pa",
    final quantity="PressureDifference")
    if (not have_serChi) and have_locSen
    "Chilled water differential pressure setpoint for local pressure sensor"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_local(
    final unit="Pa",
    final quantity="PressureDifference") if (not have_serChi) and have_locSen
    "Chilled water differential pressure from local pressure sensor"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference", nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure setpoint for remote sensor"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum_remote[nRemSen](
    final unit=fill("Pa", nRemSen),
    final quantity=fill("PressureDifference", nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Chilled water differential pressure from remote sensor"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Failsafe condition for chiller staging"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysdpSup(
    final uLow=dpDif - dpDifHys,
    final uHigh=dpDif) if (not have_serChi) and have_locSen
    "Checks how closely the chilled water pump differential pressure aproaches its setpoint from below"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysTSup(
    final uLow=TDif - TDifHys,
    final uHigh=TDif)
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysdpSup1[nRemSen](
    final uLow=fill(dpDif - dpDifHys, nRemSen),
    final uHigh=fill(dpDif, nRemSen))
    if (not have_serChi) and (not have_locSen)
    "Checks how closely the chilled water pump differential pressure aproaches its setpoint from below"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if have_serChi
    "Virtual signal for series chiller plants"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=faiSafTruDelay,
    final delayOnInit=false)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub0
    "Adder for temperatures"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    if (not have_serChi) and have_locSen
    "Subtracts differential pressures"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nRemSen)
    if (not have_serChi) and (not have_locSen)
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2[nRemSen]
    if (not have_serChi) and (not have_locSen)
    "Subtracts differential pressures"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[nRemSen](
    final delayTime=fill(faiSafTruDelay,nRemSen),
    final delayOnInit=fill(false, nRemSen))
    if (not have_serChi) and (not have_locSen) "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=faiSafTruDelay,
    final delayOnInit=false)
    if (not have_serChi) and have_locSen "Delays a true signal"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(sub1.y, hysdpSup.u)
    annotation (Line(points={{-78,0},{-62,0}}, color={0,0,127}));
  connect(dpChiWatPumSet_local, sub1.u1) annotation (Line(points={{-160,20},{-120,
          20},{-120,6},{-102,6}}, color={0,0,127}));
  connect(dpChiWatPum_local, sub1.u2) annotation (Line(points={{-160,-20},{-120,
          -20},{-120,-6},{-102,-6}}, color={0,0,127}));
  connect(sub0.y, hysTSup.u)
    annotation (Line(points={{-78,80},{-62,80}},   color={0,0,127}));
  connect(sub2.y, hysdpSup1.u)
    annotation (Line(points={{-78,-80},{-62,-80}}, color={0,0,127}));
  connect(dpChiWatPumSet_remote, sub2.u1) annotation (Line(points={{-160,-60},{-120,
          -60},{-120,-74},{-102,-74}}, color={0,0,127}));
  connect(dpChiWatPum_remote, sub2.u2) annotation (Line(points={{-160,-100},{-120,
          -100},{-120,-86},{-102,-86}}, color={0,0,127}));
  connect(or1.y, y)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));
  connect(hysTSup.y, truDel.u)
    annotation (Line(points={{-38,80},{-22,80}}, color={255,0,255}));
  connect(hysdpSup1.y, truDel1.u)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={255,0,255}));
  connect(hysdpSup.y, truDel2.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={255,0,255}));
  connect(truDel.y, or1.u1) annotation (Line(points={{2,80},{80,80},{80,0},{98,0}},
        color={255,0,255}));
  connect(truDel2.y, or1.u2) annotation (Line(points={{2,0},{60,0},{60,-8},{98,-8}},
        color={255,0,255}));
  connect(con.y, or1.u2) annotation (Line(points={{2,-40},{60,-40},{60,-8},{98,-8}},
        color={255,0,255}));
  connect(mulOr.y, or1.u2) annotation (Line(points={{42,-80},{60,-80},{60,-8},{98,
          -8}}, color={255,0,255}));
  connect(truDel1.y, mulOr.u)
    annotation (Line(points={{2,-80},{18,-80}}, color={255,0,255}));
  connect(TChiWatSupSet, sub0.u2) annotation (Line(points={{-160,90},{-130,90},{
          -130,74},{-102,74}}, color={0,0,127}));
  connect(TChiWatSup, sub0.u1) annotation (Line(points={{-160,50},{-120,50},{-120,
          86},{-102,86}}, color={0,0,127}));

annotation (defaultComponentName = "faiSafCon",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-120},{140,120}})),
Documentation(info="<html>
<p>Failsafe condition used in staging up and down, implemented according to the specification provided in section 5.2.4.15. 1711 March 2020 Draft. The subsequence applies to primary-only plants with and without a WSE. The sequence contains a boolean flag to differentiate between parallel and series chiller plants. </p>
</html>",
revisions="<html>
<ul>
<li>
January 21, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FailsafeCondition;
