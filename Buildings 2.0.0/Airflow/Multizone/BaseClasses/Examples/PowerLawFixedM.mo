within Buildings.Airflow.Multizone.BaseClasses.Examples;
model PowerLawFixedM "Test model for power law function"
  extends Modelica.Icons.Example;
  parameter Real k = 2/10^m "Flow coefficient, k = V_flow/ dp^m";

  constant Real m(min=0.5, max=1) = 0.5
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Modelica.SIunits.Pressure dp_turbulent(min=0)=5
    "Pressure difference where regularization starts";

  Modelica.SIunits.Pressure dp "Pressure difference";
  Modelica.SIunits.VolumeFlowRate V_flow
    "Volume flow rate computed with model powerLaw";
  Modelica.SIunits.VolumeFlowRate VFixed_flow
    "Volume flow rate computed with model powerLawFixed";

  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  constant Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

equation
  dp = 10*(-1+2*time);
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLaw(dp=dp, k=k, m=m, dp_turbulent=dp_turbulent);
  VFixed_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    k=k,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);
  assert(abs(V_flow-VFixed_flow) < 1E-10, "Error: The two implementations of the power law model need to give identical results");
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/PowerLawFixedM.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This examples demonstrates the
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a>
and
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>
functions.
They need to return the same function value.
This is verified by an <code>assert</code> statement.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerLawFixedM;
