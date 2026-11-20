within Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Data;
record EnergyPlus
  "Data for a rigid media pad from the EnergyPlus engineering reference with varying pad depth"
  extends Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5},
      eta={1 - (1 - 0.9133)^(d / 0.15),
        1 - (1 - 0.8473)^(d / 0.15),
        1 - (1 - 0.7926)^(d / 0.15),
        1 - (1 - 0.7478)^(d / 0.15),
        1 - (1 - 0.7110)^(d / 0.15),
        1 - (1 - 0.6808)^(d / 0.15),
        1 - (1 - 0.6555)^(d / 0.15),
        1 - (1 - 0.6336)^(d / 0.15),
        1 - (1 - 0.6136)^(d / 0.15),
        1 - (1 - 0.5937)^(d / 0.15),
        1 - (1 - 0.5725)^(d / 0.15)}),
    final dp_nominal=95.545*d*3.5^1.9259,
    final v_nominal=3.5,
    final n=1.9259);
  parameter Modelica.Units.SI.Length d = 0.15
    "Depth of the rigid media pad";
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
This data record contains rigid media pad performance data from the EnergyPlus 23.1 
Engineering Reference.
</p>
<p>
From the <i>Curve Fitting Evaporative Media</i> section of the EnergyPlus 23.1
Engineering Reference, the curve fitting equation that relates the saturation
efficiency of a rigid media pad <i>&eta;</i> to the pad depth <i>d</i> and air
velocity <i>v</i> through the pad is as follows:
</p>
<p align=\"center\">
<i>&eta; = 0.792714 + 0.958569 d - 0.25193 v - 1.03215 d<sup>2</sup>
+ 0.0262659 v<sup>2</sup> + 0.914869 d v -
1.48241 v d<sup>2</sup> - 0.018992 d v<sup>3</sup> +
1.13137 d<sup>3</sup> v + 0.0327622 d<sup>2</sup> v<sup>3</sup>
- 0.145384 d<sup>3</sup> v<sup>2</sup></i>
</p>
<p>
However, the author of this data record believes that while curve fitting is an
adequete method to describe the relationship between <i>&eta;</i> and <i>v</i>,
there exists a more accurate method to describe the relationship between
<i>&eta;</i> and <i>d</i> than curve fitting. Therefore, this data record uses
the following equations to express the relations between <i>&eta;</i>, <i>v</i>,
and <i>d</i>:
</p>
<p align=\"center\">
<i>d<sub>0</sub> = 0.15</i>
</p>
<p align=\"center\">
<i>&eta;<sub>0</sub> = 0.792714 + 0.958569 d<sub>0</sub> - 0.25193 v - 1.03215 d<sub>0</sub><sup>2</sup>
+ 0.0262659 v<sup>2</sup> + 0.914869 d<sub>0</sub> v -
1.48241 v d<sub>0</sub><sup>2</sup> - 0.018992 d<sub>0</sub> v<sup>3</sup> +
1.13137 d<sub>0</sub><sup>3</sup> v + 0.0327622 d<sub>0</sub><sup>2</sup> v<sup>3</sup>
- 0.145384 d<sub>0</sub><sup>3</sup> v<sup>2</sup></i>
</p>
<p align=\"center\">
<i>&eta; = 1 - (1 - &eta;<sub>0</sub>)<sup>d / d<sub>0</sub></sup></i>
</p>
<p>
The above equations first define a fixed baseline pad depth <i>d<sub>0</sub></i> of
<i>0.15 m</i>, then use it to calculate the baseline saturation efficiency
<i>&eta;<sub>0</sub></i> as a function of <i>v</i>, and finally compute the actual
saturation efficiency <i>&eta;</i> based on how far the actual pad depth <i>d</i>
deviates from the baseline pad depth <i>d<sub>0</sub></i>. The above equations are
based on the facts that the saturation efficiency <i>&eta;</i> is defined as how
quick the inlet air temperature approaches the air wet bulb temperature, and that
the air wet bulb temperature stays constant when air passes through a rigid media
pad.
</p>
<p>
Data point pairs of saturation efficiency <i>&eta;</i> vs. air velocity <i>v</i> are
digitized from the above equation set, where the pad depth <i>d</i> remains a parameter
that users can modify. Data point pairs include air velocity values between
<i>0 - 5 m/s</i>.
</p>
<p>
The EnergyPlus 23.1 engineering reference does not specify the pressure drop through
rigid media pads as a function of air velocity <i>v</i> and pad depth <i>d</i>.
However, an equation of the following form is used:
</p>
<p align=\"center\">
<i>dp = a d v<sup>n</sup></i>
</p>
<p>
By setting <i>a = 95.545 Pa m<sup>-1</sup> (m/s)<sup>-n</sup></i> and
<i>n = 1.9259</i>, the pressure drop and velocity value pairs (<i>dp</i> and <i>v</i>) align with the values from the
rigid media pad with a <i>150 mm</i> depth (<i>d = 0.15 m</i>) in the Munters CELdek 7090-15 Evaporative Pad
Specification Sheet. With nominal air velocity <i>v_nominal = 3.5 m/s</i>, the
nominal pressure drop <i>dp_nominal</i> can be calculated with the above pressure
drop equation if the depth of the rigid media pad <i>d</i> is known.
</p>
<h4>References</h4>
<p>
<a href=\"https://bigladdersoftware.com/epx/docs/23-1/engineering-reference/evaporative-coolers.html\">
EnergyPlus 23.1 Engineering Reference</a>, July 26, 2026.
</p>
<p>
<a href=\"https://munters.sies.si/images/pdf/celdek7090.pdf\">Munters CELdek 7090-15
Evaporative Pad Specification Sheet</a>, July 26, 2026.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2026, by Weiping Huang:<br/>
Revised the data record to use a more accurate set of equations to express the
relations between the saturation efficiency and the pad depth.
</li>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyPlus;
