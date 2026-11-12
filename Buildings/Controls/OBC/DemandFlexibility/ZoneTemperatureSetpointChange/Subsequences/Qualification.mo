within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block Qualification "Zone qualification check"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real TZonMax[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Maximum zone temperature";
  parameter Real TZonHys(
    final unit="K",
    final quantity="TemperatureDifference",
    final min=0)
    "Zone temperature hysteresis";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaZon[nZon]
    "True: zone is starved"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRogZon[nZon]
    "True: zone is rogue"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yQua[nZon]
    "The zone is qualified for temperature setpoint change"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesTZonMax[nZon](
    final t=TZonMax,
    final h=fill(TZonHys, nZon))
    "Check if the zone temperature is less than the maximum zone temperature threshold"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notStaZon[nZon]
    "Check if the zone is not starved"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRogZon[nZon]
    "Check if the zone is not rogue"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And andTZonStaZon[nZon]
    "Check if both conditions for the zone temperature and the starved zone are met"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.And andAll[nZon]
    "Check if all 3 conditions are met"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(TZon, lesTZonMax.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(uStaZon, notStaZon.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={255,0,255}));
  connect(uRogZon, notRogZon.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={255,0,255}));
  connect(lesTZonMax.y, andTZonStaZon.u1)
    annotation (Line(points={{-58,60},{-40,60},{-40,30},{-22,30}}, color={255,0,255}));
  connect(notStaZon.y, andTZonStaZon.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,22},{-22,22}}, color={255,0,255}));
  connect(andTZonStaZon.y, andAll.u1)
    annotation (Line(points={{2,30},{20,30},{20,0},{38,0}}, color={255,0,255}));
  connect(notRogZon.y, andAll.u2)
    annotation (Line(points={{-58,-60},{20,-60},{20,-8},{38,-8}}, color={255,0,255}));
  connect(andAll.y, yQua)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));

  annotation (defaultComponentName="qua",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
      grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
      textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
October 22, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Qualification check of the zone temperature setpoint change
demand flexibility strategy.
</p>
<p>
A zone is considered to be qualified for zone temperature
setpoint change if all of the following conditions are true:
</p>
<ul>
<li>
the zone temperature <code>TZon</code> is less than
<code>TZonMax</code>,
</li>
<li>
the zone is not starved
</li>
<li>
the zone is not rogue.
</li>
</ul>
<p>
Each zone is evaluated independently, and the output is a
vector with one entry per zone. For each zone, if all three
conditions are met, the zone is qualified for temperature
setpoint change and <code>yQua[i] = true</code>. Otherwise, the
zone is not qualified and <code>yQua[i] = false</code>.
</p>
<p>
The zone temperature comparison includes a hysteresis to avoid
chattering of the output when the signal is close to its
threshold. The zone temperature is compared using the
hysteresis <code>TZonHys</code>: its condition switches to
<code>false</code> when the temperature rises above
<code>TZonMax</code> and switches back to <code>true</code>
when the temperature falls to <code>TZonMax</code> minus the
hysteresis.
</p>
</html>"));
end Qualification;
