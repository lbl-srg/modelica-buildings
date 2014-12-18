within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function lineFeederCablesLow
  "This functions returns a vector of low voltage cables for the feeder"
  extends
    Buildings.Electrical.Transmission.Benchmarks.Utilities.lineFeederCables(
  redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cable_0,
  redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cable_i,
  redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cables);
  annotation (Documentation(revisions="<html>
<ul>
<li>
Sept 23 2014 by Marco Bonvini:
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This function extends
<a href=\"modelica://Buildings.Electrical.Transmission.Benchmarks.Utilities.lineFeederCables\">
Buildings.Electrical.Transmission.Benchmarks.Utilities.lineFeederCables()
</a>
and works with low voltage cables.
</p>
</html>"));
end lineFeederCablesLow;
