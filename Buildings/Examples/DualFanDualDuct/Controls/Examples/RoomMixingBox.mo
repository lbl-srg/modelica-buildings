within Buildings.Examples.DualFanDualDuct.Controls.Examples;
model RoomMixingBox "Test model for room mixing box"
extends Modelica.Icons.Example;
  Buildings.Examples.DualFanDualDuct.Controls.RoomMixingBox conMix(m_flow_min=1)
    "Controller for mixing box"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant TH(k=273.15 + 20)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant TC(k=273.15 + 26)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Trapezoid TRoo(
    amplitude=15,
    rising=900,
    width=900,
    falling=900,
    period=3600,
    offset=273.15 + 15) "Room temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Trapezoid m_flow(
    rising=900,
    width=900,
    falling=900,
    period=3600,
    amplitude=2,
    offset=0,
    startTime=3600) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFan(k=true)
    "Fan control signal"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation

  connect(TH.y, conMix.TRooSetHea) annotation (Line(
      points={{-59,40},{-42,40},{-42,14},{-22,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TC.y, conMix.TRooSetCoo) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, conMix.TRoo) annotation (Line(
      points={{-59,70},{-40,70},{-40,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, conMix.mAir_flow) annotation (Line(
      points={{-59,-20},{-40,-20},{-40,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yFan.y, conMix.yFan) annotation (Line(points={{-59,-50},{-32,-50},{
          -32,2},{-22,2}}, color={255,0,255}));
  annotation (
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DualFanDualDuct/Controls/Examples/RoomMixingBox.mos"
        "Simulate and plot"),
    experiment(
      StopTime=10800,
      Tolerance=1e-06));
end RoomMixingBox;
