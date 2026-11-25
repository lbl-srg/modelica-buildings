within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules;
block ZoneCoolingSetpointTooLow
  "Detection of a zone cooling setpoint that is too low"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real TCooSetLim(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.3722
    "Threshold of the zone cooling setpoint, below which the setpoint is considered too low (72 degF = 295.3722 K)";
  parameter Real dTHys(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=0.5
    "Hysteresis for the cooling setpoint comparison";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uExc[nZon]
    "True: the zone is exempt from the cooling setpoint lower limit check"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLowCooSet[nZon]
    "True: the zone cooling setpoint is too low"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesTCooSet[nZon](
    final t=fill(TCooSetLim, nZon),
    final h=fill(dTHys, nZon))
    "Check if the zone cooling setpoint is below the threshold"
    annotation (Placement(transformation(extent={{-90,40},{-50,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notExc[nZon]
    "Check if the zone is not exempt"
    annotation (Placement(transformation(extent={{-90,-60},{-50,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And andCooSet[nZon]
    "Check if both conditions for a too low zone cooling setpoint are met"
    annotation (Placement(transformation(extent={{0,0},{40,40}})));

equation
  connect(TCooSet, lesTCooSet.u)
    annotation (Line(points={{-138,60},{-92,60}}, color={0,0,127}));
  connect(uExc, notExc.u)
    annotation (Line(points={{-138,-40},{-92,-40}}, color={255,0,255}));
  connect(lesTCooSet.y, andCooSet.u1) annotation (Line(points={{-48,60},{-24,
          60},{-24,20},{-2,20}}, color={255,0,255}));
  connect(notExc.y, andCooSet.u2) annotation (Line(points={{-48,-40},{-24,-40},
          {-24,8},{-2,8}}, color={255,0,255}));
  connect(andCooSet.y, yLowCooSet) annotation (Line(points={{42,20},{90,20},{
          90,0},{138,0}}, color={255,0,255}));
  annotation (defaultComponentName="cooSetLow",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{
            180,100}})),
    Documentation(revisions="<html>
<ul>
<li>
November 25, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block detects whether the zone cooling temperature setpoint is too low.
The fault is detected when both of the following conditions are true:
</p>
<ul>
<li>
The zone cooling setpoint <code>TCooSet</code> is lower than
<code>TCooSetLim</code>, which defaults to <i>72 &deg;F = 295.3722 K</i>.
</li>
<li>
The zone is not exempt from this check, indicated by
<code>uExc = false</code>. The exemption input allows zones to be excluded
from this fault rule, for example zones with special temperature requirements.
</li>
</ul>
<h4>Unit conversion</h4>
<p>
The threshold of <i>72 &deg;F</i> is converted to Kelvin as
<i>(72 &deg;F &minus; 32 &deg;F) &times; 5&#8260;9 + 273.15 K = 295.3722 K</i>.
</p>
</html>"));
end ZoneCoolingSetpointTooLow;
