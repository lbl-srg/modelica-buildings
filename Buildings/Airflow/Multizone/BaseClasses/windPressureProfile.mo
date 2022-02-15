within Buildings.Airflow.Multizone.BaseClasses;
function windPressureProfile
  "Function for the cubic spline interpolation of a wind pressure profile with given support points and spline derivatives at these support points"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Angle incAng "Wind incidence angle";
  input Real[:] xd "Support points x-value";
  input Real[size(xd, 1)] yd "Support points y-value";
  input Real[size(xd, 1)] d "Derivative values at the support points";

  output Real z "Dependent variable without monotone interpolation, CpAct";

protected
  Integer i "Integer to select data interval";
  Real aR "u, restricted to 0...2*pi";

algorithm

  // Change sign to positive and constrain to [0...2*pi]
  aR :=mod(incAng, 2*Modelica.Constants.pi);

  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if aR > xd[j] then
      i := j;
    end if;
  end for;

  // Interpolate the data
  z :=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
        x=aR,
        x1=xd[i],
        x2=xd[i + 1],
        y1=yd[i],
        y2=yd[i + 1],
        y1d=d[i],
        y2d=d[i + 1]);

  annotation (
smoothOrder=1,
Documentation(revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
April 6, 2021, by Klaas De Jonge:<br/>
First implementation
</li>
</ul>
</html>",
info="<html>
<p>
This function computes the wind pressure coefficients <i>C<sub>p</sub></i> from a user-defined table data.
The same functionality is also implemented in CONTAM.
</p>
<p>
This function is used in
<a href=\"modelica://Buildings.Fluid.Sources.Outside_CpData\">
Buildings.Fluid.Sources.Outside_CpData</a>.
</p>
<h4>References</h4>
<ul>
<li>
<b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>,
National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>.
</li>
<li>
<b>Andrew K. Persily and Elizabeth M. Ivy.</b>
<i>
<a href=\"http://ws680.nist.gov/publication/get_pdf.cfm?pub_id=860831\">
Input Data for Multizone Airflow and IAQ Analysis.</a></i>
NIST, NISTIR 6585.
January, 2001.
Gaithersburg, MD.
</li>
<li><b>M. W. Liddament, 1996</b>, <i>A guide to energy efficient ventilation</i>. AIVC Annex V. </li>
</ul>

</html>"));
end windPressureProfile;
