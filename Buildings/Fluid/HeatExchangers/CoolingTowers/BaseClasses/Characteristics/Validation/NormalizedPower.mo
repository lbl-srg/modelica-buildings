within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.Validation;
model NormalizedPower "Validation model for the normalized power calculation"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan fanRelPow(
       r_V = {0, 0.1,   0.3,   0.6,   1},
       r_P = {0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan data";
  final parameter Real fanRelPowDer[size(fanRelPow.r_V,1)](each fixed=false)
    "Coefficients for fan relative power consumption as a function of control signal";

  Real y "Control signal";
  Modelica.Units.SI.Efficiency r_P(max=1) "Normalized power consumption";

initial equation
  // Derivatives for spline that interpolates the fan relative power
  fanRelPowDer = Buildings.Utilities.Math.Functions.splineDerivatives(
            x=fanRelPow.r_V,
            y=fanRelPow.r_P,
            ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=fanRelPow.r_P,
                                                                              strict=false));
equation
  y = time;
  r_P = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.normalizedPower(
    per=fanRelPow,
    r_V=y,
    d=fanRelPowDer);

  annotation (
experiment(StartTime=0, Tolerance=1e-06, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/BaseClasses/Characteristics/Validation/NormalizedPower.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the computation of the normalized power
for a varying fan control signal.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2019, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1691\">
issue 1691</a>.
</li>
</ul>
</html>"));
end NormalizedPower;
