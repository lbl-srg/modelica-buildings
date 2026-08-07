within Buildings.Fluid.BaseClasses.Media.Functions;
function isTemperatureDependentFluidMedium
  "Return true if mediumName is one of the supported temperature-dependent borefield media"
  extends .Modelica.Icons.Function;

  input String mediumName
    "Medium.mediumName string";

  output Boolean isSupported
    "True if mediumName identifies a supported medium";

protected
  Boolean isEthyleneGlycolWater=
    .Modelica.Utilities.Strings.find(
      string=mediumName,
      searchString="EthyleneGlycolWater") > 0
    "True if mediumName identifies ethylene glycol/water";

  Boolean isPropyleneGlycolWater=
    .Modelica.Utilities.Strings.find(
      string=mediumName,
      searchString="PropyleneGlycolWater") > 0
    "True if mediumName identifies propylene glycol/water";

  Boolean isWater=
    (.Modelica.Utilities.Strings.isEqual(
      string1=mediumName,
      string2="Water") or
     .Modelica.Utilities.Strings.isEqual(
      string1=mediumName,
      string2="Buildings.Media.Water")) and
    not isEthyleneGlycolWater and
    not isPropyleneGlycolWater
    "True if mediumName identifies water";

algorithm
  isSupported :=
    isWater or
    isEthyleneGlycolWater or
    isPropyleneGlycolWater;

  annotation (
    Inline=false,
    Documentation(info="<html>
<p>
This function returns <code>true</code> if <code>Medium.mediumName</code>
corresponds to one of the media supported by the borefield
temperature-dependent property correlations.
</p>
<p>
The supported media are:
</p>
<ul>
<li><code>Buildings.Media.Water</code></li>
<li><code>Buildings.Media.Antifreeze.EthyleneGlycolWater</code></li>
<li><code>Buildings.Media.Antifreeze.PropyleneGlycolWater</code></li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 2026, by L. Meertens:<br/>
First implementation for checking whether the redeclared medium is supported by
the temperature-dependent borefield property correlations.
</li>
</ul>
</html>"));
end isTemperatureDependentFluidMedium;
