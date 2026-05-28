within Buildings.Templates.Utilities;
block StagingMatrix
  parameter Integer nHp "Number of HP units (excluding polyvalent HP)";
  parameter Integer nShc "Number of polyvalent HP units";
  final parameter Integer nSta = nHp + nShc + 1
    "Total number of cooling or heating stages inc. stage 0";
  final parameter Integer staShc[nSta, nSta] =
    {min(iHea, iCoo) for iCoo in 0:nSta - 1, iHea in 0:nSta - 1}
    "Minimum between cooling and heating stage";
  final parameter Integer staHeaRes[nSta, nSta] =
    {iHea - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta - 1, iHea in 0:nSta -
      1}
    "Residual heating stage count after SHC assignment";
  parameter Integer staCooRes[nSta, nSta] =
    {iCoo - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta - 1, iHea in 0:nSta -
      1}
    "Residual cooling stage count after SHC assignment";
  parameter Integer nHpAva[nSta, nSta] =
    {nHp - nHpHea[iHea + 1, iCoo + 1] for iCoo in 0:nSta - 1, iHea in 0:nSta -
      1}
    "HP units still available after heating assignment";
  parameter Integer nShcAva[nSta, nSta] =
    {nShc - nShcShc[iHea + 1, iCoo + 1] for iCoo in 0:nSta - 1, iHea in 0:nSta -
      1}
    "Polyvalent HP units still available after SHC assignment";
  final parameter Integer nHpHea[nSta, nSta] =
    {min(staHeaRes[iHea + 1, iCoo + 1], nHp) for iCoo in 0:nSta -
      1, iHea in 0:nSta - 1}
    "Number of HP units in heating mode";
  final parameter Integer nHpCoo[nSta, nSta] =
    {min(
      staCooRes[iHea + 1, iCoo + 1],
      nHpAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta - 1, iHea in 0:nSta - 1}
    "Number of HP units in cooling mode";
  final parameter Integer nShcHea[nSta, nSta] =
    {min(
      staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1],
      nShcAva[iHea + 1, iCoo + 1]) for iCoo in 0:nSta - 1, iHea in 0:nSta - 1}
    "Number of polyvalent HP units in heating-only mode";
  final parameter Integer nShcCoo[nSta, nSta] =
    {min(
      staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1],
      nShcAva[iHea + 1, iCoo + 1] -
        nShcHea[iHea + 1, iCoo + 1]) for iCoo in 0:nSta - 1, iHea in 0:nSta - 1}
    "Number of polyvalent HP units in cooling-only mode";
  final parameter Integer nShcShc[nSta, nSta] =
    {min(staShc[iHea + 1, iCoo + 1], nShc) for iCoo in 0:nSta -
      1, iHea in 0:nSta - 1}
    "Number of polyvalent HP units in simultaneous (SHC) mode";
  final Boolean is_feasible[nSta, nSta] =
    {(staHeaRes[iHea + 1, iCoo + 1] - nHpHea[iHea + 1, iCoo + 1] -
      nShcHea[iHea + 1, iCoo + 1] == 0)
      and (staCooRes[iHea + 1, iCoo + 1] - nHpCoo[iHea + 1, iCoo + 1] -
        nShcCoo[iHea + 1, iCoo + 1] == 0) for iCoo in 0:nSta -
      1, iHea in 0:nSta - 1}
    "True if the stage combination is achievable";
end StagingMatrix;
