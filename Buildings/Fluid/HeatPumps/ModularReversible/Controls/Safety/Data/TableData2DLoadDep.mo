within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data;
record TableData2DLoadDep "Default safety settings for load-dependent data-based models"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
    use_maxCycRat=false,
    dTHysAntFre=2,
    onOffMea_start=false,
    ySetRed=0.3,
    r_mConMinPer_flow=0.1,
    r_mEvaMinPer_flow=0.1,
    use_minFlowCtr=true,
    use_minOffTime=true,
    use_minOnTime=true,
    TAntFre=273.15,
    use_antFre=false,
    dTHysOpeEnv=5,
    use_opeEnv=true,
    maxCycRat=3,
    minOffTime=1200,
    minOnTime=600);
  annotation (
    Documentation(
info="<html>
<p>
This record provides default parameters for the internal safeties
implemented in 
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>
and
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep</a>.
Notably, the maximum cycling rate safety is disabled to align with
the continuous operation assumption in these models.
The remaining default safety settings are derived from
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021</a>
and represent conservative estimates based on multiple manufacturer datasheets.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDep;
