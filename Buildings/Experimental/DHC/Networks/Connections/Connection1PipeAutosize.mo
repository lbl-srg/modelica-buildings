within Buildings.Experimental.DHC.Networks.Connections;
model Connection1PipeAutosize "Model for connecting an agent to the DHC system"
  extends Connection1PipeStandard(
    tau=5*60,
    redeclare replaceable model Model_pipDis = Pipes.PipeAutosize (
        roughness=7e-6,
        fac=1.5,
        final length=lDis,
        final dh(fixed=true) = dhDis,
        final dp_length_nominal=dp_length_nominal),
    redeclare replaceable model Model_pipCon = Pipes.PipeAutosize (
        roughness=2.5e-5,
        fac=2,
        final length=2*lCon,
        final dh(fixed=true) = dhCon,
        final dp_length_nominal=dp_length_nominal));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
equation
  connect(pipDis.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
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
The instances of the pipe model are autosized based on the pressure drop per pipe length 
at nominal flow rate.
</p>
</html>"));
end Connection1PipeAutosize;
