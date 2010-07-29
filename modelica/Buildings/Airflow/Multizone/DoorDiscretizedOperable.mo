within Buildings.Airflow.Multizone;
model DoorDiscretizedOperable
  "Door model using discretization along height coordinate"
  extends Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized;

   parameter Modelica.SIunits.Pressure dpCloRat(min=0)=4
    "|Closed aperture rating conditions|Pressure drop at rating condition";
  parameter Real CDCloRat(min=0, max=1)=1
    "|Closed aperture rating conditions|Discharge coefficient";

  parameter Modelica.SIunits.Area LClo(min=0)
    "|Closed aperture|Effective leakage area";

  parameter Real CDOpe=0.65 "|Open aperture|Discharge coefficient";
  parameter Real CDClo=0.65 "|Closed aperture|Discharge coefficient";

  parameter Real mOpe = 0.5 "|Open aperture|Flow exponent for door";
  parameter Real mClo= 0.65 "|Closed aperture|Flow exponent for crack";
  Modelica.Blocks.Interfaces.RealInput y "Opening signal, 0=closed, 1=open"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},rotation=
           0), iconTransformation(extent={{-120,-10},{-100,10}})));
protected
 parameter Modelica.SIunits.Area AOpe=wOpe*hOpe "Open aperture area";
 parameter Modelica.SIunits.Area AClo(fixed=false) "Closed aperture area";

 Real kOpe "Open aperture flow coefficient, k = V_flow/ dp^m";
 Real kClo "Closed aperture flow coefficient, k = V_flow/ dp^m";

 Real fraOpe "Fraction of aperture that is open";
initial equation
  AClo=CDClo/CDCloRat * LClo * dpCloRat^(0.5-mClo);
equation
  assert(y           >= 0, "Input error. Opening signal must be between 0 and 1.\n"
    + "  Received y.signal[1] = " + realString(y));
  assert(y           <= 1, "Input error. Opening signal must be between 0 and 1.\n"
    + "  Received y.signal[1] = " + realString(y));
  fraOpe =y;
  kClo = CDClo * AClo/nCom * sqrt(2/rhoAve);
  kOpe = CDOpe * AOpe/nCom * sqrt(2/rhoAve);

  // flow exponent
  m    = fraOpe*mOpe + (1-fraOpe)*mClo;
  // opening area
  A = fraOpe*AOpe + (1-fraOpe)*AClo;
  // friction coefficient for power law
  kVal = fraOpe*kOpe + (1-fraOpe)*kClo;
  annotation (Diagram(graphics),
                       Icon(graphics={
        Text(
          extent={{-118,34},{-98,16}},
          lineColor={0,0,127},
          textString=
               "y"),
        Rectangle(
          extent={{-100,2},{-46,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,-16},{-20,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,2},{-40,-16}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
This model describes the bi-directional air flow through an open door.
<P>
To compute the bi-directional flow, 
the door is discretize along the height coordinate, and uses
an orifice equation to compute the flow for each compartment.
<P>
The door can be either open or closed, depending on the input signal
<code>y</code>.
Set <code>y=0</code> if the door is closed, and <code>y=1</code>
if the door is open.
Use the model 
<code>Buildings.Airflow.Multizone.Crack</code> for a door
that is always closed.

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
<li><i>February 10, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end DoorDiscretizedOperable;
