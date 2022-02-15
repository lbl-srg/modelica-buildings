within Buildings.Airflow.Multizone.BaseClasses.Examples;
model PowerLaw "Test model for power law function"
  extends Modelica.Icons.Example;
  parameter Real C = 2/10^m "Flow coefficient, k = V_flow/ dp^m";

  parameter Real m(min=0.5, max=1) = 0.5
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(min=0) = 5
    "Pressure difference where regularization starts";

  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.VolumeFlowRate V_flow "Volume flow rate";
equation
  dp = 10*(-1+2*time);
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLaw(
    dp=dp,
    C=C,
    m=m,
    dp_turbulent=dp_turbulent);
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/PowerLaw.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This examples demonstrates the
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a>
function.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerLaw;
