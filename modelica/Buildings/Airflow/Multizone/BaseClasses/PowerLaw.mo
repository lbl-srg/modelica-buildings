within Buildings.Airflow.Multizone.BaseClasses;
function PowerLaw "Power law used in orifice equations"
  input Real k "Flow coefficient, k = V_flow/ dp^m";
  input Modelica.SIunits.Pressure dp "Pressure difference";
  input Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  input Modelica.SIunits.Pressure dp_turbulent(min=0)=0.001
    "Pressure difference where laminar and turbulent flow relation coincide";

  output Modelica.SIunits.VolumeFlowRate V_flow "Volume flow rate";
protected
  Modelica.SIunits.Pressure delP "Half-width of transition interval";
  Modelica.SIunits.Pressure pTilFor
    "Pressure at which transition occurs at forward flow";
  Modelica.SIunits.Pressure pTilRev
    "Pressure at which transition occurs at reverse flow";

 Real s "Part of the linear slope that is independent of k";

algorithm
  s :=dp_turbulent^(m - 1);
                    // m can be time dependent, for example for the operable door

  delP :=dp_turbulent/2.;
  pTilFor :=dp - dp_turbulent;
  pTilRev :=dp + dp_turbulent;

  /*V_flow :=k*spliceFunction(
      spliceFunction(
        abs(dp)^m,
        s*dp,
        pTilFor,
        delP),
      -(abs(dp)^m),
      pTilRev,
      delP);
*/
 if (dp >= dp_turbulent) then
    V_flow :=k*dp^m;
  elseif (dp <= -dp_turbulent) then
    V_flow :=-k*(-dp)^m;
  else
  V_flow :=k*spliceFunction(
      spliceFunction(
        abs(dp)^m,
        s*dp,
        pTilFor,
        delP),
      -(abs(dp)^m),
      pTilRev,
      delP);

  end if;

// fixme: is smoothOrder = 1 or 2?
  annotation (
          smoothOrder=1,
          Diagram(graphics),
          Icon(graphics),
Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
<PRE>
    m_flow = k * dp^m,
</PRE>
where <code>k</code> is a variable and
<code>m</code> a parameter.
For turbulent flow, set <code>m=1/2</code> and
for laminar flow, set <code>m=1</code>. 
<P>
The model is used as a base for the interzonal air flow models.

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
end PowerLaw;
