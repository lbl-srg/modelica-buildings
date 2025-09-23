within Buildings.Templates.Components.HeatPumps;
model AirToWaterSHC
  "Simultaneous heating and cooling (SHC) air-to-water heat pumps"
  extends Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC(
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWaterSHC);
equation
  connect(port_aSou, TSouEnt.port_a)
    annotation (Line(points={{80,-140},{80,-20},{40,-20}},color={0,127,255}));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for a simultaneous heating and cooling (SHC) air-to-water heat pump 
where the capacity and power are interpolated from manufacturer data along the
source and sink temperature and the part load ratio.
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the base class
<a href=\"modelica://Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC\">
Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC</a>
for a description of the available control input and output variables.
</p>
</html>", revisions="<html>
<ul>
<li>September 1, 2025, by Xing Lu, Karthik Devaprasad:<br>First implementation. </li>
</ul>
</html>"));
end AirToWaterSHC;
