within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function shaBorefieldRecords
    input String soiPath;
    input String filPath;
    input String genPath;

    output String sha;
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
end shaBorefieldRecords;
