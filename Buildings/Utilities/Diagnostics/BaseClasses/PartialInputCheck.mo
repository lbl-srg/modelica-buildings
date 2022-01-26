within Buildings.Utilities.Diagnostics.BaseClasses;
block PartialInputCheck "Assert when condition is violated"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Time startTime=0
    "Start time for activating the assert";
  parameter Real threShold(min=0)=1E-2 "Threshold for equality comparison";
  parameter String message = "Inputs differ by more than threShold";
  Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
       annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
       annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
protected
  parameter Modelica.Units.SI.Time t0(fixed=false) "Simulation start time";
initial equation
  t0 = time + startTime;

  annotation (Icon(graphics={Text(
          extent={{-62,-38},{54,-68}},
          textColor={0,0,255},
          textString="%threShold")}),
Documentation(info="<html>
<p>
Partial model that can be used to check whether its
inputs satisfy a certain condition such as equality within
a prescribed threshold.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 18, 2013, by Michael Wetter:<br/>
Removed <code>cardinality</code> function as this is
deprecated in the MSL specification and not correctly implemented in omc.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInputCheck;
