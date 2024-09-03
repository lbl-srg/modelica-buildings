within Buildings.Airflow.Multizone;
model EffectiveAirLeakageArea "Effective air leakage area"
  extends Buildings.Airflow.Multizone.Coefficient_V_flow(
    m=0.65,
    final C=L * CDRat * sqrt(2.0/rho_default) * dpRat^(0.5-m));

  parameter Modelica.Units.SI.PressureDifference dpRat(
    min=0,
    displayUnit="Pa") = 4 "Pressure drop"
    annotation (Dialog(group="Rating conditions"));
  parameter Real CDRat(
    min=0,
    max=1) = 1 "Discharge coefficient"
    annotation (Dialog(group="Rating conditions"));

  parameter Modelica.Units.SI.Area L(min=0) "Effective leakage area";

  Modelica.Units.SI.Velocity v(nominal=1) = V_flow/L "Average velocity";

  annotation (Icon(graphics={
        Rectangle(
          extent={{-50,48},{50,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,12},{-38,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,92},{-20,54}},
          textColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "L=%L"),
        Text(
          extent={{22,94},{98,56}},
          textColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "m=%m"),
        Rectangle(
          extent={{-100,6},{-64,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,4},{-52,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,2},{-38,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="lea",
Documentation(info="<html>
<p>
This model describes the one-directional pressure driven
air flow through a crack-like opening, using the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775; = C &Delta;p<sup>m</sup>,
</p>
<p>
where
<i>V&#775;</i> is the volume flow rate,
<i>C</i> is a flow coefficient and
<i>m</i> is the flow exponent.
The flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = L C<sub>D,Rat</sub> &Delta;p<sub>Rat</sub><sup>(0.5-m)</sup> (2/&rho;<sub>0</sub>)<sup>0.5</sup>,
</p>
<p>
where
<i>L</i> is the effective air leakage area,
<i>C<sub>D,Rat</sub></i> is the discharge coefficient at the reference condition,
<i>&Delta;p<sub>Rat</sub></i> is the pressure drop at the rating condition, and
<i>&rho;<sub>0</sub></i> is the mass density at the medium default pressure, temperature and humidity.
</p>
<p>
The effective air leakage area <i>L</i> can be obtained, for example,
from the ASHRAE fundamentals (ASHRAE, 1997, p. 25.18). In
the ASHRAE fundamentals, the effective air leakage area is
based on a reference pressure difference of <i>&Delta;p<sub>Rat</sub> = 4</i> Pa and a discharge
coefficient of <i>C<sub>D,Rat</sub> = 1</i>.
A similar model is also used in the CONTAM software (Dols and Walton, 2002).
Dols and Walton (2002) recommend to use for the flow exponent
<i>m=0.6</i> to <i>m=0.7</i> if the flow exponent is not
reported with the test results.
</p>
<h4>References</h4>
<ul>
<li>
<b>ASHRAE, 1997.</b>
<i>ASHRAE Fundamentals</i>,
American Society of Heating, Refrigeration and Air-Conditioning
Engineers, 1997.
</li>
<li>
<b>Dols and Walton, 2002.</b>
W. Stuart Dols and George N. Walton, <i>CONTAMW 2.0 User Manual,
Multizone Airflow and Contaminant Transport Analysis Software</i>,
Building and Fire Research Laboratory,
National Institute of Standards and Technology,
Tech. Report NISTIR 6921,
November, 2002.
</li>
<li>Michael Wetter. <a href=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">Multizone Airflow Model in Modelica.</a> Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
Changes due to changes in the baseclass, velocity is now a top-level variable.
</li>
<li>
June 24, 2018, by Michael Wetter:<br/>
Removed parameter <code>lWet</code> as it is only used to compute
the Reynolds number, and the Reynolds number is not used by this model.
Also removed the variable <code>Re</code> for the Reynolds number.<br/>
Changed base class to remove the parameters <code>A</code> and <code>CD</code>
which are not used by this model.<br/>
This change is non-backward compatible.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
</li>
<li>
May 30, 2018, by Michael Wetter:<br/>
Improved documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/546\">IBPSA, #546</a>.
</li>
<li>
April 24, 2017, by Filip Jorissen:<br/>
Corrected error in computation of <code>A</code> which was
<code>A=CD/CDRat * L * dpRat^(0.5-m)</code> rather than
<code>A=CDRat/CD * L * dpRat^(0.5-m)</code>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/743\">#743</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Changed the parameter <code>useConstantDensity</code> to
<code>useDefaultProperties</code> to use consistent names within this package.
A conversion script can be used to update this parameter.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
February 10, 2005 by Michael Wetter:<br/>
Released first version.
</li>
</ul>
</html>"));
end EffectiveAirLeakageArea;
