within Buildings.Fluid.AirFilters.BaseClasses;
model FiltrationEfficiency
  "Component that calculates the filtration efficiency"
  parameter Real mCon_nominal(
    final unit="kg")
    "Maximum mass of the contaminant can be captured by the filter";
  parameter Real epsFun[:]
    "Filtration efficiency curve";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon(
    final unit="kg")
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    final min=0,
    final max=1)
    "Filtration efficiency"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rat(
    final unit="1",
    final min=0,
    final max=1)
    "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

equation
  rat = Buildings.Utilities.Math.Functions.smoothMin(x1=1, x2= mCon/mCon_nominal, deltaX=0.1);
  y = Buildings.Utilities.Math.Functions.polynomial(a=epsFun, x=rat);
  assert(
    y > 0 and y < 1,
    "In " + getInstanceName() + ": The filter efficiency has to be in the range of [0, 1], 
    check the filter efficiency curve.",
    level=AssertionLevel.error);

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
  defaultComponentName="eps",
Documentation(info="<html>
<p>
This model calculates the filtration efficiency, <i>eps</i>, by
</p>
<p align=\"center\" style=\"font-style:italic;\">
eps = epsFun<sub>1</sub> + epsFun<sub>2</sub>rat + epsFun<sub>3</sub> rat<sup>2</sup> + ...,
</p>
<p>
where the coefficients <i>epsFun<sub>i</sub></i> are declared by the parameter <i>epsFun</i>;
</p>
<p>
The <i>rat</i> is the relative mass of the contaminant captured by the filter
and is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
rat =  mCon/mCon_nominal,
</p>
<p>
where <i>mCon</i> is the mass of the contaminant captured by the filter,
<i>mCon_nominal</i> is the maximum mass of the contaminant captured by the filter.
</p>
<P>
<b>Note:</b>
The upper limit of <i>rat</i> is 1 and any value above it is overwritten by 1.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiltrationEfficiency;
