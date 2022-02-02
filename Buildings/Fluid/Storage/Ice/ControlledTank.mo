within Buildings.Fluid.Storage.Ice;
model ControlledTank
  "Ice tank with performance based on performance curves and built-in control for outlet temperature"
  extends Buildings.Fluid.Storage.Ice.Tank(limQ_flow(y=if tanHeaTra.canMelt.y
           then m_flow*cp*(max(per.TFre, TSet) - TIn.y) elseif tanHeaTra.canFreeze.y
           then m_flow*cp*(max(TIn.y, min(per.TFre, TSet)) - TIn.y) else m_flow
          *cp*(per.TFre - TIn.y)));

  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", final displayUnit=
        "degC") "Outlet temperature setpoint during discharging"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

annotation (
defaultComponentModel="iceTan",
Documentation(info="<html>
<p>
This model implements an ice tank model with built-in idealized control
that tracks the set point <code>TSet</code> for the temperature of the working fluid
that leaves the tank.
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
</p>
<p>
Note that the setpoint is also tracked during charging mode.
If the full flow rate should go through the tank during charging,
which is generally desired, then set <code>TSet</code> to a
high temperature, such as <i>20</i>&deg;C.
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
