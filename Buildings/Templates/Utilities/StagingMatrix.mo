within Buildings.Templates.Utilities;
block StagingMatrix
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
  parameter Integer staCooRes[nSta + 1, nSta + 1] =
    {iCoo - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "Residual cooling stage count after SHC assignment";
  parameter Integer nHpAva[nSta + 1, nSta + 1] =
    {nHp - nHpHea[iHea + 1, iCoo + 1] for iCoo in 0:nSta, iHea in 0:nSta}
    "HP units still available after heating assignment";
  parameter Integer nShcAva[nSta + 1, nSta + 1] =
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
  final Boolean is_feasible[nSta + 1, nSta + 1] =
    {(staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1] -
      nShcHea[iHea + 1, iCoo + 1] == 0)
      and (staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1] -
        nShcCoo[iHea + 1, iCoo + 1] == 0) for iCoo in 0:nSta, iHea in 0:nSta}
    "True if the stage combination is achievable";
end StagingMatrix;
