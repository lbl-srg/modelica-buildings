within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model EquipmentAvailability
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentAvailability_state avaHeaCoo(
    have_heaWat=true,
    have_chiWat=true)
    "Evaluate equipment availability – Heating and cooling"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Ava(
    table=[
      0, 1;
      8, 0;
      9, 1],
    timeScale=1000,
    period=10000)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1_actual(
    table=[
      0, 1;
      1, 0;
      2.5, 1;
      4.2, 0;
      5, 1;
      7, 1;
      8, 0;
      9, 1],
    timeScale=1000,
    period=10000)
    "Equipment status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea_actual(
    table=[
      0, 1;
      1, 1;
      2, 1;
      5, 0;
      8.5, 1;
      9.7, 0],
    timeScale=1000,
    period=10000)
    "Equipment operating mode"
    annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentAvailability avaHea(
    have_heaWat=true,
    have_chiWat=false)
    "Evaluate equipment availability – Heating only"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentAvailability_state avaHeaCoo_state(
    have_heaWat=true,
    have_chiWat=true)
    "Evaluate equipment availability – Heating and cooling"
    annotation (Placement(transformation(extent={{50,24},{70,44}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentAvailability_state avaHea_state(
    have_heaWat=true,
    have_chiWat=false)
    "Evaluate equipment availability – Heating only"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation
  connect(u1Hea_actual.y[1], avaHeaCoo.u1Hea) annotation (Line(points={{-58,-38},
          {-30,-38},{-30,-6},{-2,-6}}, color={255,0,255}));
  connect(u1_actual.y[1], avaHeaCoo.u1) annotation (Line(points={{-58,40},{-20,
          40},{-20,6},{-2,6}}, color={255,0,255}));
  connect(u1_actual.y[1], avaHea.u1) annotation (Line(points={{-58,40},{-20,40},
          {-20,-54},{-2,-54}}, color={255,0,255}));
  connect(u1Ava.y[1], avaHeaCoo.u1Ava)
    annotation (Line(points={{-58,0},{-2,0}},color={255,0,255}));
  connect(u1Ava.y[1], avaHea.u1Ava)
    annotation (Line(points={{-58,0},{-40,0},{-40,-60},{-2,-60}},color={255,0,255}));
  connect(u1Hea_actual.y[1], avaHeaCoo_state.u1Hea) annotation (Line(points={{-58,
          -38},{-30,-38},{-30,28},{48,28}}, color={255,0,255}));
  connect(u1_actual.y[1], avaHeaCoo_state.u1)
    annotation (Line(points={{-58,40},{48,40}}, color={255,0,255}));
  connect(u1Ava.y[1], avaHeaCoo_state.u1Ava)
    annotation (Line(points={{-58,0},{-40,0},{-40,34},{48,34}},color={255,0,255}));
  connect(u1_actual.y[1], avaHea_state.u1) annotation (Line(points={{-58,40},{
          40,40},{40,-74},{48,-74}}, color={255,0,255}));
  connect(u1Ava.y[1], avaHea_state.u1Ava)
    annotation (Line(points={{-58,0},{-40,0},{-40,-80},{48,-80}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/EquipmentAvailability.mos"
        "Simulate and plot"),
    experiment(
      StopTime=10000.0,
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
end EquipmentAvailability;
