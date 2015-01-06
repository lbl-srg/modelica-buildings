within Buildings.Utilities.Cryptographics.BaseClasses;
function sha "Rewritten sha-code returning a unique number for each file."
  extends Modelica.Icons.Function;
  input String argv=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Documentation/userGuide/build/html/acknowledgments.html")
    "File path for which the SHA code will be computed";
  output Real sha1 "Pseudo sha code";

external"C" sha1 = sha1(argv);
  annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Documentation(info="<html>
    <p>This function uses a rewritten sha-code returning a unique number for each file. </p>
</html>", revisions="<html>
<ul>
<li>
January 2015, by Damien Picard:<br>
Add documentation.
</li>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end sha;
