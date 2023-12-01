within Buildings.Experimental.DHC.Networks.Connections;
model Connection2PipeStandard "Model for connecting an agent to the DHC system"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    tau=5*60,
    redeclare replaceable model Model_pipDisSup = Pipes.PipeStandard (
        roughness=7e-6,
        fac=1.5,
        final length=lDis,
        final dh=dhDis),
    redeclare replaceable model Model_pipDisRet = Pipes.PipeStandard (
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
equation
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-30,-40}}, color={0,127,255}));
  connect(pipDisRet.port_a, junConRet.port_2)
    annotation (Line(points={{-60,-80},{10,-80}}, color={0,127,255}));
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
end Connection2PipeStandard;
