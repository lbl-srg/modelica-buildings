within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageChangeCommandPolyvalent
  "Validation model for stage change logic with polyvalent heat pumps"
  extends Buildings.Templates.Plants.Controls.StagingRotation.Validation.StageChangeCommand(
    have_php=true,
    capHea_nominal=sum(chaSta.capEqu[1:4]),
    chaSta(
      capEqu=cat(
        1,
        fill(capHeaHp_nominal, 2),
        fill(capHeaPhp_nominal, 2),
        fill(capHeaPhpShc_nominal, 2)),
      staEqu=staPhp.staHea),
    comSta(nin=6),
    idxEquLeaLag(k={1, 2}));
  parameter Real capHeaHp_nominal = 1E5
    "Design heating capacity - Each heat pump (excluding polyvalent HP)";
  parameter Real capHeaPhp_nominal = 0.9E5
    "Design heating capacity - Each polyvalent heat pump";
  parameter Real capHeaPhpShc_nominal =
    Buildings.Templates.Data.Defaults.COPHpWwHea /
    Buildings.Templates.Data.Defaults.COPHpAwHea * capHeaPhp_nominal
    "Design heating capacity in SHC mode - Each polyvalent heat pump";
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.SelectModeState selMod(
    final have_chiWat=true,
    nHp=2,
    nPhp=2)
    "Select equipment mode at stage"
    annotation(Placement(transformation(extent={{60,20},{80,44}})));
  PolyvalentHeatPumps.StagingParameters staPhp(nHp=2, nPhp=2)
    "Staging parameters"
    annotation(Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable staCoo(
    table=[0, 0, 1; 1, 0, 1; 5, 3, 4; 6, 2, 3; 11, 1, 2; 12, 0, 1],
    timeScale=1000,
    period=20000)
    "Cooling stage, and next higher stage"
    annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extStaCoo(
    sta=staPhp.staCoo,
    is_transpose=true)
    "Extract transpose of cooling staging matrix at heating stage"
    annotation(Placement(transformation(extent={{-52,110},{-32,130}})));
equation
  connect(chaSta.staTra, selMod.staTraHea)
    annotation(Line(points={{-28,10},{-18,10},{-18,42},{58,42}},
      color={0,0,127}));
  connect(idxEquLeaLag.y, selMod.uIdxSorHp)
    annotation(Line(points={{-78,100},{54,100},{54,38},{58,38}},
      color={255,127,0}));
  connect(idxEquLeaLag.y, selMod.uIdxSorPhp)
    annotation(Line(points={{-78,100},{54,100},{54,36},{58,36}},
      color={255,127,0}));
  connect(u1AvaEqu[5:6].y, selMod.u1AvaShcPhp)
    annotation(Line(points={{-78,-100},{50,-100},{50,22},{58,22}},
      color={255,0,255}));
  connect(u1AvaEqu[3:4].y, selMod.u1AvaHeaPhp)
    annotation(Line(points={{-78,-100},{50,-100},{50,26},{58,26}},
      color={255,0,255}));
  connect(u1AvaEqu[3:4].y, selMod.u1AvaCooPhp)
    annotation(Line(points={{-78,-100},{50,-100},{50,26},{58,26}},
      color={255,0,255}));
  connect(u1AvaEqu[1:2].y, selMod.u1AvaHeaHp)
    annotation(Line(points={{-78,-100},{50,-100},{50,30},{58,30}},
      color={255,0,255}));
  connect(u1AvaEqu[1:2].y, selMod.u1AvaCooHp)
    annotation(Line(points={{-78,-100},{50,-100},{50,30},{58,30}},
      color={255,0,255}));
  connect(idxSta.y, selMod.uStaHea)
    annotation(Line(points={{22,0},{40,0},{40,34},{58,34}},
      color={255,127,0}));
  connect(selMod.y1HeaHpPhp, staEqu[1:4].y1)
    annotation(Line(points={{82,38},{92,38},{92,0},{98,0}},
      color={255,0,255}));
  connect(selMod.y1ShcPhp, staEqu[5:6].y1)
    annotation(Line(points={{82,28},{96,28},{96,0},{98,0}},
      color={255,0,255}));
  connect(selMod.y1HeaHpPhp, comSta.u1[1:4])
    annotation(Line(points={{82,38},{92,38},{92,60},{-28,60}},
      color={255,0,255}));
  connect(selMod.y1ShcPhp, comSta.u1[5:6])
    annotation(Line(points={{82,28},{96,28},{96,60},{-28,60}},
      color={255,0,255}));
  connect(staCoo.y[1], chaSta.uStaOpp)
    annotation(Line(points={{-68,40},{-60,40},{-60,10},{-52,10}},
      color={255,127,0}));
  connect(staCoo.y[2], chaSta.uStaOppNexHig)
    annotation(Line(points={{-68,40},{-60,40},{-60,12},{-52,12},{-52,12}},
      color={255,127,0}));
  connect(staCoo.y[1], selMod.uStaCoo)
    annotation(Line(points={{-68,40},{-60,40},{-60,32},{58,32}},
      color={255,127,0}));
  connect(staCoo.y[1], extStaCoo.u)
    annotation(Line(points={{-68,40},{-60,40},{-60,120},{-54,120}},
      color={255,127,0}));
  connect(extStaCoo.y, selMod.staTraCoo)
    annotation(Line(points={{-30,120},{56,120},{56,40},{58,40}},
      color={0,0,127}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageChangeCommandPolyvalent.mos"
    "Simulate and plot"),
  experiment(StopTime=20000.0,
    Tolerance=1e-06),
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
  Documentation(
    revisions="<html>
<ul>
  <li>
    June 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand\">
    Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand</a>
  in a configuration with two reversible heat pumps and two polyvalent heat
  pumps. In response to a varying flow rate, the variation of the required
  capacity <code>chaSta.capReq.y</code> triggers stage change events. The
  block
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
    Buildings.Templates.Plants.Controls.Utilities.StageIndex</a> is used to
  illustrate how these events translate into a varying plant stage index
  <code>idxSta.y</code>.
</p>
</html>"));
end StageChangeCommandPolyvalent;
