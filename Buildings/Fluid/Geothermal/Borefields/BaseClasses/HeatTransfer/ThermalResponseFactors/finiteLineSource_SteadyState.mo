within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function finiteLineSource_SteadyState
  "Steady-state finite line source solution"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Distance dis "Radial distance between borehole axes";
  input Modelica.Units.SI.Height len1 "Length of emitting borehole";
  input Modelica.Units.SI.Height burDep1 "Buried depth of emitting borehole";
  input Modelica.Units.SI.Height len2 "Length of receiving borehole";
  input Modelica.Units.SI.Height burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real h_21 "Thermal response factor of borehole 1 on borehole 2";

protected
  Real f "Intermediate variable for FLS solution";
  Real p[4] =  {1., -1., 1., -1.} "Intermediate variable for sum coefficients";
  Real q[4] "Intermediate variable for axial distances";
algorithm
  if includeRealSource then
    q := {burDep2 - burDep1 + len2,
          burDep2 - burDep1,
          burDep2 - burDep1 - len1,
          burDep2 - burDep1 + len2 - len1};
    f := p * (q .* log((q + sqrt(q.*q + ones(4)*dis^2)) / dis) - sqrt(q.*q + ones(4)*dis^2));
  else
    f := 0;
  end if;
  if includeMirrorSource then
    q := {burDep2 + burDep1 + len2,
          burDep2 + burDep1,
          burDep2 + burDep1 + len1,
          burDep2 + burDep1 + len2 + len1};
    f := f + p * (q .* log((q + sqrt(q.*q + ones(4)*dis^2)) / dis) - sqrt(q.*q + ones(4)*dis^2));
  end if;
  h_21 := 0.5 * f / len2;

annotation (
Documentation(info="<html>
<p>
This function evaluates the steady-state value of finite line source solution.
This solution gives the relation between the constant heat transfer rate (per
unit length) injected by a line source of finite length <i>H<sub>1</sub></i>
buried at a distance <i>D<sub>1</sub></i> from a constant temperature surface
(<i>T=0</i>) and the average temperature raise over a line of finite length
<i>H<sub>2</sub></i> buried at a distance <i>D<sub>2</sub></i> from the constant
temperature surface.
The finite line source solution is defined by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_01.png\" />
</p>
<p>
where <i>&Delta;T<sub>1-2</sub>(t,r,H<sub>1</sub>,D<sub>1</sub>,H<sub>2</sub>,D<sub>2</sub>)</i>
is the temperature raise after a time <i>t</i> of constant heat injection and at
a distance <i>r</i> from the line heat source, <i>Q'</i> is the heat injection
rate per unit length, <i>k<sub>s</sub></i> is the soil thermal conductivity and
<i>h<sub>FLS</sub></i> is the finite line source solution.
</p>
<p>
The steady-state finite line source solution is given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_SteadyState_01.png\" />
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_SteadyState_02.png\" />
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource_SteadyState;
