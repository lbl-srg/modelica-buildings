within Buildings.Media.Specialized.Air.Examples;
model PerfectGasDerivativeCheck
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.Specialized.Air.PerfectGas;

  Modelica.Units.SI.Temperature T "Temperature";
  Modelica.Units.SI.SpecificEnthalpy hLiqSym "Liquid phase enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hLiqCod "Liquid phase enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hSteSym "Water vapor enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hSteCod "Water vapor enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hAirSym "Dry air enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hAirCod "Dry air enthalpy";
    constant Real convT(unit="K/s3") = 270
    "Conversion factor to satisfy unit check";
initial equation
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
     hAirSym = hAirCod;
equation
    T = 273.15+convT*time^3;

    hLiqCod=Medium.enthalpyOfLiquid(T);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

    hSteCod=Medium.enthalpyOfCondensingGas(T);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");

    hAirCod=Medium.enthalpyOfDryAir(T);
    der(hAirCod)=der(hAirSym);
    assert(abs(hAirCod-hAirSym) < 1E-2, "Model has an error");

   annotation(experiment(
                 StartTime=0, StopTime=1,
                 Tolerance=1e-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Specialized/Air/Examples/PerfectGasDerivativeCheck.mos"
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
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerfectGasDerivativeCheck;
