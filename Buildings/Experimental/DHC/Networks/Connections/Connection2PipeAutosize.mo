within Buildings.Experimental.DHC.Networks.Connections;
model Connection2PipeAutosize "Model for connecting an agent to the DHC system"
  extends Connection2PipeStandard(
    tau=5*60,
    redeclare replaceable model Model_pipDisSup = Pipes.PipeAutosize (
        roughness=7e-6,
        fac=1.5,
        dh(fixed=true) = dhDis,
        final length=lDis,
        final dp_length_nominal=dp_length_nominal),
    redeclare replaceable model Model_pipDisRet = Pipes.PipeAutosize (
        roughness=7e-6,
        fac=1.5,
        dh(fixed=true) = dhDisRet,
        final length=lDis,
        final dp_length_nominal=dp_length_nominal),
    redeclare replaceable model Model_pipCon = Pipes.PipeAutosize (
        roughness=2.5e-5,
        fac=2,
        final length=2*lCon,
        final dh(fixed=true) = dhCon,
        final dp_length_nominal=dp_length_nominal));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.Units.SI.Length dhDisRet
    "Hydraulic diameter of the return distribution pipe";
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
The instances of the pipe model are autosized based on the pressure 
drop per pipe length at nominal flow rate.
</p>
</html>"));
end Connection2PipeAutosize;
