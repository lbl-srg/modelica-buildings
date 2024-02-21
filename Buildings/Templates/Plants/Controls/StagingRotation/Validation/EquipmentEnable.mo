within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model EquipmentEnable
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[
    0,1,1,1;
    6,0,0,1;
    8,0,1,1;
    10,1,0,1;
    15,1,1,0;
    18,0,1,1;
    22,1,1,1],
    timeScale=1,
    period=25) "Equipment available signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable
    equEnaOneTwo(staEqu=[1,0,0; 0,0.5,0.5; 1,0.5,0.5; 0,1,1; 1,1,1])
    "Compute array of enabled equipment – One small equipment, two large equally sized equipment"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uSta(
    table=[0,1; 5,2; 10,3; 15,4; 20,5],
    timeScale=1,
    period=25) "Stage index"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable equEnaEqu(
      staEqu=[0.33,0.33,0.33; 0.66,0.66,0.66; 1,1,1])
    "Compute array of enabled equipment – Equally sized units"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uSta1(
    table=[0,1; 10,2; 20,3],
    timeScale=1,
    period=25) "Stage index"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    "Cast to real"
    annotation (Placement(transformation(extent={{-28,50},{-8,70}})));
  Utilities.SortWithIndices sort(ascending=false, nin=3)
    "Sort lead/lag alternate equipment with available equipment first"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Cast to real"
    annotation (Placement(transformation(extent={{-28,-90},{-8,-70}})));
  Utilities.SortWithIndices sort1(ascending=false, nin=2)
    "Sort lead/lag alternate equipment with available equipment first"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar[2](each final p=1)
    "Restore indices with respect to original vector u1AvaEqu"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
equation
  connect(u1AvaEqu.y, equEnaOneTwo.u1AvaEqu) annotation (Line(points={{-58,-40},
          {-40,-40},{-40,-46},{68,-46}},
                                 color={255,0,255}));
  connect(uSta.y[1], equEnaOneTwo.uSta) annotation (Line(points={{-58,0},{40,0},
          {40,-40},{68,-40}},   color={255,127,0}));
  connect(uSta1.y[1], equEnaEqu.uSta) annotation (Line(points={{-58,40},{30,40},
          {30,40},{68,40}},   color={255,127,0}));
  connect(u1AvaEqu.y, equEnaEqu.u1AvaEqu) annotation (Line(points={{-58,-40},{-40,
          -40},{-40,34},{68,34}},      color={255,0,255}));
  connect(u1AvaEqu.y, booToRea.u) annotation (Line(points={{-58,-40},{-40,-40},{
          -40,60},{-30,60}}, color={255,0,255}));
  connect(booToRea.y, sort.u)
    annotation (Line(points={{-6,60},{-2,60}},color={0,0,127}));
  connect(sort.yIdx, equEnaEqu.uIdxAltSor) annotation (Line(points={{22,54},{60,
          54},{60,46},{68,46}},     color={255,127,0}));
  connect(u1AvaEqu.y[2:3], booToRea1.u) annotation (Line(points={{-58,-40},{-40,
          -40},{-40,-80},{-30,-80}}, color={255,0,255}));
  connect(booToRea1.y, sort1.u) annotation (Line(points={{-6,-80},{-2,-80}},
                                        color={0,0,127}));
  connect(sort1.yIdx, addPar.u) annotation (Line(points={{22,-86},{26,-86},{26,
          -80},{28,-80}},
                     color={255,127,0}));
  connect(addPar.y, equEnaOneTwo.uIdxAltSor) annotation (Line(points={{52,-80},
          {60,-80},{60,-34},{68,-34}},color={255,127,0}));
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end EquipmentEnable;
