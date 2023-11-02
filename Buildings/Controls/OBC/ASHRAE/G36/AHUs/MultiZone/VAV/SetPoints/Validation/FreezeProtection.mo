within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model FreezeProtection
  "Validate model for implementing freeze protection"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection
    frePro(
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat)
    "Freeze protection control"
    annotation (Placement(transformation(extent={{80,0},{100,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDamPos(
    final height=0.5,
    final offset=0.1,
    final duration=3600) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    final k=0.1)
    "Outdoor air damper minimum position"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp heaCoiPos(
    final height=0.46,
    final offset=0.5,
    final duration=3600) "Heating coil position"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOutDamPos(
    final k=0.15)
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp retDamPos(
    final height=0.2,
    final offset=0.7,
    final duration=3600) "Return air damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse freRes(
    final width=0.95,
    final period=3600)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp supFanSpe(
    final height=0.2,
    final offset=0.5,
    final duration=3600) "Supply fan speed"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp cooCoiPos(
    final height=0.2,
    final offset=0.5,
    final duration=3600) "Cooling coil position"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp supTem(
    final height=-4,
    final offset=273.15 + 6,
    final duration=3600) "Supply air temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp mixTem(
    final height=-5,
    final offset=273.15 + 8,
    final duration=3600) "Mixed air temperature"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final h=0.01)
    "Check if the supply fan is proven on"
    annotation (Placement(transformation(extent={{0,-56},{20,-36}})));
equation
  connect(freRes.y, not1.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={255,0,255}));
  connect(outDamPosMin.y,frePro. uOutDamPosMin) annotation (Line(points={{-58,100},
          {64,100},{64,39},{78,39}},    color={0,0,127}));
  connect(outDamPos.y, frePro.uOutDam) annotation (Line(points={{-18,80},{60,80},
          {60,37},{78,37}}, color={0,0,127}));
  connect(heaCoiPos.y,frePro. uHeaCoi) annotation (Line(points={{-58,60},{56,60},
          {56,34},{78,34}},    color={0,0,127}));
  connect(minOutDamPos.y, frePro.uMinOutDam) annotation (Line(points={{-18,40},
          {52,40},{52,31},{78,31}}, color={0,0,127}));
  connect(retDamPos.y, frePro.uRetDam) annotation (Line(points={{-58,20},{40,20},
          {40,27},{78,27}}, color={0,0,127}));
  connect(supTem.y, frePro.TAirSup) annotation (Line(points={{-18,0},{44,0},{44,
          25},{78,25}}, color={0,0,127}));
  connect(not1.y, frePro.u1SofSwiRes) annotation (Line(points={{-18,-30},{48,-30},
          {48,20},{78,20}}, color={255,0,255}));
  connect(supFanSpe.y, frePro.uSupFan) annotation (Line(points={{-18,-60},{56,-60},
          {56,15},{78,15}}, color={0,0,127}));
  connect(cooCoiPos.y,frePro. uCooCoi) annotation (Line(points={{-58,-80},{60,-80},
          {60,3},{78,3}},      color={0,0,127}));
  connect(mixTem.y, frePro.TAirMix) annotation (Line(points={{-18,-100},{64,-100},
          {64,1},{78,1}}, color={0,0,127}));
  connect(supFanSpe.y, greThr.u) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -46},{-2,-46}}, color={0,0,127}));
  connect(greThr.y, frePro.u1SupFan) annotation (Line(points={{22,-46},{52,-46},
          {52,17},{78,17}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/FreezeProtection.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection</a>
for air handling unit serving multiple zones.
</p>
</html>", revisions="<html>
<ul>
<li>
February 6, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end FreezeProtection;
