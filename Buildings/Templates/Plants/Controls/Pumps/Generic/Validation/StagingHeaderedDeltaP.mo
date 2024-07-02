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
    timeScale=3600) "Flow ratio to design value"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable enaLea(
    table=[
      0, 1;
      8000, 0],
    period=8400)
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VPri_flow(
    final k=V_flow_nominal)
    "Flow rate"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP staPum(
    final nPum=nPum,
    nSenDp=1,
    final V_flow_nominal=V_flow_nominal)
    "Pump staging triggered by efficiency conditions only"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Utilities.StageIndex idxSta(
    have_inpAva=false,
    final nSta=nPum)
    "Calculate stage index = number of enabled pumps"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold y1[nPum](
    final t={i for i in 1:nPum})
    "Pump command"
    annotation (Placement(transformation(extent={{70,90},{50,110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    nout=nPum)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{30,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[nPum](
    each samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{0,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nPum]
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{-30,90},{-50,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max)
    "Loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPum(k=0.6)
    "Pump speed command"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP staPumFaiSaf(
    final nPum=nPum,
    nSenDp=1,
    final V_flow_nominal=V_flow_nominal,
    dVOffUp=0) "Pump staging triggered by failsafe conditions only"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Utilities.StageIndex idxSta1(have_inpAva=false, final nSta=nPum)
    "Calculate stage index = number of enabled pumps"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold y2[nPum](final t={i
        for i in 1:nPum})
    "Pump command"
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(nout=nPum)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nPum]
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{30,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1
                                                             [nPum](each
      samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{-10,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
                                                          [nPum]
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(k=fill(1/nPum*V_flow_nominal*
        0.99, nPum), nin=nPum)
    "Compute nPum_actual / nPum * V_flow_nominal * 0.99"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable dp(
    table=[0,-2*staPumFaiSaf.dpOff; 1,-2*staPumFaiSaf.dpOff; 1.5,0; 2,0],
    offset={dpSet.k},
    timeScale=3600) "Loop differential pressure"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable yPum1(table=[0,1; 1,1; 1.5,
        0.3; 2,0.3], timeScale=3600) "Pump speed command"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
equation
  connect(ratFlo.y[1], VPri_flow.u)
    annotation (Line(points={{-88,60},{-82,60}},
                                              color={0,0,127}));
  connect(VPri_flow.y, staPum.V_flow)
    annotation (Line(points={{-58,60},{-4,60},{-4,64},{8,64}}, color={0,0,127}));
  connect(staPum.y1Up, idxSta.u1Up)
    annotation (Line(points={{32,66},{36,66},{36,62},{48,62}},
                                                          color={255,0,255}));
  connect(staPum.y1Dow, idxSta.u1Dow)
    annotation (Line(points={{32,54},{36,54},{36,58},{48,58}},color={255,0,255}));
  connect(rep.y, y1.u)
    annotation (Line(points={{78,100},{72,100}},
                                              color={255,127,0}));
  connect(enaLea.y[1], idxSta.u1Lea)
    annotation (Line(points={{-88,120},{40,120},{40,66},{48,66}},
                                                             color={255,0,255}));
  connect(idxSta.y, rep.u)
    annotation (Line(points={{72,60},{110,60},{110,100},{102,100}},
                                                              color={255,127,0}));
  connect(y1.y, booToRea.u)
    annotation (Line(points={{48,100},{32,100}},
                                              color={255,0,255}));
  connect(booToRea.y, zerOrdHol.u)
    annotation (Line(points={{8,100},{2,100}},
                                             color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{-22,100},{-28,100}},
                                                color={0,0,127}));
  connect(greThr.y, staPum.u1_actual)
    annotation (Line(points={{-52,100},{-60,100},{-60,68},{8,68}},
      color={255,0,255}));
  connect(dpSet.y, staPum.dpSet[1]) annotation (Line(points={{-28,40},{-2,40},{-2,60},
          {8,60}}, color={0,0,127}));
  connect(dpSet.y, staPum.dp[1]) annotation (Line(points={{-28,40},{-2,40},{-2,56},
          {8,56}}, color={0,0,127}));
  connect(yPum.y, staPum.y)
    annotation (Line(points={{-88,20},{0,20},{0,52},{8,52}}, color={0,0,127}));
  connect(staPumFaiSaf.y1Up, idxSta1.u1Up) annotation (Line(points={{32,-54},{40,
          -54},{40,-58},{48,-58}}, color={255,0,255}));
  connect(rep1.y, y2.u)
    annotation (Line(points={{78,-20},{72,-20}}, color={255,127,0}));
  connect(enaLea.y[1], idxSta1.u1Lea) annotation (Line(points={{-88,120},{40,120},
          {40,-54},{48,-54}}, color={255,0,255}));
  connect(idxSta1.y, rep1.u) annotation (Line(points={{72,-60},{110,-60},{110,-20},
          {102,-20}}, color={255,127,0}));
  connect(y2.y, booToRea1.u)
    annotation (Line(points={{48,-20},{32,-20}}, color={255,0,255}));
  connect(booToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{8,-20},{-8,-20}}, color={0,0,127}));
  connect(zerOrdHol1.y, greThr1.u)
    annotation (Line(points={{-32,-20},{-38,-20}}, color={0,0,127}));
  connect(greThr1.y, staPumFaiSaf.u1_actual) annotation (Line(points={{-62,-20},
          {-70,-20},{-70,-52},{8,-52}}, color={255,0,255}));
  connect(zerOrdHol1.y, mulSum.u) annotation (Line(points={{-32,-20},{-36,-20},{
          -36,-40},{-110,-40},{-110,-60},{-102,-60}}, color={0,0,127}));
  connect(dp.y[1], staPumFaiSaf.dp[1]) annotation (Line(points={{-48,-80},{-2,-80},
          {-2,-64},{8,-64}}, color={0,0,127}));
  connect(dpSet.y, staPumFaiSaf.dpSet[1]) annotation (Line(points={{-28,40},{-2,40},
          {-2,-60},{8,-60}}, color={0,0,127}));
  connect(yPum1.y[1], staPumFaiSaf.y) annotation (Line(points={{-18,-100},{0,-100},
          {0,-68},{8,-68}}, color={0,0,127}));
  connect(staPumFaiSaf.y1Dow, idxSta1.u1Dow) annotation (Line(points={{32,-66},{
          40,-66},{40,-62},{48,-62}}, color={255,0,255}));
  connect(mulSum.y, staPumFaiSaf.V_flow) annotation (Line(points={{-78,-60},{-4,
          -60},{-4,-56},{8,-56}}, color={0,0,127}));
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
        extent={{-120,-140},{120,140}}),
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end StagingHeaderedDeltaP;
