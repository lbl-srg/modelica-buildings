within Buildings.Airflow.Multizone;
model Orifice "Orifice"
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistance(
    m=0.5,
    k = CD * A * sqrt(2.0/rho_default));

  parameter Real CD=0.65 "|Orifice characteristics|Discharge coefficient";

  annotation (                       Icon(graphics={
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
<pre>
    V_flow = k * dp^m,
</pre>
where <code>k</code> is a variable and
<code>m</code> a parameter. For turbulent flow, set <code>m=1/2</code> and
for laminar flow, set <code>m=1</code>.
Large openings are characterized by values close to <code>0.5</code>,
while values near <code>0.65</code> have been found for small
crack-like openings (Dols and Walton, 2002).

<h4>References</h4>
<ul>
<li>
W. Stuart Dols and George N. Walton, <i>CONTAMW 2.0 User Manual,
Multizone Airflow and Contaminant Transport Analysis Software</i>,
Building and Fire Research Laboratory,
National Institute of Standards and Technology,
Tech. Report NISTIR 6921,
November, 2002.
</ul>
</html>",
revisions="<html>
<ul>
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
