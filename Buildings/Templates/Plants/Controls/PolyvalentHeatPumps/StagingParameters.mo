within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block StagingParameters
  parameter Integer nHp "Number of HP (excluding polyvalent HP)";
  parameter Integer nPhp "Number of polyvalent HP";
  final parameter Integer nSta = nHp + nPhp
    "Number of cooling or heating stages (excluding stage 0)";
  final parameter Integer staPhp[nSta + 1, nSta + 1] =
    {min(iHea, iCoo) for iCoo in 0:nSta, iHea in 0:nSta}
    "Minimum between cooling and heating stage";
  final parameter Integer staHeaRes[nSta + 1, nSta + 1] =
    {iHea - nPhpShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Residual heating stage count after SHC assignment";
  final parameter Integer staCooRes[nSta + 1, nSta + 1] =
    {iCoo - nPhpShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Residual cooling stage count after SHC assignment";
  final parameter Integer nHpAva[nSta + 1, nSta + 1] =
    {nHp - nHpHea[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of HP still available after heating assignment";
  final parameter Integer nPhpAva[nSta + 1, nSta + 1] =
    {nPhp - nPhpShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP still available after SHC assignment";
  final parameter Integer nHpHea[nSta + 1, nSta + 1] =
    {min(staHeaRes[iHea + 1, iCoo + 1], nHp) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of HP in heating mode";
  final parameter Integer nHpCoo[nSta + 1, nSta + 1] =
    {min(
      staCooRes[iHea + 1, iCoo + 1],
      nHpAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of HP in cooling mode";
  final parameter Integer nPhpHea[nSta + 1, nSta + 1] =
    {min(
      staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1],
      nPhpAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP in heating-only mode";
  final parameter Integer nPhpCoo[nSta + 1, nSta + 1] =
    {min(
      staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1],
      nPhpAva[iHea + 1, iCoo + 1] -
        nPhpHea[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP in cooling-only mode";
  final parameter Integer nPhpShc[nSta + 1, nSta + 1] =
    {min(staPhp[iHea + 1, iCoo + 1], nPhp) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP in SHC mode";
  final parameter Boolean is_feasible[nSta + 1, nSta + 1] =
    {(staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1] -
      nPhpHea[iHea + 1, iCoo + 1] == 0)
      and (staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1] -
        nPhpCoo[iHea + 1, iCoo + 1] == 0) for iCoo in 0:nSta, iHea in 0:nSta}
    "True if the stage combination is achievable";
  final parameter Real staCoo[(nSta + 1) * nSta, nHp + 2 * nPhp] =
    {(if not is_feasible[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2]
    then 0
    elseif iEqu <= nHp
    then nHpCoo[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(nHp, 1)
    elseif iEqu <= nHp + nPhp
    then nPhpCoo[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(nPhp, 1)
    else nPhpShc[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(
        nPhp,
        1)) for iEqu in 1:nHp + 2 * nPhp, r in 1:(nSta + 1) * nSta}
    "Cooling staging matrix – row-major over (0≤iHea outer, 1≤iCoo inner), 0 if infeasible";
  final parameter Real staHea[(nSta + 1) * nSta, nHp + 2 * nPhp] =
    {(if not is_feasible[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1]
    then 0
    elseif iEqu <= nHp
    then nHpHea[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(nHp, 1)
    elseif iEqu <= nHp + nPhp
    then nPhpHea[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(nPhp, 1)
    else nPhpShc[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(
        nPhp,
        1)) for iEqu in 1:nHp + 2 * nPhp, r in 1:(nSta + 1) * nSta}
    "Heating staging matrix – row-major over (0≤iCoo outer, 1≤iHea inner), 0 if infeasible";
annotation(defaultComponentName="staPhp",
  Documentation(
    info="<html>
<p>
  This block pre-computes all staging parameters for a plant with
  <i>n<sub>HP</sub></i> standard reversible heat pumps and
  <i>n<sub>PHP</sub></i>
  polyvalent heat pumps (capable of simultaneous heating and cooling, SHC).
</p>
<h5>Fundamental assumptions</h5>
<p>
  Within each equipment set (reversible HPs and polyvalent HPs), all units are
  assumed to be equally sized and are treated as lead/lag alternates. Adding
  one unit of either type therefore contributes one additional stage of
  capacity, so the maximum number of plant stages is
  <i>n<sub>Sta</sub> = n<sub>HP</sub> + n<sub>PHP</sub></i
  >. Heating and cooling stages are tracked independantly, each ranging over
  <i>{0, &hellip;, n<sub>Sta</sub>}</i>, since the same pool of units can
  serve either load.
</p>
<p>
  For each combination of active heating and cooling stages (<i
    >i<sub>Hea</sub></i
  >,&nbsp;<i>i<sub>Coo</sub></i
  >) with
  <i>i<sub>Hea</sub>, i<sub>Coo</sub> &isin; {0, &hellip;, n<sub>Sta</sub>}</i
  >, the block resolves how many units operate in each mode by applying the
  following assignment rules in order.
</p>
<h5>1. SHC assignment</h5>
<p>
  Polyvalent HPs are assigned to simultaneous heating and cooling first,
  saturating at the available count and at the smaller of the two stage
  indices (since each SHC unit satisfies one heating stage and one cooling
  stage simultaneously):
</p>
<p>
  <i
    >n<sup>SHC</sup><sub>PHP</sub> =
    min(min(i<sub>Hea</sub>,&nbsp;i<sub>Coo</sub>),&nbsp;n<sub>PHP</sub>)</i
  >
</p>
<p>The residual heating and cooling stages after SHC assignment are:</p>
<p>
  <i
    >i<sup>res</sup><sub>Hea</sub> = i<sub>Hea</sub> - n<sup>SHC</sup
    ><sub>PHP</sub></i
  >, &nbsp;&nbsp;
  <i
    >i<sup>res</sup><sub>Coo</sub> = i<sub>Coo</sub> - n<sup>SHC</sup
    ><sub>PHP</sub></i
  >
</p>
<h5>2. Heating assignment</h5>
<p>Standard HPs cover the residual heating stage first:</p>
<p>
  <i
    >n<sup>Hea</sup><sub>HP</sub> = min(i<sup>res</sup
    ><sub>Hea</sub>,&nbsp;n<sub>HP</sub>)</i
  >
</p>
<p>
  Any remaining residual heating stage is covered by polyvalent HPs operating
  in heating-only mode (drawn from those not already in SHC):
</p>
<p>
  <i
    >n<sup>Hea</sup><sub>PHP</sub> = min(i<sup>res</sup><sub>Hea</sub> - n<sup
      >Hea</sup
    ><sub>HP</sub>, &nbsp;n<sub>PHP</sub> - n<sup>SHC</sup><sub>PHP</sub>)</i
  >
</p>
<h5>3. Cooling assignment</h5>
<p>
  Standard HPs not used for heating are assigned to the residual cooling
  stage:
</p>
<p>
  <i
    >n<sup>Coo</sup><sub>HP</sub> = min(i<sup>res</sup><sub>Coo</sub>,
    &nbsp;n<sub>HP</sub> - n<sup>Hea</sup><sub>HP</sub>)</i
  >
</p>
<p>
  Remaining polyvalent HPs (neither in SHC nor heating-only) cover any unmet
  cooling stage:
</p>
<p>
  <i
    >n<sup>Coo</sup><sub>PHP</sub> = min(i<sup>res</sup><sub>Coo</sub> - n<sup
      >Coo</sup
    ><sub>HP</sub>, &nbsp;n<sub>PHP</sub> - n<sup>SHC</sup><sub>PHP</sub> -
    n<sup>Hea</sup><sub>PHP</sub>)</i
  >
</p>
<h5>Feasibility</h5>
<p>
  A stage combination is feasible if and only if both residual stages are
  fully covered by the assigned units:
</p>
<p>
  <i
    >i<sup>res</sup><sub>Hea</sub> = n<sup>Hea</sup><sub>HP</sub> + n<sup
      >Hea</sup
    ><sub>PHP</sub></i
  >
  &nbsp;&nbsp; and &nbsp;&nbsp;
  <i
    >i<sup>res</sup><sub>Coo</sub> = n<sup>Coo</sup><sub>HP</sub> + n<sup
      >Coo</sup
    ><sub>PHP</sub></i
  >
</p>
<p>
  Combinations that cannot be satisfied with the available equipment (e.g.,
  requiring more simultaneous heating and cooling stages than there are
  polyvalent HPs) are flagged in <code>is_feasible</code> and receive zero
  weights in the staging matrices.
</p>
<h5>Staging matrices</h5>
<p>
  The parameters <code>staCoo</code> and <code>staHea</code> pack feasible
  stage combinations into matrices consumed by the equipment enable logic.
  Each has <i>(n<sub>Sta</sub> + 1) &times; n<sub>Sta</sub></i> rows (one per
  non-zero stage transition) and
  <i>n<sub>HP</sub> + 2&nbsp;n<sub>PHP</sub></i> columns, ordered as: standard
  HPs | polyvalent HPs (cooling- or heating-only) | polyvalent HPs (SHC).
</p>
<p>
  For <code>staCoo</code>, row <i>r</i> corresponds to
  <i>i<sub>Hea</sub> = &lfloor;(r - 1) / n<sub>Sta</sub>&rfloor;</i>
  (outer index, 0 &le; <i>i<sub>Hea</sub></i> &le; <i>n<sub>Sta</sub></i
  >) and
  <i>i<sub>Coo</sub> = (r - 1) mod n<sub>Sta</sub> + 1</i>
  (inner index, 1 &le; <i>i<sub>Coo</sub></i> &le; <i>n<sub>Sta</sub></i
  >). Column values are normalized fractions, as specified in the
  documentation of
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
    Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>.:
</p>
<ul>
  <li>
    Columns 1 &hellip; <i>n<sub>HP</sub></i
    >: &nbsp;<i>n<sup>Coo</sup><sub>HP</sub> / max(n<sub>HP</sub>, 1)</i>
  </li>
  <li>
    Columns <i>n<sub>HP</sub> + 1</i> &hellip;
    <i>n<sub>HP</sub> + n<sub>PHP</sub></i
    >: &nbsp;<i>n<sup>Coo</sup><sub>PHP</sub> / max(n<sub>PHP</sub>, 1)</i>
  </li>
  <li>
    Columns <i>n<sub>HP</sub> + n<sub>PHP</sub> + 1</i> &hellip;
    <i>n<sub>HP</sub> + 2&nbsp;n<sub>PHP</sub></i
    >: &nbsp;<i>n<sup>SHC</sup><sub>PHP</sub> / max(n<sub>PHP</sub>, 1)</i>
  </li>
</ul>
<p>
  A row of zeros indicates an infeasible stage combination.
  <code>staHea</code> follows the same column layout but with
  <i>i<sub>Coo</sub></i> as the outer index and <i>i<sub>Hea</sub></i>
  as the inner index, and the heating counts substituted for the cooling
  counts.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"),
  Icon(graphics={Rectangle(origin={0,-25},
    lineColor={0,0,0},
    extent={{-100.0,-75.0},{100.0,75.0}},
    radius=25.0,
    fillColor={255,213,170},
    fillPattern=FillPattern.Solid),
  Text(textColor={0,0,255},
    extent={{-150,60},{150,100}},
    textString="%name"),
  Line(points={{-100,0},{100,0}},
    color={64,64,64}),
  Line(origin={0,-25},
    points={{0.0,75.0},{0.0,-75.0}},
    color={64,64,64}),
  Line(origin={0,-50},
    points={{-100.0,0.0},{100.0,0.0}},
    color={64,64,64})}));
end StagingParameters;
