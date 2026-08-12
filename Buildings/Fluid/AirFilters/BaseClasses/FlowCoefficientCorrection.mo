within Buildings.Fluid.AirFilters.BaseClasses;
model FlowCoefficientCorrection
  "Flow coefficient correction factor due to the contaminant accumulation"
  extends Modelica.Blocks.Icons.Block;

  parameter Real b(min=1)=2.0
    "Resistance coefficient";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rat(
    final unit="1",
    final min=0,
    final max=1)
    "Relative mass of the contaminant captured by the filter. It's the total captured contaminant mass divided by the filter's maximum contaminant capacity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    final min=1)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
initial equation
  assert(b>1,
          "In " + getInstanceName() + ":The resistance coefficient must be larger than 1",
         level = AssertionLevel.error)
         "Validate the resistance coefficient";
equation
  y=b^rat;

annotation (defaultComponentName="coeCor",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model calculates the flow coefficient of the filter by
</p>
<p align=\"center\" style=\"font-style:italic;\">
dpCor = b<sup>rat</sup>,
</p>
<p>
where <code>b</code> is the flow resistance coefficient, which must be greater than <i>1</i>,
<code>rat</code> is the relative mass of the contaminant that is captured by the filter
as described in 
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>.
</p>
<h4>References</h4>
<p>
Qiang Li ta al., (2022). Experimental study on the synthetic dust loading characteristics
of air filters. Separation and Purification Technology 284 (2022), 120209.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowCoefficientCorrection;
