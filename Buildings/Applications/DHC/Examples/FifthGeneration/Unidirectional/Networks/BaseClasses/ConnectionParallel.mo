within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses;
model ConnectionParallel "Model for connecting an agent to the DHC system"
  extends Buildings.Applications.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    pipDisSup(dh=dhDis, length=lDis),
    pipDisRet(dh=dhDis, length=lDis),
    pipCon(length=2*lCon, dh=dhCon));
  parameter Modelica.SIunits.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.SIunits.Length lCon
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon
    "Hydraulic diameter of the connection pipe";
end ConnectionParallel;
