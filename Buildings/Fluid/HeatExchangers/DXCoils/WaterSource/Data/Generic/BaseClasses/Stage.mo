within Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses;
record Stage "Generic data record for a stage of a DX coil"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
  redeclare parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues nomVal,
  redeclare parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.PerformanceCurve perCur);

annotation (defaultComponentName="per",
              preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for water source DX cooling coil performance data at a compressor speed.
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.DXCoil</a> for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Stage;
