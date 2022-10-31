within Buildings.Fluid.Actuators.Dampers;
model Exponential
  "Air damper with exponential opening characteristics"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential;
equation
  // Pressure drop calculation
  if linearized then
    m_flow*m_flow_nominal_pos = k^2*dp;
  else
    if homotopyInitialization then
      if from_dp then
        m_flow=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                  dp=dp, k=k,
                  m_flow_turbulent=m_flow_turbulent),
            simplified= m_flow_nominal_pos*dp/max(Modelica.Constants.eps, dp_nominal_pos));
      else
        dp=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                  m_flow=m_flow, k=k,
                  m_flow_turbulent=m_flow_turbulent),
            simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
        end if;  // from_dp
    else // do not use homotopy
      if from_dp then
        m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                  dp=dp, k=k, m_flow_turbulent=m_flow_turbulent);
      else
        dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                  m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent);
      end if;  // from_dp
    end if; // homotopyInitialization
  end if; // linearized
annotation (
defaultComponentName="damExp",
Documentation(info="<html>
<p>
Model of two flow resistances in series:
</p>
<ul>
<li>
one resistance has a fixed flow coefficient;
</li>
<li>
the other resistance represents a damper whose flow coefficient is an
exponential function of the opening angle.
</li>
</ul>
<p>
The lumped flow coefficient <i>k(y)</i> (function of the fractional opening
<i>y</i>) is used to compute the mass flow rate versus pressure drop relation as:
</p>
<p style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k(y)  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
<p>
For a description of the damper opening characteristics and typical
parameter values, see the partial model
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
April 12, 2021, by Michael Wetter:<br/>
Guarded against division by zero if the pressure equation is removed.
This then leads to a more meaningful error message.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1243\">IBPSA, #1243</a>.
</li>
<li>
December 23, 2019, by Antoine Gautier:<br/>
Added the pressure drop calculation as it is no longer in the base class.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">IBPSA, #1188</a>.
</li>
<li>
March 22, 2017, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
April 14, 2014 by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
September 26, 2013 by Michael Wetter:<br/>
Moved assignment of <code>kDam_default</code> and <code>kThetaSqRt_default</code>
from <code>initial algorithm</code> to the variable declaration, to avoid a division
by zero in OpenModelica.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
Extended range of control signal from 0 to 1 by implementing the function
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
June 30, 2007 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialActuator\">PartialActuator</a>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br/>
Introduced partial base class.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),  Polygon(
          points={{-26,12},{22,54},{22,42},{-26,0},{-26,12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-32},{26,10},{26,-2},{-22,-44},{-22,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Exponential;
