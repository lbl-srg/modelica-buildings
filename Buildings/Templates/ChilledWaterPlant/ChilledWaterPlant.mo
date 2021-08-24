within Buildings.Templates.ChilledWaterPlant;
model ChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledChiller);
  BaseClasses.CoolingTowerGroup.CoolingTowerParallel cooTow
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  BaseClasses.PumpGroup.HeaderedPump conPum
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  BaseClasses.ChillerGroup.ChillerParallel chi
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  BaseClasses.WatersideEconomizer.WatersideEconomizer wse
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  BaseClasses.PumpGroup.HeaderedPump priPum
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  BaseClasses.PumpGroup.HeaderedPump secPum
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
equation
  connect(cooTow.port_b, conPum.port_a)
    annotation (Line(points={{-60,-10},{-40,-10}}, color={0,127,255}));
  connect(conPum.port_b, chi.port_a) annotation (Line(points={{-20,-10},{30,-10},
          {30,-6},{80,-6}}, color={0,127,255}));
  connect(chi.port_b, priPum.port_a) annotation (Line(points={{80,-14},{90,-14},
          {90,-10},{100,-10}}, color={0,127,255}));
  connect(priPum.port_b, secPum.port_a)
    annotation (Line(points={{120,-10},{160,-10}}, color={0,127,255}));
  connect(secPum.port_b, port_a) annotation (Line(points={{180,-10},{204,-10},{
          204,-20},{220,-20}}, color={0,127,255}));
  connect(port_b, wse.port_a2) annotation (Line(points={{220,-60},{46,-60},{46,
          -56},{40,-56}}, color={0,127,255}));
  connect(chiPlaCon, cooTow.busCon) annotation (Line(
      points={{-100,40},{-70,40},{-70,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chiPlaCon, conPum.busCon) annotation (Line(
      points={{-100,40},{-30,40},{-30,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chiPlaCon, chi.busCon) annotation (Line(
      points={{-100,40},{70,40},{70,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chiPlaCon, priPum.busCon) annotation (Line(
      points={{-100,40},{110,40},{110,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chiPlaCon, secPum.busCon) annotation (Line(
      points={{-100,40},{170,40},{170,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wse.busCon, chiPlaCon) annotation (Line(
      points={{30,-40},{30,40},{-100,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {220,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,100}})));
end ChilledWaterPlant;
