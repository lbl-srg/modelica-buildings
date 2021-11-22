within Buildings.Fluid.Movers.Validation;
model PowerEuler
  "Power calculation comparison among three mover types, using Euler number computation for m_flow and dp"
  extends PowerSimplified(
    pump_dp(per=perPea),
    pump_m_flow(per=perPea));

  parameter Data.Generic perPea(
    powMet=Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.EulerNumber,
    peak=Buildings.Fluid.Movers.BaseClasses.Euler.findPeak(
      pressure=per.pressure,
      power=per.power))
    "Peak condition";

  annotation (
    experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PowerEuler.mos"
        "Simulate and plot"),
        Documentation(
info="<html>
<p>
[Documentation pending.]
</p>
</html>",
revisions="<html>
<ul>
<li>
[Documentation pending.]
</li>
</ul>
</html>"));
end PowerEuler;
