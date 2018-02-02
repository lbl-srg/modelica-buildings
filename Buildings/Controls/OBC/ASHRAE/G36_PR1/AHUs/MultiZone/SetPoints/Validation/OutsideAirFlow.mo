within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Validation;
model OutsideAirFlow
  "Validate the model of calculating minimum outdoor airflow setpoint"

  parameter Integer numZon = 5 "Total number of zones that the system serves";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSet_MulZon(numZon=numZon,
    AFlo=fill(40, numZon),
    maxSysPriFlo=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{54,0},{94,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSet_MulZon1(
    numZon=numZon,
    AFlo=fill(40, numZon),
    maxSysPriFlo=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20,
    have_occSen=false,
    have_winSen=false)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{54,-60},{94,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat[numZon](
    k={0.1,0.12,0.2,0.09,0.1})
    "Measured primary flow rate in each zone at VAV box"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc3(
    duration=3600,
    height=3,
    startTime=900) "Occupant number in zone 3"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc4(
    duration=3600,
    startTime=900,
    height=2) "Occupant number in zone 4"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc5(
    duration=3600,
    startTime=0,
    height=-3,
    offset=3) "Occupant number in zone 4"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[numZon](
    k=fill(false,numZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(
    k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[numZon](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[numZon](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

equation
  connect(winSta.y, outAirSet_MulZon.uWin)
    annotation (Line(points={{-39,-20},{16,-20},{16,16},{52,16}},
      color={255,0,255}));
  connect(supFan.y, outAirSet_MulZon.uSupFan)
    annotation (Line(points={{-39,-50},{24,-50},{24,12},{52,12}},
      color={255,0,255}));
  connect(zonPriFloRat.y, outAirSet_MulZon.VBox_flow)
    annotation (Line(points={{21,-80},{40,-80},{40,2},{52,2}},
      color={0,0, 127}));
  connect(TZon.y, outAirSet_MulZon.TZon)
    annotation (Line(points={{-39,40},{-8,40},{-8,30},{52,30}},
      color={0,0,127}));
  connect(TDis.y,outAirSet_MulZon.TDis)
    annotation (Line(points={{-39,10},{8,10},{8,24},{52,24}},
      color={0,0,127}));
  connect(numOfOcc1.y, outAirSet_MulZon.nOcc[1])
    annotation (Line(points={{-69,80},{-60,80},{-60,60},{0,60},{0,36},{52,36}},
      color={0,0,127}));
  connect(numOfOcc2.y, outAirSet_MulZon.nOcc[2])
    annotation (Line(points={{-29,80},{-20,80},{-20,60},{0,60},{0,36},{52,36}},
      color={0,0,127}));
  connect(numOfOcc3.y, outAirSet_MulZon.nOcc[3])
    annotation (Line(points={{11,80},{20,80},{20,60},{0,60},{0,36},{52,36}},
      color={0,0,127}));
  connect(numOfOcc4.y, outAirSet_MulZon.nOcc[4])
    annotation (Line(points={{51,80},{60,80},{60,60},{0,60},{0,36},{52,36}},
      color={0,0,127}));
  connect(numOfOcc5.y, outAirSet_MulZon.nOcc[5])
    annotation (Line(points={{91,80},{96,80},{96,60},{0,60},{0,36},{52,36}},
      color={0,0,127}));
  connect(opeMod.y, outAirSet_MulZon.uOpeMod)
    annotation (Line(points={{-39,-80},{-20,-80},{-20,-60},{32,-60},{32,8},{52,8}},
      color={255,127,0}));
  connect(zonPriFloRat.y, outAirSet_MulZon1.VBox_flow)
    annotation (Line(points={{21,-80},{40,-80},{40,-58},{52,-58}},
      color={0,0,127}));
  connect(opeMod.y, outAirSet_MulZon1.uOpeMod)
    annotation (Line(points={{-39,-80},{-20,-80},{-20,-60},{32,-60},{32,-52},
      {52,-52}}, color={255,127,0}));
  connect(supFan.y, outAirSet_MulZon1.uSupFan)
    annotation (Line(points={{-39,-50},{24,-50},{24,-48},{52,-48}},
      color={255,0,255}));
  connect(TDis.y, outAirSet_MulZon1.TDis)
    annotation (Line(points={{-39,10},{8,10},{8,-36},{52,-36}},
      color={0,0,127}));
  connect(TZon.y, outAirSet_MulZon1.TZon)
    annotation (Line(points={{-39,40},{-8,40},{-8,-30},{52,-30}},
      color={0,0,127}));

  annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/SetPoints/Validation/OutsideAirFlow.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end OutsideAirFlow;
