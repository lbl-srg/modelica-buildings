within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules;
block SupplyAirflowDeviation
  "Detection of supply airflow deviating from the supply airflow setpoint"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real rSetMin(
    final min=0,
    final unit="1")=0.9
    "Lower ratio of the measured supply airflow to the supply airflow setpoint, below which a fault is detected";
  parameter Real rSetMax(
    final min=1,
    final unit="1")=1.1
    "Upper ratio of the measured supply airflow to the supply airflow setpoint, above which a fault is detected";
  parameter Real V_flowMin(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.0235974
    "Minimum absolute difference between the measured supply airflow and the supply airflow setpoint to detect a fault (50 cfm = 0.0235974 m3/s)";
  parameter Real V_flowHys(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.005
    "Hysteresis for the airflow comparisons";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow[nZon](
    each final unit="m3/s",
    each final quantity="VolumeFlowRate")
    "Measured VAV box discharge airflow"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDisSet_flow[nZon](
    each final unit="m3/s",
    each final quantity="VolumeFlowRate")
    "VAV box discharge airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAirFloDev[nZon]
    "True: the supply airflow does not meet the supply airflow setpoint"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulVSetMax[nZon](
    final k=fill(rSetMax, nZon))
    "Upper limit of the measured supply airflow, 1.1 times the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulVSetMin[nZon](
    final k=fill(rSetMin, nZon))
    "Lower limit of the measured supply airflow, 0.9 times the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greVDis[nZon](
    final h=fill(V_flowHys, nZon))
    "Check if the measured supply airflow is greater than 1.1 times the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesVDis[nZon](
    final h=fill(V_flowHys, nZon))
    "Check if the measured supply airflow is less than 0.9 times the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or orVDis[nZon]
    "Check if the measured supply airflow is either too high or too low"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dVDis[nZon]
    "Measured supply airflow minus the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Abs absDVDis[nZon]
    "Absolute difference between the measured supply airflow and the supply airflow setpoint"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greDVDis[nZon](
    final t=fill(V_flowMin, nZon),
    final h=fill(V_flowHys, nZon))
    "Check if the absolute airflow difference is greater than the minimum threshold"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And andVDis[nZon]
    "Check if both conditions for the supply airflow deviation are met"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(VDis_flow, lesVDis.u1) annotation (Line(points={{-160,70},{-80,70},{-80,
          -20},{-22,-20}},     color={0,0,127}));
  connect(VDis_flow, greVDis.u1) annotation (Line(points={{-160,70},{-80,70},{-80,
          80},{-42,80}},         color={0,0,127}));
  connect(VDis_flow, dVDis.u1) annotation (Line(points={{-160,70},{-100,70},{-100,
          -74},{-82,-74}},        color={0,0,127}));
  connect(VDisSet_flow, mulVSetMin.u)
    annotation (Line(points={{-160,0},{-120,0},{-120,-40},{-82,-40}},
                                                   color={0,0,127}));
  connect(VDisSet_flow, mulVSetMax.u) annotation (Line(points={{-160,0},{-120,0},
          {-120,100},{-102,100}},          color={0,0,127}));
  connect(VDisSet_flow, dVDis.u2) annotation (Line(points={{-160,0},{-120,0},{-120,
          -86},{-82,-86}},          color={0,0,127}));
  connect(mulVSetMax.y, greVDis.u2)
    annotation (Line(points={{-78,100},{-60,100},{-60,72},{-42,72}},
                                                    color={0,0,127}));
  connect(mulVSetMin.y, lesVDis.u2)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-28},{-22,-28}},
                                                  color={0,0,127}));
  connect(greVDis.y, orVDis.u1) annotation (Line(points={{-18,80},{20,80},{20,40},
          {38,40}},          color={255,0,255}));
  connect(lesVDis.y, orVDis.u2) annotation (Line(points={{2,-20},{20,-20},{20,32},
          {38,32}},         color={255,0,255}));
  connect(dVDis.y, absDVDis.u)
    annotation (Line(points={{-58,-80},{-42,-80}},  color={0,0,127}));
  connect(absDVDis.y, greDVDis.u)
    annotation (Line(points={{-18,-80},{-2,-80}},  color={0,0,127}));
  connect(greDVDis.y, andVDis.u2) annotation (Line(points={{22,-80},{40,-80},{40,
          -8},{98,-8}},     color={255,0,255}));
  connect(orVDis.y, andVDis.u1) annotation (Line(points={{62,40},{80,40},{80,0},
          {98,0}},      color={255,0,255}));
  connect(andVDis.y, yAirFloDev) annotation (Line(points={{122,0},{160,0}},
                           color={255,0,255}));
  annotation (defaultComponentName="supAirFloDev",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,100},{100,-100}}),
                    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
            120}})),
    Documentation(revisions="<html>
<ul>
<li>
November 25, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block detects whether the supply airflow of a VAV box does not meet the
supply airflow setpoint. The fault is detected when both of the following
conditions are true:
</p>
<ul>
<li>
The measured supply airflow <code>VDis_flow</code> is less than
<i>0.9</i> times the supply airflow setpoint <code>VDisSet_flow</code>, or
greater than <i>1.1</i> times the supply airflow setpoint. The ratio
thresholds are configured by the parameters <code>rSetMin</code> and
<code>rSetMax</code>.
</li>
<li>
The absolute difference between the measured supply airflow and the supply
airflow setpoint is greater than <code>V_flowMin</code>, which defaults to
<i>50 cfm = 0.0235974 m3/s</i>.
</li>
</ul>
<p>
The absolute difference condition avoids flagging a fault for small VAV boxes
or low cooling loads, where the measured airflow is close to the setpoint in
absolute terms even though the relative deviation exceeds the ratio thresholds.
</p>
<h4>Unit conversion</h4>
<p>
The threshold of <i>50 cfm</i> is converted to SI units as
<i>50 cfm &times; 0.0004719474432 m3&#8260;(s &middot; cfm) = 0.0235974 m3/s</i>.
</p>
</html>"));
end SupplyAirflowDeviation;
