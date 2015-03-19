within Buildings.Rooms.Validation.BESTEST.Data;
record ResultSummary "Record that is used for summary of the results"
 parameter Real Min "Minimum";
 parameter Real Max "Maximum";
 parameter Real Mean "Mean";
 annotation (
   Documentation(info=
"<html>
<p>
Record that is used for reference results.</p>
</html>",
revisions="<html>
<ul>
<li>
July 12, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResultSummary;
