within Buildings.Fluid.Actuators.BaseClasses;
function characteristicFitHX
  "Inverse of heat exchanger characteristic Q2/Q2Nom = f(V1/V1Nom) fitting function"
  extends Modelica.Icons.Function;
  input Real x(min=0, unit="") "Secondary heat flow rate to nominal ratio";
  input String fitMod "Type of heat exchanger characteristic fitting function";
  input Real b1
    "Fitting function first coefficient";
  input Real b2
    "Fitting function second coefficient (exponential law only)";
  output Real y(unit="") "Primary mass flow rate to nominal ratio";
algorithm
  if fitMod == "Exponential" then
    y := Modelica.Math.log(1 - Modelica.Math.log(1 - (1 - Modelica.Math.exp(-b2)) * x) /
    (-b2) * (1 - Modelica.Math.exp(-b1))) / (-b1);
    // 1 - (1 - Modelica.Math.exp(-b2)) * x > 0 for all x and b2 values OK
  else
    if fitMod == "a coefficient" then
      y := x * b1 / (x * (b1 - 1) + 1);
    else
      y := x;
    end if;
  end if;
end characteristicFitHX;
