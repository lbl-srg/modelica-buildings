within Buildings.Airflow.Multizone;
model DoorDiscretizedOperable
  "Door model using discretization along height coordinate"
  extends Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized;

   parameter Modelica.SIunits.PressureDifference dpCloRat(min=0,
                                                          displayUnit="Pa") = 4
    "|Closed aperture rating conditions|Pressure drop at rating condition";
  parameter Real CDCloRat(min=0, max=1)=1
    "|Closed aperture rating conditions|Discharge coefficient";

  parameter Modelica.SIunits.Area LClo(min=0)
    "|Closed aperture|Effective leakage area";

  parameter Real CDOpe=0.65 "|Open aperture|Discharge coefficient";
  parameter Real CDClo=0.65 "|Closed aperture|Discharge coefficient";

  parameter Real mOpe = 0.5 "|Open aperture|Flow exponent for door";
  parameter Real mClo= 0.65 "|Closed aperture|Flow exponent for crack";
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    "Opening signal, 0=closed, 1=open"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));
protected
 parameter Modelica.SIunits.Area AOpe=wOpe*hOpe "Open aperture area";
 parameter Modelica.SIunits.Area AClo(fixed=false) "Closed aperture area";

 Real kOpe "Open aperture flow coefficient, k = V_flow/ dp^m";
 Real kClo "Closed aperture flow coefficient, k = V_flow/ dp^m";

 Real fraOpe "Fraction of aperture that is open";
initial equation
  AClo=CDClo/CDCloRat * LClo * dpCloRat^(0.5-mClo);
equation
  fraOpe =y;
  kClo = CDClo * AClo/nCom * sqrt(2/rho_default);
  kOpe = CDOpe * AOpe/nCom * sqrt(2/rho_default);

  // flow exponent
  m    = fraOpe*mOpe + (1-fraOpe)*mClo;
  // opening area
  A = fraOpe*AOpe + (1-fraOpe)*AClo;
  // friction coefficient for power law
  kVal = fraOpe*kOpe + (1-fraOpe)*kClo;

  // orifice equation
  for i in 1:nCom loop
    dV_flow[i] = Buildings.Airflow.Multizone.BaseClasses.powerLaw(
      k=kVal,
      dp=dpAB[i],
      m=m,
      dp_turbulent=dp_turbulent);
  end for;

  annotation (Icon(graphics={
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
defaultComponentName="doo",
Documentation(info="<html>
<p>
This model describes the bi-directional air flow through an open door.
</p>
<p>
To compute the bi-directional flow,
the door is discretize along the height coordinate, and uses
an orifice equation to compute the flow for each compartment.
</p>
<p>
The door can be either open or closed, depending on the input signal
<i>y</i>.
Set <i>y=0</i> if the door is closed, and <i>y=1</i>
if the door is open.
Use the model
<a href=\"modelica://Buildings.Airflow.Multizone.DoorDiscretizedOpen\">
Buildings.Airflow.Multizone.DoorDiscretizedOpen</a>
for a door that is always closed.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li><i>December 6, 2011</i> by Michael Wetter:<br/>
       Changed the computation of the discharge coefficient to use the
       nominal density instead of the actual density.
       Computing <code>sqrt(2/rho)</code> sometimes causes warnings from the solver,
       as it seems to try negative values for the density during iterative solutions.
</li>
<li><i>August 12, 2011</i> by Michael Wetter:<br/>
       Changed model to use the new function
       <a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
       Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 10, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end DoorDiscretizedOperable;
