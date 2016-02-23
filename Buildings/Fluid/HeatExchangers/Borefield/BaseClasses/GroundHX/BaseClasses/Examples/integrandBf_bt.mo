within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model IntegrandBf_bt "Test for the integrand function"
  extends Modelica.Icons.Example;

  parameter Integer lim=5;
  Real int;

algorithm
  if time < 0.00785 then
    int := 0;
  else
    int := BaseClasses.integrandBf_bt(D=100, rBor=0.1, u=time*lim, nbBh=2, cooBh={{0,0},{1,1}});
  end if;
  annotation (experiment(
      StopTime=1,
      __Dymola_NumberOfIntervals=100,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput, Documentation(info="<html>
        <p>Test implementation of integrandBf_bt function.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end IntegrandBf_bt;
