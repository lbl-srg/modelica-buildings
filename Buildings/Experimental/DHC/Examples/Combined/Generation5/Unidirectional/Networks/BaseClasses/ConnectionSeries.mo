within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.BaseClasses;
model ConnectionSeries "Model for connecting an agent to the DHC system"
  extends Experimental.DHC.Networks.BaseClasses.PartialConnection1Pipe(
    redeclare model Model_pipDis = PipeDistribution (
      final length=lDis,
      final dp_length_nominal=dpDis_length_nominal,
      final dh=dhDis),
    redeclare model Model_pipCon = PipeConnection (
      final length=2*lCon,
      final dp_length_nominal=dpCon_length_nominal,
      final dh=dhCon));
  parameter Modelica.SIunits.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.SIunits.Length lCon
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Real dpDis_length_nominal(final unit="Pa/m")
    "Pressure drop per pipe length at nominal mass flow rate - Distribution line";
  parameter Real dpCon_length_nominal(final unit="Pa/m")
    "Pressure drop per pipe length at nominal mass flow rate - Connection line";
  parameter Modelica.SIunits.Length dhDis(fixed=false,
    start=0.2,
    min=0.01);
  parameter Modelica.SIunits.Length dhCon(fixed=false,
    start=0.2,
    min=0.01);
initial equation
  pipDis.dpStraightPipe_nominal = pipDis.dp_nominal / pipDis.fac;
  pipCon.dpStraightPipe_nominal = pipCon.dp_nominal / pipCon.fac;
end ConnectionSeries;
