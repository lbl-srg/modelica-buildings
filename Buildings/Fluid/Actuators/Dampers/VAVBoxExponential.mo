within Buildings.Fluid.Actuators.Dampers;
model VAVBoxExponential
  "VAV box with a fixed resistance plus a damper model withe exponential characteristics"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
  dp(nominal=dp_nominal),
  final kFixed=sqrt(kResSqu));
  parameter Boolean dp_nominalIncludesDamper = true
    "set to true if dp_nominal includes the pressure loss of the open damper"
                                              annotation(Dialog(group = "Nominal condition"));
protected
  parameter Modelica.SIunits.PressureDifference dpDamOpe_nominal(displayUnit="Pa")=
     k1*m_flow_nominal^2/2/Medium.density(sta_default)/A^2
    "Pressure drop of fully open damper at nominal flow rate";
  parameter Real kResSqu(unit="kg.m", fixed=false)
    "Resistance coefficient for fixed resistance element";
initial equation
  kResSqu = if dp_nominalIncludesDamper then
       m_flow_nominal^2 / (dp_nominal-dpDamOpe_nominal) else
       m_flow_nominal^2 / dp_nominal;
  assert(kResSqu > 0,
         "Wrong parameters in damper model: dp_nominal < dpDamOpe_nominal"
          + "\n  dp_nominal = "       + String(dp_nominal)
          + "\n  dpDamOpe_nominal = " + String(dpDamOpe_nominal));
   annotation (
defaultComponentName="vavDam",
Documentation(info="<html>
<p>
Model of two resistances in series. One resistance has a fixed flow coefficient, the
other resistance is an air damper whose flow coefficient is an exponential function of the opening angle.
</p>
<p>
If <code>dp_nominalIncludesDamper=true</code>, then the parameter <code>dp_nominal</code>
is equal to the pressure drop of the damper plus the fixed flow resistance at the nominal
flow rate.
If <code>dp_nominalIncludesDamper=false</code>, then <code>dp_nominal</code>
does not include the flow resistance of the air damper.
</p>
</html>", revisions="<html>
<ul>
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
<li>
April 13, 2010 by Michael Wetter:<br/>
Added <code>noEvent</code> to guard evaluation of the square root
for negative numbers during the solver iterations.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
September 11, 2007 by Michael Wetter:<br/>
Redefined <code>kRes</code>, now the pressure drop of the fully open damper is subtracted from the fixed resistance.
</li>
<li>
February 24, 2010 by Michael Wetter:<br/>
Added parameter <code>dp_nominalIncludesDamper</code>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{-110,-34},{12,-100}},
          lineColor={0,0,255},
          textString="dp_nominal=%dp_nominal"),
        Text(
          extent={{-102,-76},{10,-122}},
          lineColor={0,0,255},
          textString="m0=%m_flow_nominal"),
        Polygon(
          points={{-24,8},{24,50},{24,38},{-24,-4},{-24,8}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-36},{28,6},{28,-6},{-20,-48},{-20,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end VAVBoxExponential;
