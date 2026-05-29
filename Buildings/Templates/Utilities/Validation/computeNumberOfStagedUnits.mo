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
  // Row-major flattening to be CDL-compliant (3D arrays not supported):
  // from staCooNonCdl[iHea, iCoo, iEqu]
  // staCooNonCdl[nSta, nSta - 1, nHp + 2 * nShc] -> staCoo[nSta * (nSta - 1), nHp + 2 * nShc]
  // and staCoo[(iHea-1)*(nSta-1) + 1 : iHea*(nSta-1)] = staCooNonCdl[iHea]
  parameter Real staCooNonCdl[nSta, nSta-1, nHp + 2 * nShc] =
    {cat(1,
      fill(nHpCoo[iHea, iCoo] / nHp, nHp),
      fill(nShcCoo[iHea, iCoo] / nShc, nShc),
      fill(nShcShc[iHea, iCoo] / nShc, nShc)) for iCoo in 2:nSta, iHea in 1:nSta}
    "Cooling staging matrix – Varies with heating stage";
  parameter Real staCoo[nSta * (nSta-1), nHp + 2 * nShc] =
    {cat(1,
      fill(nHpCoo[div(k-1, nSta-1) + 1, mod(k-1, nSta-1) + 2] / nHp, nHp),
      fill(nShcCoo[div(k-1, nSta-1) + 1, mod(k-1, nSta-1) + 2] / nShc, nShc),
      fill(nShcShc[div(k-1, nSta-1) + 1, mod(k-1, nSta-1) + 2] / nShc, nShc))
    for k in 1:nSta*(nSta-1)}
    "Cooling staging matrix – Varies with heating stage";
  Buildings.Templates.Utilities.StagingMatrix sta(
    final nHp=nHp,
    final nShc=nShc)
    "Calculate staging matrix with block";
  Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nHp + 2*nShc,nSta*(nSta - 1)](
     final k={staCoo[i, j] for i in 1:nSta*(nSta - 1),j in 1:nHp + 2*nShc})
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Controls.OBC.CDL.Integers.Sources.Constant iHea(k=3)
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Controls.OBC.CDL.Integers.Multiply mulInt
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=nSta - 1)
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Controls.OBC.CDL.Integers.Subtract intSub
    annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
  Controls.OBC.CDL.Integers.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst1[nSta - 1](k={i for i in 1:
        nSta - 1})
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nSta - 1)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Controls.OBC.CDL.Integers.Add addInt[nSta - 1]
    annotation (Placement(transformation(extent={{48,-50},{68,-30}})));
  Controls.OBC.CDL.Routing.RealExtractor extIndRea[nHp + 2*nShc,nSta - 1](each
      nin=nSta*(nSta - 1))
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Controls.OBC.CDL.Routing.IntegerVectorReplicator intVecRep(nin=nSta - 1, nout
      =nHp + 2*nShc)
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep[nHp + 2*nShc](each
      nin=nSta*(nSta - 1), each nout=nSta - 1)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Templates.Utilities.ExtractTransposeAtStage extractTransposeAtStage(final sta=staCoo)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
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
  for iHea in 1:nSta, iCoo in 1:nSta-1, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staCoo[(iHea-1)*(nSta-1) + iCoo, iEqu] - staCooNonCdl[iHea, iCoo, iEqu]) < Modelica.Constants.small, "Mismatch");
  end for;
  for iCoo in 1:nSta-1, iEqu in 1:nHp + 2 * nShc loop
    assert(abs(staCooNonCdl[iHea.k, iCoo, iEqu] - extractTransposeAtStage.y[iEqu, iCoo]) < Modelica.Constants.small, "Mismatch");
  end for;
equation
  connect(iHea.y, intSub.u1) annotation (Line(points={{-68,-40},{-60,-40},{-60,-34},
          {-58,-34}}, color={255,127,0}));
  connect(nStaCst.y, mulInt.u2) annotation (Line(points={{-28,-80},{-24,-80},{-24,
          -46},{-22,-46}}, color={255,127,0}));
  connect(intSub.y, mulInt.u1) annotation (Line(points={{-34,-40},{-30,-40},{-30,
          -34},{-22,-34}}, color={255,127,0}));
  connect(one.y, intSub.u2) annotation (Line(points={{-68,-80},{-64,-80},{-64,-46},
          {-58,-46}}, color={255,127,0}));
  connect(mulInt.y, intScaRep.u)
    annotation (Line(points={{2,-40},{8,-40}}, color={255,127,0}));
  connect(intScaRep.y, addInt.u1) annotation (Line(points={{32,-40},{40,-40},{40,
          -34},{46,-34}}, color={255,127,0}));
  connect(nStaCst1.y, addInt.u2) annotation (Line(points={{32,-80},{40,-80},{40,
          -46},{46,-46}}, color={255,127,0}));
  connect(conStaCoo.y, reaVecRep.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(reaVecRep.y, extIndRea.u)
    annotation (Line(points={{-18,60},{28,60}}, color={0,0,127}));
  connect(addInt.y, intVecRep.u) annotation (Line(points={{70,-40},{80,-40},{80,
          0},{0,0},{0,20},{10,20}},      color={255,127,0}));
  connect(intVecRep.y, extIndRea.index)
    annotation (Line(points={{34,20},{40,20},{40,48}}, color={255,127,0}));
  connect(iHea.y, extractTransposeAtStage.u) annotation (Line(points={{-68,-40},{-60,
          -40},{-60,0},{-42,0}}, color={255,127,0}));
end computeNumberOfStagedUnits;
