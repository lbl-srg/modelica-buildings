within Buildings.Fluid.AirFilters.BaseClasses;
model FlowCoefficientCorrection
  "Component that calculates the flow coefficient correction factor"
  parameter Real b = 1.1
    "Resistance coefficient";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rat(
    each final unit="1",
    each final min=0,
    each final max=1)
    "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    each final unit="1",
    each final min=1)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
initial equation
  assert(b - 1.0 > 0.01,
          "In " + getInstanceName() + ":The resistance coefficient should be larger
          than 1",
         level = AssertionLevel.error)
         "Validate the resistance coefficient";
equation
  y = b^rat;

annotation (defaultComponentName="coeCor",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model calculates the flow coefficient of the filter by
</p>
<p align=\"center\" style=\"font-style:italic;\">
 kCor = b<sup>rat</sup>,
</p>
<p>
where <code>b</code> is the resistance coefficient and it has to be greater than 1,
<code>rat</code> is the relative mass of the contaminant captured by the filter
(see descriptions in 
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>).
</p>
<h4>References</h4>
<p>
Qiang Li ta al., (2022). Experimental study on the synthetic dust loading characteristics of air filters.
Separation and Purification Technology 284 (2022), 120209
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
