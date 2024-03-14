within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
function validateAngles "Function to validate the provided angles"
  extends Modelica.Icons.Function;
  input Modelica.Units.NonSI.Angle_deg[:] incAngDatDeg(
    final min=0,
    final max=90)
    "Incident angle data in degrees";
  input Real[:] incAngModDat(
    final min=0,
    final unit="1")
    "Incident angle modifier data";
  output Boolean valid;
protected
  Integer n = size(incAngDatDeg,1) "Number of elements";
algorithm
  assert(size(incAngModDat, 1) == n, "Both arguments incAngDatDeg and incAngModDat must have the same size.");
  assert(abs(incAngDatDeg[1]) < 1E-4, "First element of incAngDatDeg must be zero.");
  assert(abs(90-incAngDatDeg[n]) < 1E-4, "Last element of incAngDatDeg must be 90.");
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
