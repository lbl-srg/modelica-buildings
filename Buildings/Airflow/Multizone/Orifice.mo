within Buildings.Airflow.Multizone;
model Orifice "Orifice"
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistance(
    m=0.5,
    k=CD*A*sqrt(2.0/rho_default));

  parameter Modelica.SIunits.Area A "Area of orifice"
    annotation (Dialog(group="Orifice characteristics"));
  parameter Real CD=0.65 "Discharge coefficient"
    annotation (Dialog(group="Orifice characteristics"));

equation
  v = V_flow/A;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,8},{100,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,100},{20,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-20},{20,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{24,-24},{96,-100}},
          lineColor={0,0,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="A=%A")}),
defaultComponentName="ori",
Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775; = k &Delta;p<sup>m</sup>,
</p>
<p>
where
<i>V&#775;</i> is the volume flow rate,
<i>k</i> is a flow coefficient and
<i>m</i> is the flow exponent.
The flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = C<sub>D</sub> A (2/&rho;<sub>0</sub>)<sup>0.5</sup>,
</p>
<p>
where
<i>C<sub>D</sub></i> is the discharge coefficient,
<i>A</i> is the cross section area and
<i>&rho;<sub>0</sub></i> is the mass density at the medium default pressure, temperature and humidity.
</p>
<p>
For turbulent flow, set <i>m=1/2</i> and
for laminar flow, set <i>m=1</i>.
Large openings are characterized by values close to <i>0.5</i>,
while values near <i>0.65</i> have been found for small
crack-like openings (Dols and Walton, 2002).
</p>
<h4>References</h4>
<ul>
<li>
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
June 27, 2018, by Michael Wetter:<br/>
Corrected old parameter annotation.
</li>
<li>
June 24, 2018, by Michael Wetter:<br/>
Removed parameter <code>lWet</code> as it is only used to compute
the Reynolds number, and the Reynolds number is not used by this model.
Also removed the variable <code>Re</code> for the Reynolds number.<br/>
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
October 8, 2013 by Michael Wetter:<br/>
Changed the parameter <code>useConstantDensity</code> to
<code>useDefaultProperties</code> to use consistent names within this package.
A conversion script can be used to update this parameter.
</li>
<li>
December 6, 2011 by Michael Wetter:<br/>
Replaced <code>rho</code> with <code>rho_nominal</code> because
<code>rho</code> is computed in an <code>equation</code> section and not
in the <code>initial equation</code> section.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
February 4, 2005 by Michael Wetter:<br/>
Released first version.
</li>
</ul>
</html>"));
end Orifice;
