within Buildings.Controls.Continuous;
block SignalRanker "Ranks output signals such that y[i] >= y[i+1]"
   extends Modelica.Blocks.Interfaces.MIMO(final nout=nin);
protected
  Real t "Temporary variable";
algorithm
  y[:] := u[:];
  for i in 1:nin loop
    for j in 1:nin-1 loop
    if y[j] < y[j+1] then
      t      := y[j+1];
      y[j+1] := y[j];
      y[j]   := t;
    end if;
   end for;
  end for;
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
          lineColor={0,0,255},
          textString="y[i] >= y[i+1]")}));
end SignalRanker;
