within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX;
function BoreFieldWallTemperature
  "Return the borefield mean wall temperature for the discrete time t_d"
  extends BaseClasses.partialBoreFieldTemperature;

protected
  Real lb "Lower boundary of integral";
  Real ub = 100
    "Upper boundary of integral. Theoritical value = infty. From some tests, the value 100 seems sufficient.";
  Real res "Integral value";
  SI.TemperatureDifference deltaT "Temperature rise at boreholes wall";
algorithm
  lb := 1/sqrt(4*soi.alp*t_d*gen.tStep);

  res := Modelica.Math.Nonlinear.quadratureLobatto(
    function BaseClasses.integrandBf_bt(
      D=gen.hBor,
      rBor=gen.rBor,
      nbBh=gen.nbBh,
      cooBh=gen.cooBh),
    lb,
    ub);

  deltaT := gen.q_ste/(4*Modelica.Constants.pi*soi.k)*res;
  T := gen.T_start + deltaT;

  annotation (Documentation(info="<html>
  <p>Return the corrected average borehole wall temperature of the whole borefield in function of the discrete time step t_d.
  The correction is from t=0 till t_d = tBre. Input TResSho gives the vector with the correct temperatures for this time period.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end BoreFieldWallTemperature;
