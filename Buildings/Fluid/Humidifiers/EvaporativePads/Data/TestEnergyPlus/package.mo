within Buildings.Fluid.Humidifiers.EvaporativePads.Data;
package CELdekEnergyPlus
  "Package of CELdek evaporative pad performance data in EnergyPlus"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
This package contains performance data from the EnergyPlus 23.1 engineering
reference for CELdek evaporative pads.
</p>
<p>
From the
<a href=\"https://bigladdersoftware.com/epx/docs/23-1/engineering-reference/evaporative-coolers.html#curve-fitting-evaporative-media\">
Curve Fitting Evaporative Media</a> section of the EnergyPlus 23.1 engineering
reference, the curve fitting equation that relates the saturation efficiency of an
evaporative pad &eta; to the pad depth <i>d</i> and air velocity <i>v</i> through
the pad is as follows:
</p>
<p align=\"center\">
<i>&eta; = 0.792714 + 0.958569&sdot;d - 0.25193&sdot;v - 1.03215&sdot;d<sup>2</sup>
+ 0.0262659&sdot;v<sup>2</sup> + 0.914869&sdot;d&sdot;v -
1.48241&sdot;v&sdot;d<sup>2</sup> - 0.018992&sdot;d&sdot;v<sup>3</sup> +
1.13137&sdot;d<sup>3</sup>&sdot;v + 0.0327622&sdot;d<sup>2</sup>&sdot;v<sup>3</sup>
- 0.145384&sdot;d<sup>3</sup>&sdot;v<sup>2</sup></i>
</p>
<p>
Data point pairs of saturation efficiency vs. air velocity are digitized from this
curve fitting equation for a specific pad depth. Data point pairs include air
velocity values between the normal domain of <i>0 - 4.575 m/s</i>, as well as two
additional air velocity values that are <i>10</i> times and <i>100</i> times of the
maximum value of the normal domain, <i>45.75 m/s</i> and <i>457.5 m/s</i>. The
saturation effciency values from the data point pairs are limited within the range
of <i>0% - 100%</i>.
</p>
<p>
The EnergyPlus 23.1 engineering reference does not specify the pressure drop through
evaporative pads as a function of air velocity and pad depth. However, an equation
of the following form is used:
</p>
<p align=\"center\">
<i>dp = a&sdot;d&sdot;v<sup>b</sup></i>
</p>
<p>
By setting <i>a = 78.74 Pa&sdot;m<sup>-1</sup>&sdot;(m/s)<sup>-b</sup></i> and
<i>b = 1.8</i>, the pressure drop <i>dp</i> aligns with the values from the 
<a href=\"https://munters.sies.si/images/pdf/CELdek7090.pdf\">CELdek 7090-15
evaporative pad</a> product. Data point pairs of pressure drop vs. air velocity are
digitized from this equation for a specific pad depth.
</p>
</html>"));
end CELdekEnergyPlus;
