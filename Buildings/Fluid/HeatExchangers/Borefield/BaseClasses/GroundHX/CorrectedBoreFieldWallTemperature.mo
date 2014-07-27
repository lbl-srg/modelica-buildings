within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX;
function CorrectedBoreFieldWallTemperature "Return the corrected average borehole wall temperature of the whole borefield in function of the discrete time step t_d.
  The correction is from t=0 till t_d = tBre. Input TResSho gives the vector with the correct temperatures for this time period"
  extends BaseClasses.partialBoreFieldTemperature;
  import SI = Modelica.SIunits;

  input Real[:] TResSho
    "Vector containing the short term  borehole wall step-reponse temperature in function of the time";

protected
  SI.TemperatureDifference deltaTwallCorBre;

algorithm
  if t_d < gen.tBre_d then
    T := TResSho[t_d + 1];
    deltaTwallCorBre := 0;
  else
    deltaTwallCorBre := TResSho[gen.tBre_d] -
      BoreFieldWallTemperature(
      t_d=gen.tBre_d,
      gen=gen,
      soi=soi);
    T := BoreFieldWallTemperature(
      t_d=t_d,
      gen=gen,
      soi=soi) + deltaTwallCorBre;
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
end CorrectedBoreFieldWallTemperature;
