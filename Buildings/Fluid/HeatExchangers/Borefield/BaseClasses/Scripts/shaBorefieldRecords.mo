within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function shaBorefieldRecords
  "Return a pseudo sha code of the combination of the record soi, fil and gen of the borefield"
  extends Modelica.Icons.Function;
    input String soiPath "Computer path of the soil record";
    input String filPath "Computer path of the fil record";
    input String genPath "Computer path of the general record";

    output String sha
    "Pseudo sha code of the combination of the soi, fil and gen records";
protected
  Real[3] shaMat=
    {Buildings.Utilities.Cryptographics.BaseClasses.sha(soiPath),
    Buildings.Utilities.Cryptographics.BaseClasses.sha(filPath),
    Buildings.Utilities.Cryptographics.BaseClasses.sha(genPath)};
  Real shaSum = sum(shaMat);

  Integer hash_el "Part of the sha-number";
algorithm
  sha :="";
  for i in 1:19 loop
    hash_el :=integer(shaSum/10^(57 - 3*i));
    shaSum :=shaSum - hash_el*10^(57 - 3*i);
    sha :=sha + String(hash_el);
  end for;

    annotation (Documentation(info="<html>
    <p>This function returns a pseudo sha code of the combination of the record soi, fil and gen of the borefield. The SHA of the different records are calculated using 
    <a href=\"Buildings.Utilities.Cryptographics.BaseClasses.sha\"> Buildings.Utilities.Cryptographics.BaseClasses.sha </a>. The obtained reals are summed to a unique number.
    Finally, the real is converted to a string. Notice that the function <code>String()</code> cannot convert an real of 60 digits. Therefore, in order to
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
end shaBorefieldRecords;
