within Buildings.Utilities.IO.Files.BaseClasses;
type OutputTime = enumeration(
    Initial "Output results at initial() time",
    Terminal "Output results at terminal() time",
    Custom "Output results at custom time value")
    "Time when results are outputted" annotation (Documentation(info="<html>
<p>
Enumeration for when output files are written.
</p>
</html>"));
