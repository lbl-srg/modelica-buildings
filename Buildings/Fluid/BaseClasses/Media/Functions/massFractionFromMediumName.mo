within Buildings.Fluid.BaseClasses.Media.Functions;
function massFractionFromMediumName
  "Extract glycol mass fraction X_a from a mediumName string"
  extends .Modelica.Icons.Function;

  input String mediumName
    "Medium.mediumName string";

  output .Modelica.Units.SI.MassFraction X_a
    "Mass fraction of glycol in water";

protected
  Integer iX_a
    "Start index of X_a in mediumName";

  Integer iEqu
    "Index of equality sign after X_a";

  Integer iEquLoc
    "Local index of equality sign in substring";

  Integer iNext
    "Index after scanned real";

  Real x
    "Parsed mass fraction";

  String sub
    "Substring starting at X_a";

algorithm
  iX_a := .Modelica.Utilities.Strings.find(
    string=mediumName,
    searchString="X_a");

  assert(
    iX_a > 0,
    "Could not extract X_a from Medium.mediumName = \"" + mediumName + "\". "
    + "The medium name must contain a token such as X_a = 0.40.");

  sub := .Modelica.Utilities.Strings.substring(
    string=mediumName,
    startIndex=iX_a,
    endIndex=.Modelica.Utilities.Strings.length(mediumName));

  iEquLoc := .Modelica.Utilities.Strings.find(
    string=sub,
    searchString="=");

  assert(
    iEquLoc > 0,
    "Could not extract X_a from Medium.mediumName = \"" + mediumName + "\". "
    + "The token X_a was found, but no equality sign was found after it.");

  iEqu := iX_a + iEquLoc - 1;

  (x, iNext) := .Modelica.Utilities.Strings.scanReal(
    string=mediumName,
    startIndex=iEqu + 1,
    unsigned=false,
    message="Could not scan X_a from Medium.mediumName = \"" + mediumName + "\".");

  X_a := x;

  assert(
    X_a >= 0 and X_a <= 0.6,
    "The glycol mass fraction X_a extracted from Medium.mediumName = \""
    + mediumName + "\" is outside the supported range 0 <= X_a <= 0.6.");

  annotation (
    Inline=false,
    Documentation(info="<html>
<p>
This function extracts the glycol mass fraction <code>X_a</code> from the
<code>Medium.mediumName</code> string of the Buildings antifreeze media.
</p>
<p>
For example, a medium name may contain
<code>X_a = 0.40</code>, which is parsed and returned as a real value.
</p>
<p>
This function should only be called for the glycol media.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by L. Meertens:<br/>
First implementation for deriving glycol mass fraction from the redeclared
medium.
</li>
</ul>
</html>"));
end massFractionFromMediumName;
