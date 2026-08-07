within Buildings.Fluid.BaseClasses.Media.Types;

  type TemperatureDependentPropertyFluid = enumeration(
      Water
        "Buildings.Media.Water",
      EthyleneGlycolWater
        "Buildings.Media.Antifreeze.EthyleneGlycolWater",
      PropyleneGlycolWater
        "Buildings.Media.Antifreeze.PropyleneGlycolWater")
    "Enumeration for internally selected temperature-dependent fluid-property evaluation"
  annotation (Documentation(info="<html>
<p>
Enumeration used internally by the borefield models to select the
temperature-dependent fluid-property correlations that correspond to the
redeclared medium.
</p>
<p>
This type is not intended to be exposed as a user-facing parameter. The value
is derived from <code>Medium.mediumName</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));
