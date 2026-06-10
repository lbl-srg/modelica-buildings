within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model EquipmentEnable "Validation model for equipment enable logic"
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[
      0, 1, 1, 1;
      6, 0, 0, 1;
      8, 0, 1, 1;
      10, 1, 0, 1;
      15, 1, 1, 0;
      18, 0, 1, 1;
      22, 1, 1, 1],
    timeScale=1,
    period=25)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable equEnaOneTwo(
    staEqu=[
      1, 0, 0;
      0, 1 / 2, 1 / 2;
      1, 1 / 2, 1 / 2;
      0, 1, 1;
      1, 1, 1])
    "Compute array of enabled equipment – One small equipment, two large equally sized equipment"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uSta(
    table=[
      0, 1;
      5, 2;
      10, 3;
      15, 4;
      20, 5],
    timeScale=1,
    period=25)
    "Stage index"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable equEnaEqu(staEqu=[1
        /3,1/3,1/3; 2/3,2/3,2/3; 1,1,1])
    "Compute array of enabled equipment – Equally sized units"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uSta1(
    table=[
      0, 1;
      10, 2;
      20, 3],
    timeScale=1,
    period=25)
    "Stage index"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime sorRunTim(
      idxEquAlt={2,3},
    runTim_start={i for i in 1:2},
                       nin=3)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Components.Controls.StatusEmulator sta[3](each delayTime=0.1)
    "Equipment status"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime sorRunTim1(
      runTim_start={i for i in 1:3},
                       nin=3) "Sort equipment runtime"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Components.Controls.StatusEmulator sta1[3](each delayTime=0.1)
    "Equipment status"
    annotation (Placement(transformation(extent={{60,70},{40,90}})));
equation
  connect(u1AvaEqu.y, equEnaOneTwo.u1Ava)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-46},{68,-46}},color={255,0,255}));
  connect(uSta.y[1], equEnaOneTwo.uSta)
    annotation (Line(points={{-58,-80},{40,-80},{40,-40},{68,-40}},
                                                               color={255,127,0}));
  connect(uSta1.y[1], equEnaEqu.uSta)
    annotation (Line(points={{-58,40},{68,40}},color={255,127,0}));
  connect(u1AvaEqu.y, equEnaEqu.u1Ava)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,34},{68,34}},color={255,0,255}));
  connect(u1AvaEqu.y[1:3], sorRunTim.u1Ava[1:3]) annotation (Line(points={{-58,-40},
          {-40,-40},{-40,-26},{-12,-26},{-12,-25.3333}}, color={255,0,255}));
  connect(sorRunTim.yIdx, equEnaOneTwo.uIdxAltSor) annotation (Line(points={{12,-26},
          {60,-26},{60,-34},{68,-34}},      color={255,127,0}));
  connect(equEnaOneTwo.y1, sta.y1) annotation (Line(points={{92,-40},{96,-40},{
          96,0},{62,0}},       color={255,0,255}));
  connect(sta.y1_actual, sorRunTim.u1Run) annotation (Line(points={{38,0},{-20,
          0},{-20,-14},{-12,-14}},       color={255,0,255}));
  connect(u1AvaEqu.y[1:3], sorRunTim1.u1Ava[1:3]) annotation (Line(points={{-58,-40},
          {-40,-40},{-40,54},{-12,54},{-12,54.6667}},  color={255,0,255}));
  connect(equEnaEqu.y1, sta1.y1) annotation (Line(points={{92,40},{96,40},{96,
          80},{62,80}}, color={255,0,255}));
  connect(sta1.y1_actual, sorRunTim1.u1Run[1:3]) annotation (Line(points={{38,80},
          {-20,80},{-20,66.6667},{-12,66.6667}},                   color={255,0,
          255}));
  connect(sorRunTim1.yIdx, equEnaEqu.uIdxAltSor) annotation (Line(points={{12,
          54},{60,54},{60,46},{68,46}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/EquipmentEnable.mos"
        "Simulate and plot"),
    experiment(
      StopTime=25.0,
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
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
in a configuration with three equally sized units (component <code>equEnaEqu</code>)
and in a configuration with one small unit and two large equally sized
units (component <code>equEnaOneTwo</code>).
Only the units of the same size are lead/lag alternated.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Antoine Gautier:<br/>
Refactored with status emulator and runtime sorter.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquipmentEnable;
