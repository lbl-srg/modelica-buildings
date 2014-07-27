within Buildings.Utilities.Cryptographics.BaseClasses;
function sha "Rewritten sha-code returning a unique number for each file."
  extends Modelica.Icons.Function;
  input String argv=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Documentation/userGuide/build/html/acknowledgments.html");
  output Real sha1;

external"C" sha1 = sha1(argv);
  annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://Buildings/Resources/C-Sources");
end sha;
