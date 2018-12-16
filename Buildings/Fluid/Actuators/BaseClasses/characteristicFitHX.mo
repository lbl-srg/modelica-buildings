within Buildings.Fluid.Actuators.BaseClasses;
function characteristicFitHX
  "Heat exchanger characteristic Q2/Q2Nom = f(V1/V1Nom) fitting function"
  extends Modelica.Icons.Function;

  input Real x(min=0, unit="") "Primary mass flow rate fraction";
  input String fitMod "Type of heat exchanger characteristic fitting function";
  input Real b1(min=-10, max=10)
    "Fitting function first coefficient";
  input Real b2(min=-10, max=10)
    "Fitting function second coefficient (exponential law only)";
  output Real y(min=0, unit="") "Secondary heat flow rate fraction";

algorithm
  if fitMod == "Exponential" then
    y := Modelica.Math.log(1 - Modelica.Math.log(1 - (1 - Modelica.Math.exp(-b2)) * x) /
    (-b2) * (1 - Modelica.Math.exp(-b1))) / (-b1);
  else
    if fitMod == "a coefficient" then
      y := x / (x * (1 - b1) + b1);
    else
      y := x;
    end if;
  end if;

end characteristicFitHX;
