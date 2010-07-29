within Buildings.Airflow.Multizone;
model Orifice "Orifice"
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistance(m=0.5);

  parameter Real CD=0.65 "|Orifice characteristics|Discharge coefficient";
protected
  parameter Real coef = CD * A * sqrt(2) "Constant coefficient";

initial equation
  k = coef / sqrt(rho);
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
          extent={{28,-22},{100,-98}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="A=%A")}),
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

<h3>References</h3>
<UL>
<LI>
<B>Dols and Walton, 2002.</B> 
W. Stuart Dols and George N. Walton, <I>CONTAMW 2.0 User Manual,
Multizone Airflow and Contaminant Transport Analysis Software</I>,
Building and Fire Research Laboratory,
National Institute of Standards and Technology,
Tech. Report NISTIR 6921,
November, 2002.
</UL>
<h3>Main Author</h3>
<P>
    Michael Wetter<br>
    <a href=\"http://www.utrc.utc.com\">United Technologies Research Center</a><br>
    411 Silver Lane<br>
    East Hartford, CT 06108<br>
    USA<br>
    email: <A HREF=\"mailto:WetterM@utrc.utc.com\">WetterM@utrc.utc.com</A>
<h3>Release Notes</h3>
<P>
<ul>
<li><i>February 4, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end Orifice;
