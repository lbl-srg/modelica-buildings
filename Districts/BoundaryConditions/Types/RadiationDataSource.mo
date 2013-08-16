within Districts.BoundaryConditions.Types;
type RadiationDataSource = enumeration(
    File "Use data from file",
    Input_HGloHor_HDifHor
      "Global horizontal and diffuse horizontal radiation from connector",
    Input_HDirNor_HDifHor
      "Direct normal and diffuse horizontal radiation from connector",
    Input_HDirNor_HGloHor
      "Direct normal and global horizontal radiation from connector")
  "Enumeration to define solar radiation data source"
      annotation(Documentation(info="<html>
<p>
Enumeration to define the data source used in the weather data reader.
</p>
</html>",
        revisions=
        "<html>
<ul>
<li>
August 13, 2012, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
