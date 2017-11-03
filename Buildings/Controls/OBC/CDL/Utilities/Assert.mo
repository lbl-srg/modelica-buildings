within Buildings.Controls.OBC.CDL.Utilities;
block Assert
  "Trigger warning and print warning message if assertion condition is not fulfilled"

  parameter Modelica.SIunits.Time startTime = 0
    "Start time for activating the assert";
  parameter String warOnInf = "Warning ON message";
  parameter String warOffInf= "Warning OFF message";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean input to trigger assert"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
protected
  parameter Modelica.SIunits.Time t0( fixed=false)
    "Simulation start time";
  Boolean not_u=not u;

initial equation
  t0 = time + startTime;
  pre(not_u) = not u;

equation
  if noEvent(time > t0) then
    assert(not_u, warOnInf + "\n"
      + "at  time  = " + String(time), AssertionLevel.warning);
    assert(u, warOffInf + "\n"
      + "at  time  = " + String(time), AssertionLevel.warning);
  end if;

annotation (
  defaultComponentName="assMes",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,160},{100,106}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Model that triggers an assert if the boolean input <code>u</code> has falling or 
increasing edge. If input <code>u</code> increase, a message <code>warOnInf</code> 
indicating warning-on will be print.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Assert;
