model MoistAirDerivativeCheck 
  
   annotation(Diagram, Commands(file="MoistAirDerivativeCheck.mos" "run"));
    annotation (
      Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",   revisions="<html>
<ul>
<li>
May 12, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
   package Medium = Buildings.Fluids.Media.PerfectGases.MoistAir;
  
    Real hLiqSym;
    Real hLiqCod;
    Real hSteSym;
    Real hSteCod;
    Real hAirSym;
    Real hAirCod;
  
initial equation 
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
     hAirSym = hAirCod;
equation 
    hLiqCod=Medium.enthalpyOfLiquid(time);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");
  
    hSteCod=Medium.enthalpyOfCondensingGas(time);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");
  
    hAirCod=Medium.enthalpyOfDryAir(time);
    der(hAirCod)=der(hAirSym);
    assert(abs(hAirCod-hAirSym) < 1E-2, "Model has an error");
  
end MoistAirDerivativeCheck;
