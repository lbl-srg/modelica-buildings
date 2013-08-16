within Districts.BoundaryConditions.Types;
type DataSource = enumeration(
    File "Use data from file",
    Parameter "Use parameter",
    Input "Use input connector") "Enumeration to define data source"
      annotation(Documentation(info="<html>
<p>
Enumeration to define the data source used in the weather data reader.
</p>
</html>",
        revisions=
        "<html>
<ul>
<li>
July 20, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
