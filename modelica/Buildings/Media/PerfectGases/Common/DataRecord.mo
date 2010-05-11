within Buildings.Media.PerfectGases.Common;
record DataRecord "Coefficient data record for properties of perfect gases"
  extends Modelica.Icons.Record;

  String name "Name of ideal gas";
  Modelica.SIunits.MolarMass MM "Molar mass";
  Modelica.SIunits.SpecificHeatCapacity R "Gas constant";
  Modelica.SIunits.SpecificHeatCapacity cp
    "Specific heat capacity at constant pressure";
  Modelica.SIunits.SpecificHeatCapacity cv = cp - R
    "Specific heat capacity at constant volume";
  annotation (Documentation(preferedView="info", info="<HTML>
<p>
This data record contains the coefficients for perfect gases.
</p>
</HTML>"), revisions=
        "<html>
<ul>
<li>
May 12, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end DataRecord;
