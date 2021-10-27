within Buildings.Templates.ChilledWaterPlant;
model AirCooledChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.AirCooledChiller);
  extends
    Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialChilledWaterLoop(
    final is_airCoo=true);
equation
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(chi.busCon, chwCon.chi) annotation (Line(
      points={{-50,10},{-60,10},{-60,60.1},{200.1,60.1}},
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
  connect(chwCon.TCHWRet, TCHWRet.busCon) annotation (Line(
      points={{200,60},{150,60},{150,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
  connect(dpCHW.port_b, port_a)
    annotation (Line(points={{190,10},{200,10}}, color={0,127,255}));
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
end AirCooledChilledWaterPlant;
