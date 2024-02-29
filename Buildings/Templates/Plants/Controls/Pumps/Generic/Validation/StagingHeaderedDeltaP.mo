within Buildings.Templates.Plants.Controls.Pumps.Generic.Validation;
model StagingHeaderedDeltaP
  "Validation model for staging of headered variable speed pumps using ∆p pump speed control"
  parameter Integer nPum=4
    "Number of pumps that operate at design conditions";
  parameter Real V_flow_nominal=0.1
    "Design flow rate";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(
    table=[
      0, 0;
      1, 1;
      1.5, 1;
      2, 0],
    timeScale=3600)
    "Flow ratio to design value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable enaLea(
    table=[
      0, 1;
      8000, 0],
    period=8400)
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VPri_flow(
    final k=V_flow_nominal)
    "Flow rate"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP staPum(final
      nPum=nPum, final V_flow_nominal=V_flow_nominal) "Pump staging"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Utilities.StageIndex idxSta(
    final nSta=nPum)
    "Calculate stage index = number of enabled pumps"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava[nPum](
    each k=true)
    "Equipment available status"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold y1_actual[nPum](
      final t={i for i in 1:nPum}) "Evaluate pump status"
    annotation (Placement(transformation(extent={{20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    nout=nPum)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,50},{40,70}})));
equation
  connect(ratFlo.y[1], VPri_flow.u)
    annotation (Line(points={{-58,0},{-42,0}},color={0,0,127}));
  connect(VPri_flow.y, staPum.V_flow) annotation (Line(points={{-18,0},{-10,0},
          {-10,-6},{-2,-6}}, color={0,0,127}));
  connect(staPum.y1Up, idxSta.u1Up)
    annotation (Line(points={{22,6},{40,6},{40,2},{48,2}}, color={255,0,255}));
  connect(staPum.y1Dow, idxSta.u1Dow) annotation (Line(points={{22,-6},{40,-6},
          {40,-2},{48,-2}}, color={255,0,255}));
  connect(ava.y, idxSta.u1Ava)
    annotation (Line(points={{-58,-40},{40,-40},{40,-6},{48,-6}},color={255,0,255}));
  connect(rep.y, y1_actual.u)
    annotation (Line(points={{38,60},{22,60}}, color={255,127,0}));
  connect(y1_actual.y, staPum.u1_actual) annotation (Line(points={{-2,60},{-10,
          60},{-10,6},{-2,6}}, color={255,0,255}));
  connect(enaLea.y[1], idxSta.u1Lea)
    annotation (Line(points={{-58,40},{40,40},{40,6},{48,6}},color={255,0,255}));
  connect(idxSta.y, rep.u) annotation (Line(points={{72,0},{80,0},{80,60},{62,
          60}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Generic/Validation/StagingHeaderedDeltaP.mos"
        "Simulate and plot"),
    experiment(
      StopTime=8400.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP</a>
in a configuration with four pumps.
</p>
<p>
The simulation of this model shows that when the lead pump is enabled,
the output of the staging controller is greater than or equal to one.
The number of enabled pumps increases and decreases with the varying
flow rate and under the condition of a minimum runtime of <i>10</i>&nbsp;min.
It remains greater than or equal to one as long as the lead pump remains
enabled.
</p>
<p>
When the lead pump is disabled, the number of enabled pumps is set
to <i>0</i>. This transition is not subject to the minimum runtime.
</p>
</html>",
      revisions="<html>
<ul>
<li>
FIXME, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end StagingHeaderedDeltaP;
