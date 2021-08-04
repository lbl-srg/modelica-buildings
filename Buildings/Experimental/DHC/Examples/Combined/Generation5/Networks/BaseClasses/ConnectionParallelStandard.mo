within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses;
model ConnectionParallelStandard
  "Model for connecting an agent to the DHC system"
  extends DHC.Networks.BaseClasses.PartialConnection2Pipe(
    tau=5*60,
    redeclare replaceable model Model_pipDis = PipeStandard (
      roughness=7e-6,
      fac=1.5,
      final length=lDis,
      final dh=dhDis),
    redeclare replaceable model Model_pipCon = PipeStandard (
      roughness=2.5e-5,
      fac=2,
      final length=2*lCon,
      final dh=dhCon));
  parameter Modelica.SIunits.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.SIunits.Length lCon
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon
    "Hydraulic diameter of the connection pipe";
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents the supply and return lines to connect an
agent (e.g., an energy transfer station) to a two-pipe main distribution
system.
The instances of the pipe model are parameterized with the
hydraulic diameter.
</p>
</html>"));
end ConnectionParallelStandard;
