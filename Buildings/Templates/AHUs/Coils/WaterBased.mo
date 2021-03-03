within Buildings.Experimental.Templates.AHUs.Coils;
model WaterBased
  extends Interfaces.Coil(
    final typ=Types.Coil.WaterBased,
    final have_sou=true,
    final typAct=act.typ,
    final typHex=coi.typ);

  replaceable Actuators.None act
    constrainedby Interfaces.Actuator(
      redeclare final package Medium = MediumSou)
    "Actuator"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-70},{10,-50}})));

  replaceable HeatExchangers.EffectivenessNTU coi
    constrainedby Interfaces.HeatExchanger(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir)
    "Coil"
    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{10,4},{-10,-16}})));

equation
  connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(ahuBus.ahuO.yCoiCoo, act.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-40,80},{-40,-60},{-11,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(act.port_bSup, coi.port_a1) annotation (Line(points={{-4,-50},{-4,-22},
          {20,-22},{20,-12},{10,-12}}, color={0,127,255}));
  connect(coi.port_b1, act.port_aRet) annotation (Line(points={{-10,-12},{-20,-12},
          {-20,-24},{4,-24},{4,-50}}, color={0,127,255}));
  connect(port_a, coi.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b2, port_b) annotation (Line(points={{10,0},{56,0},{56,0},{100,
          0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WaterBased;
