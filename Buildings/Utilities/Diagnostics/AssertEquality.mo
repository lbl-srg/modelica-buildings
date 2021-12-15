within Buildings.Utilities.Diagnostics;
block AssertEquality "Assert when condition is violated"
  extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threShold");
equation
  if noEvent(time > t0) then
    assert(noEvent(abs(u1 - u2) < threShold), message + "\n"
      + "  time       = " + String(time) + "\n"
      + "  u1         = " + String(u1) + "\n"
      + "  u2         = " + String(u2) + "\n"
      + "  abs(u1-u2) = " + String(abs(u1-u2)) + "\n"
      + "  threShold  = " + String(threShold));
  end if;
annotation (
defaultComponentName="assEqu",
Icon(graphics={Text(
          extent={{-84,108},{90,-28}},
          textColor={255,0,0},
          textString="u1 = u2")}),
Documentation(info="<html>
<p>
Model that triggers an assert if
<i>|u1-u2| &gt; threShold</i>
and <i>t &gt; t<sub>0</sub></i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 10, 2013, by Michael Wetter:<br/>
Reformulated model to avoid an event iteration.
</li>
<li>
September 10, 2013, by Michael Wetter:<br/>
Added <code>time</code> in print statement as OpenModelica,
in its error message, does not output the time when the assert is triggered.
</li>
<li>
January 23, 2013, by Michael Wetter:<br/>
Replaced <code>when</code> test with <code>if</code> test as
equations within a <code>when</code> section are only evaluated
when the condition becomes true.
This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/72\">issue 72</a>.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertEquality;
