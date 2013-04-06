within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function boreholeInternalResistance
  "Calculate the internal resistance of the borehole"
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  input Modelica.SIunits.Radius rTub "Radius of the tube";
  input Modelica.SIunits.Length eTub "Thickness of the tubes";
  input Modelica.SIunits.Length xC
    "Shank spacing, defined as half the center-to-center distance between the two pipes";
  input Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the filling material";
  input Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soil";
  output Modelica.SIunits.ThermalResistance R
    "Internal resistance of the borehole";
protected
  final parameter Real P1=rBor/(rTub + eTub)
    "Non-dimensional geometrical parameter ";
  final parameter Real P2=rBor/xC "Non-dimensional geometrical parameter ";
  final parameter Real P3=(kFil - kSoi)/(kFil + kSoi)
    "Non-dimensional parameter for filling and soil conductivity";
algorithm
  assert(xC > (rTub + eTub) and xC < rBor - (rTub + eTub),
  "Parameters do not correspond to physically possible location of borehole tube.
    xC   = " + String(xC) + "
    rTub = " + String(rTub) + "
    eTub = " + String(eTub) + ".");
  R := Modelica.Math.log((2*P1*(P2^2 + 1)^P3)/(P2*(P2^2 - 1)^P3))/
           (Modelica.Constants.pi*kFil*hSeg);
  annotation (Documentation(info="<html>
<p>
This model computes the internal resistance <i>R</i> of a single U-tube borehole, 
as defined by Hellstrom (1991), as 
</p>
<p align=\"center\" style=\"font-style:italic;\">
 k = ( 2 P<sub>1</sub> ( P<sub>2</sub><sup>2</sup> + 1 ) <sup>W</sup> ) / ( P<sub>2</sub> ( P<sub>2</sub><sup>2</sup> - 1 )<sup>W</sup> ),
</p>
<p align=\"center\" style=\"font-style:italic;\">
 R = ln(k) / (&pi; k<sub>fil</sub> h<sub>seg</sub>) ,
 </p>
where <i>P<sub>1</sub> </i> and <i>P<sub>2</sub></i> are two dimensionless geometrical factors and
<i>W</i> is a conductivity ratio.
The geometrical factors are defined as
<i>P<sub>1</sub> = r<sub>bor</sub>/(r<sub>tub</sub> + e<sub>tub</sub>)</i>, 
where <i>r<sub>bor</sub></i> is the borehole radius and  <i>r<sub>tub</sub> + e<sub>tub</sub> </i> is
the external radius of a pipe and
<i>P<sub>2</sub> = r<sub>bor</sub>/ x<sub>c</sub> </i>, where
<i>x<sub>c</sub></i> is the shank spacing defined as half the center-to-center distance 
between the two pipes, and
<i>W = k<sub>fil</sub> - k<sub>soi</sub>/ (k<sub>soi</sub> + k<sub>fil</sub>)</i>.
</p>
<h4>References</h4>
<p>
Hellstrom, G (1991). <br>
 <a href=\"http://intraweb.stockton.edu/eyos/energy_studies/content/docs/proceedings/HELLS.PDF\">
 Thermal Performance of Borehole Heat Exchangers</a>.<br> 
Department of Mathematical Physics, Lund Institute of Technology.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end boreholeInternalResistance;
