within Buildings.Airflow.Multizone;
model Orifice "Orifice"
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistance(m=0.5,
    k = CD * A * sqrt(2.0/rho_nominal));

  parameter Real CD=0.65 "|Orifice characteristics|Discharge coefficient";

  annotation (Diagram(graphics),
                       Icon(graphics={
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
<PRE>
    V_flow = k * dp^m,
</PRE>
where <code>k</code> is a variable and
<code>m</code> a parameter. For turbulent flow, set <code>m=1/2</code> and
for laminar flow, set <code>m=1</code>. 
Large openings are characterized by values close to <code>0.5</code>,
while values near <code>0.65</code> have been found for small
crack-like openings (Dols and Walton, 2002).

<h4>References</h4>
<UL>
<LI>
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
<li><i>December 6, 2011</i> by Michael Wetter:<br>
       Replaced <code>rho</code> with <code>rho_nominal</code> because
       <code>rho</code> is computed in an <code>equation</code> section and not
       in the <code>initial equation</code> section.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end Orifice;
