within Buildings.HeatTransfer.Windows.Functions;
function glassPropertyUncoated
  "Compute angular variation and hemispherical integration of the transmittance and reflectance for a uncoated glass pane without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialSingleGlassRadiation;

  input Real glass[3] "Propertry of one glass pane";
  input Modelica.Units.SI.Length x "Thickness";
  input Modelica.Units.SI.Angle psi[HEM - 1] "Incident angles";
  output Real layer[3, HEM] "Transmittance, front and back reflectance";

protected
  Integer NDIR "Number of incident angles";
  Real psi_c "cos(psi), psi is incident angle in air";
  Real psi1_c "cos(psi1), psi1 is incident angle in glass";
  Real angT "Angular variation of transmittance";
  Real angR "Angular variation of reflectance";
  Real f[3, HEM-1]
    "Temporary variables for integration in hemispherical transmittance and reflectance";
  Real beta "Temporary coefficient defined in (7.2.1i)";
  Real rho0
    "Spectral reflectivity at incident angle of 0 degree at the interface";
  Real rho "Spectral reflectivity at the interface";
  Real rho1;
  Real rho2;
  Real tau "Spectral transmissivity at the interface";
  Real tau1;
  Real tau2;
  Real angT1;
  Real angT2;
  Real angR1;
  Real angR2;
  Real tmp;
  Real alpha "Spectral absorption coefficient defined in (7.2.1e)";
  Real n
    "Ratio of spectral index of refraction of glass to the index of refraction of air";
  Real psi1 "The angle od incident angle in glass";
  Real deltaX;

algorithm
  // Check the data
  assert(glass[TRA] >= 0,
    "Glass property is not correct with solar transmittance less than 0");
  assert(glass[Ra] >= 0,
    "Glass property is not correct with solar reflectance less than 0");
  assert(glass[TRA] + glass[Ra] <= 1,
    "Glass property is not correct since the summation of solar reflectance and transmittance is larger than 1");

  NDIR := HEM-1;
  deltaX := 0.5*Modelica.Constants.pi/(NDIR-1);
  // Compute specular value for angle 0 to 90 degree (psi[1] to psi[N])
  for k in TRA:Rb loop
    layer[k, 1] := glass[k] "Copy the data at 0 degree (normal incidence)";
  end for;

  beta := glass[TRA]^2 - glass[Ra]^2 + 2*glass[Ra] + 1 "(2)";

  tmp := beta^2 - 4*(2 - glass[Ra])*glass[Ra] "part of (1)";
  assert(tmp >= 0,
    "Glass property is wrong. It is not possible to calculate the spectral reflectivity at 0 degree for uncoated glass.");

  rho0 := 0.5*(beta - sqrt(tmp))/(2 - glass[Ra]) "(1)";
  assert(rho0 >= 0,
    "Glass property is wrong. The spectral reflectivity at 0 degree for uncoated glass is less than zero.");

  tmp := (glass[Ra] - rho0)/(rho0*glass[TRA]) "part of (3)";
  assert(tmp > 0,
    "Glass property is wrong. It is not possible to calculate the spectral extinction coefficient for uncoated glass.");

  alpha := -log(tmp)/x "(3)";
  tmp := sqrt(rho0);
  assert(tmp <> 1,
    "Glass property is wrong. It is not possible to calculate the spectral index of refraction for uncoated glass.");
  n := (1 + tmp)/(1 - tmp) "(4)";

  for j in 2:HEM-2 loop
    psi1 := asin(sin(psi[j])/n) "(5)";
    psi_c := cos(psi[j]);
    psi1_c := cos(psi1);

    rho1 := ((n*psi_c - psi1_c)/(n*psi_c + psi1_c))^2 "(6)";
    rho2 := ((n*psi1_c - psi_c)/(n*psi1_c + psi_c))^2 "(7)";

    tau1 := 1 - rho1 "(8)";
    tau2 := 1 - rho2 "(9)";

    tmp := exp(-alpha*x/psi1_c);

    angT1 := tau1^2*tmp/(1 - rho1^2*tmp^2) "(10)";
    angR1 := rho1*(1 + angT1*tmp) "(13)";
    angT2 := tau2^2*tmp/(1 - rho2^2*tmp^2) "(11)";
    angR2 := rho2*(1 + angT2*tmp) "(14)";

    layer[TRA, j] := 0.5*(angT1 + angT2) "Tansmittance in (12)";
    layer[Ra, j] := 0.5*(angR1 + angR2) "Front reflectance (15)";
    layer[Rb, j] := layer[Ra, j] "Back reflectance in (15)";
  end for;

  // When incident angle is equal to 90 degree
  layer[TRA, NDIR] := 0 "(16)";
  layer[Ra, NDIR] := 1.0 "(16)";
  layer[Rb, NDIR] := 1.0 "(16)";

  // Computer hemispherical value: HEM.
  for j in 1:HEM-1 loop
    for k in TRA:Rb loop
      f[k, j] := 2*layer[k, j]*Modelica.Math.cos(psi[j])*Modelica.Math.sin(psi[
        j]);
    end for;
  end for;

  for k in TRA:Rb loop
    layer[k, HEM] := Buildings.Utilities.Math.Functions.trapezoidalIntegration(
      NDIR,
      f[k, :],
      deltaX)
      "Equation (A.4.70a) and (A.4.70b) in M. Wetter 's Thesis or (7.3) in Finlayson 1993.";
  end for
annotation (Documentation(info="<html>
<p>
This function computes the angular variation and the hemispherical integration of the transmittance and reflectance for one uncoated glass pane.
The equations are mainly based on Finlayson et al. (1990) and Fuler et al. (1991) with some modifications.
</p>
<h4>Implementation</h4>
<p>
Step 1: Compute the reflectivity at normal incidence
</p>
<table summary=\"summary\">
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
   &rho;(0) = {&beta; &minus; sqrt[&beta;<sup>2</sup> &minus; 4(2 &minus; R(0))R(0)]}
      &frasl;
   [2(2&minus;R(0))],
</p></td>
<td>(1)</td>
</tr>
</table>
where
<table summary=\"summary\">
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
  &beta; = T(0)<sup>2</sup> &minus; R(0)<sup>2</sup> + 2R(0) + 1.
</p></td>
<td>(2)</td>
</tr>
</table>

<p>
Step 2: Compute the spectral absorption coefficient &alpha; and spectral index of refraction n
</p>
<table summary=\"summary\">
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
  &alpha; = 4 &pi; &kappa;<sub>&lambda;</sub> &frasl;  &lambda;
  = - ln[(R(0) &minus; &rho;(0)) &frasl; (&rho;(0)T(0))] &frasl; d,
</p></td>
<td>(3)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
  n = (1 + sqrt(&rho;(0))) &frasl;
        (1 &minus; sqrt(&rho;(0))).
</p></td>
<td>(4)</td>
</tr>
</table>

<p>
Step 3: For each angle of incidence measured in air &phi; (0 &lt; &phi; &lt; 90)
</p>
<table summary=\"summary\">
<tr>
<td> a. Compute the angle of incidence measured in glass &phi;'</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
  &phi;' = asin(sin&phi; &frasl;  n).
</p></td>
<td>(5)</td>
</tr>
<tr>
<td> b. Compute spectral reflectivities at surface</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
&rho;<sub>1</sub>(&phi;)=[(n cos&phi; &minus; cos&phi;') &frasl;
(n cos&phi; + cos&phi;')] <sup>2</sup>,
</p></td>
<td>(6)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
&rho;<sub>2</sub>(&phi;)=[(n cos&phi;' &minus; cos&phi;) &frasl;
(n cos&phi;' + cos&phi;)] <sup>2</sup>.
</p></td>
<td>(7)</td>
</tr>
<tr>
<td>c. Compute spectral tansmissivities at surface</td>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>1</sub>(&phi;)= 1 &minus; &rho;<sub>1</sub>(&phi;),
</p></td>
<td>(8)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>2</sub>(&phi;)= 1 &minus; &rho;<sub>2</sub>(&phi;).
</p></td>
<td>(9)</td>
</tr>
<tr>
<td>d. Compute spectral tansmittance of the glass</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
T<sub>1</sub>(&phi;)= &tau;<sub>1</sub>(&phi;)<sup>2</sup> exp(-&alpha; d/cos&phi;') &frasl;
(1 &minus; &rho;<sub>1</sub>(&phi;)<sup>2</sup> exp(-2&alpha; d/cos&phi;')),
</p></td>
<td>(10)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
T<sub>2</sub>(&phi;)= &tau;<sub>2</sub>(&phi;)<sup>2</sup> exp(-&alpha; d/cos&phi;') &frasl;
(1 &minus; &rho;<sub>2</sub>(&phi;)<sup>2</sup> exp(-2&alpha; d/cos&phi;')),
</p></td>
<td>(11)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
T(&phi;)= (T<sub>1</sub>(&phi;) + T<sub>2</sub>(&phi;)) / 2.
</p></td>
<td>(12)</td>
</tr>
<tr>
<td>e. Compute spectral reflectance of the glass</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
R<sub>1</sub>(&phi;)= &rho;<sub>1</sub>(&phi;)(1+ T<sub>1</sub>(&phi;)exp(-&alpha; d/cos&phi;')),
</p></td>
<td>(13)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
R<sub>2</sub>(&phi;)= &rho;<sub>2</sub>(&phi;)(1+ T<sub>2</sub>(&phi;)exp(-&alpha; d/cos&phi;')),
</p></td>
<td>(14)</td>
</tr>
<tr>
<td><p align=\"center\" style=\"font-style:italic;\">
R(&phi;)= (R<sub>1</sub>(&phi;) + R<sub>2</sub>(&phi;)) / 2.
</p></td>
<td>(15)</td>
</tr>
</table>
<p>
Step 4: T(90)=0, R(90)=1. (16)

<h4>Limitations</h4>
WINDOW program calculates the angular property for each wave length based on the spectral data.
It uses different <code>R<sub>&lambda;</sub>(0)</code> and <code>T<sub>&lambda;</sub>(0)</code> for each wave length.
Then it integrates the properties over the wave length to get averaged property of <code>R(0)</code> and <code>T(0)</code>.
<p>
The current window model in the Buildings library uses averaged <code>R(0)</code> and <code>T(0)</code> directly.
It can generate the same results as WINDOW for a single pane window and multi-pane window with the same glass.
However, the results may be slightly different for multi-pane window with different glasses.
The reason is that different glasses may have different angular properties for the same wave length.
To precisely calculate the angular properties of the entire window system, one has to calculate the property for each wave length and integrate them as WINDOW does.
For more details, see the paper of Nouidui et al. (2012).

<h4>References</h4>
<p>
Finlayson, E. U., D. K. Arasteh, C. Huizenga, M.D. Rubin, M.S. Reily. 1993. WINDOW 4.0: Documentation of Calcualtion Precedures. <i>Technical Report LBL-33943</i>. Lawrence Berkeley National Laboratory.
</p>
<p>
Fuler, Reto A., Angular dependence of optical properties of homogeneous glasses, <i>ASHRAE Transaction</i>, V.97 Part 2, 1991.
</p>
<p>
Thierry Stephane Nouidui, Michael Wetter, and Wangda Zuo.
<a href=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/2012-simBuild-windowValidation.pdf\">
Validation of the window model of the Modelica Buildings library.</a>
<i>Proc. of the 5th SimBuild Conference</i>, Madison, WI, USA, August 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed use of <code>NDIR</code> for OpenModelica.
</li>
<li>
August 06, 2012, by Wangda Zuo:<br/>
Improved the documentation for implementation and added comments for model limitations.
</li>
<li>
December 09, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end glassPropertyUncoated;
