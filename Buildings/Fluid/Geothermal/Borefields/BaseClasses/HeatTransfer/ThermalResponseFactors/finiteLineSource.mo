within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function finiteLineSource
  "Finite line source solution of Claesson and Javed"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.Time t "Time";
  input Modelica.SIunits.ThermalDiffusivity aSoi "Ground thermal diffusivity";
  input Modelica.SIunits.Distance dis "Radial distance between borehole axes";
  input Modelica.SIunits.Height len1 "Length of emitting borehole";
  input Modelica.SIunits.Height burDep1 "Buried depth of emitting borehole";
  input Modelica.SIunits.Height len2 "Length of receiving borehole";
  input Modelica.SIunits.Height burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real h_21 "Thermal response factor of borehole 1 on borehole 2";

protected
  Real lowBou(unit="m-1") "Lower bound of integration";
  // Upper bound is infinite
  Real uppBou(unit="m-1") = max(100.0, 10.0/dis) "Upper bound of integration";
  Modelica.SIunits.Distance disMin
    "Minimum distance between sources and receiving line";
  Modelica.SIunits.Time timTre "Time treshold for evaluation of the solution";

algorithm

  h_21 := 0;
  if t > 0 and (includeRealSource or includeMirrorSource) then
    // Find the minimum distance between the line source and the line where the
    // finite line source solution is evaluated.
    if includeRealSource then
      if (burDep2 + len2) < burDep1 then
        disMin := sqrt(dis^2 + (burDep1 - burDep2 - len2)^2);
      elseif burDep2 > (burDep1 + len1) then
        disMin := sqrt(dis^2 + (burDep1 - burDep2 + len1)^2);
      else
        disMin := dis;
      end if;
    else
      disMin := sqrt(dis^2 + (burDep1 + burDep2)^2);
    end if;
    // The traveled distance of the temperature front is assumed to be:
    // d = 5*sqrt(aSoi*t).
    // The solution is only evaluated at times when the traveled distance is
    // greater than the minimum distance.
    timTre := disMin^2/(25*aSoi);

    if t >= timTre then
      lowBou := 1.0/sqrt(4*aSoi*t);
      h_21 := Modelica.Math.Nonlinear.quadratureLobatto(
        function
          Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
          dis=dis,
          len1=len1,
          burDep1=burDep1,
          len2=len2,
          burDep2=burDep2,
          includeRealSource=includeRealSource,
          includeMirrorSource=includeMirrorSource),
        lowBou,
        uppBou,
        1.0e-6);
    else
      // Linearize the solution at times below the time treshold.
      lowBou := 1.0/sqrt(4*aSoi*timTre);
      h_21 := t/timTre*Modelica.Math.Nonlinear.quadratureLobatto(
        function
          Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
          dis=dis,
          len1=len1,
          burDep1=burDep1,
          len2=len2,
          burDep2=burDep2,
          includeRealSource=includeRealSource,
          includeMirrorSource=includeMirrorSource),
        lowBou,
        uppBou,
        1.0e-6);
    end if;
  end if;

annotation (
Documentation(info="<html>
<p>
This function evaluates the finite line source solution. This solution
gives the relation between the constant heat transfer rate (per unit length)
injected by a line source of finite length <i>H<sub>1</sub></i> buried at a
distance <i>D<sub>1</sub></i> from a constant temperature surface
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
The finite line source solution is given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_02.png\" />
</p>
<p>
where <i>&alpha;<sub>s</sub></i> is the ground thermal diffusivity and
<i>erfint</i> is the integral of the error function, defined in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Erfint\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_erfint</a>.
The integral is solved numerically, with the integrand defined in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2019, by Massimo Cimmino:<br/>
Modified the upper bound of integration to avoid underestimating the value of
the integral.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1107\">IBPSA, issue 1107</a>.
</li>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource;
