within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX;
function correctedBoreFieldWallTemperature "Return the corrected average borehole wall temperature of the whole borefield in function of the discrete time step t_d.
  The correction is from t=0 till t_d = tBre. Input TResSho gives the vector with the correct temperatures for this time period"
  extends BaseClasses.partialBoreFieldTemperature;

  input Modelica.SIunits.Temperature[:] TResSho
    "Vector containing the short term  borehole wall step-reponse temperature in function of the time";

protected
  Modelica.SIunits.TemperatureDifference deltaTWallCorBre
    "Wall temperature of the borefield at the switching time between the short and long-term model";

algorithm
  if t_d < gen.tBre_d then
    T := TResSho[t_d + 1];
    deltaTWallCorBre := 0;
  else
    deltaTWallCorBre := TResSho[gen.tBre_d] -
      boreFieldWallTemperature(
      t_d=gen.tBre_d,
      gen=gen,
      soi=soi);
    T := boreFieldWallTemperature(
      t_d=t_d,
      gen=gen,
      soi=soi) + deltaTWallCorBre;
  end if;
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
end correctedBoreFieldWallTemperature;
