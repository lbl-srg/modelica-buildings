within Buildings.Fluid.DXSystems.BaseClasses.Functions;
function warnIfPerformanceOutOfBounds
  "Function that checks the performance and writes a warning if it is outside of 0.9 to 1.1"
  input Real x "Argument to be checked";
  input String msg "String to be added to warning message";
  input String curveName "Name of the curve that was tested";
  output Integer retVal
    "0 if x is inside bounds, -1 if it is below bounds, or +1 if it is above bounds";

algorithm
  if (x > 1.1) then
    retVal :=1;
  elseif ( x < 0.9) then
      retVal :=-1;
  else
    retVal :=0;
  end if;
  assert(
    retVal == 0,
"*** Warning: DX coil performance curves at nominal conditions are outside of bounds.
             " + msg + " is outside of bounds 0.9 to 1.1.
             The value of the curve fit is " + String(x) + "
             Check the coefficients of the function " + curveName + ".",
    level = AssertionLevel.warning);

annotation (
    Documentation(info="<html>
<p>
This function checks if the numeric argument is outside of the
interval <i>0.9</i> to <i>1.1</i>.
If this is the case, the function writes a warning.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2023, by Michael Wetter:<br/>
Changed print statement to an assertion.
</li>
<li>
September 12, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end warnIfPerformanceOutOfBounds;
