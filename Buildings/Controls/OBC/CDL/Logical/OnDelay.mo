within Buildings.Controls.OBC.CDL.Logical;
block OnDelay
  "Delay a rising edge of the input, but do not delay a falling edge."

  parameter Modelica.SIunits.Time delayTime "Delay time";

  Controls.OBC.CDL.Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Controls.OBC.CDL.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
      Boolean delaySignal(start=false,fixed=true);
      discrete Modelica.SIunits.Time t_next;

initial equation
      pre(u) = false;
      pre(t_next) = time - 1;
algorithm
      when initial() then
         delaySignal := u;
         t_next := time - 1;
      elsewhen u then
         delaySignal := true;
         t_next := time + delayTime;
      elsewhen not u then
         delaySignal := false;
         t_next := time - 1;
      end when;
equation
      if delaySignal then
         y = time >= t_next;
      else
         y = false;
      end if;
      annotation (
          defaultComponentName="onDel",
          Icon(graphics={        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Text(
            extent={{-250,-120},{250,-150}},
            lineColor={0,0,0},
            textString="%delayTime s"),
          Line(points={{-80,-66},{-60,-66},{-60,-22},{38,-22},{38,-66},{66,-66}}),
          Line(points={{-80,32},{-4,32},{-4,76},{38,76},{38,32},{66,32}},
              color={255,0,255}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
Block that delays an on-signal.
</p>
<p>
A rising edge of the Boolean input <code>u</code> gives a delayed output.
A falling edge of the input is immediately given to the output.
</p>

<p>
Simulation results of a typical example with a delay time of 0.1 s
is shown in the next figure.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/OnDelay1.png\"
     alt=\"OnDelay1.png\" />
<br/>
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/OnDelay2.png\"
     alt=\"OnDelay2.png\" />
</p>

</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end OnDelay;
