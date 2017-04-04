within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model RampLimiter "Validation model for the RampLimiter block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RampLimiter ramplimiter1(
    Increase=1,
    IncDT = 1,
    Decrease=1,
    DecDT = 1)
    "Block that limit the increase or decrease rate of input"
    annotation (Placement(transformation(extent={{-10,8},{10,28}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=0,
    height=1.5) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));

equation
  connect(ramp1.y, ramplimiter1.u)
    annotation (Line(points={{-39,18},{-25.5,18},{-12,18}}, color={0,0,127}));
  annotation (
 experiment(StopTime=1.0),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/RampLimiter.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RampLimiter\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.RampLimiter</a>.
</p>
<p>
The input <code>ramp1.u</code> varies from <i>0</i> to <i>+1.5</i>, 
in <code> 1 s</code>.
</p>
<p>
The increase and decrease rate limits are <code>[Increase/IncDT, -Decrease/DecDT] </code>, which is <code>[1, -1]</code> here.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end RampLimiter;
