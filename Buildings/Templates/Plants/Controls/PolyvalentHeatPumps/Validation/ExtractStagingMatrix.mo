within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.Validation;
model ExtractStagingMatrix
  extends Modelica.Icons.Example;
  parameter Integer nHp = 2
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
  parameter Real capHeaShc_nominal = 1.3E5
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
  parameter Real capCooSta_nominal[nSta + 1,nSta + 1]=staPar.nHpCoo*
      capCooHp_nominal .+ staPar.nShcCoo*capCooShc_nominal .+ staPar.nShcShc*
      capCooShcShc_nominal "Cooling capacity at each stage";
  parameter Real capHeaSta_nominal[nSta + 1,nSta + 1]=staPar.nHpHea*
      capHeaHp_nominal .+ staPar.nShcHea*capHeaShc_nominal .+ staPar.nShcShc*
      capHeaShcShc_nominal "Heating capacity at each stage";
  // Columns are for equipment tags, duplicating SHC units for cooling-only and SHC mode indexing
  // NOT CDL compliant because 3D array!
  parameter Real staCoo[nSta + 1,nSta,nHp + 2*nShc]={cat(
      1,
      fill(staPar.nHpCoo[iHea, iCoo + 1]/max(nHp, 1), nHp),
      fill(staPar.nShcCoo[iHea, iCoo + 1]/max(nShc, 1), nShc),
      fill(staPar.nShcShc[iHea, iCoo + 1]/max(nShc, 1), nShc)) for iCoo in 1:
    nSta, iHea in 1:nSta + 1}
    "Cooling staging matrix – Varies with heating stage";
  parameter Real staHea[nSta + 1,nSta,nHp + 2*nShc]={cat(
      1,
    fill(staPar.nHpHea[iHea + 1, iCoo]/max(nHp, 1), nHp),
    fill(staPar.nShcHea[iHea + 1, iCoo]/max(nShc, 1), nShc),
    fill(staPar.nShcShc[iHea + 1, iCoo]/max(nShc, 1), nShc)) for iHea in 1:
    nSta, iCoo in 1:nSta + 1}
    "Heating staging matrix – Varies with cooling stage";
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters staPar(final nHp
      =nHp, final nShc=nShc) "Staging parameters"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable iHea(
    table={{i*iHea.timeScale,i} for i in 0:nSta},
    timeScale=1/(nSta + 1),
    period=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix
    extSta(final sta=staPar.staCoo)
    "Extract cooling staging matrix at given heating stage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ExtractStagingMatrix
    extTra(final sta=staPar.staCoo, is_transpose=true)
    "Extract transpose of cooling staging matrix at given heating stage"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
initial algorithm
  for iOut in 1:nSta + 1, iInn in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staPar.staCoo[(iOut - 1)*nSta + iInn, iEqu] - staCoo[iOut, iInn,
      iEqu]) < Modelica.Constants.small, "Mismatch");
    assert(abs(staPar.staHea[(iOut - 1)*nSta + iInn, iEqu] - staHea[iOut, iInn,
      iEqu]) < Modelica.Constants.small, "Mismatch");
    if staPar.is_feasible[iOut, iInn +1] then
      assert(abs(staHea[iOut, iInn, iEqu] - staCoo[iOut, iInn, iEqu]) <
        Modelica.Constants.small, "Mismatch");
    end if;
  end for;
  for iCoo in 1:nSta + 1, iHea in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staPar.staHea[(iCoo - 1)*nSta + iHea, iEqu] - staHea[iCoo, iHea,
      iEqu]) < Modelica.Constants.small, "Mismatch");
  end for;
  for iCoo in 1:nSta, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staCoo[iHea.y[1] + 1, iCoo, iEqu] - extSta.y[iCoo, iEqu]) <
      Modelica.Constants.small, "Mismatch");
    assert(abs(staCoo[iHea.y[1] + 1, iCoo, iEqu] - extTra.y[iEqu, iCoo]) <
      Modelica.Constants.small, "Mismatch");
  end for;
equation
  connect(iHea.y[1], extSta.u)
    annotation (Line(points={{-58,0},{-12,0}}, color={255,127,0}));
  connect(iHea.y[1], extTra.u) annotation (Line(points={{-58,0},{-20,0},{-20,-40},
          {-12,-40}}, color={255,127,0}));
end ExtractStagingMatrix;
