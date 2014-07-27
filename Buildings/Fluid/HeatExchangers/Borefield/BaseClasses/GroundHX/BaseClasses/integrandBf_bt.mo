within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function integrandBf_bt
  "Integrand for the mean borehole wall temperature of a borefield. u = integration variable,  y = integrand "
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
  import SI = Modelica.SIunits;

  input SI.Distance D "depth of boreholes";
  input SI.Radius rBor "bh radius";
  input Integer nbBh "number of boreholes";
  input Real cooBh[nbBh,2] "coordinates of center of boreholes";

protected
  Real r_ij;
  Real supCoe "superposition coefficient of integrand for wall temperature";

algorithm
  supCoe := 0;
  for i in 1:nbBh loop
    for j in 1:nbBh loop
      if i == j then
        r_ij := rBor;
      else
        r_ij := sqrt((cooBh[i, 1] - cooBh[j, 1])^2 + (cooBh[i, 2] - cooBh[j, 2])
          ^2);
      end if;

      supCoe := supCoe + exp(-r_ij^2*u^2);
    end for;
  end for;
  supCoe := supCoe/nbBh;

  y := supCoe*(4*ierf(D*u) - ierf(2*D*u))/(D*u^2);

  annotation (Documentation(info="<html>
  <p>FIXME </p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end integrandBf_bt;
