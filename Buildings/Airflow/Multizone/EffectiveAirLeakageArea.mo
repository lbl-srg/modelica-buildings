within Buildings.Airflow.Multizone;
model EffectiveAirLeakageArea "Effective air leakage area"
  extends Buildings.Airflow.Multizone.Orifice(
    m=0.65,
    final A=CDRat/CD * L * dpRat^(0.5-m));

  parameter Modelica.SIunits.PressureDifference dpRat(min=0,
                                                      displayUnit="Pa") = 4
    "|Rating conditions|Pressure drop at rating condition";
  parameter Real CDRat(min=0, max=1)=1
    "|Rating conditions|Discharge coefficient";

  parameter Modelica.SIunits.Area L(min=0) "Effective leakage area";

  annotation (                       Icon(graphics={
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
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "L=%L"),
        Text(
          extent={{22,94},{98,56}},
          lineColor={0,0,255},
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
air flow through a crack-like opening.
</p>
<p>
The opening is modeled as an orifice. The orifice area
is parameterized by processing the effective air leakage area, the discharge coefficient and pressure drop at a reference condition.
The effective air leakage area can be obtained, for example,
from the ASHRAE fundamentals (ASHRAE, 1997, p. 25.18). In
the ASHRAE fundamentals, the effective air leakage area is
based on a reference pressure difference of <i>4</i> Pa and a discharge
coefficient of <i>1</i>.
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
</ul>
</html>",
revisions="<html>
<ul>
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
