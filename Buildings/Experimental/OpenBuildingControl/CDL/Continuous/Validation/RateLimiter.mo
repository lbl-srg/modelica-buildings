within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model RateLimiter "Validation model for the RateLimiter block"
  import Buildings;
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RateLimiter rampLimiter(
    raiseSpeed=1,
    fallSpeed = 1)
    "Block that limit the increase or decrease rate of input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=0,
    height=1.5) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=1,
    offset=0,
    height=-1.5,
    startTime=2)
                "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Add add
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(ramp1.y, add.u1) annotation (Line(points={{-59,30},{-46,30},{-46,6},{-32,
          6}}, color={0,0,127}));
  connect(ramp2.y, add.u2) annotation (Line(points={{-59,-30},{-46,-30},{-46,-6},
          {-32,-6}}, color={0,0,127}));
  connect(rampLimiter.u, add.y)
    annotation (Line(points={{18,0},{-9,0}}, color={0,0,127}));
  annotation (
 experiment(StopTime=1.0, Tolerance=1e-06),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/RateLimiter.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RateLimiter\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RateLimiter</a>.
</p>
<p>
The input <code>ramp1.u</code> varies from <i>0</i> to <i>+1.5</i>,
in <code> 1 s</code>.
</p>
<p>
The increase and decrease rate limits are <code>[increase/incDt, -decrease/decDt] </code>, which is <code>[1, -1]</code> here.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end RateLimiter;
