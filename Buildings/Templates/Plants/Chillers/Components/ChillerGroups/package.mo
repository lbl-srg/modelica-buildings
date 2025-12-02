within Buildings.Templates.Plants.Chillers.Components;
package ChillerGroups "Models for chiller groups"
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>
This package contains models of chiller groups.
</p>
<p>
Note that the hydronic connections between the chillers are
modeled outside of those components, for instance using
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Routing.ChillersToPrimaryPumps\">
Buildings.Templates.Plants.Chillers.Components.Routing.ChillersToPrimaryPumps</a>.
This way, the components inside this package can be used to model
either parallel or series arrangements.
</p>
</html>"));
end ChillerGroups;
