within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.Validation;
model ExtractStagingMatrix
  extends Modelica.Icons.Example;
  parameter Integer nHp = 0
    "Number of HP units (excluding polyvalent HP)"
    annotation(Evaluate=true);
  parameter Integer nShc = 2
    "Number of polyvalent HP units"
    annotation(Evaluate=true);
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
    sta.nHpCoo * capCooHp_nominal .+ sta.nShcCoo * capCooShc_nominal .+
      sta.nShcShc * capCooShcShc_nominal
    "Cooling capacity at each stage";
  parameter Real capHeaSta_nominal[nSta + 1, nSta + 1] =
    sta.nHpHea * capHeaHp_nominal .+ sta.nShcHea * capHeaShc_nominal .+
      sta.nShcShc * capHeaShcShc_nominal
    "Heating capacity at each stage";
  // Columns are for equipment tags, duplicating SHC units for cooling-only and SHC mode indexing
  // NOT CDL compliant because 3D array!
  parameter Real staCoo[nSta + 1, nSta, nHp + 2 * nShc] =
    {cat(
      1,
      fill(sta.nHpCoo[iHea, iCoo + 1] / max(nHp, 1), nHp),
      fill(sta.nShcCoo[iHea, iCoo + 1] / max(nShc, 1), nShc),
      fill(
        sta.nShcShc[iHea, iCoo + 1] / max(nShc, 1),
        nShc)) for iCoo in 1:nSta, iHea in 1:nSta + 1}
    "Cooling staging matrix – Varies with heating stage";
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingOrder sta(
      final nHp=nHp, final nShc=nShc) "Calculate staging order";
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant iHea(k=3)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix
    extSta(
    final sta=sta.staCoo,
    final nHp=nHp,
    final nShc=nShc) "Extract cooling staging matrix at given heating stage"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix
    extTra(
    is_transpose=true,
    final sta=sta.staCoo,
    final nHp=nHp,
    final nShc=nShc)
    "Extract transpose of cooling staging matrix at given heating stage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
initial algorithm
  for iHea in 1:nSta + 1, iCoo in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(
      abs(
        sta.staCoo[((iHea - 1) * nSta + (iCoo - 1)) * (nHp + 2 * nShc) + iEqu] -
          staCoo[iHea, iCoo, iEqu]) < Modelica.Constants.small,
      "Mismatch");
  end for;
  for iCoo in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(
      abs(staCoo[iHea.k, iCoo, iEqu] - extSta.y[iCoo, iEqu]) <
        Modelica.Constants.small,
      "Mismatch");
    assert(
      abs(staCoo[iHea.k, iCoo, iEqu] - extTra.y[iEqu, iCoo]) <
        Modelica.Constants.small,
      "Mismatch");
  end for;
equation
  connect(iHea.y, extSta.u)
    annotation(Line(points={{-38,0},{-20,0},{-20,30},{-12,30}},
      color={255,127,0}));
  connect(iHea.y, extTra.u)
    annotation(Line(points={{-38,0},{-12,0}},
      color={255,127,0}));
end ExtractStagingMatrix;
