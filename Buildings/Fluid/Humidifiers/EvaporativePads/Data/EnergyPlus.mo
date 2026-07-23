within Buildings.Fluid.Humidifiers.EvaporativePads.Data;
record EnergyPlus
  "Data for an evaporative pad from the EnergyPlus engineering reference with varying pad depth"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5},
      eta={0.7927+0.9586*d-1.0321*d^2+0.0*d^3,
        0.6733+1.4136*d-1.7693*d^2+0.5293*d^3,
        0.567+1.8544*d-2.4818*d^2+0.986*d^3,
        0.4739+2.2668*d-3.1452*d^2+1.3699*d^3,
        0.3939+2.6364*d-3.7349*d^2+1.6812*d^3,
        0.3271+2.949*d-4.2263*d^2+1.9198*d^3,
        0.2733+3.1904*d-4.5948*d^2+2.0857*d^3,
        0.2327+3.3463*d-4.8159*d^2+2.1788*d^3,
        0.2052+3.4026*d-4.865*d^2+2.1993*d^3,
        0.1909+3.3448*d-4.7175*d^2+2.1471*d^3,
        0.1897+3.1589*d-4.3489*d^2+2.0222*d^3}),
    final dp_nominal=95.545*d*3.5^1.9259,
    final v_nominal=3.5,
    final n=1.9259);
  parameter Modelica.Units.SI.Length d = 0.1524
    "Depth of the rigid media evaporative pad";
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
This data record contains evaporative pad performance data from the EnergyPlus 23.1 
engineering reference.
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
curve fitting equation. However, the pad depth remains a parameter that users can 
modify. Data point pairs include air velocity values between <i>0 - 5 m/s</i>.
</p>
<p>
The EnergyPlus 23.1 engineering reference does not specify the pressure drop through
evaporative pads as a function of air velocity <i>v</i> and pad depth <i>d</i>.
However, an equation of the following form is used:
</p>
<p align=\"center\">
<i>dp = a&sdot;d&sdot;v<sup>n</sup></i>
</p>
<p>
By setting <i>a = 95.545 Pa&sdot;m<sup>-1</sup>&sdot;(m/s)<sup>-n</sup></i> and
<i>n = 1.9259</i>, the pressure drop <i>dp</i> aligns with the values from the 
<a href=\"https://munters.sies.si/images/pdf/celdek7090.pdf\">CELdek 7090-15
150mm evaporative pad</a> product. With nominal air velocity <i>v_nominal =
3.5 m/s</i>, the nominal pressure drop <i>dp_nominal</i> can be calculated with the
above pressure drop equation if the depth of the evaporative pad <i>d</i> is known.
</p>
</html>", revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyPlus;
