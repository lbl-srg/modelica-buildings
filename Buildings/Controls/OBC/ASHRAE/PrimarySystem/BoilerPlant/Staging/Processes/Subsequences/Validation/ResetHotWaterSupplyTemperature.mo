within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.Validation;
model ResetHotWaterSupplyTemperature
    "Validate sequence of reseting hot water supply temperature"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature
    hotWatSupTemRes(
    final nSta=1,
    final delPro=300,
    final TMinSupNonConBoi=333.2,
    final sigDif=0.1)
    "Scenario testing reset for condensing boiler stage type"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature
    hotWatSupTemRes1(
    final nSta=2,
    final delPro=300,
    final TMinSupNonConBoi=333.2,
    final sigDif=0.1)
    "Scenario testing reset for lead non-condensing boiler stage type"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature
    hotWatSupTemRes2(
    final nSta=2,
    final delPro=300,
    final TMinSupNonConBoi=333.2,
    final sigDif=0.1)
    "Scenario testing reset for lag non-condensing boiler stage type"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=800)
    "Stage-up signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[1](
    final k={1})
    "Vector of stage types"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/3200,
    final offset=333.2)
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Current stage setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[2](
    final k={2,2})
    "Vector of stage types"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Current stage setpoint"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

equation
  connect(booPul.y, hotWatSupTemRes.uStaUp) annotation (Line(points={{-58,60},{-46,
          60},{-46,7},{-42,7}}, color={255,0,255}));

  connect(conInt.y, hotWatSupTemRes.uStaTyp) annotation (Line(points={{-58,-20},
          {-50,-20},{-50,-3},{-42,-3}}, color={255,127,0}));

  connect(sin.y, hotWatSupTemRes.THotWatSup) annotation (Line(points={{-58,20},{
          -50,20},{-50,3},{-42,3}}, color={0,0,127}));

  connect(conInt1.y, hotWatSupTemRes.uStaSet) annotation (Line(points={{-58,-60},
          {-46,-60},{-46,-7},{-42,-7}}, color={255,127,0}));

  connect(booPul.y, hotWatSupTemRes1.uStaUp) annotation (Line(points={{-58,60},{
          54,60},{54,7},{58,7}}, color={255,0,255}));

  connect(sin.y, hotWatSupTemRes1.THotWatSup) annotation (Line(points={{-58,20},
          {50,20},{50,3},{58,3}}, color={0,0,127}));

  connect(booPul.y, hotWatSupTemRes2.uStaUp) annotation (Line(points={{-58,60},{
          134,60},{134,7},{138,7}}, color={255,0,255}));

  connect(sin.y, hotWatSupTemRes2.THotWatSup) annotation (Line(points={{-58,20},
          {130,20},{130,3},{138,3}}, color={0,0,127}));

  connect(conInt3.y, hotWatSupTemRes2.uStaTyp) annotation (Line(points={{42,-20},
          {130,-20},{130,-3},{138,-3}}, color={255,127,0}));

  connect(conInt4.y, hotWatSupTemRes2.uStaSet) annotation (Line(points={{122,-60},
          {134,-60},{134,-7},{138,-7}}, color={255,127,0}));

  connect(conInt3.y, hotWatSupTemRes1.uStaTyp) annotation (Line(points={{42,-20},
          {50,-20},{50,-3},{58,-3}}, color={255,127,0}));

  connect(conInt1.y, hotWatSupTemRes1.uStaSet) annotation (Line(points={{-58,-60},
          {54,-60},{54,-7},{58,-7}}, color={255,127,0}));

annotation (
 experiment(
      StopTime=3200,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Subsequences/Validation/ResetHotWaterSupplyTemperature.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2020 by Karthik Devaprasad:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{180,100}})));
end ResetHotWaterSupplyTemperature;
