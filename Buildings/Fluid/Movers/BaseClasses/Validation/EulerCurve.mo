within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerCurve "Displays the curve of the Euler number's correlation"
  extends Modelica.Icons.Example;
  Real x "log10(Eu/Eu_peak)";
  Real etaApp "eta/eta_peak from polynomial approximation";
  Real etaOri "eta/eta_peak from original correlation";

function correlation
  input Real x "log10(Eu/Eu_peak)";
  output Real y "eta/eta_peak";
  protected
  constant Real a=-2.732094, b=2.273014, c=0.196344, d=5.267518;
  Real Z1, Z2, Z3;
algorithm
  Z1:=(x-a)/b;
  Z2:=((exp(c*x)*d*x)-a)/b;
  Z3:=-a/b;
  y:=(exp(-0.5*Z1^2)*(1+sign(Z2)*Modelica.Math.Special.erf(u=abs(Z2)/sqrt(2))))
    /(exp(-0.5*Z3^2)*(1+Modelica.Math.Special.erf(u=Z3/sqrt(2))));
end correlation;

initial equation
  x = -4;
equation
  der(x)=1;
  etaApp = Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x);
  etaOri = correlation(x);

  annotation (experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EulerCurve.mos"
 "Simulate and plot"),
 Documentation(
info="<html>
<p>
This validation model plots and compares out the original correlation function
of Euler number and its polynomial approximation.
</p>
<p>
See details of this function in the documentation of
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 13, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end EulerCurve;
