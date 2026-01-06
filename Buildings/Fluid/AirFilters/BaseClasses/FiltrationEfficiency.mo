within Buildings.Fluid.AirFilters.BaseClasses;
model FiltrationEfficiency
  "Filtration efficiencies for capturing each contaminant"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Mass mCon_max
    "Maximum mass of the contaminant that can be captured by the filter";
  parameter String namCon[:]
    "Name of trace substance";
  parameter Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters filEffPar[nConSub]
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
    "Relative mass of the contaminant captured by the filter, which is the total captured contaminant mass divided by the filter's maximum contaminant capacity"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
protected
  parameter Integer nConSub = size(namCon,1)
    "Total types of contaminant substances";
equation
  rat = mCon/mCon_max "Relative mass of the contaminant captured by the filter";
  for i in 1:nConSub loop
     y[i] = Buildings.Utilities.Math.Functions.smoothLimit(
        Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=rat,
                xSup=filEffPar[i].rat,
                ySup=filEffPar[i].eps),
        0,
        1,
        1E-3)
     "Calculate the filtration efficiency";
  end for;
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="eps",
Documentation(info="<html>
<p>
This model calculates the filtration efficiency, <i>eps</i>, using cubic Hermite
spline interpolation of the filter dataset (see
<a href=\"modelica://Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters\">
Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters</a>)
with respect to the input <i>rat</i>.
</p>
<p>
The <i>rat</i> is the relative mass of the contaminant that is captured by the filter,
and is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
rat =  mCon/mCon_max,
</p>
<p>
where <i>mCon</i> is the mass of all the captured contaminants, and
<i>mCon_max</i> is the maximum mass of the contaminants that can be captured.
</p>
</html>", revisions="<html>
<ul>
<li>
December 10, 2025, by Michael Wetter:<br/>
Changed <code>rat</code> to be not bounded by <i>1</i> as there is no need for such a bound.
</li>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiltrationEfficiency;
