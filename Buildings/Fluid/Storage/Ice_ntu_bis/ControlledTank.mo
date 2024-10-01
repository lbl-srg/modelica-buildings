within Buildings.Fluid.Storage.Ice_ntu_bis;
model ControlledTank
  "Ice tank with performance based on performance curves and built-in control for outlet temperature"
  extends Buildings.Fluid.Storage.Ice_ntu_bis.Tank;

  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    final displayUnit="degC")
    "Outlet temperature setpoint during discharging"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

annotation (
defaultComponentModel="iceTan",
Documentation(info="<html>
<p>
This model implements an ice tank model with built-in idealized control
that tracks the set point <code>TSet</code> for the temperature of the working fluid
that leaves the tank, as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"Schematics of the controlled tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Ice/ControlledTank.png\"/>
</p>
<p>
The model is identical to
<a href=\"modelica://Buildings.Fluid.Storage.Ice.Tank\">Buildings.Fluid.Storage.Ice.Tank</a>,
except that it takes as an input the set point for the temperature of the
leaving working fluid.
This temperature is maintained if the flow rate and temperatures allow
sufficient heat flow rate between the tank and the working fluid.
</p>
<p>
The built-in control is an idealization of a tank that has a controller that
bypasses some of the working fluid in order to meet the set point for the temperature
of the leaving working fluid.
The fluid from <code>port_a</code> to <code>port_b</code> has by default
a first order response. If the tank has sufficient capacity for the given
inlet temperature and flow rate, then the idealized control has no
steady-state error. During transients, the set point may not be met
exactly due to the first order response that approximates the dynamics
of the heat exchanger.
</p>
<p>
Note that the setpoint is also tracked during charging mode.
If the full flow rate should go through the tank during charging,
which is generally desired, then set <code>TSet</code> to a
high temperature, such as <i>20</i>&deg;C.
</p>
<h4>Usage</h4>
<p>
This model requires the fluid to flow from <code>port_a</code> to <code>port_b</code>.
Otherwise, the simulation stops with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
Refactored model to new architecture.
Changed model to allow idealized control.
Avoided SOC to be outside <i>[0, 1]</i>.
</li>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
    Text( extent={{-168,130},{-72,84}},
          textColor={0,0,88},
          textString=DynamicSelect("TSet", String(TSet-273.15, format=".1f")))}));
end ControlledTank;
