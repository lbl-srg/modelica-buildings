within Buildings.Media.Examples;
model AirDerivativeCheck "Model that tests the derivative implementation"
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.Air;
    Modelica.SIunits.Temperature T "Temperature";
    Modelica.SIunits.MassFraction X[1] "Water vapor mass fraction";

    Modelica.SIunits.SpecificEnthalpy hLiqSym "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hLiqCod "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteSym "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteCod "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirSym "Dry air enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirCod "Dry air enthalpy";
    Modelica.SIunits.SpecificHeatCapacity cpSym "Specific heat capacity";
    Modelica.SIunits.SpecificHeatCapacity cpCod "Specific heat capacity";
    Modelica.SIunits.SpecificHeatCapacity cvSym "Specific heat capacity";
    Modelica.SIunits.SpecificHeatCapacity cvCod "Specific heat capacity";
    constant Real convT(unit="K/s3") = 270
    "Conversion factor to satisfy unit check";
    constant Real convX(unit="1/s3") = 0.01
    "Conversion factor to satisfy unit check";
initial equation
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
     hAirSym = hAirCod;
     cpSym   = cpCod;
     cvSym   = cvCod;
equation
    T = 273.15+convT*time^3;
    X = {0.001}+convX*time^3*{1};
    hLiqCod=Medium.enthalpyOfLiquid(T);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

    hSteCod=Medium.enthalpyOfCondensingGas(T);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");

    hAirCod=Medium.enthalpyOfNonCondensingGas(T);
    der(hAirCod)=der(hAirSym);
    assert(abs(hAirCod-hAirSym) < 1E-2, "Model has an error");

    cpCod=Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
         p=1e5,
         T=T,
         X=X));
    der(cpCod)=der(cpSym);
    assert(abs(cpCod-cpSym) < 1E-2, "Model has an error");

     cvCod=Medium.specificHeatCapacityCv(
      Medium.setState_pTX(
         p=1e5,
         T=T,
         X=X));
    der(cvCod)=der(cvSym);
    assert(abs(cvCod-cvSym) < 1E-2, "Model has an error");

   annotation(experiment(StartTime=0, StopTime=1, Tolerance=1E-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/AirDerivativeCheck.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",   revisions="<html>
<ul>
<li>
August 17, 2015, by Michael Wetter:<br/>
Changed regression test to have slope different from one.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
November 20, 2013, by Michael Wetter:<br/>
Removed check of <code>enthalpyOfDryAir</code> as this function
is protected and should therefore not be accessed from outside the class.
</li>
<li>
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirDerivativeCheck;
