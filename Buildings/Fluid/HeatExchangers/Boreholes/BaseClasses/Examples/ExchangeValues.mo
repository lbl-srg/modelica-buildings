within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.Examples;
model ExchangeValues "Test problem for the function that exchanges values"
 extends Modelica.Icons.Example;
  parameter Real x = 3;
  Real y;
  Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.ExtendableArray table=
    Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.ExtendableArray()
    "Extentable array, used to store history of rate of heat flows";

algorithm
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=1, x=x, iY=1);
  assert(abs(y-3) < 1E-10, "Error in implementation of exchangeVaules.");
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=2, x=4*x, iY=1);
  assert(abs(y-3) < 1E-10, "Error in implementation of exchangeVaules.");
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=2, x=4*x, iY=2);
  assert(abs(y-12) < 1E-10, "Error in implementation of exchangeVaules.");
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=200, x=5*x, iY=1);
  assert(abs(y-3) < 1E-10, "Error in implementation of exchangeVaules.");
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=10, x=6*x, iY=200);
  assert(abs(y-15) < 1E-10, "Error in implementation of exchangeVaules.");
  y := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=10, x=6*x, iY=1);
  assert(abs(y-3) < 1E-10, "Error in implementation of exchangeVaules.");

annotation(
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/ExchangeValues.mos"
        "Simulate"),
    Documentation(info="<html>
<p>
This example tests the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.exchangeValues</a> by
assigning and reading different elements of the array.
The assert statements check whether the returned values is correct.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExchangeValues;
