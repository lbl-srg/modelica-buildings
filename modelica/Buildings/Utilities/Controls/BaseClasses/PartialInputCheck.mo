block PartialInputCheck "Assert when condition is violated" 
  extends Modelica.Blocks.Interfaces.BlockIcon;
  annotation (Icon(Text(
        extent=[-62,-38; 54,-68],
        style(color=3, rgbcolor={0,0,255}),
        string="%threShold")),                Diagram,
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
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Modelica.SIunits.Time startTime = 0 
    "Start time for activating the assert, set to -1 to disable";
  parameter Real threShold(min=0)=1E-2 "Threshold for equality comparison";
  parameter String message = "Inputs differ by more than threShold";
protected 
  parameter Modelica.SIunits.Time t0( fixed=false) "Simulation start time";
public 
  Modelica.Blocks.Interfaces.RealInput u1 
    "Value to check, equal to 0 if unconnected" 
       annotation (extent=[-140,40; -100,80]);
  Modelica.Blocks.Interfaces.RealInput u2 
    "Value to check, equal to 0 if unconnected" 
       annotation (extent=[-140,-80; -100,-40]);
initial equation 
  t0 = time + startTime;
equation 
  if cardinality(u1)==0 then
    u1 = 0;
  end if;
  if cardinality(u2)==0 then
    u2 = 0;
  end if;
end PartialInputCheck;
