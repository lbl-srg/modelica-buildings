within Buildings.Utilities.Diagnostics;
block AssertInequality "Assert when condition is violated"
  extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threShold",
     threShold = 0);
  annotation (Icon(graphics={Text(
          extent={{-84,108},{90,-28}},
          lineColor={255,0,0},
          textString="u1 > u2")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics),
Documentation(info="<html>
<p>
Model that triggers an assert if 
<tt>u1 > u2 - threShold</tt>
and <tt>t > t0</tt>.
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
equation
  when (time > t0) then
    assert(u1 > u2 - threShold, message + "\n"
      + "  u1         = " + realString(u1) + "\n"
      + "  u2         = " + realString(u2) + "\n"
      + "  abs(u1-u2) = " + realString(abs(u1-u2)) + "\n"
      + "  threShold  = " + realString(threShold));
  end when;
end AssertInequality;
