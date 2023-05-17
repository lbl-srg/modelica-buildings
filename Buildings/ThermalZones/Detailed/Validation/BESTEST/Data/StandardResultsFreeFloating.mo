within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record StandardResultsFreeFloating "ASHRAE Standard Results"
    extends Modelica.Icons.Record;

 parameter ResultSummary minT(Min(final unit="K", displayUnit="degC"),
                              Max(final unit="K", displayUnit="degC"),
                              Mean(final unit="K", displayUnit="degC"))
                              "Minimum temperature";

 parameter ResultSummary maxT(Min(final unit="K", displayUnit="degC"),
                              Max(final unit="K", displayUnit="degC"),
                              Mean(final unit="K", displayUnit="degC")) "Maximum temperature";

 parameter ResultSummary meanT(Min(final unit="K", displayUnit="degC"),
                               Max(final unit="K", displayUnit="degC"),
                               Mean(final unit="K", displayUnit="degC")) "Mean temperature";

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
