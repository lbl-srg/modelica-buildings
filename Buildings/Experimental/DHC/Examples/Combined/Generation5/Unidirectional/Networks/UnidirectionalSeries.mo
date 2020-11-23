within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Networks;
model UnidirectionalSeries
  "Hydraulic network for unidirectional series DHC system"
  extends Applications.DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    redeclare BaseClasses.ConnectionSeries con[nCon](
      final lDis=lDis, final lCon=lCon, each final dhDis=dhDis, final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeDistribution (
      final dh=dhDis, final length=2*lEnd));
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd
    "Length of the end of the distribution line (after last connection)";
  parameter Modelica.SIunits.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon[nCon]
    "Hydraulic diameter of each connection pipe";
end UnidirectionalSeries;
