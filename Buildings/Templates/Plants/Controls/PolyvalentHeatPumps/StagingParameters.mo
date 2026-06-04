within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block StagingParameters
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
  final parameter Real staCoo[(nSta + 1) * nSta, nHp + 2 * nShc] =
    {(if iEqu <= nHp
    then nHpCoo[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(nHp, 1)
    elseif iEqu <= nHp + nShc
    then nShcCoo[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(nShc, 1)
    else nShcShc[div(r - 1, nSta) + 1, mod(r - 1, nSta) + 2] / max(
        nShc,
        1)) for iEqu in 1:nHp + 2 * nShc, r in 1:(nSta + 1) * nSta}
    "Cooling staging matrix – row-major over (0≤iHea outer, 1≤iCoo inner)";
  final parameter Real staHea[(nSta + 1)*nSta, nHp + 2*nShc] =
    {(if iEqu <= nHp
    then nHpHea[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(nHp, 1)
    elseif iEqu <= nHp + nShc
    then nShcHea[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(nShc, 1)
    else nShcShc[mod(r - 1, nSta) + 2, div(r - 1, nSta) + 1] / max(nShc, 1))
      for iEqu in 1:nHp + 2*nShc, r in 1:(nSta + 1)*nSta}
    "Heating staging matrix – row-major over (0≤iCoo outer, 1≤iHea inner)";
annotation(defaultComponentName="staPar",
  Documentation(
    info="<html>
<p>
  For a plant with polyvalent heat pumps, this block calculates the number of
  units to be staged in each operating mode.
</p>
</html>"),
  Icon(graphics={Rectangle(origin={0,-25},
    lineColor={64,64,64},
    fillColor={255,215,136},
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
