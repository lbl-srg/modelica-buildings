within Buildings.Templates.ChilledWaterPlant;
model WaterCooledChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledChiller);
  extends
    Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialChilledWaterLoop;
  extends
    Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialCondenserWaterLoop;
equation
  connect(secPum.port_b, port_a)
    annotation (Line(points={{180,-10},{200,-10}}, color={0,127,255}));
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(secPum.busCon, chwCon.secPum) annotation (Line(
      points={{170,0},{170,40.1},{200.1,40.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(priPum.busCon, chwCon.priPum) annotation (Line(
      points={{90,0},{90,40.1},{200.1,40.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chi.busCon, chwCon.chi) annotation (Line(
      points={{-12,-10},{-20,-10},{-20,40},{90,40},{90,40.1},{200.1,40.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(comLeg.busCon, chwCon.comLeg) annotation (Line(
      points={{50,-30},{50,40.1},{200.1,40.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(wse.busCon, chwCon.wse) annotation (Line(
      points={{-12,-70},{-20,-70},{-20,40},{90,40},{90,40.1},{200.1,40.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWRet.T, chwCon.inp.TCHWRet) annotation (Line(points={{150,-59},{150,
          40},{200,40}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(cwSupSpl.port_2, chi.port_a1) annotation (Line(points={{-40,-10},{-30,
          -10},{-30,10},{-8,10},{-8,0}}, color={0,127,255}));
  connect(cwRetSpl.port_2, wse.port_b1) annotation (Line(points={{-40,-70},{-30,
          -70},{-30,-92},{-8,-92},{-8,-80}}, color={0,127,255}));
  connect(chi.port_b1, wse.port_a1)
    annotation (Line(points={{-8,-20},{-8,-60}}, color={0,127,255}));
  connect(secPum.port_b, port_a)
    annotation (Line(points={{180,-10},{200,-10}}, color={0,127,255}));
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(cwCon.cooTow, cooTow.busCon) annotation (Line(
      points={{-199.9,40.1},{-170,40.1},{-170,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cwCon.conPum, conPum.busCon) annotation (Line(
      points={{-199.9,40.1},{-130,40.1},{-130,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCWSup.T, cwCon.inp.TCWSup) annotation (Line(points={{-90,1},{-90,40},
          {-200,40}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, cooTow.weaBus) annotation (Line(
      points={{0,100},{0,50},{-165,50},{-165,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end WaterCooledChilledWaterPlant;
