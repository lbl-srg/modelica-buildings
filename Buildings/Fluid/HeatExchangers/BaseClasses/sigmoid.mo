within Buildings.Fluid.HeatExchangers.BaseClasses;
function sigmoid
  input Real a=1  "the magnitude of 'a' controls the transition area";
  input Real c=0  "the magnitude of 'c' controls the center point of the sigmoid membership function";
  input Real x;
  output Real y;
algorithm
  y:=1/(1 + Modelica.Math.exp(-a*(x - c)));
end sigmoid;
