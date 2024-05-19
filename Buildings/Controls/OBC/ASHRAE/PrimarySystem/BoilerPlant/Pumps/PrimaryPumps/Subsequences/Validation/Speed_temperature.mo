within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Validation;
model Speed_temperature
  "Validate sequence of controlling hot water pump speed for primary-secondary plants with temperature sensors"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature
    hotPumSpe(
    final primarySecondarySensors=true,
    final nBoi=2,
    final nPum=2,
    final boiDesFlo={0.25,0.5},
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1)
    "Testing controller for plant with temperature sensors in primary and secondary loops"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature
    hotPumSpe1(
    final primarySecondarySensors=false,
    final nBoi=2,
    final nPum=2,
    final boiDesFlo={0.25,0.5},
    final twoReqLimLow=1.2,
    final twoReqLimHig=2,
    final oneReqLimLow=0.2,
    final oneReqLimHig=1)
    "Testing controller for plant with temperature sensors in secondary loop and boiler supply terminals"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.95, 2),
    final period=fill(3600, 2),
    final shift=fill(1, 2))
    "Pump status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSecSup(
    final k=8.5)
    "Temperature sensor reading from secondary circuit"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine TPriSup(
    phase=3.1415926535898,
    final offset=8.5,
    final freqHz=1/3600,
    final amplitude=2.5)
    "Temperature sensor reading from primary circuit"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine TBoiSup2(
    phase=3.1415926535898,
    final offset=8,
    final freqHz=1/3600,
    final amplitude=2.5)
    "Flowrate sensor reading from decoupler"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta1(
    final width=0.5,
    final period=1800,
    final shift=1)
    "Pump status"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

equation

  connect(pumSta.y, hotPumSpe.uHotWatPum) annotation (Line(points={{-58,40},{-50,
          40},{-50,8},{-42,8}}, color={255,0,255}));
  connect(TPriSup.y, hotPumSpe.THotWatPri) annotation (Line(points={{-58,0},{-50,
          0},{-50,4},{-42,4}}, color={0,0,127}));
  connect(TSecSup.y, hotPumSpe.THotWatSec) annotation (Line(points={{-58,-40},{-46,
          -40},{-46,0},{-42,0}}, color={0,0,127}));
  connect(TSecSup.y, hotPumSpe1.THotWatSec) annotation (Line(points={{-58,-40},{
          30,-40},{30,0},{38,0}}, color={0,0,127}));
  connect(pumSta.y, hotPumSpe1.uHotWatPum) annotation (Line(points={{-58,40},{28,
          40},{28,8},{38,8}}, color={255,0,255}));
  connect(TPriSup.y, hotPumSpe1.THotWatBoiSup[1]) annotation (Line(points={{-58,
          0},{-50,0},{-50,-18},{34,-18},{34,-9},{38,-9}}, color={0,0,127}));
  connect(TBoiSup2.y, hotPumSpe1.THotWatBoiSup[2]) annotation (Line(points={{12,-60},
          {36,-60},{36,-6},{38,-6},{38,-7}},      color={0,0,127}));
  connect(pumSta[1].y, hotPumSpe1.uBoiSta[1]) annotation (Line(points={{-58,40},
          {28,40},{28,-4},{38,-4},{38,-5}}, color={255,0,255}));
  connect(pumSta1.y, hotPumSpe1.uBoiSta[2]) annotation (Line(points={{12,60},{34,
          60},{34,-3},{38,-3}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/PrimaryPumps/Subsequences/Validation/Speed_temperature.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Speed_temperature;
