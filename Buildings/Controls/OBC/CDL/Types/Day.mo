within Buildings.Controls.OBC.CDL.Types;
type Day=enumeration(WorkingDay
  "Working day, such as Monday through Friday",NonWorkingDay
  "Non-working day, such as week-ends, but not holidays",Holiday
  "Holiday")
  "Enumeration for the day types"
  annotation (Documentation(info="<html>
<p>
Enumeration for the type of days.
The possible values are:
</p>
<ol>
<li>
WorkingDay
</li>
<li>
NonWorkingDay
</li>
<li>
Holiday
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>
February 27, 2017 by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
