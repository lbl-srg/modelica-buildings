within Buildings.Utilities.Math.Functions.Examples;
model IsMonotonic
  "Tests the correct implementation of the function isMonotonic"
  extends Modelica.Icons.Example;
  Real x_incStrict[3] = {0, 1, 2} "strictly increasing";
  Real x_notMon[3] = {0, 3, 2} "not monotonic";
  Real x_incWeak[4] = {0, 1, 1, 2} "weakly increasing";
  Real x_notWeak[4] = {0, 3, 3, 2} "not weakly monotonic";
  Real x_decStrict[3] = {2.5, 2, 0.1} "strictly decreasing";
  Real x_decWeak[4] = {3, 1, 1, 0.5} "weakly decreasing";

equation
// Tests with weak monotonicity
    //strictly increasing
assert(Buildings.Utilities.Math.Functions.isMonotonic(x_incStrict, strict=false),
   "Error. Function should have returned true.");
     //not monotonic
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_notMon, strict=false),
   "Error. Function should have returned true.");
     //weakly increasing
assert(Buildings.Utilities.Math.Functions.isMonotonic(x_incWeak, strict=false),
   "Error. Function should have returned true.");
     //not weakly monotonic
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_notWeak, strict=false),
   "Error. Function should have returned true.");

    //strictly decreasing
assert(Buildings.Utilities.Math.Functions.isMonotonic({2.5, 2, 0.1}, strict=false),
   "Error. Function should have returned true.");
     //weakly decreasing
assert(Buildings.Utilities.Math.Functions.isMonotonic({3, 1, 1, 0.5}, strict=false),
   "Error. Function should have returned true.");

// Tests with strict monotonicity
    //strictly increasing
assert(Buildings.Utilities.Math.Functions.isMonotonic(x_incStrict, strict=true),
   "Error. Function should have returned true.");
     //not monotonic
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_notMon, strict=true),
   "Error. Function should have returned true.");
     //weakly increasing
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_incWeak, strict=true),
   "Error. Function should have returned true.");
     //not weakly monotonic
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_notWeak, strict=true),
   "Error. Function should have returned true.");

    //strictly decreasing
assert(Buildings.Utilities.Math.Functions.isMonotonic(x_decStrict, strict=true),
   "Error. Function should have returned true.");
     //weakly decreasing
assert(false == Buildings.Utilities.Math.Functions.isMonotonic(x_decWeak, strict=true),
   "Error. Function should have returned true.");

  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/IsMonotonic.mos"
        "Simulate and plot"),
Documentation(
info="<html>
<p>
This example tests the correct implementation of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.isMonotonic\">
Buildings.Utilities.Math.Functions.isMonotonic</a>.
If the function is implemented incorrect, the example will stop
with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 8, 2014, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end IsMonotonic;
