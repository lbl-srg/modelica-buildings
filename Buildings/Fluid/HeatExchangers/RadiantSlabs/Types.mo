within Buildings.Fluid.HeatExchangers.RadiantSlabs;
package Types "Package with type definitions"

  type FluidHeatTransfer = enumeration(
      EpsilonNTU "Epsilon-NTU",
      FiniteDifference "Finite difference")
    "Model for the heat transfer along the fluid flow direction";

  type SystemType = enumeration(
      Ceiling_Wall_or_Capillary
        "Radiant heating or cooling system (ceiling or wall)",
      Floor "Floor heating system") "System type for radiant slab";

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for the radiant slabs.
</p>
</html>"));
end Types;
