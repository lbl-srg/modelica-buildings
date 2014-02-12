within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses;
package Types "Types for radiant slab model"
  type SystemType = enumeration(
      Ceiling_Wall_or_Capillary
        "Radiant heating or cooling system (ceiling or wall)",
      Floor "Floor heating system") "System type for radiant slab";
annotation (
    Documentation(info="<html>
<p>
This package contains type definitions that are used
in the radiant slab model.
</p>
<p>
The enumeration <code>RadiantSystemType</code> is used 
in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance</a>
to select the equation for a fictitious resistance
between the pipes and an average temperature of the plane
that contains the pipes.
</p>
</html>
",
revisions="<html>
<ul>
<li>
April 5, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
April 3, 2012, by Xiufeng Pang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Types;
