within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples;
model YorkCalcDerivativeCheck

 annotation(Diagram(graphics),
                     Commands(file="YorkCalcDerivativeCheck.mos" "run"));
  annotation (
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Modelica.SIunits.Temperature TRan = 5.56
    "Range temperature (water in - water out)";
  parameter Modelica.SIunits.Temperature TAirInWB = 35.55 + 273.15
    "Inlet air wet bulb temperature";
  Real x;
  Real y;
initial equation
   y=x;
equation
  x=CoolingTowers.Correlations.yorkCalc(TRan=TRan,      TWB=TAirInWB,
                                                        FRWat=time,
                                                        FRAir=1.1);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");
end YorkCalcDerivativeCheck;
