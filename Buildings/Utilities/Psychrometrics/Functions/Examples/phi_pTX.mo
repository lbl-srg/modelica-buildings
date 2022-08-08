within Buildings.Utilities.Psychrometrics.Functions.Examples;
model phi_pTX "Model to test phi_pTX"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Pressure p=101325 "Pressure of the medium";
  Modelica.Units.SI.Temperature T "Temperature";
  Modelica.Units.SI.MassFraction X_w "Mass fraction";
  Real phi "Relative humidity";
  Real X_inv "Inverse computation of mass fraction";
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
  phi = Buildings.Utilities.Psychrometrics.Functions.phi_pTX(p=p, T=T, X_w=X_w);
  X_inv=Buildings.Utilities.Psychrometrics.Functions.X_pTphi(p=p, T=T, phi=phi);
  assert(abs(X_inv-X_w) < 1e-5,
    "Inconsistency in the inverse implementation of phi_pTX: X_pTphi");
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/phi_pTX.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
April 4, 2019 by Filip Jorissen:<br/>
Added inverse implementation check
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1110\">#1110</a>.
</li>
</ul>
</html>"));
end phi_pTX;
