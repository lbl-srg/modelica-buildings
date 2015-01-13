within Buildings.Rooms.Validation.BESTEST.Data;
record StandardResultsFreeFloating "ASHRAE Standard Results"
    extends Modelica.Icons.Record;

 parameter ResultSummary minT(Min(unit="K"),
                              Max(unit="K"),
                              Mean(unit="K")) "Minimum temperature";

 parameter ResultSummary maxT(Min(unit="K"),
                              Max(unit="K"),
                              Mean(unit="K")) "Maximum temperature";

 parameter ResultSummary meanT(Min(unit="K"),
                               Max(unit="K"),
                              Mean(unit="K")) "Mean temperature";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="staRes",
Documentation(info=
"<html>
<p>
For free-floating temperature cases,
this record is used to compare the simulated results with
the results published in the ASHRAE/ANSI Standard 140.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 12, 2012, by Michael Wetter:<br/>
Merged to the Buildings library.
Changed units to units used in Modelica Standard Library.
Used records to store data.
</li>
<li>
June 26, 2012, by Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>"));

end StandardResultsFreeFloating;
