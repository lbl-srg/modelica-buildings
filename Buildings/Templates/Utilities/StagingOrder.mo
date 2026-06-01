within Buildings.Templates.Utilities;
block StagingOrder
  parameter Integer nHp "Number of HP units (excluding polyvalent HP)";
  parameter Integer nShc "Number of polyvalent HP units";
  final parameter Integer nSta = nHp + nShc
    "Number of cooling or heating stages (excluding stage 0)";
  final parameter Integer staShc[nSta + 1, nSta + 1] =
    {min(iHea, iCoo) for iCoo in 0:nSta, iHea in 0:nSta}
    "Minimum between cooling and heating stage";
  final parameter Integer staHeaRes[nSta + 1, nSta + 1] =
    {iHea - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Residual heating stage count after SHC assignment";
  final parameter Integer staCooRes[nSta + 1, nSta + 1] =
    {iCoo - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Residual cooling stage count after SHC assignment";
  final parameter Integer nHpAva[nSta + 1, nSta + 1] =
    {nHp - nHpHea[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "HP units still available after heating assignment";
  final parameter Integer nShcAva[nSta + 1, nSta + 1] =
    {nShc - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Polyvalent HP units still available after SHC assignment";
  final parameter Integer nHpHea[nSta + 1, nSta + 1] =
    {min(staHeaRes[iHea + 1, iCoo + 1], nHp) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of HP units in heating mode";
  final parameter Integer nHpCoo[nSta + 1, nSta + 1] =
    {min(
      staCooRes[iHea + 1, iCoo + 1],
      nHpAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of HP units in cooling mode";
  final parameter Integer nShcHea[nSta + 1, nSta + 1] =
    {min(
      staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1],
      nShcAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP units in heating-only mode";
  final parameter Integer nShcCoo[nSta + 1, nSta + 1] =
    {min(
      staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1],
      nShcAva[iHea + 1, iCoo + 1] -
        nShcHea[iHea + 1, iCoo + 1]) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP units in cooling-only mode";
  final parameter Integer nShcShc[nSta + 1, nSta + 1] =
    {min(staShc[iHea + 1, iCoo + 1], nShc) for iCoo in 0:nSta, iHea in 0:nSta}
    "Number of polyvalent HP units in simultaneous (SHC) mode";
  final parameter Boolean is_feasible[nSta + 1, nSta + 1] =
    {(staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1] -
      nShcHea[iHea + 1, iCoo + 1] == 0)
      and (staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1] -
        nShcCoo[iHea + 1, iCoo + 1] == 0) for iCoo in 0:nSta, iHea in 0:nSta}
    "True if the stage combination is achievable";
  final parameter Real staCoo[(nSta + 1) * nSta * (nHp + 2 * nShc)] =
    {(if mod(m - 1, nHp + 2 * nShc) < nHp
    then nHpCoo[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
        div(m - 1, nHp + 2 * nShc),
        nSta) + 2] / max(nHp, 1)
    elseif mod(m - 1, nHp + 2 * nShc) < nHp + nShc
    then nShcCoo[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
      div(m - 1, nHp + 2 * nShc),
      nSta) + 2] / max(nShc, 1)
    else nShcShc[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
        div(m - 1, nHp + 2 * nShc),
        nSta) + 2] / max(nShc, 1)) for m in 1:(nSta + 1) * nSta * (nHp + 2 *
      nShc)}
    "Cooling staging matrix – fully flattened (row-major over iHea, iCoo, iEqu)";
  final parameter Real staHea[(nSta + 1) * nSta * (nHp + 2 * nShc)] =
    {(if mod(m - 1, nHp + 2 * nShc) < nHp
    then nHpHea[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
        div(m - 1, nHp + 2 * nShc),
        nSta) + 2] / max(nHp, 1)
    elseif mod(m - 1, nHp + 2 * nShc) < nHp + nShc
    then nShcHea[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
      div(m - 1, nHp + 2 * nShc),
      nSta) + 2] / max(nShc, 1)
    else nShcShc[div(m - 1, nSta * (nHp + 2 * nShc)) + 1, mod(
        div(m - 1, nHp + 2 * nShc),
        nSta) + 2] / max(nShc, 1)) for m in 1:(nSta + 1) * nSta * (nHp + 2 *
      nShc)}
    "Heating staging matrix – fully flattened (row-major over iHea, iCoo, iEqu)";
annotation(Documentation(
  info="<html>
<p>
  For a plant with polyvalent heat pumps, this block calculates the number of
  units to be staged in each operating mode.
</p>
</html>"));
end StagingOrder;
