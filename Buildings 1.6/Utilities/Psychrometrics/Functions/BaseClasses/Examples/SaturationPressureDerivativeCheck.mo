within Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples;
model SaturationPressureDerivativeCheck
  "Model to test correct implementation of derivative"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Temperature TMin = 190 "Temperature";
  parameter Modelica.SIunits.Temperature TMax = 373.16 "Temperature";
  Modelica.SIunits.Temperature T "Temperature";
  Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";
  Modelica.SIunits.AbsolutePressure pSatDer "Saturation pressure";
  constant Real conv(unit="1/s") = 1 "Conversion factor";
equation
  T = TMin + conv*time * (TMax-TMin);
initial equation
     pSat=pSatDer;
equation
    pSat=Buildings.Utilities.Psychrometrics.Functions.saturationPressure(T);
    der(pSat)=der(pSatDer);
    assert(abs(pSat-pSatDer) < 1E-2, "Model has an error");
   annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/BaseClasses/Examples/SaturationPressureDerivativeCheck.mos"
        "Simulate and plot"),
      experiment(
        StartTime=0,
        StopTime=1),
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
First implementation.
</li>
</ul>
</html>"));
end SaturationPressureDerivativeCheck;
