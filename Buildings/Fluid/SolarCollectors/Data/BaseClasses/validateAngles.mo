within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
function validateAngles "Function to validate the provided angles"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Angle[:] incAngDat(
    each final min=0,
    each final max=Modelica.Constants.pi/2)
    "Incident angle data in degrees";
  input Real[:] incAngModDat(
    each final min=0,
    each final unit="1")
    "Incident angle modifier data";
  output Boolean valid;
protected
  Integer n = size(incAngDat,1) "Number of elements";
algorithm
  assert(size(incAngModDat, 1) == n, "Both arguments incAngDat and incAngModDat must have the same size.");
  assert(abs(incAngDat[1]) < 1E-4, "First element of incAngDat must be zero.");
  assert(abs(Modelica.Constants.pi/2-incAngDat[n]) < 1E-4, "Last element of incAngDat must be pi/2.");
  assert(abs(1-incAngModDat[1]) < 1E-4, "First element of incAngModDat must be 1.");
  assert(abs(incAngModDat[n]) < 1E-4, "Last element of incAngModDat must be 0.");
  valid := true;

  annotation (Documentation(info="<html>
<p>
Function that validates the incidence angle modifiers.
If the data are invalid, the function issues an assertion and stops the simulation.
Otherwise it returns <code>true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end validateAngles;
