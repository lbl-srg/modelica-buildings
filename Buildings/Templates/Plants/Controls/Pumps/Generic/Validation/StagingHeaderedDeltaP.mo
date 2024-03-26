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
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable enaLea(
    table=[
      0, 1;
      8000, 0],
    period=8400)
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VPri_flow(
    final k=V_flow_nominal)
    "Flow rate"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP staPum(
    final nPum=nPum,
    final V_flow_nominal=V_flow_nominal)
    "Pump staging"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Utilities.StageIndex idxSta(
    have_inpAva=false,
    final nSta=nPum,
    final dtRun=staPum.dtRun)
    "Calculate stage index = number of enabled pumps"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold y1[nPum](
    final t={i for i in 1:nPum})
    "Pump command"
    annotation (Placement(transformation(extent={{62,50},{42,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    nout=nPum)
    "Replicate signal"
    annotation (Placement(transformation(extent={{92,50},{72,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{32,50},{12,70}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[nPum](
    each samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{2,50},{-18,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nPum]
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{-28,50},{-48,70}})));
equation
  connect(ratFlo.y[1], VPri_flow.u)
    annotation (Line(points={{-88,0},{-42,0}},color={0,0,127}));
  connect(VPri_flow.y, staPum.V_flow)
    annotation (Line(points={{-18,0},{-10,0},{-10,-6},{-2,-6}},color={0,0,127}));
  connect(staPum.y1Up, idxSta.u1Up)
    annotation (Line(points={{22,6},{40,6},{40,2},{48,2}},color={255,0,255}));
  connect(staPum.y1Dow, idxSta.u1Dow)
    annotation (Line(points={{22,-6},{40,-6},{40,-2},{48,-2}},color={255,0,255}));
  connect(rep.y, y1.u)
    annotation (Line(points={{70,60},{64,60}},color={255,127,0}));
  connect(enaLea.y[1], idxSta.u1Lea)
    annotation (Line(points={{-88,40},{40,40},{40,6},{48,6}},color={255,0,255}));
  connect(idxSta.y, rep.u)
    annotation (Line(points={{72,0},{100,0},{100,60},{94,60}},color={255,127,0}));
  connect(y1.y, booToRea.u)
    annotation (Line(points={{40,60},{34,60}},color={255,0,255}));
  connect(booToRea.y, zerOrdHol.u)
    annotation (Line(points={{10,60},{4,60}},color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{-20,60},{-26,60}},color={0,0,127}));
  connect(greThr.y, staPum.u1_actual)
    annotation (Line(points={{-50,60},{-60,60},{-60,20},{-10,20},{-10,6},{-2,6}},
      color={255,0,255}));
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
March 29, 2024, by Antoine Gautier:<br/>
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
      coordinateSystem(
        extent={{-120,-100},{120,100}}),
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end StagingHeaderedDeltaP;
