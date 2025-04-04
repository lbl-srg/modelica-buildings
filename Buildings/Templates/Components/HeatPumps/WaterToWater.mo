within Buildings.Templates.Components.HeatPumps;
model WaterToWater
  "Water-to-water heat pump - Equation fit model"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPumpEquationFit(
    final typ=Buildings.Templates.Components.Types.HeatPump.WaterToWater);
equation
  connect(port_aSou, TSouEnt.port_a)
    annotation (Line(points={{80,-140},{80,-20},{40,-20}},color={0,127,255}));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for a water-to-water heat pump where the capacity
and input power are computed based on the equation fit method.
The model can be configured with the parameter <code>is_rev</code>
to represent either a non-reversible heat pump (heating only) or a
reversible heat pump.
This model uses
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>,
which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the interface class
<a href=\"modelica://Buildings.Templates.Components.Interfaces.PartialHeatPumpEquationFit\">
Buildings.Templates.Components.Interfaces.PartialHeatPumpEquationFit</a>
for a description of the available control input and output
variables.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterToWater;
