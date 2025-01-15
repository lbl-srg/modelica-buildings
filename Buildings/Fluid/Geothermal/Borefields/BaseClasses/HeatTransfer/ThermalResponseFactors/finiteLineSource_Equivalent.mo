within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function finiteLineSource_Equivalent
  "Finite line source solution of Prieto and Cimmino"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Time t "Time";
  input Modelica.Units.SI.ThermalDiffusivity aSoi "Ground thermal diffusivity";
  input Modelica.Units.SI.Distance dis[n_dis] "Radial distance between borehole axes";
  input Integer wDis[n_dis] "Number of occurences of each distance";
  input Modelica.Units.SI.Height len1 "Length of emitting boreholes";
  input Modelica.Units.SI.Height burDep1 "Buried depth of emitting boreholes";
  input Modelica.Units.SI.Height len2 "Length of receiving boreholes";
  input Modelica.Units.SI.Height burDep2 "Buried depth of receiving boreholes";
  input Integer nBor2 "Number of receiving boreholes";
  input Integer n_dis "Number of unique distances";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real h_21 "Thermal response factor of borehole 1 on borehole 2";

protected
  Real lowBou(unit="m-1") "Lower bound of integration";
  // Upper bound is infinite
  Real uppBou(unit="m-1") = max(100.0, 10.0/min(dis)) "Upper bound of integration";
  Modelica.Units.SI.Distance disMin
    "Minimum distance between sources and receiving line";
  Modelica.Units.SI.Time timTre "Time treshold for evaluation of the solution";

algorithm

  h_21 := 0;
  if t > 0 and (includeRealSource or includeMirrorSource) then
    // Find the minimum distance between the line source and the line where the
    // finite line source solution is evaluated.
    if includeRealSource then
      if (burDep2 + len2) < burDep1 then
        disMin := sqrt(min(dis)^2 + (burDep1 - burDep2 - len2)^2);
      elseif burDep2 > (burDep1 + len1) then
        disMin := sqrt(min(dis)^2 + (burDep1 - burDep2 + len1)^2);
      else
        disMin := min(dis);
      end if;
    else
      disMin := sqrt(min(dis)^2 + (burDep1 + burDep2)^2);
    end if;
    // The traveled distance of the temperature front is assumed to be:
    // d = 5*sqrt(aSoi*t).
    // The solution is only evaluated at times when the traveled distance is
    // greater than the minimum distance.
    timTre := disMin^2/(25*aSoi);

    if t >= timTre then
      lowBou := 1.0/sqrt(4*aSoi*t);
      h_21 :=Modelica.Math.Nonlinear.quadratureLobatto(
        function
          Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent(
          dis=dis,
          wDis=wDis,
          len1=len1,
          burDep1=burDep1,
          len2=len2,
          burDep2=burDep2,
          nBor2=nBor2,
          n_dis=n_dis,
          includeRealSource=includeRealSource,
          includeMirrorSource=includeMirrorSource),
        lowBou,
        uppBou,
        1.0e-6);
    else
      // Linearize the solution at times below the time treshold.
      lowBou := 1.0/sqrt(4*aSoi*timTre);
      h_21 :=t/timTre*Modelica.Math.Nonlinear.quadratureLobatto(
        function
          Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent(
          dis=dis,
          wDis=wDis,
          len1=len1,
          burDep1=burDep1,
          len2=len2,
          burDep2=burDep2,
          nBor2=nBor2,
          n_dis=n_dis,
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
injected by a group of line sources of finite length <i>H<sub>1</sub></i> buried
at a distance <i>D<sub>1</sub></i> from a constant temperature surface
(<i>T=0</i>) and the average temperature raise over a group of
<i>N<sub>2</sub></i> lines of finite length <i>H<sub>2</sub></i> buried at a
distance <i>D<sub>2</sub></i> from the constant temperature surface.
The finite line source solution is defined by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_EquivalentBoreholes_01.png\" />
</p>
<p>
where <i>&Delta;T<sub>1-2</sub>(t,r<sub>1->2</sub>,H<sub>1</sub>,D<sub>1</sub>,H<sub>2</sub>,D<sub>2</sub>,N<sub>2</sub>)</i>
is the temperature raise over lines in group <i>2</i> after a time <i>t</i> of
constant heat injection, <i>r<sub>1->2</sub></i> is the list of distance between
all pairs of lines in groups <i>1</i> and <i>2</i>, <i>N<sub>1->2</sub></i> is
the number of distances, <i>Q'</i> is the heat injection
rate per unit length, <i>k<sub>s</sub></i> is the soil thermal conductivity and
<i>h<sub>FLS</sub></i> is the finite line source solution.
</p>
<p>
The finite line source solution is given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/FiniteLineSource_EquivalentBoreholes_02.png\" />
</p>
<p>
where <i>&alpha;<sub>s</sub></i> is the ground thermal diffusivity and
<i>erfint</i> is the integral of the error function, defined in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Erfint\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_erfint</a>.
The integral is solved numerically, with the integrand defined in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource_Equivalent;
