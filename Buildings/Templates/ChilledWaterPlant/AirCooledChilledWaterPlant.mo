within Buildings.Templates.ChilledWaterPlant;
model AirCooledChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.AirCooledChiller);
  extends Buildings.Templates.BaseClasses.ChilledWaterPlant.PartialChilledWaterLoop(
    final is_airCoo=true);
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
      points={{50,-30},{50,40},{124,40},{124,40.1},{200.1,40.1}},
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
end AirCooledChilledWaterPlant;
