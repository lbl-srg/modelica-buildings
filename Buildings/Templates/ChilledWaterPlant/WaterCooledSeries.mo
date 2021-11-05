within Buildings.Templates.ChilledWaterPlant;
model WaterCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledChiller);
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
      redeclare final Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerSeries
        chi(redeclare final package Medium1=MediumCW),
      final is_airCoo=false);
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialCondenserWaterLoop;
  inner replaceable
    Components.Controls.OpenLoop
    con constrainedby Components.Controls.OpenLoop
      annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-48,90})));
equation
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(chi.busCon, chwCon.chi) annotation (Line(
      points={{-50,10},{-60,10},{-60,60},{200.1,60},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(WSE.busCon, chwCon.wse) annotation (Line(
      points={{-50,-72},{-60,-72},{-60,60},{200.1,60},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(cwCon.cooTow, cooTow.busCon) annotation (Line(
      points={{-199.9,60.1},{-170,60.1},{-170,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cwCon.conPum,pumCon.busCon)  annotation (Line(
      points={{-200,60},{-90,60},{-90,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, cooTow.weaBus) annotation (Line(
      points={{0,100},{0,70},{-165,70},{-165,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chwCon.TCHWRet, TCHWRet.busCon) annotation (Line(
      points={{200,60},{150,60},{150,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(cwCon.TCWSup, TCWSup.busCon) annotation (Line(
      points={{-200,60},{-110,60},{-110,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(dpCHW.port_b, port_a) annotation (Line(points={{190,10},{196,10},{196,
          10},{200,10}}, color={0,127,255}));
  connect(VSCHW_flow.busCon, chwCon.VSCHW_flow) annotation (Line(
      points={{150,20},{150,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(dpCHW.busCon, chwCon.dpCHW) annotation (Line(
      points={{180,20},{180,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chwCon.pumGro,pumPri.busCon)  annotation (Line(
      points={{200.1,60.1},{10,60.1},{10,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWSup.busCon, chwCon.TCHWSup) annotation (Line(
      points={{130,20},{130,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.ports_b, chi.ports_a1) annotation (Line(points={{-80,-10},{-70,
          -10},{-70,30},{-46,30},{-46,20}}, color={0,127,255}));
  connect(pumPri.port_wse, WSE.port_a1) annotation (Line(points={{-80,-16},{-70,
          -16},{-70,-50},{-46,-50},{-46,-62}}, color={0,127,255}));
  connect(chi.port_b1, mixCW.port_3) annotation (Line(points={{-46,0},{-46,-40},
          {-90,-40},{-90,-60}}, color={0,127,255}));
  connect(WSE.port_b1, mixCW.port_2) annotation (Line(points={{-46,-82},{-46,
          -88},{-70,-88},{-70,-70},{-80,-70}}, color={0,127,255}));
  connect(con.busCon, cwCon) annotation (Line(
      points={{-58,90},{-174,90},{-174,60},{-200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.busCHW, chwCon) annotation (Line(
      points={{-38,90},{-30,90},{-30,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCWSup.y, cwCon.TCWSup) annotation (Line(points={{-130,2},{-130,60},{
          -200,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCWRet.y, cwCon.TCWRet) annotation (Line(points={{-130,-58},{-130,-40},
          {-150,-40},{-150,60},{-200,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCHWRetByp.y, chwCon.TCHWRetByp) annotation (Line(points={{30,-38},{
          30,60},{200,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end WaterCooledSeries;
