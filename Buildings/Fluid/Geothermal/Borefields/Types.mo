within Buildings.Fluid.Geothermal.Borefields;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type BoreholeConfiguration = enumeration(
      SingleUTube
    "Single U-tube configuration",
      DoubleUTubeParallel
    "Double U-tube configuration with pipes connected in parallel",
      DoubleUTubeSeries
    "Double U-tube configuration with pipes connected in series")
  "Enumeration to define the borehole configurations"
  annotation (Documentation(info="<html>
<p>
Enumeration that defines the pipe configuration in the borehole.
</p>
<p>
The following pipe configurations are available in this enumeration:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>SingleUTube</td><td>Single U-tube configuration</td></tr>

<tr><td>DoubleUTubeParallel</td><td>Double U-tube configuration with pipes connected in parallel</td></tr>
<tr><td>DoubleUTubeSeries</td><td>Double U-tube configuration with pipes connected in series</td></tr>
</table>
</html>",
  revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  type FluidPropertyEvaluation = enumeration(
      use_MediaFunctions
        "Use functions from the redeclared Medium package",
      Water
        "Use water correlations",
      PropyleneGlycolWater
        "Use propylene-glycol/water correlations")
    "Enumeration for fluid property evaluation"
    annotation (Documentation(info="<html>
<p>
Enumeration that defines how fluid properties are evaluated for heat-transfer
and pressure-drop correlations in the borefield models.
</p>
<p>
The following fluid-property evaluation methods are available in this
enumeration:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>GenericMedium</td><td>Evaluate properties through the Medium interface.</td></tr>
<tr><td>Water</td><td>Evaluate water properties using local temperature-dependent correlations.</td></tr>
<tr><td>PropyleneGlycolWater</td><td>Evaluate propylene-glycol/water properties using local temperature-dependent correlations.</td></tr>
</table>
</html>",
revisions="<html>
<ul>
<li>
July 27, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));

  annotation (preferredView="info", Documentation(info="<html>
 <p>
 This package contains type definitions.
 </p>
 </html>"));
end Types;
