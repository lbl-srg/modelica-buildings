within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function singleUTubeResistances
  "Thermal resistances for single U-tube, according to Bauer et al. 2011"

  // Geometry borehole
  input Modelica.SIunits.Height hSeg "Height of the element";
  // Geometry pipe
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  input Modelica.SIunits.Radius rTub "Radius of the tube";
  input Modelica.SIunits.Length eTub "Thickness of the tubes";
  input Modelica.SIunits.Length sha
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // thermal properties
  input Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the grout";
  input Modelica.SIunits.ThermalConductivity kTub
    "Thermal conductivity of the tube";

  // Outputs
  output Modelica.SIunits.ThermalResistance Rgb
    "Thermal resistance between: Grout zone and bore hole wall";
  output Modelica.SIunits.ThermalResistance Rgg
    "Thermal resistance between: The two grout zones";
  output Modelica.SIunits.ThermalResistance RCondGro
    "Thermal resistance between: pipe wall to capacity in grout";
  output Real x "capacity location";

  output Integer i=1 "loop counter";

protected
  Boolean test=false "thermodynamic test for R and x value";

  Modelica.SIunits.ThermalResistance Rg
    "Thermal resistance between: Outer wall and one tube";
  Modelica.SIunits.ThermalResistance Rar
    "Thermal resistance between: The two pipe outer walls";
  Modelica.SIunits.ThermalResistance RCondPipe
    "Thermal resistance of the pipe's wall";

algorithm
  // ********** Help variables **********
  //Thermal resistance between: Outer wall and one tube
  Rg := Modelica.Math.acosh((rBor^2 + (rTub + eTub)^2 - sha^2)/(2*rBor*(rTub +
    eTub)))/(2*Modelica.Constants.pi*hSeg*kFil)*(1.601 - 0.888*sha/rBor);

  //Thermal resistance between: The two pipe outer walls
  Rar := Modelica.Math.acosh((2*sha^2 - (rTub + eTub)^2)/(rTub + eTub)^2)/(2*
    Modelica.Constants.pi*hSeg*kFil);

  // ********** Resistances **********

  while test == false and i <= 10 loop
    // Capacity location ( with correction factor in case that the test is negative
    x := Modelica.Math.log(sqrt(rBor^2 + 2*(rTub + eTub)^2)/(2*(rTub + eTub)))/
      Modelica.Math.log(rBor/(sqrt(2)*(rTub + eTub)))*((15 - i + 1)/15);

    //Thermal resistance between: Grout zone and bore hole wall
    Rgb := (1 - x)*Rg;

    //Thermal resistance between: The two grout zones
    Rgg := 2*Rgb*(Rar - 2*x*Rg)/(2*Rgb - Rar + 2*x*Rg);

    // Thermodynamic test to check if negative R values make sense. If not, decrease x-value.
    test := if (1/Rgg + 1/2/Rgb)^(-1) > 0 then true else false;
    i := i + 1;
  end while;
  //Conduction resistance in grout from pipe wall to capacity in grout
  RCondGro := x*Rg + Modelica.Math.log((rTub + eTub)/rTub)/(2*Modelica.Constants.pi
    *hSeg*kTub);

  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the borehole total thermal resistance for a single U-tube.
The computation is as defined in Hellstom (1991).
The total thermal resistance is the contribution of three different resistances as
<p align=\"center\" style=\"font-style:italic;\">
 R<sub>tot</sub>= R<sub>Con</sub> + R<sub>tub</sub> + R<sub>fil</sub>.
</p>
<p>
where 
<i>R<sub>Con</sub></i> is the convective resistance of the fluid, 
<i>R<sub>tub</sub></i> is the conductive resistance of the tube wall and 
<i>R<sub>fil</sub></i> is the resistance of the filling material.
</p>
<p>
The convective resistance is obtained as
<p>
 <p align=\"center\" style=\"font-style:italic;\">
 R<sub>Con</sub> = 1 &frasl; (4 &pi; h<sub>seg</sub> r<sub>tub</sub> h<sub>in</sub> ),
 </p> 
<p>
where <i>h<sub>seg</sub></i> is the height of the segment and 
<i>h<sub>in</sub></i> is the convective heat transfer coefficient. 
The convective heat transfer coefficient is determined using the 
Dittus-Boelter correlation,
</p>
<p align=\"center\" style=\"font-style:italic;\">
 h<sub>in</sub>= 0.023 k<sub>med</sub> Pr<sup>0.35</sup> Re<sup>0.8</sup> &frasl; 2 r<sub>tub</sub>,
</p>
<p>
where <i>k<sub>med</sub></i> is the thermal conductivity of the fluid, 
<i>Pr</i> is the Prandtl number, 
<i>Re</i> is the Reynolds number and 
<i>r<sub>tub</sub></i> is the inside radius of the pipe.
</p>
<p>
The conductive resistance is determined using
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>tub</sub>= ln[ ( r<sub>tub</sub>+e<sub>tub</sub> ) &frasl; r<sub>tub</sub> ] &frasl; 4 &pi; 
   k<sub>tub</sub> h<sub>seg</sub>,
 </p>
where <i>k<sub>tub</sub></i> the heat conductivity of the pipe and 
<i>e<sub>tub</sub></i> is the thickness of the wall.
</p>
<p>
The resistance of the filling material is determined using the correlation from Paul (1996) :
<p align=\"center\" style=\"font-style:italic;\">
R<sub>fil</sub> = k<sub>fil</sub> h<sub>seg</sub> &beta;<sub>0</sub> 
  (r<sub>Bor</sub> &frasl; (r<sub>tub</sub> + e<sub>tub</sub>)) <sup>&beta;<sub>1</sub></sup> ,
</p>
<p>
where <i>k<sub>fil</sub></i> is the thermal conductivity of the filling material and 
<i>&beta;<sub>0</sub>, &beta;<sub>1</sub></i> are the resistance shape factors
(Paul 1996) based on U-tube shank spacing.
Paul's shape factors are based on experimental and finite element analysis of typical borehole.
The default values used for these coefficients are &beta;<sub>0</sub>= 20.100 and &beta;<sub>1</sub>=-0.94467.
Values listed by Paul are given in the table below.
</p>
<p>
  <table>
  <tr><th>pipe spacing</th><th><i>&beta;<sub>0</sub></i></th><th><i>&beta;<sub>1</sub></i></th></tr>
  <tr><td> close  </td><td> 20.100377 </td><td> -0.94467 </td></tr>
  <tr><td> middle  </td><td> 17.44 </td><td> -0.6052  </td></tr>
  <tr><td> spaced </td><td> 21.91 </td><td> -0.3796 </td></tr>
  </table>
  </p>
<h4>References</h4>
<p>
Hellstrom, G (1991). <br>
 <a href=\"http://intraweb.stockton.edu/eyos/energy_studies/content/docs/proceedings/HELLS.PDF\">
 Thermal Performance of Borehole Heat Exchangers</a>.<br> 
Department of Mathematical Physics, Lund Institute of Technology.
</p>
<p>
Paul, N.D (1996). <i>The effect of grout thermal conductivity on vertical geothermal heat exchanger design
and performance.</i> 
Master of Science Thesis, South Dakota State University.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end singleUTubeResistances;
