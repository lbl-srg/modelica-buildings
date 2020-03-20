within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block FailsafeCondition
  "Failsafe condition used in staging up and down"

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Modelica.SIunits.Time delayStaCha = 900
    "Enable delay";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Temperature hysteresis deadband";

  parameter Real hysSig = 0.05
    "Signal hysteresis deadband";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water differential pressure and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDifHys = 0.5 * 6895
    "Pressure difference hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference") if not serChi
    "Chilled water differential pressure"
    annotation (Placement(
    transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Failsafe condition for chiller staging"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysdpSup(final uLow=dpDif -
        dpDifHys, final uHigh=dpDif) if
                                     not serChi
    "Checks how closely the chilled water pump differential pressure aproaches its setpoint from below"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTSup(final uLow=TDif -
        TDifHys, final uHigh=TDif)
    "Checks if the chilled water supply temperature is higher than its setpoint plus an offset"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if serChi
    "Virtual signal for series chiller plants"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  CDL.Interfaces.BooleanInput                        uAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delayStaCha,
    final delayOnInit=true)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add0(
    final k1=-1,
    final k2=1) "Adder for temperatures"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=1,
    final k2=-1) if not serChi
    "Subtracts differential pressures"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

equation
  connect(add1.y, hysdpSup.u)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={0,0,127}));
  connect(dpChiWatPumSet, add1.u1) annotation (Line(points={{-160,0},{-120,0},{-120,
          -4},{-102,-4}},         color={0,0,127}));
  connect(dpChiWatPum, add1.u2) annotation (Line(points={{-160,-40},{-120,-40},{
          -120,-16},{-102,-16}},  color={0,0,127}));
  connect(hysTSup.y, or1.u1)
    annotation (Line(points={{-38,70},{18,70}},   color={255,0,255}));
  connect(add0.y, hysTSup.u)
    annotation (Line(points={{-78,70},{-62,70}},   color={0,0,127}));
  connect(TChiWatSupSet, add0.u1) annotation (Line(points={{-160,80},{-120,80},{
          -120,76},{-102,76}},
                          color={0,0,127}));
  connect(TChiWatSup, add0.u2) annotation (Line(points={{-160,40},{-120,40},{-120,
          64},{-102,64}},   color={0,0,127}));
  connect(hysdpSup.y, or1.u2) annotation (Line(points={{-38,-10},{0,-10},{0,62},
          {18,62}},  color={255,0,255}));
  connect(and2.y, truDel.u)
    annotation (Line(points={{82,0},{98,0}}, color={255,0,255}));
  connect(truDel.y, y)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));

  connect(con.y, or1.u2) annotation (Line(points={{-38,30},{-10,30},{-10,62},{18,
          62}},      color={255,0,255}));
  connect(or1.y, and2.u1) annotation (Line(points={{42,70},{50,70},{50,0},{58,0}},
        color={255,0,255}));
  connect(uAvaCur, and2.u2) annotation (Line(points={{-160,-80},{50,-80},{50,-8},
          {58,-8}}, color={255,0,255}));
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
          extent={{-140,-100},{140,100}})),
Documentation(info="<html>
<p>
Failsafe condition used in staging up and down,
implemented according to the specification provided in section 
5.2.4.15.6. and 10. in the December 2019 draft. The subsequence
applies to primary-only plants with and without a WSE. The 
sequence contains a boolean flag to differentiate between parallel and series chiller 
plants.
</p>
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
