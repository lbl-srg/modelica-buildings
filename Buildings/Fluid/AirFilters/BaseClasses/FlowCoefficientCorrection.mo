within Buildings.Fluid.AirFilters.BaseClasses;
model FlowCoefficientCorrection
  "Component that calculates the flow coefficient correction factor"
  parameter Real b(
    final min = 1 + 1E-3)
    "Resistance coefficient";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rat(
    final unit="1",
    final min=0,
    final max=1)
    "Relative mass of the contaminant captured by the filter"
   annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    final min=1)
    "Flow coefficient correction" annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{
            140,20}})));
equation
  y = b^rat;
   annotation (Dialog(group="Pressure"),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-143,-98},{157,-138}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="kCor",
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model calculates the flow coefficient of the filter by
</p>
<p align=\"center\" style=\"font-style:italic;\">
  kCor = b<sup>rat</sup>,
</p>
<p>
where <i>b</i> is a constant that is larger than 1,
<i>rat</i> is the relative mass of the contaminant captured by the filter (see descriptions in 
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>).
</p>
<h4>References</h4>
<p>
Qiang Li ta al., (2022). Experimental study on the synthetic dust loading characteristics of air filters.
Separation and Purification Technology 284 (2022), 120209
</p>
</html>"));
end FlowCoefficientCorrection;
