within Buildings.Media.Examples;
model AirDerivativeCheck "Model that tests the derivative implementation"
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.Air;

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
    constant Real conv(unit="K/s") = 1
    "Conversion factor to satisfy unit check";
initial equation
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
     hAirSym = hAirCod;
     cpSym   = cpCod;
     cvSym   = cvCod;
equation
    hLiqCod=Medium.enthalpyOfLiquid(conv*time);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

    hSteCod=Medium.enthalpyOfCondensingGas(conv*time);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");

    hAirCod=Medium.enthalpyOfNonCondensingGas(conv*time);
    der(hAirCod)=der(hAirSym);
    assert(abs(hAirCod-hAirSym) < 1E-2, "Model has an error");

    cpCod=Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
         p=1e5,
         T=conv*time,
         X={0.1}));
    der(cpCod)=der(cpSym);
    assert(abs(cpCod-cpSym) < 1E-2, "Model has an error");

     cvCod=Medium.specificHeatCapacityCv(
      Medium.setState_pTX(
         p=1e5,
         T=conv*time,
         X={0.1}));
    der(cvCod)=der(cvSym);
    assert(abs(cvCod-cvSym) < 1E-2, "Model has an error");

   annotation(experiment(StartTime=273.15, StopTime=373.15),
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
