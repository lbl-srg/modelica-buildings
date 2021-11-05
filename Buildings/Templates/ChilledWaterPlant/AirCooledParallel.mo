within Buildings.Templates.ChilledWaterPlant;
model AirCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.AirCooledChiller);
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final is_airCoo=true,
    redeclare final Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel chi(
        has_dedPum=pumPri.is_dedicated));

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Controls.OpenLoop
    con constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController
      annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,90})));

equation
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(dpCHW.port_b, port_a)
    annotation (Line(points={{190,10},{200,10}}, color={0,127,255}));
  connect(TCHWRetByp.y, chwCon.TRetByp) annotation (Line(points={{30,-38},{30,
          60},{200,60}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWSup.y, chwCon.TSup) annotation (Line(points={{130,22},{130,60},{
          200,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWRet.y, chwCon.TRet) annotation (Line(points={{150,-58},{150,60},{
          200,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(dpCHW.y, chwCon.dp) annotation (Line(points={{180,22},{180,60},{200,
          60}},                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.busCon, chwCon.pumGro) annotation (Line(
      points={{10,20},{10,60.1},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chi.busCon, chwCon.chi) annotation (Line(
      points={{-50,10},{-60,10},{-60,60.1},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(WSE.busCon, chwCon.wse) annotation (Line(
      points={{-50,-72},{-60,-72},{-60,60.1},{200.1,60.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.busCon, cwCon) annotation (Line(
      points={{-60,90},{-174,90},{-174,60},{-200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.busCHW, chwCon) annotation (Line(
      points={{-40,90},{-24,90},{-24,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-200,-100},{200,100}})), Icon(
        coordinateSystem(extent={{-200,-100},{200,100}})));
end AirCooledParallel;
