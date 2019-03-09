within Buildings.Fluid.HeatPumps.Data;
package WSHP
  record Generic "Generic data for Water Source HeatPump"

   extends Buildings.Fluid.HeatPumps.Data.BaseClasses.HeatPump(
        final nCapFunT=6,
        final nEIRFunT=6,
        final nEIRFunPLR=3);


   annotation (
   defaultComponentName="per",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>This record is used as a template for performance data
for the HeatPump model
<a href=\"Buildings.Fluid.HeatPumps.WSHP\">
Buildings.Fluid.HeatPumps.WSHP</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2014 by Michael Wetter:<br/>
Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>.
</li><li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  end Generic;
end WSHP;
