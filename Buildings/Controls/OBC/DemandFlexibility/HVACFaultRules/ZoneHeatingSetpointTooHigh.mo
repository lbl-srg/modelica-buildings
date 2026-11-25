within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules;
block ZoneHeatingSetpointTooHigh
  "Detection of a zone heating setpoint that is too high"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real THeaSetLim(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.3722
    "Threshold of the zone heating setpoint, above which the setpoint is considered too high (72 degF = 295.3722 K)";
  parameter Real dTHys(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=0.5
    "Hysteresis for the heating setpoint comparison";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uExc[nZon]
    "True: the zone is exempt from the heating setpoint upper limit check"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigHeaSet[nZon]
    "True: the zone heating setpoint is too high"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greTHeaSet[nZon](
    final t=fill(THeaSetLim, nZon),
    final h=fill(dTHys, nZon))
    "Check if the zone heating setpoint is above the threshold"
    annotation (Placement(transformation(extent={{-90,40},{-50,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notExc[nZon]
    "Check if the zone is not exempt"
    annotation (Placement(transformation(extent={{-90,-60},{-50,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And andHeaSet[nZon]
    "Check if both conditions for a too high zone heating setpoint are met"
    annotation (Placement(transformation(extent={{0,0},{40,40}})));

equation
  connect(THeaSet, greTHeaSet.u)
    annotation (Line(points={{-160,60},{-92,60}}, color={0,0,127}));
  connect(uExc, notExc.u)
    annotation (Line(points={{-160,-40},{-92,-40}}, color={255,0,255}));
  connect(greTHeaSet.y, andHeaSet.u1) annotation (Line(points={{-48,60},{-24,
          60},{-24,20},{-2,20}}, color={255,0,255}));
  connect(notExc.y, andHeaSet.u2) annotation (Line(points={{-48,-40},{-24,-40},
          {-24,8},{-2,8}}, color={255,0,255}));
  connect(andHeaSet.y, yHigHeaSet) annotation (Line(points={{42,20},{90,20},{90,
          0},{160,0}},    color={255,0,255}));
  annotation (defaultComponentName="heaSetHig",
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
This block detects whether the zone heating temperature setpoint is too high.
The fault is detected when both of the following conditions are true:
</p>
<ul>
<li>
The zone heating setpoint <code>THeaSet</code> is higher than
<code>THeaSetLim</code>, which defaults to <i>72 &deg;F = 295.3722 K</i>.
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
end ZoneHeatingSetpointTooHigh;
