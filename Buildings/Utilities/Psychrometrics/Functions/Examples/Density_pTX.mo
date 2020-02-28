within Buildings.Utilities.Psychrometrics.Functions.Examples;
model Density_pTX "Model to test density_pTX"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Pressure p=101325 "Pressure of the medium";
  Modelica.Units.SI.Temperature T "Temperature";
  Modelica.Units.SI.MassFraction X_w "Mass fraction";
  Modelica.Units.SI.Density d "Mass density";
  constant Real convT(unit="1/s") = 0.999 "Conversion factor";
  constant Real convX(unit="1/s") = 0.02 "Conversion factor";
equation
  if time < 0.5 then
    X_w = convX*time;
    T = 293.15;
  else
    X_w = 0.5*convX;
    T = 293.15+convT*(time-0.5)*10;
  end if;
  d = Buildings.Utilities.Psychrometrics.Functions.density_pTX(p=p, T=T, X_w=X_w);
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/Density_pTX.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Model that tests the implementation of
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.density_pTX\">
Buildings.Utilities.Psychrometrics.Functions.density_pTX</a>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
February 24, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Density_pTX;
