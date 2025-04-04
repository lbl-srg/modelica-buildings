within Buildings.Fluid.HeatPumps.ModularReversible.Types;
type Modes = enumeration(
    AmbientCooling "Ambient cooling mode",
    HeatingCooling "Heating cooling mode",
    AmbientHeating "Ambient heating mode")
      "4-pipe heat pump modes"  annotation (
    Documentation(info="<html>
<p>Enumeration for the type 4-pipe heat pump mode. </p>
<ol>
<li>AmbientCooling</li>
<li>HeatingCooling  </li>
<li>AmbientHeating </li>
</ol>
</html>",
        revisions="<html>
</html>"));
