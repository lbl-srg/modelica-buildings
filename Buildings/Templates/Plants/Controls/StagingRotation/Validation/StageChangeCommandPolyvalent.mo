within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageChangeCommandPolyvalent
  extends Buildings.Templates.Plants.Controls.StagingRotation.Validation.StageChangeCommand(
    have_php=true,
    capHea_nominal = sum(chaSta.capEqu[1:4]),
    chaSta(capEqu=cat(
          1,
          fill(capHeaHp_nominal, 2),
          fill(capHeaPhp_nominal, 2),
          fill(capHeaPhpShc_nominal, 2)), staEqu=staPhp.staHea),
    comSta(nin=6),
    idxEquLeaLag(k={1,2}));
  parameter Real capHeaHp_nominal = 1E5
    "Design heating capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capHeaPhp_nominal = 0.9E5
    "Design heating capacity - Each polyvalent heat pump";
  parameter Real capHeaPhpShc_nominal =
    Buildings.Templates.Data.Defaults.COPHpWwHea /
      Buildings.Templates.Data.Defaults.COPHpAwHea * capHeaPhp_nominal
    "Design heating capacity in SHC mode - Each polyvalent heat pump";
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentEnable
    enaEquPhp(nHp=2, nPhp=2) "Enable equipment at stage"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  PolyvalentHeatPumps.StagingParameters staPhp(nHp=2, nPhp=2)
    "Staging parameters"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable staOpp(
    table=[0,0,1; 1,0,1; 5,3,4; 6,2,3; 11,1,2; 12,0,1],
    timeScale=1000,
    period=20000) "Opposite mode (cooling) stage, and next higher stage"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(chaSta.staTra, enaEquPhp.staTra) annotation (Line(points={{-28,10},{-18,
          10},{-18,38},{58,38}}, color={0,0,127}));
  connect(idxEquLeaLag.y,enaEquPhp.uIdxSorHp)  annotation (Line(points={{-78,100},
          {54,100},{54,36},{58,36}}, color={255,127,0}));
  connect(idxEquLeaLag.y, enaEquPhp.uIdxSorPhp1) annotation (Line(points={{-78,
          100},{54,100},{54,34},{58,34}}, color={255,127,0}));
  connect(u1AvaEqu[5:6].y,enaEquPhp.u1AvaPhp2)  annotation (Line(points={{-78,-100},{
          50,-100},{50,22},{58,22}}, color={255,0,255}));
  connect(u1AvaEqu[3:4].y,enaEquPhp.u1AvaPhp1)  annotation (Line(points={{-78,-100},{
          50,-100},{50,24},{58,24}}, color={255,0,255}));
  connect(u1AvaEqu[1:2].y,enaEquPhp.u1AvaHp)  annotation (Line(points={{-78,-100},{50,
          -100},{50,26},{58,26}}, color={255,0,255}));
  connect(idxSta.y, enaEquPhp.uSta) annotation (Line(points={{22,0},{40,0},{40,30},
          {58,30}}, color={255,127,0}));
  connect(enaEquPhp.y1HpPhp1, staEqu[1:4].y1) annotation (Line(points={{82,26},{
          92,26},{92,0},{98,0}}, color={255,0,255}));
  connect(enaEquPhp.y1Php2[3:4], staEqu[5:6].y1) annotation (Line(points={{82,30},{96,
          30},{96,0},{98,0}}, color={255,0,255}));
  connect(enaEquPhp.y1HpPhp1, comSta.u1[1:4]) annotation (Line(points={{82,26},{
          92,26},{92,60},{-28,60}},
                             color={255,0,255}));
  connect(enaEquPhp.y1Php2[3:4], comSta.u1[5:6]) annotation (Line(points={{82,30},{96,
          30},{96,60},{-28,60}}, color={255,0,255}));
  connect(staOpp.y[1], chaSta.uStaOpp) annotation (Line(points={{-68,40},{-60,40},
    {-60,10},{-52,10}}, color={255,127,0}));
  connect(staOpp.y[2], chaSta.uStaOppNexHig) annotation (Line(points={{-68,40},{-60,40},
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
