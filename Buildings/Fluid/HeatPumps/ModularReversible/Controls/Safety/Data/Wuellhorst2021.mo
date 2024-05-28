within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data;
record Wuellhorst2021
  "Apply the default values according to the conference publication by Wuellhorst et al. (2021)"
  extends Generic(
    tabLowCoo=[263.15,283.15; 333.15,283.15],
    dTHysAntFre=2,
    onOffMea_start=false,
    ySetRed=0.3,
    r_mConMinPer_flow=0.1,
    r_mEvaMinPer_flow=0.1,
    use_minFlowCtr=true,
    use_maxCycRat=true,
    use_minOffTime=true,
    use_minOnTime=true,
    TAntFre=273.15,
    use_antFre=false,
    dTHysOpeEnv=5,
    use_opeEnv=true,
    tabUppHea=[233.15,343.15; 313.15,343.15],
    maxCycRat=3,
    minOffTime=1200,
    minOnTime=600);
  annotation (Documentation(info="<html>
<p>
  Default values according to the conference publication
  by Wuellhorst et. al. <a href=\"https://doi.org/10.3384/ecp21181561\">
  https://doi.org/10.3384/ecp21181561</a>.
</p>
<p>
  These values are conservative estimates based on multiple datasheets.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>
"));
end Wuellhorst2021;
