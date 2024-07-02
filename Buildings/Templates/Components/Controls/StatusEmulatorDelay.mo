within Buildings.Templates.Components.Controls;
block StatusEmulatorDelay
  "Block that emulates the status of an equipment"
  parameter Real delayTime(
    final quantity="Time",
    final unit="s")=2
    "Delay time";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1 "Equipment run command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual
    "Equipment status" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
protected
  Real y1Rea = if y1 then 1.0 else 0.0;
  Real y1Rea_actual = delay(y1Rea, delayTime, delayTime);
equation
  y1_actual = y1Rea_actual > 0;
  annotation (
  defaultComponentName="sta",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
This block emulates the status of an equipment, i.e.,
the current on/off state as reported by the hardware itself.
</p>
<p>
The implementation is based on
<a href=\"modelica://Buildings.Fluid.BaseClasses.ActuatorFilter\">
Buildings.Fluid.BaseClasses.ActuatorFilter</a>
and the model is configured with <code>yLim=0.5</code> so that
the delay between the on command and the on status is
equal to the delay between the off command and the off status
(about <i>2</i>&nbsp;s with the default parameter settings).
Note that this delay may not be representative of the actual
dynamics of certain equipment such as chillers or heat pumps.
In addition, this block uses the equipment command signal to
generate the status signal, which in turn can lead to inconsistencies
with certain equipment that run cyclically at low load and
where the status then comes and goes.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StatusEmulatorDelay;
