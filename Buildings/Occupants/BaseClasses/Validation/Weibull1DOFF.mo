within Buildings.Occupants.BaseClasses.Validation;
model Weibull1DOFF "Test model for 1D binary variable generation function"
  extends Modelica.Icons.Example;

  parameter Integer seed = 5 "Seed for the random number generator";
  parameter Real u=1.0 "Parameter defining the Weibull distribution threshold";
  parameter Real L=0.5 "Parameter defining the Weibull distribution normalization factor";
  parameter Real k=1.0 "Parameter defining the Weibull distribution shape factor";
  parameter Real dt=0.2 "Time step length";

  Real x "Time-varying real number as input";
  output Real y "Output";
protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  Real curSeed "Current value for seed as a real-valued variable";

initial equation
  y = 0;
  t0 = time;
  curSeed = t0*seed;

equation
  x = time;
  when sample(0, 0.1) then
    curSeed = seed*1E6*time;
    if Buildings.Occupants.BaseClasses.weibull1DOFF(x,u,L,k,dt,globalSeed=integer(curSeed)) then
      y = 1;
    else
      y = 0;
    end if;
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/Weibull1DOFF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.BaseClasses.weibull1DOFF\">
Buildings.Occupants.BaseClasses.weibull1DOFF</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Weibull1DOFF;
