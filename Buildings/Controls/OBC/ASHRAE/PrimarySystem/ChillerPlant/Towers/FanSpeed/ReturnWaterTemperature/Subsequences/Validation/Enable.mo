within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model Enable
  "Validation sequence of enabling and disabling tower fans"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable
    enaTow "Enabling tower fans"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable
    disTow "Disable tower fans due to the low head pressure control maximum tower fan speed"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable
    disTow1 "Disable tower fans due to low fan speed and low tower temperature"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conRetSet(
    final k=273.15 + 32) "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant offTowSta[4](
    final k=fill(false,4)) "Tower is OFF"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conRet1(
    final height=2,
    final duration=3600,
    final offset=273.15 + 32.5) "Condenser return water temperature"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe1(
    final k=0.2)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe2(
    final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe(
    final k=0)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeConPum(
    final k=1)
    "Operating condenser water pumps"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe3(
    final k=0.1)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe4(
    final k=0.2)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe1(
    final k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conRetSet1(
    final k=273.15 + 32)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conRet2(
    final height=2,
    final duration=3600,
    final offset=273.15 + 32.5) "Condenser return water temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onTowSta1[4](
    final k=fill(true,4)) "Tower is ON"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeConPum1(
    final k=2) "Operating condenser water pumps"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe5(final k=0.2)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe6(final k=0.2)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe2(final k=0.1)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conRetSet2(
    final k=273.15 + 32) "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conRet3(
    final height=-2,
    final duration=3600,
    final offset=273.15 + 32.5) "Condenser return water temperature"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onTowSta2[4](
    final k=fill(true,4)) "Tower is ON"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeConPum2(
    final k=2)
    "Operating condenser water pumps"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
  connect(hpTowSpe1.y, enaTow.uMaxTowSpeSet[1])
    annotation (Line(points={{-198,90},{-180,90},{-180,60},{-142,60}},
      color={0,0,127}));
  connect(hpTowSpe2.y, enaTow.uMaxTowSpeSet[2])
    annotation (Line(points={{-238,70},{-180,70},{-180,60},{-142,60}},
      color={0,0,127}));
  connect(towFanSpe.y,enaTow.uFanSpe)
    annotation (Line(points={{-198,40},{-180,40},{-180,56},{-142,56}},
      color={0,0,127}));
  connect(conRetSet.y, enaTow.TTowSet) annotation (Line(points={{-198,0},{
          -174,0},{-174,52},{-142,52}}, color={0,0,127}));
  connect(conRet1.y, enaTow.TTow) annotation (Line(points={{-238,-30},{-168,
          -30},{-168,48},{-142,48}}, color={0,0,127}));
  connect(offTowSta.y, enaTow.uTow) annotation (Line(points={{-198,-50},{-162,-50},
          {-162,44},{-142,44}}, color={255,0,255}));
  connect(opeConPum.y, enaTow.uConWatPumNum)
    annotation (Line(points={{-238,-80},{-156,-80},{-156,40},{-142,40}},
      color={255,127,0}));
  connect(hpTowSpe3.y, disTow.uMaxTowSpeSet[1])
    annotation (Line(points={{-18,90},{0,90},{0,60},{38,60}}, color={0,0,127}));
  connect(hpTowSpe4.y, disTow.uMaxTowSpeSet[2])
    annotation (Line(points={{-58,70},{0,70},{0,60},{38,60}}, color={0,0,127}));
  connect(towFanSpe1.y,disTow.uFanSpe)
    annotation (Line(points={{-18,40},{0,40},{0,56},{38,56}}, color={0,0,127}));
  connect(conRetSet1.y, disTow.TTowSet)
    annotation (Line(points={{-18,0},{6,0},{6,52},{38,52}}, color={0,0,127}));
  connect(conRet2.y, disTow.TTow) annotation (Line(points={{-58,-30},{12,-30},
          {12,48},{38,48}}, color={0,0,127}));
  connect(onTowSta1.y, disTow.uTow) annotation (Line(points={{-18,-60},{18,-60},
          {18,44},{38,44}}, color={255,0,255}));
  connect(opeConPum1.y, disTow.uConWatPumNum)
    annotation (Line(points={{-58,-80},{24,-80},{24,40},{38,40}},
      color={255,127,0}));
  connect(hpTowSpe5.y, disTow1.uMaxTowSpeSet[1])
    annotation (Line(points={{162,90},{180,90},{180,60},{218,60}},
      color={0,0,127}));
  connect(hpTowSpe6.y, disTow1.uMaxTowSpeSet[2])
    annotation (Line(points={{122,70},{180,70},{180,60},{218,60}},
      color={0,0,127}));
  connect(towFanSpe2.y,disTow1.uFanSpe)
    annotation (Line(points={{162,40},{180,40},{180,56},{218,56}},
      color={0,0,127}));
  connect(conRetSet2.y, disTow1.TTowSet) annotation (Line(points={{162,0},
          {186,0},{186,52},{218,52}}, color={0,0,127}));
  connect(conRet3.y, disTow1.TTow) annotation (Line(points={{122,-30},{192,
          -30},{192,48},{218,48}}, color={0,0,127}));
  connect(onTowSta2.y, disTow1.uTow) annotation (Line(points={{162,-60},{198,-60},
          {198,44},{218,44}}, color={255,0,255}));
  connect(opeConPum2.y, disTow1.uConWatPumNum)
    annotation (Line(points={{122,-80},{204,-80},{204,40},{218,40}},
      color={255,127,0}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/Enable.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},{280,120}})));
end Enable;
