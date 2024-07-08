within Buildings.Fluid.Movers.Validation;
model PowerExact
  "Power calculation comparison among three mover types, using exact power computation for m_flow and dp"
  extends Buildings.Fluid.Movers.Validation.PowerSimplified(
    pump_dp(per=per),
    pump_m_flow(per=per));
  annotation (
    experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PowerExact.mos"
        "Simulate and plot"),
        Documentation(
info="<html>
<p>
Note that the results of this validation model is no longer relevant
to the current implementation and it will be obsoleted in a future release.
For details see
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">
IBPSA issue #1880</a>.
</p>
<p>
This example is identical to
<a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerSimplified\">
Buildings.Fluid.Movers.Validation.PowerSimplified</a>, except that the
performance data for the flow controlled pumps
<code>pump_dp</code> and <code>pump_m_flow</code> contain
the pressure curves and efficiency curves.
The plot below shows that this leads to a computation of the power consumption
that is identical to the one from the speed controlled pump <code>pump_y</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Validation/PowerExact.png\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
October 15, 2021, by Hongxiang Fu:<br/>
Fixed the image in the documentation which was cut off
at the <i>y</i>-axis. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1533\">IBPSA, #1533</a>.
</li>
<li>
March 2, 2016, by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
</ul>
</html>"));
end PowerExact;
