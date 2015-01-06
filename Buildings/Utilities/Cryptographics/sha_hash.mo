within Buildings.Utilities.Cryptographics;
function sha_hash
  "Return unique string containing the digits from the real number of baseClasses.sha. This is necessary as the Modelica function \"String\" cannot return 60 digits"
   extends Modelica.Icons.Function;
    input String argv=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Documentation/userGuide/build/html/acknowledgments.html");
    output String hash "string make of the digits of the sha-number";
protected
  Real hash_numb "Real number for sha-function";
  Integer hash_el "Part of the sha-number";
algorithm
  hash_numb :=Buildings.Utilities.Cryptographics.BaseClasses.sha(argv);
  hash :="";
  for i in 1:19 loop
    hash_el :=integer(hash_numb/10^(57 - 3*i));
    hash_numb :=hash_numb - hash_el*10^(57 - 3*i);
    hash :=hash + String(hash_el);
  end for;

    annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Documentation(info="<html>
    <p>This function return unique string containing the digits from the real number of <a href=\"Buildings.Utilities.Cryptographics.BaseClasses.sha\"> 
    Buildings.Utilities.Cryptographics.BaseClasses.sha </a>. This is necessary as the Modelica function <code> String </code> cannot return 60 digits. Therefore, in order to
    convert the full number, the convertion is done by the concatenation of 19 different string. </p>
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
end sha_hash;
