within Buildings.Fluid.AirFilters.BaseClasses;
model FiltrationEfficiency
  "Component that calculates the filtration efficiency"
  parameter Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per
    "Record with performance dat"
    annotation (Placement(transformation(extent={{20,62},{40,82}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon(
    final unit="kg")
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[size(per.substanceName, 1)](
    each final unit="1",
    each final min=0,
    each final max=1) "Filtration efficiency"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rat(
    each final unit="1",
    each final min=0,
    each final max=1)
    "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
equation
  rat = Buildings.Utilities.Math.Functions.smoothMin(
                x1=1,
                x2= mCon/per.mCon_nominal,
                deltaX=0.1)
                "Calculate the relative mass of the contaminant captured by the filter";
  for i in 1:size(per.substanceName, 1) loop
     y[i] = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=rat,
                xSup=per.filterationEfficiencyParameters.rat[i],
                ySup=per.filterationEfficiencyParameters.eps[i])
                "Calculate the filtration efficiency";
  end for;
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
This model calculates the filtration efficiency, <i>eps</i>, based on the cubic hermite spline interpolation of
the filter dataset (see 
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.Characteristics.filterationEfficiencyParameters\">
Buildings.Fluid.AirFilters.BaseClasses.Characteristics.filterationEfficiencyParameters</a>).
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
