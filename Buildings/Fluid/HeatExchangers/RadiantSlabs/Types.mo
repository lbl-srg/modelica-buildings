within Buildings.Fluid.HeatExchangers.RadiantSlabs;
package Types "Package with type definitions"

  type HeatTransfer = enumeration(
      EpsilonNTU "Epsilon-NTU",
      FiniteDifference "Finite difference")
    "Model for the heat transfer along the fluid flow direction" annotation (
      Documentation(info="<html>
<p>
This type definition is used to determine
whether the <i>&epsilon;-NTU</i> approach
should be used to compute the heat transfer
between the fluid and the solid.
See the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
user's guide</a>
for more information.
</p>
</html>"));

  type SystemType = enumeration(
      Ceiling_Wall_or_Capillary
        "Radiant heating or cooling system (ceiling or wall)",
      Floor "Floor heating system") "System type for radiant slab" annotation (
      Documentation(info="<html>
<p>
This type definition is used to specify
the type of radiant system to be modeled.
See the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
user's guide</a>
for more information.
</p>
</html>"));

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for the radiant slabs.
</p>
</html>"));
end Types;
