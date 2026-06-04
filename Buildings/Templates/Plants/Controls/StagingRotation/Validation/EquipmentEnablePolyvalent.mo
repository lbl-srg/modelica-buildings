within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model EquipmentEnablePolyvalent
  "Validation model for polyvalent HP enable logic"
  parameter Integer nHp = 2
    "Number of reversible heat pumps"
    annotation (Evaluate=true);
  parameter Integer nShc = 2
    "Number of polyvalent units"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaHp(
    table=[0,1,1; 80,0,1],
    timeScale=1,
    period=100) "HP available signal"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnablePolyvalent
    enaEqu(final nHp=nHp, final nShc=nShc) "Compute array of enabled equipment"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uSta(
    table=[0,0; 10,1; 20,2; 30,3; 40,4],
    timeScale=1,
    period=50) "Stage index"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  PolyvalentHeatPumps.StagingParameters staPar(final nHp=nHp, final nShc=nShc)
    "Generate staging parameters"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extractStagingMatrix2D(final sta=
        staPar.staCoo, is_transpose=true)
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaShc1(
    table=[0,1,1],
    timeScale=1,
    period=100)
               "Polyvalent HP available signal in single mode"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaShc2(
    table=[0,1,1],
    timeScale=1,
    period=100)
               "Polyvalent HP available signal in SHC mode"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSorHp[nHp](k={i for i in
            1:nHp}) "HP runtime order"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSorShc[nShc](k={i
        for i in nShc:-1:1}) "Polyvalent HP runtime order"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uStaOpp(
    table=[0,0; 60,3],
    timeScale=1,
    period=100) "Opposite mode stage index"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
equation
  connect(uSta.y[1], enaEqu.uSta)
    annotation (Line(points={{-68,0},{8,0}}, color={255,127,0}));
  connect(extractStagingMatrix2D.y, enaEqu.staTra)
    annotation (Line(points={{-8,20},{0,20},{0,8},{8,8}}, color={0,0,127}));
  connect(u1AvaHp.y, enaEqu.u1HpAva) annotation (Line(points={{-68,-40},{0,-40},
          {0,-4},{8,-4}}, color={255,0,255}));
  connect(u1AvaShc1.y, enaEqu.u1Shc1Ava) annotation (Line(points={{-38,-60},{-18,
          -60},{-18,-6},{8,-6}}, color={255,0,255}));
  connect(u1AvaShc2.y, enaEqu.u1Shc2Ava) annotation (Line(points={{-68,-80},{-16,
          -80},{-16,-8},{8,-8}}, color={255,0,255}));
  connect(idxSorHp.y, enaEqu.uIdxHpSor)
    annotation (Line(points={{-38,60},{4,60},{4,6},{8,6}}, color={255,127,0}));
  connect(idxSorShc.y, enaEqu.uIdxShcSor)
    annotation (Line(points={{-68,40},{2,40},{2,4},{8,4}}, color={255,127,0}));
  connect(uStaOpp.y[1], extractStagingMatrix2D.u)
    annotation (Line(points={{-38,20},{-32,20}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/EquipmentEnablePolyvalent.mos"
        "Simulate and plot"),
    experiment(
      StopTime=100.0,
      Tolerance=1e-06),
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
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnablePolyvalent\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnablePolyvalent</a>
in a configuration with three equally sized units (component <code>equEnaEqu</code>)
and in a configuration with one small unit and two large equally sized
units (component <code>equEnaOneTwo</code>).
Only the units of the same size are lead/lag alternated.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquipmentEnablePolyvalent;
