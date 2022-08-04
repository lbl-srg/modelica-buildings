within Buildings.Controls.Continuous;
block SignalRanker "Ranks output signals such that y[i] >= y[i+1]"
   extends Modelica.Blocks.Interfaces.MIMO(final nout=nin);
equation
  y = Modelica.Math.Vectors.sort(u, ascending=false);
  annotation (
defaultComponentName="sigRan",
Documentation(info="<html>
<p>
Block that sorts the input signal <code>u[:]</code> such that the output
signal satisfies <code>y[i] &gt;= y[i+1]</code> for all <code>i=1, ..., nin-1</code>.
</p>
<p>
This block may for example be used in a variable air volume flow
controller to access the position of the dampers that are most open.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 15, 2021, by Michael Wetter:<br/>
Changed implementation to use sort function from Modelica Standard Library.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1534\">IBPSA, #1534</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Removed <code>assert</code> statement.
</li>
<li>
November 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={Text(
          extent={{-94,34},{96,-164}},
          textColor={0,0,255},
          textString="y[i] >= y[i+1]")}));
end SignalRanker;
