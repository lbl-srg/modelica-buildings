within Buildings.Templates.ChilledWaterPlant;
model WaterCooledChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledChiller);
  extends
    Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialChilledWaterLoop(
      chi(redeclare final package Medium1=MediumCW),
      final is_airCoo=false);
  extends
    Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialCondenserWaterLoop;
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
  connect(splCWRet.port_2,WSE.port_b1)  annotation (Line(points={{-70,-70},{-66,
          -70},{-66,-96},{-46,-96},{-46,-82}},
                                             color={0,127,255}));
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
      points={{-199.9,60.1},{-140,60.1},{-140,0}},
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
  connect(splCWSup.port_2, chi.port_a1) annotation (Line(points={{-70,-10},{-66,
          -10},{-66,30},{-46,30},{-46,20}},
                                       color={0,127,255}));
  connect(chi.port_b1,WSE.port_a1)
    annotation (Line(points={{-46,0},{-46,-62},{-46,-62}},
                                                 color={0,127,255}));
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
  connect(chwCon.pumGro, pumGro.busCon) annotation (Line(
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
end WaterCooledChilledWaterPlant;
