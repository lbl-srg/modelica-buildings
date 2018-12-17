within Buildings.Fluid.Actuators.Dampers;
model VAVBoxExpLin
  "VAV box model (exponential characteristic) with optional characteristic linearization"
  extends Buildings.Fluid.Actuators.Dampers.VAVBoxExponential(
    conFilterBool=not linearized);

protected
  Buildings.Fluid.Actuators.BaseClasses.LinearizeVAVBoxExponential lin_block(
  kFixed=kFixed,
  dp_nominal_pos=dp_nominal_pos,
  dp_cor_nominal=dp_cor_nominal,
  m_flow_nominal_pos=m_flow_nominal_pos,
  rho=rho,
  A=A,
  a=a,
  b=b,
  cL=cL,
  cU=cU,
  yL=yL,
  yU=yU) if linearized;

  parameter Real dp_cor_nominal = if dp_nominalIncludesDamper then 0.0 else dpDamOpe_nominal;

equation
  if linearized then
    connect(y, lin_block.u);
    connect(lin_block.y, y_internal);
  end if;

annotation (
defaultComponentName="vavDam",
Documentation(info="<html>
<p>
This class extends <code>VAVBoxExponential</code> and includes an option to linearize the relationship between
the input control signal and the mass flow rate. 
</p>
<p>
If <code>linearize=true</code> then:
<ul>
<li>
the inverse function of the damper characteristic is applied to the input control signal;
</li>
<li>
a linear relationship between <i>m</i> and <i>&Delta;p</i> is used for any flow rate.
</li>
</ul>
<p>
The inverse function includes the optional fixed flow resistance specified by the user so that 
the linear relationship is not altered by the additional pressure drop.
</p>
<p>
Note:
<ul>
<li>
The parameter <code>linearize</code> was previously used in <code>VAVBoxExponential</code> to 
enforce a linear relationship between <i>m</i> and <i>&Delta;p</i> and alleviate solver issues.<br/>
It did not address the potential control instabilities caused by the nonlinearities of the damper's 
opening characteristic.
</li>
<li>
The optional second order input filter modeling the actuator's dynamics introduces further nonlinearities 
that the current <code>linearize</code> option does not cancel.
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
