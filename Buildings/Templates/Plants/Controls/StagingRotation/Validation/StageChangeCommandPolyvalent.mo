within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageChangeCommandPolyvalent
  extends Buildings.Templates.Plants.Controls.StagingRotation.Validation.StageChangeCommand(
    have_shc=true,
    capHea_nominal = sum(chaSta.capEqu[1:4]),
    chaSta(
      capEqu=cat(1, fill(capHeaHp_nominal,2), fill(capHeaShc_nominal, 2), fill(capHeaShcShc_nominal, 2)),
      staEqu=staPhp.staHea),
    comSta(nin=6),
    idxEquLeaLag(k={1,2}));
  parameter Real capHeaHp_nominal = 1E5
    "Design heating capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capHeaShc_nominal = 0.9E5
    "Design heating capacity - Each polyvalent heat pump";
  parameter Real capHeaShcShc_nominal =
    Buildings.Templates.Data.Defaults.COPHpWwHea /
      Buildings.Templates.Data.Defaults.COPHpAwHea * capHeaShc_nominal
    "Design heating capacity in SHC mode - Each polyvalent heat pump";
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnablePolyvalent
    enaEquShc(nHp=2, nShc=2) "Enable equipment at stage"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  PolyvalentHeatPumps.StagingParameters staPhp(nHp=2, nShc=2)
    "Staging parameters"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable staOpp(
    table=[0,0; 1,0; 5,3; 6,2; 11,1; 12,0],
    timeScale=1000,
    period=20000) "Opposite mode (cooling) stage"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(chaSta.staTra, enaEquShc.staTra) annotation (Line(points={{-28,10},{-18,
          10},{-18,38},{58,38}}, color={0,0,127}));
  connect(idxEquLeaLag.y, enaEquShc.uIdxHpSor) annotation (Line(points={{-78,100},
          {54,100},{54,36},{58,36}}, color={255,127,0}));
  connect(idxEquLeaLag.y, enaEquShc.uIdxShcSor) annotation (Line(points={{-78,100},
          {54,100},{54,34},{58,34}}, color={255,127,0}));
  connect(u1AvaEqu[5:6].y, enaEquShc.u1Shc2Ava) annotation (Line(points={{-78,-100},{
          50,-100},{50,22},{58,22}}, color={255,0,255}));
  connect(u1AvaEqu[3:4].y, enaEquShc.u1Shc1Ava) annotation (Line(points={{-78,-100},{
          50,-100},{50,24},{58,24}}, color={255,0,255}));
  connect(u1AvaEqu[1:2].y, enaEquShc.u1HpAva) annotation (Line(points={{-78,-100},{50,
          -100},{50,26},{58,26}}, color={255,0,255}));
  connect(idxSta.y, enaEquShc.uSta) annotation (Line(points={{22,0},{40,0},{40,30},
          {58,30}}, color={255,127,0}));
  connect(enaEquShc.y1Hp, staEqu[1:2].y1) annotation (Line(points={{82,34},{92,34},
          {92,0},{98,0}}, color={255,0,255}));
  connect(enaEquShc.y1Shc1, staEqu[3:4].y1) annotation (Line(points={{82,30},{94,
          30},{94,0},{98,0}}, color={255,0,255}));
  connect(enaEquShc.y1Shc2, staEqu[5:6].y1) annotation (Line(points={{82,26},{96,
          26},{96,0},{98,0}}, color={255,0,255}));
  connect(enaEquShc.y1Hp, comSta.u1[1:2]) annotation (Line(points={{82,34},{92,34},
          {92,60},{-28,60}}, color={255,0,255}));
  connect(enaEquShc.y1Shc1, comSta.u1[3:4]) annotation (Line(points={{82,30},{94,
          30},{94,60},{-28,60}}, color={255,0,255}));
  connect(enaEquShc.y1Shc2, comSta.u1[5:6]) annotation (Line(points={{82,26},{96,
          26},{96,60},{-28,60}}, color={255,0,255}));
  connect(staOpp.y[1], chaSta.uStaOpp) annotation (Line(points={{-68,40},{-60,40},
          {-60,10},{-52,10}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageChangeCommandPolyvalent.mos"
        "Simulate and plot"),
    experiment(
      StopTime=20000.0,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-140,-140},{140,140}})));
end StageChangeCommandPolyvalent;
