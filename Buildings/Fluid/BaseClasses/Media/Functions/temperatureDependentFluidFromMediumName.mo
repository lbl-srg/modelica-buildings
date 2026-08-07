within Buildings.Fluid.BaseClasses.Media.Functions;
function temperatureDependentFluidFromMediumName
  "Return the internally used temperature-dependent fluid type from a mediumName string"
  extends .Modelica.Icons.Function;

  input String mediumName
    "Medium.mediumName string";

  output .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid fluid
    "Temperature-dependent fluid type derived from mediumName";

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
  if isEthyleneGlycolWater then
    fluid :=
      .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.EthyleneGlycolWater;

  elseif isPropyleneGlycolWater then
    fluid :=
      .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.PropyleneGlycolWater;

  elseif isWater then
    fluid :=
      .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.Water;

  else
    /*
      Return Water as a harmless default for unsupported media.

      The actual restriction must be enforced separately, and only when
      use_TDepPressureDrop or use_TDepRConv is true. This avoids accidentally
      rejecting arbitrary media when temperature-dependent property evaluation
      is disabled.
    */
    fluid :=
      .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.Water;
  end if;

  annotation (
    Inline=false,
    Documentation(info="<html>
<p>
This function derives the internally used temperature-dependent fluid type from
<code>Medium.mediumName</code>.
</p>
<p>
If the medium name is not recognized, the function returns
<code>Water</code> as a harmless default. The caller must separately assert that
the medium is supported when temperature-dependent property evaluation is
enabled.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by L. Meertens:<br/>
First implementation for automatic selection of borefield fluid-property
correlations from the redeclared medium.
</li>
</ul>
</html>"));
end temperatureDependentFluidFromMediumName;
