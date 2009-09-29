within Buildings.Fluid.Actuators.Dampers;
model VAVBoxExponential
  "VAV box with a fixed resistance plus a damper model withe exponential characteristics"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(dp_start=dp_nominal);
  import SI = Modelica.SIunits;

   annotation (Documentation(info="<html>
VAV box plus an air damper with a flow coefficient that is an exponential function of the opening angle.
</html>", revisions="<html>
<ul>
<li>
June 10, 2008 by Michael Wetter:<br>
Introduced new partial base class, 
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
September 11, 2007 by Michael Wetter:<br>
Redefined <code>kRes</code>, now the pressure drop of the fully open damper is subtracted from the fixed resistance.
<li>
July 27, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-66,-40},{-34,40}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,22},{102,-24}},
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
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-36},{28,6},{28,-6},{-20,-48},{-20,-36}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics));
  parameter SI.MassFlowRate m_flow_nominal "Mass flow rate" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Pressure dp_nominal(min=0)
    "Pressure drop, including fully open damper" 
                                              annotation(Dialog(group = "Nominal Condition"));
protected
  parameter SI.Pressure dpDamOpe0 = k1*m_flow_nominal^2/2/Medium.density(sta0)/A^2
    "Pressure drop of fully open damper at nominal flow rate";
  parameter Real kResSqu(unit="kg.m") = m_flow_nominal^2 / (dp_nominal-dpDamOpe0)
    "Resistance coefficient for fixed resistance element";
equation
//    "flow coefficient for resistance base model";
   k = sqrt(1/(1/kResSqu + 1/kDamSqu))
    "flow coefficient for resistance base model";

end VAVBoxExponential;
