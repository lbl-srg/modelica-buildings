within Buildings.Media.Specialized.Water;
package HighTemperature
  "Package with model for liquid water with constant density and an extended 
  maxiumum temperature threshold"
   extends IBPSA.Media.Water(
     T_max = 273.15+600);

  replaceable function saturationTemperature_p
    "Return saturation temperature (K) from a given pressure (Pa)"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T   "Saturation temperature";
  protected
    Real a[:] = {2.2830066E+02,1.1893913E+00,5.2484699E-01,1.2416857E-01,
      -1.3714779E-02,5.5702047E-04}
      "Coefficients";
  algorithm
    T := a[1] + a[2]*log(p) + a[3]*log(p)^2 + a[4]*log(p)^3 +
      a[5]*log(p)^4 + a[6]*log(p)^5  "Saturation temperature";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Saturation temperature is computed from pressure. This relation is
    valid in the region of <i>273.16</i> to <i>647.096</i> K (<i>613.3</i> to <i>22,049,100</i> Pa).
    </p>
    <p>
    The function has the following form:
    </p>
    <p align=\"center\" style=\"font-style:italic;\">
    T = a<sub>1</sub> + a<sub>2</sub> ln(p) + a<sub>3</sub> ln(p)<sup>2</sup> +
    a<sub>4</sub> ln(p)<sup>3</sup> + a<sub>5</sub> ln(p)<sup>4</sup> + a<sub>6</sub> ln(p)<sup>5</sup>
    </p>
    <p>
    where temperature <i>T</i> is in units Kelvin, pressure <i>p</i> is in units Pa, and <i>a<sub>1</sub></i>
    through <i>a<sub>6</sub></i> are regression coefficients.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationTemperature_p;
  annotation(preferredView="info", Documentation(info="<html>
<p><b><span style=\"font-size: 11pt; color: #ff0000;\">This model is a beta version and is not fully validated yet. </span></b></p>
<p>This medium package models liquid water. Extending <a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a>, the package sets the maximum temperature threshold at <i>600</i> &deg;C. A new function to calculate the saturation temperature from the saturation pressure is also provided. This model is intended for modeling liquid water at high pressure states. </p>
<p>The mass density is computed using a constant value of <i>995.586</i> kg/s. For a medium model in which the density is a function of temperature, use <a href=\"modelica://IBPSA.Media.Specialized.Water.TemperatureDependentDensity\">IBPSA.Media.Specialized.Water.TemperatureDependentDensity</a> which may have considerably higher computing time. </p>
<p>For the specific heat capacities at constant pressure and at constant volume, a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C is used. The figure below shows the relative error of the specific heat capacity that is introduced by this simplification. </p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Media/Water/plotCp.png\" alt=\"Relative variation of specific heat capacity with temperature\"/> </p>
<p>The enthalpy is computed using the convention that <i>h=0</i> if <i>T=0</i> &deg;C. </p>
<h4>Limitations</h4>
<p>Density, specific heat capacity, thermal conductivity and viscosity are constant. Water is modeled as an incompressible liquid. There are no phase changes. </p>
</html>", revisions="<html>
<ul>
<li>
May 25, 2020, by Kathryn Hinkelman<br/>
First implementation of water medium with default high temperature limit and
saturation temperature function.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{16,-28},{32,-42},{26,-48},{10,-36},{16,-28}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{10,34},{26,44},{30,36},{14,26},{10,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-82,52},{24,-54}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{22,82},{80,24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{20,-30},{78,-88}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95})}));
end HighTemperature;
