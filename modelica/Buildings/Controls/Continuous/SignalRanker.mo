block SignalRanker "Ranks output signals such that y[i] >= y[i+1]" 
   extends Modelica.Blocks.Interfaces.MIMO(final nout=nin);
  annotation (Documentation(info="<html>
<p>
Block that sorts the input signal <tt>u[:]</tt> such that the output
signal satisfies <tt>y[i] >= y[i+1]</tt> for all <tt>i=1, ..., nin-1</tt>.
</p>
<p>
This block may for example be used in a variable air volume flow
controller to access the position of the dampers that are most open.
</html>",
revisions="<html>
<ul>
<li>
November 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon(Text(
        extent=[-94,34; 96,-164], 
        style(color=3, rgbcolor={0,0,255}), 
        string="y[i] >= y[i+1]")));
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
  // check algorithm (during development only)
  for i in 1:nin-1 loop
    assert(y[i] >= y[i+1], "Error in sorting algorithm.");
  end for;
end SignalRanker;
