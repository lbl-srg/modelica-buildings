within Districts.Utilities.Diagnostics.BaseClasses;
block PartialInputCheck "Assert when condition is violated"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.Time startTime = 0
    "Start time for activating the assert";
  parameter Real threShold(min=0)=1E-2 "Threshold for equality comparison";
  parameter String message = "Inputs differ by more than threShold";
protected
  parameter Modelica.SIunits.Time t0( fixed=false) "Simulation start time";
public
  Modelica.Blocks.Interfaces.RealInput u1
    "Value to check, equal to 0 if unconnected"
       annotation (Placement(transformation(extent={{-140,40},{-100,80}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u2
    "Value to check, equal to 0 if unconnected"
       annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
          rotation=0)));
initial equation
  t0 = time + startTime;
equation
  if cardinality(u1)==0 then
    u1 = 0;
  end if;
  if cardinality(u2)==0 then
    u2 = 0;
  end if;
  annotation (Icon(graphics={Text(
          extent={{-62,-38},{54,-68}},
          lineColor={0,0,255},
          textString="%threShold")}),         Diagram(graphics),
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
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInputCheck;
