within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir;
model VariableSpeed "Variable speed water to air heat pump"

  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.PartialWaterToAir(
      heaMasFlo(calRecoverableWasteHeat=true));
  Buildings.Utilities.Math.IntegerReplicator intRep(nout=2)
    annotation (Placement(transformation(extent={{8,84},{20,96}})));
  Modelica.Blocks.Interfaces.RealInput heaSpeRat(final min=0, final max=1)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput cooSpeRat(final min=0, final max=1)
    "Cooling mode speed ratio"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioSelector speRatSel(
    cooModMinSpeRat=cooModMinSpeRat,
    cooModSpeRatDeaBan=cooModSpeRatDeaBan,
    heaModMinSpeRat=heaModMinSpeRat,
    heaModSpeRatDeaBan=heaModSpeRatDeaBan)
    annotation (Placement(transformation(extent={{-60,28},{-48,40}})));
  parameter Real cooModMinSpeRat(min=0,max=1)= 0.2
    "Minimum speed ratio in cooling mode";
  parameter Real cooModSpeRatDeaBan(min=0,max=1)= 0.05
    "Deadband for minimum speed ratio in cooling mode";
  parameter Real heaModMinSpeRat(min=0,max=1)= 0.2
    "Minimum speed ratio in heating mode";
  parameter Real heaModSpeRatDeaBan(min=0,max=1)= 0.05
    "Deadband for minimum speed ratio in heating mode";

equation
  connect(intRep.y, dynStaSto.mode) annotation (Line(
      points={{20.6,90},{38,90},{38,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaSpeRat, speRatSel.heaSpeRat) annotation (Line(
      points={{-120,100},{-86,100},{-86,37},{-61.2,37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat, speRatSel.cooSpeRat) annotation (Line(
      points={{-120,20},{-86,20},{-86,31},{-61.2,31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatSel.speRat, heaMasFlo.speRat) annotation (Line(
      points={{-47.4,31.6},{-34,31.6},{-34,7.6},{-5,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatSel.mode, heaMasFlo.mode) annotation (Line(
      points={{-47.4,36.4},{-30,36.4},{-30,10},{-5,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRatSel.mode, intRep.u) annotation (Line(
      points={{-47.4,36.4},{-30,36.4},{-30,90},{6.8,90}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end VariableSpeed;
