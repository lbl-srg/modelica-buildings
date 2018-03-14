within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model TowerFan "Validate cooling tower fan control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerFan towFan(
    minFanSpe=0.1)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conWatPumSta[2](
    k={true,false}) "Condenser water pump status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp Lift(
    duration=3600,
    offset=9,
    height=4) "Chiller lift temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatSupTem(
    amplitude=2,
    freqHz=1/1800,
    offset=279.15) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conWatRet(
    amplitude=5,
    freqHz=1/3600,
    offset=295.15) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine fanSpe(
    freqHz=1/3600,
    amplitude=0.25,
    offset=0.5) "Current fan speed"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation
  connect(conWatPumSta.y, towFan.uConWatPum)
    annotation (Line(points={{-59,80},{20,80},{20,18},{38,18}},
      color={255,0,255}));
  connect(Lift.y, towFan.dTRef)
    annotation (Line(points={{-59,40},{0,40},{0,14},{38,14}},
      color={0,0,127}));
  connect(chiWatSupTem.y, towFan.TChiWatSup)
    annotation (Line(points={{-59,0},{-20,0},{-20,10},{38,10}},
      color={0,0,127}));
  connect(conWatRet.y, towFan.TConWatRet)
    annotation (Line(points={{-59,-40},{0,-40},{0,6},{38,6}},
      color={0,0,127}));
  connect(fanSpe.y, towFan.uFanSpe)
    annotation (Line(points={{-59,-80},{20,-80},{20,2},{38,2}},
      color={0,0,127}));

annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/TowerFan.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerFan\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TowerFan;
