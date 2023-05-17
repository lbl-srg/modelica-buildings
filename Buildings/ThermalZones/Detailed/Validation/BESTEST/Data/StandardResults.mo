within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record StandardResults "ASHRAE Standard Results"
    extends Modelica.Icons.Record;

 parameter ResultSummary annualHea(Min(final unit="J"),
                                 Max(final unit="J"),
                                 Mean(final unit="J")) "Annual heating energy";
 parameter ResultSummary annualCoo(Min(final unit="J"),
                                 Max(final unit="J"),
                                 Mean(final unit="J")) "Annual heating energy";
 parameter ResultSummary peakHea(Min(final unit="W"),
                                 Max(final unit="W"),
                                 Mean(final unit="W")) "Peak heating power";
 parameter ResultSummary peakCoo(Min(final unit="W"),
                                 Max(final unit="W"),
                                 Mean(final unit="W")) "Peak heating power";
 annotation (
   defaultComponentPrefixes="parameter",
   defaultComponentName="staRes",
   Documentation(info=
"<html>
<p>
For cases with heating and cooling,
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

end StandardResults;
