within Buildings.Experimental.DHC.Networks.Connections;
model Connection1Pipe_R "Model for connecting an agent to the DHC system"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection1Pipe(
    tau=5*60,
    redeclare replaceable model Model_pipDis = Pipes.PipeAutosize(
        roughness = 7e-6,
        final length = lDis,
        dh(fixed=true) = dhDis,
        final dp_length_nominal = dp_length_nominal),
    redeclare replaceable model Model_pipCon = Buildings.Fluid.FixedResistances.LosslessPipe,
    pipDis(fac=1));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.Units.SI.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.Units.SI.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  annotation (Documentation(revisions="<html>
  <ul>
<li>
March 15, 2024, by David Blum:<br/>
Renamed.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3712\">issue 3712</a>.
</li>
<li>
December 20, 2023, by Ettore Zanetti:<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents the supply and return lines to connect an
agent (e.g., an energy transfer station) to a one-pipe main distribution
system. The instances of the pipe model are autosized based on the pressure drop per pipe length
at nominal flow rate based on the model <a href=\"modelica://Buildings.Experimental.DHC.Networks.Pipes.PipeAutosize\">
Buildings.Experimental.DHC.Networks.Pipes.PipeAutosize</a> for the distribution line. The connection to the building as the length is typically relatively short so a losssless pipe is considered.
</p>
</html>"));
end Connection1Pipe_R;
