within Buildings.Fluid.AirFilters.BaseClasses;
model FiltrationEfficiency
  "Component that calculates the filtration efficiency"

  parameter Real mCon_nominal(
    final unit = "kg")
    "Maximum mass of the contaminant that can be captured by the filter";
  parameter String substanceName[:] = {"CO2"}
    "Name of trace substance";
  parameter
    Buildings.Fluid.AirFilters.BaseClasses.Characteristics.FiltrationEfficiencyParameters
    filEffPar
    "Filtration efficiency versus relative mass of the contaminant";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon(
    final unit="kg")
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nConSub](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Filtration efficiency of each contaminant"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rat(
    final unit="1",
    final min=0,
    final max=1)
    "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
protected
  parameter Integer nConSub = size(substanceName,1)
    "Total types of contaminant substances";
equation
  rat = Buildings.Utilities.Math.Functions.smoothMin(
                x1=1,
                x2= mCon/mCon_nominal,
                deltaX=0.1)
                "Calculate the relative mass of the contaminant captured by the filter";
  for i in 1:nConSub loop
     y[i] = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=rat,
                xSup=filEffPar.rat[i],
                ySup=filEffPar.eps[i])
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
This model calculates the filtration efficiency, <i>eps</i>, using cubic Hermite spline interpolation of
the filter dataset (see 
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.Characteristics.filtrationEfficiencyParameters\">
Buildings.Fluid.AirFilters.BaseClasses.Characteristics.filtrationEfficiencyParameters</a>)
with respect to <i>rat</i>.
</p>
<p>
The <i>rat</i> is the relative mass of the contaminant that is captured by the filter,
and is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
rat =  mCon/mCon_nominal,
</p>
<p>
where <i>mCon</i> is the mass of the contaminant that is captured by the filter, and
<i>mCon_nominal</i> is the filter's maximum contaminant capacity.
</p>
<P>
<b>Note:</b>
The upper limit of <i>rat</i> is 1 and any value exceeding 1 will be capped at 1.
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
