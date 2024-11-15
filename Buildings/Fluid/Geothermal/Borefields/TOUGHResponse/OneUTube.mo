within Buildings.Fluid.Geothermal.Borefields.TOUGHResponse;
model OneUTube
  "Borefield model containing single U-tube boreholes, with ground response calcuted by TOUGH"
  extends Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.PartialBorefieldWithTough(
    redeclare Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHol);

  annotation (
  defaultComponentName="borFie",
  Documentation(info="<html>
<p>
This model simulates a borefield containing one or many single U-tube boreholes
using the parameters in the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using only one borehole heat exchanger. The
fluid mass flow rate into the borehole is divided to reflect the per-borehole
fluid mass flow rate. The borehole model calculates the dynamics within the
borehole itself using an axial discretization and a resistance-capacitance
network for the internal thermal resistances between the individual pipes and
between each pipe and the borehole wall.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneUTube;
