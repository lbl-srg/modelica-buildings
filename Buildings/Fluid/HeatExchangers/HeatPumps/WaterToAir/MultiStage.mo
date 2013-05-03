within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir;
model MultiStage "Multi stage water to air heat pump"
  import Buildings;
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.PartialWaterToAir(
      heaMasFlo(calRecoverableWasteHeat=true));
  Buildings.Utilities.Math.IntegerReplicator intRep(nout=2)
    annotation (Placement(transformation(extent={{8,84},{20,96}})));
  Modelica.Blocks.Interfaces.IntegerInput heaSta
    "Heating stage (positive value, 0: off)"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.IntegerInput cooSta
    "Cooling stage (positive value, 0: off)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSelect modSel
    "Selects mode of operation of the heat pump"
    annotation (Placement(transformation(extent={{-74,38},{-62,50}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedSelect speSel(
    nHeaSta=datHP.nHeaSta,
    heaSpeSet=datHP.heaSta.spe,
    nCooSta=datHP.nCooSta,
    cooSpeSet=datHP.cooSta.spe)
    annotation (Placement(transformation(extent={{-52,20},{-40,32}})));
equation
  connect(intRep.y, dynStaSto.mode) annotation (Line(
      points={{20.6,90},{38,90},{38,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(cooSta,modSel. cooSta) annotation (Line(
      points={{-120,40},{-84,40},{-84,41.6},{-75.2,41.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaSta, modSel.heaSta) annotation (Line(
      points={{-120,100},{-80,100},{-80,46.4},{-75.2,46.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, intRep.u) annotation (Line(
      points={{-60.8,46.4},{-60,46.4},{-60,46},{-44,46},{-44,90},{6.8,90}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, heaMasFlo.mode) annotation (Line(
      points={{-60.8,46.4},{-30,46.4},{-30,10},{-5,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, speSel.mode) annotation (Line(
      points={{-60.8,46.4},{-56,46.4},{-56,28.4},{-52.6,28.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.stage, speSel.stage) annotation (Line(
      points={{-60.8,41.6},{-58,41.6},{-58,23.6},{-52.6,23.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speSel.speRat, heaMasFlo.speRat) annotation (Line(
      points={{-39.4,26},{-34,26},{-34,7.6},{-5,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end MultiStage;
