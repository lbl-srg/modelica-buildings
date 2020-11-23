within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Networks;
model UnidirectionalParallel
  "Hydraulic network for unidirectional parallel DHC system"
  extends Applications.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    redeclare BaseClasses.ConnectionParallel con[nCon](
      final lDis=lDis, final lCon=lCon, final dhDis=dhDis, final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeDistribution (
      final dh=dhEnd, final length=2*lEnd));
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd
    "Length of the end of the distribution line (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis[nCon]
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhCon[nCon]
    "Hydraulic diameter of each connection pipe";
  parameter Modelica.SIunits.Length dhEnd = dhDis[nCon]
    "Hydraulic diameter of the end of the distribution line";
end UnidirectionalParallel;
