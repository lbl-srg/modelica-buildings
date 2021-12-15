within Buildings.Fluid.Geothermal.Boreholes.BaseClasses;
function singleUTubeResistances "Thermal resistances for single U-tube"

  // Geometry of the borehole
  input Modelica.Units.SI.Height hSeg "Height of the element";
  input Modelica.Units.SI.Radius rBor "Radius of the borehole";
  // Geometry of the pipe
  input Modelica.Units.SI.Radius rTub "Radius of the tube";
  input Modelica.Units.SI.Length eTub "Thickness of the tubes";
  input Modelica.Units.SI.Length xC
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soi";
  input Modelica.Units.SI.ThermalConductivity kFil
    "Thermal conductivity of the grout";
  input Modelica.Units.SI.ThermalConductivity kTub
    "Thermal conductivity of the tube";

  // Outputs
  output Modelica.Units.SI.ThermalResistance Rgb
    "Thermal resistance between the grout zone and the borehole wall";
  output Modelica.Units.SI.ThermalResistance Rgg
    "Thermal resistance between the two grout zones";
  output Modelica.Units.SI.ThermalResistance RCondGro
    "Thermal resistance between the pipe wall ant the capacity in the grout";
  output Real x "Capacity location";

protected
  Boolean test=false "Thermodynamic test for R and x value";

  Modelica.Units.SI.ThermalResistance Rg
    "Thermal resistance between outer borehole wall and one tube";
  Modelica.Units.SI.ThermalResistance Rar
    "Thermal resistance between the two pipe outer walls";
  Modelica.Units.SI.ThermalResistance RCondPipe
    "Thermal resistance of the pipe wall";

  Real Rb
    "Fluid-to-grout resistance, as defined by Hellstroem. Resistance from the fluid in the pipe to the borehole wall";
  Real Ra
    "Grout-to-grout resistance (2D) as defined by Hellstroem. Interaction between the different grout part";

  // Help variables
  Real sigma "Help variable as defined by Hellstroem";
  Real beta "Help variable as defined by Hellstroem";
  Real R_1delta_LS
    "One leg of the triangle resistance network, corresponding to the line source solution";
  Real R_1delta_MP
    "One leg of the triangle resistance network, corresponding to the multipole solution";
  Real Ra_LS
    "Grout-to-grout resistance calculated with the line-source approximation";

  Integer i=1 "Loop counter";

algorithm
  // ********** Rb and Ra from multipole **********
  // Help variables
  RCondPipe :=Modelica.Math.log((rTub + eTub)/rTub)/(2*Modelica.Constants.pi*hSeg*kTub);
  beta :=2*Modelica.Constants.pi*kFil*RCondPipe;
  sigma :=(kFil - kSoi)/(kFil + kSoi);
  R_1delta_LS :=1/(2*Modelica.Constants.pi*kFil)*(log(rBor/(rTub + eTub)) + log(rBor/(2*xC)) +
    sigma*log(rBor^4/(rBor^4 - xC^4)));
  R_1delta_MP :=R_1delta_LS - 1/(2*Modelica.Constants.pi*kFil)*((rTub + eTub)^2/
    (4*xC^2)*(1 - sigma*4*xC^4/(rBor^4 - xC^4))^2)/((1 + beta)/(1 - beta) + (
    rTub + eTub)^2/(4*xC^2)*(1 + sigma*16*xC^4*rBor^4/(rBor^4 - xC^4)^2));
  Ra_LS      :=1/(Modelica.Constants.pi*kFil)*(log(2*xC/rTub) + sigma*log((
    rBor^2 + xC^2)/(rBor^2 - xC^2)));

  //Rb and Ra
  Rb :=R_1delta_MP/2;
  Ra :=Ra_LS - 1/(Modelica.Constants.pi*kFil)*(rTub^2/(4*xC^2)*(1 + sigma*
    4*rBor^4*xC^2/(rBor^4 - xC^4))/((1 + beta)/(1 - beta) - rTub^2/(4*xC^2) +
    sigma*2*rTub^2*rBor^2*(rBor^4 + xC^4)/(rBor^4 - xC^4)^2));

  //Conversion of Rb (resp. Ra) to Rg (resp. Rar) of Bauer:
  Rg  :=2*Rb/hSeg;
  Rar :=Ra/hSeg;

/* **************** Simplification of Bauer for single U-tube ************************
  //Thermal resistance between: Outer wall and one tube
     Rg := Modelica.Math.acosh((rBor^2 + (rTub + eTub)^2 - xC^2)/(2*rBor*(rTub +
       eTub)))/(2*Modelica.Constants.pi*hSeg*kFil)*(1.601 - 0.888*xC/rBor);

  //Thermal resistance between: The two pipe outer walls
  Rar := Modelica.Math.acosh((2*xC^2 - (rTub + eTub)^2)/(rTub + eTub)^2)/(2*
       Modelica.Constants.pi*hSeg*kFil);
*************************************************************************************** */

  // ********** Resistances and capacity location according to Bauer **********
  while test == false and i <= 15 loop
    // Capacity location (with correction factor in case that the test is negative)
    x := Modelica.Math.log(sqrt(rBor^2 + 2*(rTub + eTub)^2)/(2*(rTub + eTub)))/
      Modelica.Math.log(rBor/(sqrt(2)*(rTub + eTub)))*((15 - i + 1)/15);

    //Thermal resistance between the grout zone and bore hole wall
    Rgb := (1 - x)*Rg;

    //Thermal resistance between the two grout zones
    Rgg := 2*Rgb*(Rar - 2*x*Rg)/(2*Rgb - Rar + 2*x*Rg);

    // Thermodynamic test to check if negative R values make sense.
    // If not, decrease x-value.
    test := (1/Rgg + 1/2/Rgb > 0);
    i := i + 1;
  end while;
  // Check for errors.
  assert(test,
  "Maximum number of iterations exceeded. Check the borehole geometry.
  The tubes may be too close to the borehole wall.
  Input to the function
  Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances
  is
           hSeg = " + String(hSeg) + " m
           rBor = " + String(rBor) + " m
           rTub = " + String(rTub) + " m
           eTub = " + String(eTub) + " m
           xC   = " + String(xC)  + " m
           kSoi = " + String(kSoi) + " W/m/K
           kFil = " + String(kFil) + " W/m/K
           kTub = " + String(kTub) + " W/m/K
  Computed x    = " + String(x) + " K/W
           Rgb  = " + String(Rgb) + " K/W
           Rgg  = " + String(Rgg) + " K/W");

  //Conduction resistance in grout from pipe wall to capacity in grout
  RCondGro := x*Rg + RCondPipe;

  annotation ( Documentation(info="<html>
<p>
This model computes the thermal resistances of a
single-U-tube borehole using the method of Bauer et al. (2011).
It also computes the fluid-to-ground thermal resistance <i>R<sub>b</sub></i>
and the grout-to-grout thermal resistance <i>R<sub>a</sub></i> as defined by
Hellstroem (1991) using the multipole method.
</p>
<p>
The figure below shows the thermal network set up by Bauer et al. (2011).
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Boreholes/BaseClasses/Bauer_singleUTube.png\" alt=\"image\"/>
</p>
<p>
The different resistances are calculated as follows.
The grout zone and bore hole wall thermal resistance are related as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>gb</sub><sup>1U</sup> =  (  1 - x<sup>1U</sup>  )  R<sub>g</sub><sup>1U</sup>.
</p>
<p>
The thermal resistance between the two grout zones are
<p align=\"center\" style=\"font-style:italic;\">
R<sub>gg</sub><sup>1U</sup> = 2 R<sub>gb</sub><sup>1U</sup>
( R<sub>ar</sub><sup>1U</sup> - 2 x<sup>1U</sup> R<sub>g</sub><sup>1U</sup> ) /
( 2 R<sub>gb</sub><sup>1U</sup> - R<sub>ar</sub><sup>1U</sup> + 2 x<sup>1U</sup> R<sub>g</sub><sup>1U</sup> ).
</p>
<p>
Thermal resistance between the pipe wall to the capacity in the grout is
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>CondGro</sub> = x<sup>1U</sup> R<sub>g</sub><sup>1U</sup> + log (  ( r<sub>Tub</sub> + e<sub>Tub</sub> ) /r<sub>Tub</sub> ) / ( 2 &pi; h<sub>Seg</sub> k<sub>Tub</sub> ).
</p>
<p>
The capacities are located at
</p>
<p align=\"center\" style=\"font-style:italic;\">
x<sup>1U</sup> =log ( (r<sub>Bor</sub><sup>2</sup>
+ 2  ( r<sub>Tub</sub> + e<sub>Tub</sub> ) <sup>2</sup>)<sup>1&frasl;2</sup>/ ( 2  ( r<sub>Tub</sub> + e<sub>Tub</sub> )  )  ) /
log ( r<sub>Bor</sub>/ ( &radic;2  ( r<sub>Tub</sub> + e<sub>Tub</sub> ))).
</p>
<p>
The thermal resistance between the outer borehole wall and one tube is
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>g</sub><sup>1U</sup> =2 R<sub>b</sub> &frasl; h<sub>Seg</sub>.
</p>
<p>
The thermal resistance between the two pipe outer walls is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  R<sub>ar</sub><sup>1U</sup> =R<sub>a</sub> &frasl; h<sub>Seg</sub>.
</p>
<p>
The fluid to ground thermal resistance
<i>R<sub>b</sub></i>
and the grout to grout thermal resistance <i>R<sub>a</sub></i> are calculated with the multipole method
(Hellstroem (1991)) as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>b</sub> =1/ ( 4 &pi; k<sub>Fil</sub> )   ( log ( r<sub>Bor</sub>/ ( r<sub>Tub</sub> + e<sub>Tub</sub> )  )  + log ( r<sub>Bor</sub>/ ( 2 x<sub>C</sub> )  )  +
    &sigma; log ( r<sub>Bor</sub><sup>4</sup>/ ( r<sub>Bor</sub><sup>4</sup> - x<sub>C</sub><sup>4</sup> )  )  )  - 1/ ( 4 &pi; k<sub>Fil</sub> )   (  ( r<sub>Tub</sub> + e<sub>Tub</sub> ) <sup>2</sup>/
     ( 4 x<sub>C</sub><sup>2</sup> )   ( 1 - &sigma; 4 x<sub>C</sub><sup>4</sup>/ ( r<sub>Bor</sub><sup>4</sup> - x<sub>C</sub><sup>4</sup> )  ) <sup>2</sup> ) / (  ( 1 + &beta; ) / ( 1 - &beta; )  +  (
    r<sub>Tub</sub> + e<sub>Tub</sub> ) <sup>2</sup>/ ( 4 x<sub>C</sub><sup>2</sup> )   ( 1 + &sigma; 16 x<sub>C</sub><sup>4</sup> r<sub>Bor</sub><sup>4</sup>/ ( r<sub>Bor</sub><sup>4</sup> - x<sub>C</sub><sup>4</sup> ) <sup>2</sup>)).
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>a</sub> = 1/ ( &pi; k<sub>Fil</sub> )   ( log ( 2 x<sub>C</sub>/r<sub>Tub</sub> )  + &sigma; log ((
    r<sub>Bor</sub><sup>2</sup> + x<sub>C</sub><sup>2</sup> ) / ( r<sub>Bor</sub><sup>2</sup> - x<sub>C</sub><sup>2</sup> )  )  )  - 1/ ( &pi; k<sub>Fil</sub> )   ( r<sub>Tub</sub><sup>2</sup>/ ( 4 x<sub>C</sub><sup>2</sup> )   ( 1 + &sigma;
    4 r<sub>Bor</sub><sup>4</sup> x<sub>C</sub><sup>2</sup>/ ( r<sub>Bor</sub><sup>4</sup> - x<sub>C</sub><sup>4</sup> )  ) / (  ( 1 + &beta; ) / ( 1 - &beta; )  - r<sub>Tub</sub><sup>2</sup>/ ( 4 x<sub>C</sub><sup>2</sup> )  +
    &sigma; 2 r<sub>Tub</sub><sup>2</sup> r<sub>Bor</sub><sup>2</sup>  ( r<sub>Bor</sub><sup>4</sup> + x<sub>C</sub><sup>4</sup> ) / ( r<sub>Bor</sub><sup>4</sup> - x<sub>C</sub><sup>4</sup> ) <sup>2</sup>)),
</p>
<p>
with
<i>&sigma; = ( k<sub>Fil</sub> - k<sub>Soi</sub> ) / ( k<sub>Fil</sub> + k<sub>Soi</sub> ) </i> and  <i> &beta; = 2 &pi; k<sub>Fil</sub> R<sub>CondPipe</sub></i>,
where
<i>k<sub>Fil</sub></i> and <i>k<sub>Soi</sub></i> are the conductivity of the filling material
and of the ground,
<i>r<sub>Tub</sub>+e<sub>Tub</sub></i> and <i>r<sub>Bor</sub></i> are the pipe and the borehole outside radius and
<i>x<sub>C</sub></i> is the shank spacing, which is equal to the distance between
the center of borehole and the center of the pipe.
</p>
<p>
<b>Note</b>: The value of <i>R<sub>gg</sub><sup>1U</sup></i> may be negative
as long as
</p>
<p align=\"center\" style=\"font-style:italic;\">
1/R<sub>gg</sub><sup>1U</sup> + 1/(2 &nbsp; R<sub>gb</sub><sup>1U</sup>) &gt; 0,
</p>
<p>
in which case the laws of thermodynamics are not violated. See
Bauer et al. (2011) for details.
</p>
<h4>References</h4>
<p>
G. Hellstr&ouml;m. <i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>.
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
<a href=\"http://dx.doi.org/10.1002/er.1689\">
Thermal resistance and capacity models for borehole heat exchangers
</a>
</i>.
International Journal Of Energy Research, 35:312&ndash;320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
January 21, 2015 by Michael Wetter:<br/>
Fixed bug in <code>beta</code> being used before it was assigned.
</li>
<li>
February 14, 2014 by Michael Wetter:<br/>
Added an assert statement to test for non-physical values.
</li>
<li>
February 13, 2014 by Damien Picard:<br/>
Edit documentation and add formula for beta.
</li>
<li>
February 12, 2014, by Damien Picard:<br/>
Remove the flow dependency of the resistances, as this function calculates the conduction resistances only.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation.</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end singleUTubeResistances;
