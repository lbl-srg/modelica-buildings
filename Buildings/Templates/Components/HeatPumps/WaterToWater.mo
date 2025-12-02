within Buildings.Templates.Components.HeatPumps;
model WaterToWater
  "Water-to-water heat pump"
  extends Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep
                                                                                     (
    final typ=Buildings.Templates.Components.Types.HeatPump.WaterToWater, hp(
        use_intSafCtr=false));
equation
  connect(port_aSou, TSouEnt.port_a)
    annotation (Line(points={{80,-140},{80,-20},{40,-20}},color={0,127,255}));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for a water-to-water heat pump where the capacity
and input power are computed by interpolating manufacturer data
along the condenser entering or leaving temperature, the
evaporator entering or leaving temperature and the part load ratio.
The model can be configured to represent either a non-reversible
(heating-only) heat pump (<code>is_rev=false</code>) or a
reversible heat pump (<code>is_rev=true</code>).
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the base class
<a href=\"modelica://Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep\">
Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep</a>
for a description of the available control input and output variables.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterToWater;
