within Buildings.Fluid.Storage.Ice;
model ControlledTank
  "Ice tank model with built-in control for water flow diversion"
  extends Buildings.Fluid.Storage.Ice.Tank(
      limQ_flow(y=if tanHeaTra.canMelt.y then m_flow*cp*(max(per.TFre, TOutSet) - TIn.y)
 elseif
       tanHeaTra.canFreeze.y then
        m_flow*cp*(max(TIn.y, min(per.TFre, TOutSet)) - TIn.y)
 else m_flow*cp*(per.TFre - TIn.y)));

  Modelica.Blocks.Interfaces.RealInput TOutSet(
    final unit = "K",
    final displayUnit="degC")
    "Outlet temperature setpoint during discharging"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

annotation (
defaultComponentModel="iceTan",
Documentation(info="<html>
<p>
xxx
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
</html>"));
end ControlledTank;
