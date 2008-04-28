block AssertInquality "Assert when condition is violated" 
  extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threShold",
     threShold = 0);
  annotation (Icon(           Text(
        extent=[-84,108; 90,-28],
        string="u1 = u2",
        style(color=1, rgbcolor={255,0,0}))), Diagram,
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
end AssertInquality;
