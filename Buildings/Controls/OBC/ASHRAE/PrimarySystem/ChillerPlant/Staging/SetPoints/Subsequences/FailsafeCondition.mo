within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block FailsafeCondition
  "Failsafe condition used in staging up and down"

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Temperature hysteresis deadband";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water differential pressure and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDifHys = 0.5 * 6895
    "Pressure difference hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water differential pressure"
    annotation (Placement(
    transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Failsafe condition for chiller staging"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysdpSup(
    final uLow=dpDif - dpDifHys,
    final uHigh=dpDif) if not serChi
    "Checks how closely the chilled water pump differential pressure aproaches its setpoint from below"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(
    final uLow=TDif - TDifHys,
    final uHigh=TDif)
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if serChi
    "Virtual signal for series chiller plants"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=faiSafTruDelay, final delayOnInit=false)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) "Adder for temperatures"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=1,
    final k2=-1) if not serChi
    "Subtracts differential pressures"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(add1.y, hysdpSup.u)
    annotation (Line(points={{-78,-30},{-62,-30}}, color={0,0,127}));
  connect(dpChiWatPumSet, add1.u1) annotation (Line(points={{-160,-20},{-120,-20},
          {-120,-24},{-102,-24}}, color={0,0,127}));
  connect(dpChiWatPum, add1.u2) annotation (Line(points={{-160,-60},{-120,-60},{
          -120,-36},{-102,-36}},  color={0,0,127}));
  connect(hysTSup.y, or1.u1)
    annotation (Line(points={{-38,50},{-10,50},{-10,0},{38,0}},
                                                  color={255,0,255}));
  connect(add0.y, hysTSup.u)
    annotation (Line(points={{-78,50},{-62,50}},   color={0,0,127}));
  connect(TChiWatSupSet, add0.u1) annotation (Line(points={{-160,60},{-120,60},{
          -120,56},{-102,56}},
                          color={0,0,127}));
  connect(TChiWatSup, add0.u2) annotation (Line(points={{-160,20},{-120,20},{-120,
          44},{-102,44}},   color={0,0,127}));
  connect(hysdpSup.y, or1.u2) annotation (Line(points={{-38,-30},{-20,-30},{-20,
          -8},{38,-8}}, color={255,0,255}));
  connect(truDel.y, y)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));

  connect(con.y, or1.u2) annotation (Line(points={{-38,10},{-20,10},{-20,-8},{38,
          -8}}, color={255,0,255}));
  connect(or1.y, truDel.u)
    annotation (Line(points={{62,0},{98,0}}, color={255,0,255}));
annotation (defaultComponentName = "faiSafCon",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-80},{140,80}})),
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
