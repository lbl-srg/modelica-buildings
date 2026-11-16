within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.Validation;
model ExtractStagingMatrix
  extends Modelica.Icons.Example;
  parameter Integer nHp = 2
    "Number of HP (excluding polyvalent HP)"
    annotation(Evaluate=true);
  parameter Integer nPhp = 2
    "Number of polyvalent HP"
    annotation(Evaluate=true);
  final parameter Integer nSta = nHp + nPhp
    "Number of cooling or heating stages (excluding stage 0)";
  parameter Real capHeaHp_nominal = 1E5
    "Design heating capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capCooHp_nominal = (1 - 1 /
    Buildings.Templates.Data.Defaults.COPHpAwHea) * capHeaHp_nominal
    "Design cooling capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capHeaPhp_nominal = 1.3E5
    "Design heating capacity - Each polyvalent heat pump";
  parameter Real capCooPhp_nominal = (1 - 1 /
    Buildings.Templates.Data.Defaults.COPHpAwHea) * capHeaPhp_nominal
    "Design cooling capacity - Each polyvalent heat pump";
  parameter Real capHeaShcPhp_nominal =
    Buildings.Templates.Data.Defaults.COPHpWwHea /
    Buildings.Templates.Data.Defaults.COPHpAwHea * capHeaPhp_nominal
    "Design heating capacity in SHC mode - Each polyvalent heat pump";
  parameter Real capCooShcPhp_nominal = (1 - 1 /
    Buildings.Templates.Data.Defaults.COPHpWwHea) * capHeaShcPhp_nominal
    "Design cooling capacity in SHC mode - Each polyvalent heat pump";
  parameter Real capCooSta_nominal[nSta + 1, nSta + 1] = staPhp.nHpCoo *
    capCooHp_nominal .+ staPhp.nPhpCoo * capCooPhp_nominal .+ staPhp.nPhpShc *
    capCooShcPhp_nominal
    "Cooling capacity at each stage";
  parameter Real capHeaSta_nominal[nSta + 1, nSta + 1] = staPhp.nHpHea *
    capHeaHp_nominal .+ staPhp.nPhpHea * capHeaPhp_nominal .+ staPhp.nPhpShc *
    capHeaShcPhp_nominal
    "Heating capacity at each stage";
  // Columns are for equipment tags, duplicating polyvalent units for cooling-only and SHC mode indexing
  // NOT CDL compliant because 3D array!
  parameter Real staCoo[nSta + 1, nSta, nHp + 2 * nPhp] = {cat(
    1,
    fill(staPhp.nHpCoo[iHea, iCoo + 1] / max(nHp, 1), nHp),
    fill(staPhp.nPhpCoo[iHea, iCoo + 1] / max(nPhp, 1), nPhp),
    fill(
      staPhp.nPhpShc[iHea, iCoo + 1] / max(nPhp, 1),
      nPhp)) for iCoo in 1:nSta, iHea in 1:nSta + 1}
    "Cooling staging matrix – Varies with heating stage";
  parameter Real staHea[nSta + 1, nSta, nHp + 2 * nPhp] = {cat(
    1,
    fill(staPhp.nHpHea[iHea + 1, iCoo] / max(nHp, 1), nHp),
    fill(staPhp.nPhpHea[iHea + 1, iCoo] / max(nPhp, 1), nPhp),
    fill(
      staPhp.nPhpShc[iHea + 1, iCoo] / max(nPhp, 1),
      nPhp)) for iHea in 1:nSta, iCoo in 1:nSta + 1}
    "Heating staging matrix – Varies with cooling stage";
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters staPhp(
    final nHp=nHp,
    final nPhp=nPhp)
    "Staging parameters"
    annotation(Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable iHea(
    table={{i * iHea.timeScale, i} for i in 0:nSta},
    timeScale=1 / (nSta + 1),
    period=1)
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix extSta(
    final sta=staPhp.staCoo)
    "Extract cooling staging matrix at given heating stage"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix extStaTra(
    final sta=staPhp.staCoo,
    is_transpose=true)
    "Extract transpose of cooling staging matrix at given heating stage"
    annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
initial algorithm
  for iOut in 1:nSta + 1, iInn in 1:nSta, iEqu in 1:nHp + 2 * nPhp loop
    if staPhp.is_feasible[iOut, iInn + 1] then
      assert(
        abs(
          staPhp.staCoo[(iOut - 1) * nSta + iInn, iEqu] -
            staCoo[iOut, iInn, iEqu]) < Modelica.Constants.small,
        "Mismatch");
      assert(
        abs(
          staPhp.staHea[(iOut - 1) * nSta + iInn, iEqu] -
            staHea[iOut, iInn, iEqu]) < Modelica.Constants.small,
        "Mismatch");
      assert(
        abs(staHea[iOut, iInn, iEqu] - staCoo[iOut, iInn, iEqu]) <
          Modelica.Constants.small,
        "Mismatch");
    end if;
  end for;
  for iCoo in 1:nSta, iEqu in 1:nHp + 2 * nPhp loop
    assert(
      abs(staCoo[iHea.y[1] + 1, iCoo, iEqu] - extSta.y[iCoo, iEqu]) <
        Modelica.Constants.small,
      "Mismatch");
    assert(
      abs(staCoo[iHea.y[1] + 1, iCoo, iEqu] - extStaTra.y[iEqu, iCoo]) <
        Modelica.Constants.small,
      "Mismatch");
  end for;
equation
  connect(iHea.y[1], extSta.u)
    annotation(Line(points={{-58,0},{-12,0}},
      color={255,127,0}));
  connect(iHea.y[1], extStaTra.u)
    annotation(Line(points={{-58,0},{-20,0},{-20,-40},{-12,-40}},
      color={255,127,0}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/PolyvalentHeatPumps/Validation/ExtractStagingMatrix.mos"
    "Simulate and plot"),
  experiment(StopTime=1.0,
    Tolerance=1e-06),
  Documentation(
  info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters\">
    Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters</a>
  and
  <a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix\">
    Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix</a>
  in a configuration with two reversible heat pumps and two polyvalent heat
  pumps.
</p>
<p>
  The parameters <code>staHea</code> and <code>staCoo</code> independently
  reconstruct, from the equipment count matrices computed by
  <code>StagingParameters</code>, the per-mode staging matrices. At
  initialization, these matrices are compared against the ones internally
  computed by <code>StagingParameters</code> for every feasible combination of
  heating and cooling stage, and against each other, which validates the
  internal consistency of <code>StagingParameters</code>.
</p>
<p>
  The heating stage index is cycled through every stage over the course of the
  simulation, and is used to extract the cooling staging matrix and its
  transpose at the current heating stage. At initialization, i.e., at heating
  stage <i>0</i>, the extracted matrices are compared against the
  independently reconstructed reference <code>staCoo</code>, which validates
  <code>ExtractStagingMatrix</code> for both the direct and the transposed
  extraction.
</p>
</html>",
  revisions="<html>
<ul>
  <li>
    July 3, 2026, by Antoine Gautier:<br />
    Added documentation.
  </li>
</ul>
</html>"));
end ExtractStagingMatrix;
