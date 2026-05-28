within Buildings.Templates.Utilities.Validation;
model computeNumberOfStagedUnits
  extends Modelica.Icons.Example;
  parameter Integer nHp = 2 "Number of HP units (excluding polyvalent HP)";
  parameter Integer nShc = 3 "Number of polyvalent HP units";
  final parameter Integer nSta = nHp + nShc + 1
    "Total number of cooling or heating stages inc. stage 0";
  parameter Integer nHpHea[nSta, nSta](each fixed=false)
    "Number of HP units in heating mode";
  parameter Integer nHpCoo[nSta, nSta](each fixed=false)
    "Number of HP units in cooling mode";
  parameter Integer nShcHea[nSta, nSta](each fixed=false)
    "Number of polyvalent HP units in heating-only mode";
  parameter Integer nShcCoo[nSta, nSta](each fixed=false)
    "Number of polyvalent HP units in cooling-only mode";
  parameter Integer nShcShc[nSta, nSta](each fixed=false)
    "Number of polyvalent HP units in simultaneous (SHC) mode";
  parameter Boolean is_feasible[nSta, nSta](each fixed=false)
    "True if the stage combination is achievable";
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
  parameter Real capCooSta_nominal[nSta, nSta] =
    nHpCoo * capCooHp_nominal .+ nShcCoo * capCooShc_nominal .+ nShcShc *
      capCooShcShc_nominal
    "Cooling capacity at each stage";
  parameter Real capHeaSta_nominal[nSta, nSta] =
    nHpHea * capHeaHp_nominal .+ nShcHea * capHeaShc_nominal .+ nShcShc *
      capHeaShcShc_nominal
    "Heating capacity at each stage";
  // Columns are for equipment tags, duplicating SHC units for cooling-only and SHC mode indexing
  parameter Real staCoo[nSta, nSta-1, nHp + 2 * nShc] =
    {cat(1,
      fill(nHpCoo[iHea, iCoo] / nHp, nHp),
      fill(nShcCoo[iHea, iCoo] / nShc, nShc),
      fill(nShcShc[iHea, iCoo] / nShc, nShc)) for iCoo in 2:nSta, iHea in 1:nSta}
    "Cooling staging matrix – Varies with heating stage"; // !!! 3D array is not CDL-compliant: process dynamically with a block
  Buildings.Templates.Utilities.StagingMatrix sta(
    final nHp=nHp,
    final nShc=nShc)
    "Calculate staging matrix with block";
initial algorithm
  for iHea in 1:nSta, iCoo in 1:nSta loop
    (nHpHea[iHea, iCoo],
      nHpCoo[iHea, iCoo],
      nShcHea[iHea, iCoo],
      nShcCoo[iHea, iCoo],
      nShcShc[iHea, iCoo],
      is_feasible[iHea, iCoo]) :=
      Buildings.Templates.Utilities.computeNumberOfStagedUnits(
      iHea - 1, iCoo - 1, nHp, nShc);
    assert(sta.nHpHea[iHea, iCoo] == nHpHea[iHea, iCoo], "Mismatch");
    assert(sta.nHpCoo[iHea, iCoo] == nHpCoo[iHea, iCoo], "Mismatch");
    assert(sta.nShcShc[iHea, iCoo] == nShcShc[iHea, iCoo], "Mismatch");
    assert(sta.nShcHea[iHea, iCoo] == nShcHea[iHea, iCoo], "Mismatch");
    assert(sta.nShcCoo[iHea, iCoo] == nShcCoo[iHea, iCoo], "Mismatch");

  end for;
end computeNumberOfStagedUnits;
