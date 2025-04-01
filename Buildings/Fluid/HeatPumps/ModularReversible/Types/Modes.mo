within Buildings.Fluid.HeatPumps.ModularReversible.Types;
type Modes = enumeration(
    AmbientCooling "Ambient cooling mode",
    AmbientHeating "Ambient heating mode",
    HeatingCooling "Heating cooling mode") "4-pipe heat pump modes"  annotation (
    Documentation(info="<html>
<p>Enumeration for the type 4-pipe heat pump mode. </p>
<ol>
<li>AmbientCooling </li>
<li>AmbientHeating </li>
<li>HeatingCooling </li>
</ol>
</html>",
        revisions="<html>
</html>"));
