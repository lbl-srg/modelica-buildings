within Buildings.Controls.OBC.CDL.Integers;
block OnCounter "Increment the output if the input switches to true"

  parameter Integer y_start = 0
    "Initial and reset value of y if input reset switches to true";

  Interfaces.BooleanInput trigger "Boolean input signal"
    annotation (Placement(transformation(extent={{-180,-40},{-100,40}})));

  Interfaces.BooleanInput reset "Reset the counter" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

  Interfaces.IntegerOutput y "Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  pre(y) = y_start;

equation
  when {trigger, reset} then
     y = if reset then y_start else pre(y) + 1;
  end when;

  annotation (
    defaultComponentName="onCouInt",
    Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        initialScale=0.06), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Text(
            visible=use_reset,
            extent={{-64,-62},{58,-86}},
            lineColor={0,0,0},
            textString="reset"),        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
Block that outputs how often the <code>trigger</code> input changed to <code>true</code>
since the last invocation of <code>reset</code>.
</p>
<p>
This block may be used as a counter. Its output <code>y</code> starts
at the parameter value <code>y_start</code>.
Whenever the input signal <code>trigger</code> changes to <code>true</code>,
the output is incremented by <i>1</i>.
When the input <code>reset</code> changes to <code>true</code>,
then the output is reset to <code>y = y_start</code>.
If both inputs <code>trigger</code> and <code>reset</code> change
simultaneously, then the ouput is <code>y = y_start</code>.
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
end OnCounter;
