within Buildings.Airflow.Multizone.BaseClasses;
function windPressureLowRise "Wind pressure coefficient for low-rise buildings"
  extends Modelica.Icons.Function;

  input Real Cp0
    "Wind pressure coefficient for normal wind incidence angle";
  input Modelica.Units.SI.Angle alpha
    "Wind incidence angle (0: normal to wall)";
  input Real G "Natural logarithm of side ratio";
  output Real Cp "Wind pressure coefficient";
protected
  constant Modelica.Units.SI.Angle pi2=2*Modelica.Constants.pi;
  constant Modelica.Units.SI.Angle aRDel=5*Modelica.Constants.pi/180
    "Lower bound where transition occurs";
  constant Modelica.Units.SI.Angle aRDel2=aRDel/2
    "Half-width of transition interval";
  constant Modelica.Units.SI.Angle aRMax=175*Modelica.Constants.pi/180
    "Upper bound where transition occurs";
  Real a180 = Modelica.Math.log(1.248 - 0.703 +
              0.131*Modelica.Math.sin(2*Modelica.Constants.pi*G)^3
              + 0.071*G^2) "Attenuation factor at 180 degree incidence angle";

  Modelica.Units.SI.Angle aR "alpha, restricted to 0...pi";
  Modelica.Units.SI.Angle incAng2 "0.5*wind incidence angle";
  Real sinA2 "=sin(alpha/2)";
  Real cosA2 "=cos(alpha/2)";
  Real a "Attenuation factor";
algorithm
  // Restrict incAng to [0...pi]

  // Change sign to positive
  aR :=if alpha < 0 then -alpha else alpha;
  // Constrain to [0...2*pi]
  if aR > pi2 then
    aR := aR - integer(aR/pi2)*pi2;
  end if;
  // Constrain to [0...pi]
  if aR > Modelica.Constants.pi then
    aR := pi2-aR;
  end if;

  // Evaluate eqn. 2-1 from FSEC-CR-163-86
  incAng2 :=aR/2;
  sinA2 :=Modelica.Math.sin(incAng2);
  cosA2 :=Modelica.Math.cos(incAng2);
  // Implementation of the wind pressure coefficient that is once
  // continuously differentiable for all incidence angles
  if aR < aRDel then
    Cp :=Cp0*Buildings.Utilities.Math.Functions.regStep(
      y1=Modelica.Math.log(1.248 - 0.703*sinA2 - 1.175*Modelica.Math.sin(aR)^2
         + 0.131*Modelica.Math.sin(2*aR*G)^3 + 0.769*cosA2 + 0.071*G^2*sinA2^2
         + 0.717*cosA2^2),
      y2=1,
      x=aR - aRDel2,
      x_small=aRDel2);
  elseif aR > aRMax then
    Cp :=Cp0*Buildings.Utilities.Math.Functions.regStep(
      y1=a180,
      y2=Modelica.Math.log(1.248 - 0.703*sinA2 - 1.175*Modelica.Math.sin(aR)^2
         + 0.131*Modelica.Math.sin(2*aR*G)^3 + 0.769*cosA2 + 0.071*G^2*sinA2^2
         + 0.717*cosA2^2),
      x=aR + aRDel2 - Modelica.Constants.pi,
      x_small=aRDel2);
  else
    Cp :=Cp0*Modelica.Math.log(1.248 - 0.703*sinA2 - 1.175*Modelica.Math.sin(aR)^2 +
      0.131*Modelica.Math.sin(2*aR*G)^3 + 0.769*cosA2 + 0.071*G^2*sinA2^2 + 0.717*cosA2^2);
  end if;
annotation (
smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the wind pressure coefficient for
low-rise buildings with rectangular shape.
The correlation is the data fit from Swami and Chandra (1987),
who fitted a function to various wind pressure coefficients from the literature.
The same correlation is also implemented in CONTAM (Persily and Ivy, 2001).
</p>
<p>
The wind pressure coefficient is computed based on the
natural logarithm of the side ratio of the walls, which is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
G = ln(x &frasl; y)
</p>
<p>
where <i>x</i> is the length of the wall that will be connected to
this model, and <i>y</i> is the length of the adjacent wall as shown
in the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Airflow/Multizone/BaseClasses/windPressureLowRise.png\" border=\"1\" alt=\"Definition of the aspect ratio.\"/>
</p>
<p>
Based on the wind incidence angle <i>&alpha;</i> and the side ratio
of the walls, the model computes how much the wind pressure
is attenuated compared to the reference wind pressure <code>Cp0</code>.
The reference wind pressure <code>Cp0</code> is a user-defined parameter,
and must be equal to the wind pressure at zero wind incidence angle, i.e.,
<i>&alpha; = 0</i>.
Swami and Chandra (1987) recommend <i>C<sub>p0</sub> = 0.6</i> for
all low-rise buildings as this represents the average of
various values reported in the literature.
The attenuation factor is
</p>
<p align=\"center\" style=\"font-style:italic;\">
C<sub>p</sub> &frasl; C<sub>p0</sub> = ln(1.248 - 0.703 sin(&alpha; &frasl; 2)
      - 1.175 sin<sup>2</sup>(&alpha;)
      - 0.131 sin<sup>3</sup>(2 &alpha; G)
      + 0.769 cos(&alpha; &frasl; 2)
       +0.071 G<sup>2</sup> * sin<sup>2</sup>(&alpha; &frasl; 2)
       + 0.717 cos<sup>2</sup>(&alpha; &frasl; 2)),
</p>
<p>
where
<i>C<sub>p</sub></i> is the wind pressure coefficient for
the current angle of incidence.
</p>
<p>
This function is used in
<a href=\"modelica://Buildings.Fluid.Sources.Outside_CpLowRise\">
Buildings.Fluid.Sources.Outside_CpLowRise</a>
which can be used directly with components of this package.
</p>
<h4>References</h4>
<ul>
<li>
Muthusamy V. Swami and
Subrato Chandra.
<i>
<a href=\"http://www.fsec.ucf.edu/en/publications/pdf/FSEC-CR-163-86.pdf\">
Procedures for
Calculating Natural
Ventilation Airflow
Rates in Buildings.</a></i>
Florida Solar Energy Center, FSEC-CR-163-86. March, 1987.
Cape Canaveral, Florida.
</li>
<li>
Andrew K. Persily and Elizabeth M. Ivy.
<i>
<a href=\"http://ws680.nist.gov/publication/get_pdf.cfm?pub_id=860831\">
Input Data for Multizone Airflow and IAQ Analysis.</a></i>
NIST, NISTIR 6585.
January, 2001.
Gaithersburg, MD.
</li>
</ul>
<h4>Implementation</h4>
<p>
Symmetry requires that the first derivative of the wind pressure coefficient
with respect to the incidence angle is zero for incidence angles of zero and &pi;.
However, the correlation of Swami and Chandra has non-zero derivatives at these values.
In this implementation, the original function is therefore slightly modified for incidence angles
between 0 and 5 degree, and between 175 and 180 degree.
This leads to a model that is differentiable in the incidence angle,
which generally leads to better numeric performance.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2022, by Michael Wetter:<br/>
Changed argment name to <code>alpha</code> for consistency with figure.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Removed <code>constant</code> keyword for <code>a180</code> as its value
depends on the input of the function.
</li>
<li>
October 27, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end windPressureLowRise;
