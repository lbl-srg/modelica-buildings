within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.Examples;
model Factorial "Test the function factorial"
 extends Modelica.Icons.Example;
  parameter Integer x[:] = {1, 2, 3, 4, 5};
  Integer y[5];
equation
  y = Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.factorial(x);
  assert(abs(120-y[5]) < 1E-10, "Error: Factorial function yields wrong result.");
annotation(
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/Factorial.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.factorial\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.factorial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end Factorial;
