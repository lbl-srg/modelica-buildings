within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.Validation;
model StageProcesses
  "Validation sequence of tower cells staging process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses
    enaPro(nTowCel=4) "Enable tower cells process"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses
    disPro(nTowCel=4)  "Disable tower cells process"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[4](
    final k=fill(false,4)) "Constant zero"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[4](
    final k={false,true,true,false})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Chiller stage up status"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.1,
    final period=3800) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[4] "Logical switch"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=4) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(10, 4)) "Isolation valve actual position"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[4] "Tower cell actual status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[4](final
      samplePeriod=fill(10, 4))     "Isolation valve actual position"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4](
    pre_u_start={false,true,true,false}) "Tower cell actual status"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[4] "Logical switch"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[4](
    final k={0,1,1,0})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

equation
  connect(booPul2.y, staUp1.u)
    annotation (Line(points={{-118,60},{-102,60}}, color={255,0,255}));
  connect(enaPro.yIsoVal, zerOrdHol.u) annotation (Line(points={{82,46},{92,46},
          {92,40},{98,40}}, color={0,0,127}));
  connect(zerOrdHol.y, enaPro.uIsoVal) annotation (Line(points={{122,40},{140,40},
          {140,20},{50,20},{50,40},{58,40}}, color={0,0,127}));
  connect(con2.y, logSwi.u1)
    annotation (Line(points={{-38,100},{-20,100},{-20,68},{-2,68}}, color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{-78,20},{-20,20},{-20,52},{-2,52}}, color={255,0,255}));
  connect(logSwi.y, enaPro.uChaCel) annotation (Line(points={{22,60},{30,60},{30,
          48},{58,48}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2)
    annotation (Line(points={{-38,60},{-2,60}},color={255,0,255}));
  connect(staUp1.y, booRep.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={255,0,255}));
  connect(enaPro.yTowSta, pre.u) annotation (Line(points={{82,40},{88,40},{88,0},
          {98,0}}, color={255,0,255}));
  connect(pre.y, enaPro.uTowSta) annotation (Line(points={{122,0},{140,0},{140,-20},
          {40,-20},{40,32},{58,32}}, color={255,0,255}));
  connect(disPro.yIsoVal, zerOrdHol1.u) annotation (Line(points={{82,-34},{92,-34},
          {92,-40},{98,-40}}, color={0,0,127}));
  connect(disPro.yTowSta, pre1.u) annotation (Line(points={{82,-40},{88,-40},{88,
          -80},{98,-80}}, color={255,0,255}));
  connect(pre1.y, disPro.uTowSta) annotation (Line(points={{122,-80},{140,-80},{
          140,-100},{40,-100},{40,-48},{58,-48}}, color={255,0,255}));
  connect(logSwi.y, disPro.uChaCel) annotation (Line(points={{22,60},{30,60},{30,
          -32},{58,-32}}, color={255,0,255}));
  connect(swi.y, disPro.uIsoVal)
    annotation (Line(points={{22,-40},{58,-40}}, color={0,0,127}));
  connect(booRep.y, swi.u2) annotation (Line(points={{-38,60},{-30,60},{-30,-40},
          {-2,-40}}, color={255,0,255}));
  connect(con1.y, swi.u3) annotation (Line(points={{-78,-70},{-40,-70},{-40,-48},
          {-2,-48}}, color={0,0,127}));
  connect(zerOrdHol1.y, swi.u1) annotation (Line(points={{122,-40},{140,-40},{140,
          -60},{-20,-60},{-20,-32},{-2,-32}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Staging/Subsequences/Validation/StageProcesses.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses</a>.
It demonstrates the process of enabling (<code>enaPro</code>) and
disabling (<code>disPro</code>) tower cells.
</p>
<ul>
<li>
For enabling process in instance <code>enaPro</code>, at 380 seconds,
the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
true, indicating that the status of cell 2 and 3 should be changed.
As the cell 2 and 3 are initially disabled, thus the cell 2 and 3
are being enabled. After the isolation valve of cell 2 and 3 being
slowly open from 380 seconds to fully open at 470 seconds, the two
cells are enabled.
</li>
<li>
For disabling process in instance <code>disPro</code>, at 380 seconds,
the input <code>uChaCel[2]</code> and <code>uChaCel[3]</code> are
true, indicating that the status of cell 2 and 3 should be changed.
As the cell 2 and 3 are initially enabled, thus the cell 2 and 3
are being disabled. Different from the enabling process, in the
disabling process, it shuts the isolation valve with no delay.
At the meantime, the two cells are disabled.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                   graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{160,120}})));
end StageProcesses;
