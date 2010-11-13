within Buildings.Airflow.Multizone;
model EffectiveAirLeakageArea "Effective air leakage area"
  extends Buildings.Airflow.Multizone.Orifice(
     m=0.65, final A=CD/CDRat * L * dpRat^(0.5-m));

  parameter Modelica.SIunits.Pressure dpRat(min=0)=4
    "|Rating conditions|Pressure drop at rating condition";
  parameter Real CDRat(min=0, max=1)=1
    "|Rating conditions|Discharge coefficient";

  parameter Modelica.SIunits.Area L(min=0) "Effective leakage area";

  annotation (Diagram(graphics),
                       Icon(graphics={
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
          extent={{-70,-42},{18,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "L=%L"),
        Text(
          extent={{-80,96},{26,52}},
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
Documentation(info="<html>
<p>
This model describes the one-directional pressure driven
air flow through a crack like opening.
<P>
The opening is modeled as an orifice. The orifice area
is parameterized by processing the effective air leakage area, the discharge coefficient and pressure drop at a reference condition.
The effective air leakage area can be obtained, for example,
from the ASHRAE fundamentals (ASHRAE, 1997, p. 25.18). In
the ASHRAE fundamentals, the effective air leakage area is
based on a reference pressure difference of 4 Pa and a discharge
coefficient of 1.
A similar model is also used in the CONTAM software (Dols and Walton, 2002).
Dols and Walton (2002) recommend to use for the flow exponent
<code>m=0.6</code> to <code>m=0.7</code> if the flow exponent is not
reported with the test results.

<h4>References</h4>
<UL>
<LI>
<B>ASHRAE, 1997.</B> 
<i>ASHRAE Fundamentals</i>, 
American Society of Heating, Refrigeration and Air-Conditioning
Engineers, 1997.
<LI>
<B>Dols and Walton, 2002.</B> 
W. Stuart Dols and George N. Walton, <I>CONTAMW 2.0 User Manual,
Multizone Airflow and Contaminant Transport Analysis Software</I>,
Building and Fire Research Laboratory,
National Institute of Standards and Technology,
Tech. Report NISTIR 6921,
November, 2002.
</UL>
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 10, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end EffectiveAirLeakageArea;
