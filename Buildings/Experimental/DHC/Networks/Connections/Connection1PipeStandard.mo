within Buildings.Experimental.DHC.Networks.Connections;
model Connection1PipeStandard "Model for connecting an agent to the DHC system"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection1Pipe(
    tau=5*60,
    redeclare replaceable model Model_pipDis = Pipes.PipeStandard (
        roughness=7e-6,
        fac=1.5,
        final length=lDis,
        final dh=dhDis),
    redeclare replaceable model Model_pipCon = Pipes.PipeStandard (
        roughness=2.5e-5,
        fac=2,
        final length=2*lCon,
        final dh=dhCon));
  parameter Modelica.Units.SI.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.Units.SI.Length lCon
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.Units.SI.Length dhCon
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
agent (e.g., an energy transfer station) to a one-pipe main distribution
system.
The instances of the pipe model are parameterized with the
hydraulic diameter.
</p>
</html>"));
end Connection1PipeStandard;
