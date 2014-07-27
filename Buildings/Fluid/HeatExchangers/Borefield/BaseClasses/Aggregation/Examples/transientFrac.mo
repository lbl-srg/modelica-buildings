within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.Examples;
function transientFrac "ATTENTION: don't translate this function! otherwise it doesn't work anymore, \\
  because some of the code is not possible to statically translate into c-code!\\
  ATTENTION: first translate transientFrac!
  ---------------------------------------------------------------------
  Borefield.Data.GenericStepParam.tS3600_tmind1_qSte30(),
  Borefield.Data.BorefieldGeometricData.Line1_rB010_h100(),
  Borefield.Data.SoilData.Sandstone(),
  Borefield.Data.ShortTermResponse.SandstoneH100qSte30()
  ---------------------------------------------------------------------
  "
  input Integer n_max=201;
  input Integer p_max=5;
  input Real TWallSteSta = 280;
  input Real[:] TResSho;

  output Integer q_max=BaseClasses.nbOfLevelAgg(
      n_max, p_max);
  output Integer v_max;
  output Integer[q_max] rArr;
  output Integer nbLumpedCells;
  output Integer[q_max,p_max] nuMat;
  output Real[q_max,p_max] kappaMat;

algorithm
  (,v_max) := BaseClasses.nbOfLevelAgg(n_max, p_max);
  rArr := BaseClasses.cellWidth(q_max, p_max);

  nuMat := BaseClasses.nbPulseAtEndEachLevel(
    q_max,
    p_max,
    rArr);

  kappaMat :=Aggregation.transientFrac(
    q_max=q_max,
    p_max=p_max,
    gen=Data.GeneralData.c8x1_h110_b5_d3600_T283(),
    soi=Data.SoilData.SandStone(),
    TResSho=TResSho,
    nuMat=nuMat,
    TWallSteSta=TWallSteSta);
    annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end transientFrac;
