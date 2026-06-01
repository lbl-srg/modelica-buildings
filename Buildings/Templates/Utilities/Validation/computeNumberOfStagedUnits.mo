within Buildings.Templates.Utilities.Validation;
model computeNumberOfStagedUnits
  extends Modelica.Icons.Example;
  parameter Integer nHp = 2 "Number of HP units (excluding polyvalent HP)";
  parameter Integer nShc = 3 "Number of polyvalent HP units";
  final parameter Integer nSta = nHp + nShc
    "Number of cooling or heating stages (excluding stage 0)";
  parameter Real capHeaHp_nominal = 1E5
    "Design heating capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capCooHp_nominal =
    (1 - 1 / Buildings.Templates.Data.Defaults.COPHpAwHea) * capHeaHp_nominal
    "Design cooling capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capHeaShc_nominal = 2E5
    "Design heating capacity - Each polyvalent heat pump";
  parameter Real capCooShc_nominal =
    (1 - 1 / Buildings.Templates.Data.Defaults.COPHpAwHea) * capHeaShc_nominal
    "Design cooling capacity - Each polyvalent heat pump";
  parameter Real capHeaShcShc_nominal =
    Buildings.Templates.Data.Defaults.COPHpWwHea /
      Buildings.Templates.Data.Defaults.COPHpAwHea * capHeaShc_nominal
    "Design heating capacity in SHC mode - Each polyvalent heat pump";
  parameter Real capCooShcShc_nominal =
    (1 - 1 / Buildings.Templates.Data.Defaults.COPHpWwHea) *
      capHeaShcShc_nominal
    "Design cooling capacity in SHC mode - Each polyvalent heat pump";
  parameter Real capCooSta_nominal[nSta + 1, nSta + 1] =
    sta.nHpCoo * capCooHp_nominal .+ sta.nShcCoo * capCooShc_nominal .+ sta.nShcShc *
      capCooShcShc_nominal
    "Cooling capacity at each stage";
  parameter Real capHeaSta_nominal[nSta + 1, nSta + 1] =
    sta.nHpHea * capHeaHp_nominal .+ sta.nShcHea * capHeaShc_nominal .+ sta.nShcShc *
      capHeaShcShc_nominal
    "Heating capacity at each stage";
  // Columns are for equipment tags, duplicating SHC units for cooling-only and SHC mode indexing
  // Row-major flattening to be CDL-compliant (3D arrays not supported):
  // from staCooNonCdl[iHea, iCoo, iEqu]
  // staCooNonCdl[nSta + 1, nSta, nHp + 2 * nShc] -> staCoo[(nSta + 1) * nSta, nHp + 2 * nShc]
  // and staCoo[(iHea-1) * nSta + 1 : iHea * nSta] = staCooNonCdl[iHea]
  parameter Real staCooNonCdl[nSta + 1, nSta, nHp + 2 * nShc] =
    {cat(1,
      fill(sta.nHpCoo[iHea, iCoo] / nHp, nHp),
      fill(sta.nShcCoo[iHea, iCoo] / nShc, nShc),
      fill(sta.nShcShc[iHea, iCoo] / nShc, nShc)) for iCoo in 1:nSta, iHea in 1:nSta + 1}
    "Cooling staging matrix – Varies with heating stage";
  parameter Real staCoo1D[(nSta + 1)*nSta*(nHp + 2*nShc)] =
    {(if mod(m-1, nHp + 2*nShc) < nHp then
        sta.nHpCoo[div(m-1, nSta*(nHp + 2*nShc)) + 1,
                   mod(div(m-1, nHp + 2*nShc), nSta) + 1] / nHp
      elseif mod(m-1, nHp + 2*nShc) < nHp + nShc then
        sta.nShcCoo[div(m-1, nSta*(nHp + 2*nShc)) + 1,
                    mod(div(m-1, nHp + 2*nShc), nSta) + 1] / nShc
      else
        sta.nShcShc[div(m-1, nSta*(nHp + 2*nShc)) + 1,
                    mod(div(m-1, nHp + 2*nShc), nSta) + 1] / nShc)
      for m in 1:(nSta + 1)*nSta*(nHp + 2*nShc)}
    "Cooling staging matrix – fully flattened (row-major over iHea, iCoo, iEqu)";
  Buildings.Templates.Utilities.StagingMatrix sta(
    final nHp=nHp,
    final nShc=nShc)
    "Calculate staging matrix with block";
  Controls.OBC.CDL.Integers.Sources.Constant iHea(k=3)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Utilities.ExtractMatrixAtStage ext1D(
    final sta=staCoo1D, final nHp=nHp, final nShc=nShc)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Templates.Utilities.ExtractMatrixAtStage extTra(
    is_transpose=true,
    final sta=staCoo1D, final nHp=nHp, final nShc=nShc)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
initial algorithm
  for iHea in 1:nSta + 1, iCoo in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staCoo1D[((iHea-1)*nSta + (iCoo-1))*(nHp + 2*nShc) + iEqu] - staCooNonCdl[iHea, iCoo, iEqu]) < Modelica.Constants.small, "Mismatch");
  end for;
  for iCoo in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staCooNonCdl[iHea.k, iCoo, iEqu] - ext1D.y[iCoo, iEqu])  <
      Modelica.Constants.small, "Mismatch");
    assert(abs(staCooNonCdl[iHea.k, iCoo, iEqu] - extTra.y[iEqu, iCoo])  <
      Modelica.Constants.small, "Mismatch");
  end for;
equation
  connect(iHea.y, ext1D.u) annotation (Line(points={{-38,0},{-20,0},{-20,30},{-12,
          30}},      color={255,127,0}));
  connect(iHea.y, extTra.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={255,127,0}));
end computeNumberOfStagedUnits;
