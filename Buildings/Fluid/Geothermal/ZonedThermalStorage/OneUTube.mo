within Buildings.Fluid.Geothermal.ZonedThermalStorage;
model OneUTube "Borefield model containing single U-tube boreholes"
  extends Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.PartialStorage(
    redeclare Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHol[nZon]);

  annotation (
  defaultComponentName="borFie",
  Documentation(info="<html>
<p>
This model simulates a borehole thermal energy storage system with multiple
zones of single U-tube boreholes. Boreholes within the same zone are connected
in parallel. The borefield configuration and thermal parameters are defined in
the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using only one borehole heat exchanger per
zone. The fluid mass flow rate into each borehole is divided to reflect the
per-borehole fluid mass flow rate. The borehole model calculates the dynamics
within the borehole itself using an axial discretization and a
resistance-capacitance network for the internal thermal resistances between the
individual pipes and between each pipe and the borehole wall.
</p>
<p>
The ground thermal response at each borehole segment is evaluated using
analytical thermal response factors. Spatial and temporal superposition are used
to evaluate the total temperature change at each of the borehole segments.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneUTube;
