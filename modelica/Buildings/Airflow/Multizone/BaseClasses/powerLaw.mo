within Buildings.Airflow.Multizone.BaseClasses;
function powerLaw "Power law used in orifice equations"
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

  delP :=dp_turbulent/2.0;
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
   // The test below avoids computing 0^(-0.5) in
   // Buildings.Airflow.Multizone.BaseClasses.powerLaw:derf,
   // which causes the following error:
   // Model error - power: (abs(dp)) ** (m-1) = (0) ** (-0.5)
   if (abs(dp)<Modelica.Constants.small) then
      V_flow := 0;
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

  end if;

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
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end powerLaw;
