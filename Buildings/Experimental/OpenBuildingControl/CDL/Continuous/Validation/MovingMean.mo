within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model MovingMean "Validation model for the MovingMean block"
extends Modelica.Icons.Example;

  Modelica.Blocks.Noise.UniformNoise uniformNoise(
    y_min=0,
    y_max=1,
    samplePeriod=6)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean movingMean_300(
    delta=300) "Moving average with 300 sec sliding window"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean movingMean_200(
    delta=200) "Moving average with 200 sec sliding window"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean movingMean_100(
    delta=100) "Moving average with 100 sec sliding window"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean movingMean_400(
    delta=400) "Moving average with 400 sec sliding window"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean movingMean_500(
    delta=500) "Moving average with 500 sec sliding window"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(uniformNoise.y, movingMean_300.u)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  connect(uniformNoise.y, movingMean_100.u)
    annotation (Line(points={{-19,0},{0,0},{0,60},{18,60}}, color={0,0,127}));
  connect(uniformNoise.y, movingMean_200.u)
    annotation (Line(points={{-19,0},{0,0},{0,30},{18,30}}, color={0,0,127}));
  connect(uniformNoise.y, movingMean_500.u) annotation (Line(points={{-19,0},{0,
          0},{0,-60},{18,-60}}, color={0,0,127}));
  connect(uniformNoise.y, movingMean_400.u) annotation (Line(points={{-19,0},{0,
          0},{0,-30},{18,-30}}, color={0,0,127}));
  annotation (experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/MovingMean.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean</a>.
</p>
<p>
The input <code>uniformNoise</code> generates random value ranging from 0 to 1.
Different time horizon, i.e. <code>delta=100s, 200s, 300s, 400s, 500s</code>, are
used to compute the moving average of the input.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end MovingMean;
