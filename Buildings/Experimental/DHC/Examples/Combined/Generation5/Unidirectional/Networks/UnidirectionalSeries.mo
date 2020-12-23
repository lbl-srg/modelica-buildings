within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks;
model UnidirectionalSeries
  "Hydraulic network for unidirectional series DHC system"
  extends DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    redeclare BaseClasses.ConnectionSeries con[nCon](
      final lDis=lDis,
      final lCon=lCon,
      each final dpCon_length_nominal=dpCon_length_nominal,
      each final dpDis_length_nominal=dpDis_length_nominal),
    redeclare model Model_pipDis = BaseClasses.PipeDistribution (
      final length=2*lEnd,
      final dp_length_nominal=dpDis_length_nominal,
      final dh=con[1].pipDis.dh));
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd
    "Length of the end of the distribution line (after last connection)";
  parameter Real dpDis_length_nominal(final unit="Pa/m")
    "Pressure drop per pipe length at nominal mass flow rate - Distribution line";
  parameter Real dpCon_length_nominal(final unit="Pa/m")
    "Pressure drop per pipe length at nominal mass flow rate - Connection line";
end UnidirectionalSeries;
