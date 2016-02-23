within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation;
function transientFrac
  "Calculates the transient resistance for each cell of the aggregation matrix"
  extends Interface.partialAggFunction;

  input Data.Records.General gen "General parameter of the borefield";
  input Data.Records.Soil soi "Soil charachteristics";
  input Modelica.SIunits.Temperature[:] TResSho
    "Vector containing the short term step-reponse wall temperature in function of the time";

  input Integer[q_max,p_max] nuMat "Number of pulse at the end of each cell";

  input Modelica.SIunits.Temperature TWallSteSta
    "Steady state temperature of the wall";

  output Real[q_max,p_max] kappaMat "Transient resistance for each cell";

protected
  Integer q_pre "Level number of the previous aggregation cell";
  Integer p_pre "Cell number of the previous aggregation cell";

algorithm
  for q in 1:q_max loop
    for p in 1:p_max loop
      if q == 1 and p == 1 then
        kappaMat[q, p] :=(GroundHX.correctedBoreFieldWallTemperature(
          t_d=nuMat[q, p],
          gen=gen,
          soi=soi,
          TResSho=TResSho) - gen.T_start)/TWallSteSta;

      else
        (q_pre,p_pre) := BaseClasses.previousCellIndex(
          q_max,
          p_max,
          q,
          p);

        kappaMat[q, p] :=(GroundHX.correctedBoreFieldWallTemperature(
          t_d=nuMat[q, p],
          gen=gen,
          soi=soi,
          TResSho=TResSho) - GroundHX.correctedBoreFieldWallTemperature(
          t_d=nuMat[q_pre, p_pre],
          gen=gen,
          soi=soi,
          TResSho=TResSho))/TWallSteSta;
      end if;
    end for;
  end for;

  annotation (Documentation(info="<html>
        <p>Calculates the transient resistance for each cell of the aggregation matrix.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end transientFrac;
