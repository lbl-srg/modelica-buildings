within Buildings.Media.PerfectGases.Examples;
model MoistAirDerivativeCheck
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.PerfectGases.MoistAir;

    Modelica.SIunits.SpecificEnthalpy hLiqSym "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hLiqCod "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteSym "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteCod "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirSym "Dry air enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirCod "Dry air enthalpy";
    constant Real conv(unit="K/s") = 1
    "Conversion factor to satisfy unit check";
initial equation
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
     hAirSym = hAirCod;
equation
    hLiqCod=Medium.enthalpyOfLiquid(conv*time);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

    hSteCod=Medium.enthalpyOfCondensingGas(conv*time);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");

    hAirCod=Medium.enthalpyOfDryAir(conv*time);
    der(hAirCod)=der(hAirSym);
    assert(abs(hAirCod-hAirSym) < 1E-2, "Model has an error");

   annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
experiment(StartTime=273.15, StopTime=373.15),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/PerfectGases/Examples/MoistAirDerivativeCheck.mos"
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
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAirDerivativeCheck;
