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
  For a plant with polyvalent heat pumps, this block calculates the number of
  units to be staged in each operating mode.
</p>
</html>"),
  Icon(graphics={Rectangle(origin={0,-25},
    lineColor={0,0,0},
    fillColor={255,128,0},
    fillPattern=FillPattern.Solid,
    extent={{-100.0,-75.0},{100.0,75.0}},
    radius=25.0),
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
