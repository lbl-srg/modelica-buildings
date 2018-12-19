within Buildings.Fluid.Actuators.Dampers;
model VAVBoxExpLin
  "VAV box model (exponential characteristic) with optional characteristic linearization"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
    complete_linear=linearized,
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
defaultComponentName="damLin",
Documentation(info="<html>
<p>
This class is similar to 
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.VAVBoxExponential\">Dampers.VAVBoxExponential</a>
 with an optional linearization of the relationship between the input control signal and the mass flow rate. 
</p>
<p>
If <code>linearized</code> then:
<ul>
<li>
the flow coefficient is computed by means of a linearizing function taking values between <i>k(y=0)</i> and <i>k(y=1)</i>;
</li>
<li>
a linear relationship between <i>m</i> and <i>&Delta;p</i> is used for any flow rate.
</li>
</ul>
<p>
The linearizing function includes the fixed flow resistance specified by the user so that 
the linear relationship is not altered by the additional pressure drop.
</p>
<p>
Note:
<ul>
<li>
The parameter <code>linearized</code> was previously used in 
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.VAVBoxExponential\">Dampers.VAVBoxExponential</a> 
to enforce a linear relationship between <i>m</i> and <i>&Delta;p</i> and alleviate solver issues.<br/>
It did not address the potential control instabilities caused by the nonlinearities of the damper's 
opening characteristic.
</li>
<li>
The optional second order input filter modeling the actuator's dynamics introduces further nonlinearities 
that the current <code>linearized</code> option does not cancel.
</li>
</ul>  
</p>
</html>", revisions="<html>
<ul>
<li>
December 16, 2018 by Antoine Gautier:<br/>
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
end VAVBoxExpLin;
