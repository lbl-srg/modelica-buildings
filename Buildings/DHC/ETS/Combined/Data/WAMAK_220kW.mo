within Buildings.DHC.ETS.Combined.Data;
record WAMAK_220kW "WAMAK heat pump with 220kW"
  extends Buildings.DHC.ETS.Combined.Data.GenericHeatPump(
    datHea = Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW());

annotation(defaultComponentName="datHeaPum",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Parameters that describe the performance of the a WAMAK heat pump,
as specified in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW\">
Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
</ul>
</html>"));

end WAMAK_220kW;
