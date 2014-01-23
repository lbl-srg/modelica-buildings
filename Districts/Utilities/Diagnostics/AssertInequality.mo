within Districts.Utilities.Diagnostics;
block AssertInequality "Assert when condition is violated"
  extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threShold",
     threShold = 0);
equation
  when (time > t0) then
    assert(u1 > u2 - threShold, message + "\n"
      + "  u1         = " + String(u1) + "\n"
      + "  u2         = " + String(u2) + "\n"
      + "  abs(u1-u2) = " + String(abs(u1-u2)) + "\n"
      + "  threShold  = " + String(threShold));
  end when;
  annotation (Icon(graphics={Text(
          extent={{-84,108},{90,-28}},
          lineColor={255,0,0},
          textString="u1 > u2")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics),
Documentation(
defaultComponentName="assIne",
info="<html>
<p>
Model that triggers an assert if 
<i>u1 > u2 - threShold</i>
and <i>t &gt; t<sub>0</sub></i>.
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
end AssertInequality;
