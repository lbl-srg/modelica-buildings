within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Validation;
model Controller
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conRet(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 32) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-292,84},{-272,104}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-292,54},{-272,74}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-232,54},{-212,74}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conRetSet(
    final k=273.15 + 32)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-232,84},{-212,104}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp conWatPumSpe[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-292,14},{-272,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe(
    final height=0.25,
    final duration=3600,
    final offset=0.5) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-292,-26},{-272,-6}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe1(
    final height=-0.25,
    final duration=3600,
    final offset=0.8) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-232,-26},{-212,-6}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plrTowMaxSpe(
    final height=-0.3,
    final duration=3600,
    final offset=0.9) "Maximum tower speed reset based on the partial load"
    annotation (Placement(transformation(extent={{-292,-66},{-272,-46}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe
    "Tow fan speed for close coupled plants that have waterside economizer"
    annotation (Placement(transformation(extent={{-80,100},{-40,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe1(closeCoupledPlant=false)
    "Tow fan speed for less coupled plants that have waterside economizer"
    annotation (Placement(transformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe2(hasWSE=false)
    "Tow fan speed for close coupled plants that have no waterside economizer"
    annotation (Placement(transformation(extent={{90,-150},{130,-110}})));
  CDL.Continuous.Sources.Ramp speWSE(final height=0.9, final duration=3600)
    "Tower fan speed when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
equation
  connect(conRet.y, add2.u1)
    annotation (Line(points={{-270,94},{-252,94},{-252,70},{-234,70}},
                                                                   color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-270,64},{-252,64},{-252,58},{-234,58}},
                                                                   color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/FanSpeed/ReturnWaterTemperature/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller</a>.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-200},{320,200}})));
end Controller;
