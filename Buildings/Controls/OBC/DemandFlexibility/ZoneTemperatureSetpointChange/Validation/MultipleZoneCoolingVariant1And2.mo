within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model MultipleZoneCoolingVariant1And2
  "Validation model for multiple-zone cooling temperature setpoint change with Variant 1 and 2"

  parameter Integer nZon(min=1)=5
    "Number of zones in the building";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant rouZonFla(k=false)
    "Rogue zone flag"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Setpoints zonSetGen(
    TDefOccHeaSet=273.15 + 20,
    TDefUnoHeaSet=273.15 + 12,
    TDefOccCooSet=273.15 + 24,
    TDefUnoCooSet=273.15 + 32,
    dTSheHeaSet=4,
    dTSheCooSet=4,
    dTPreHeaSet=1.5,
    dTPreCooSet=1.5,
    occHouSta=7,
    occHouEnd=23.5,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable tabTCurZon(
    table=[0,273.15 + 18; 4,273.15 + 14; 5,273.15 + 14; 11,273.15 + 20;
      16,273.15 + 22; 18,273.15 + 28.5; 19,273.15 + 28; 19.25,273.15 + 33.5;
      20,273.15 + 34; 21,273.15 + 31; 22,273.15 + 22; 24,273.15 + 18],
    timeScale=3600)
    "A table of a current zone temperature profile that repeats every day"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar2[nZon](
      samplePeriod=fill(10, nZon),
     y_start=fill(273.15 + 20, nZon))
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 2 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={90,-110})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConCooVar2(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    TResInt=0.5,
    setChaWaiTim=150,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
    nZon=nZon,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_2)
    "A zone temperature setpoint change controller for cooling under Variant 2 of zone control"
    annotation (Placement(transformation(extent={{40,-128},{60,-92}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResVar2[nZon](
    resInt=fill(0.1, nZon),
    refSet=fill(293.15, nZon))
    "Add setpoint resolution for Variant 2 of zone control"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rouZonFlaRep(nout=nZon)
    "Replicate the rogue zone flag"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TCurZonRep(nout=nZon)
    "Replicate the current zone temperature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TBia[nZon](p={1,0.5,0,-0.5,-1})
    "Use different temperature bias values to make zone temperature different for different zones"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TPreTarCooSetRep(nout=nZon)
    "Replicate the pre-cool target cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSheTarCooSetRep(nout=nZon)
    "Replicate the load-shed target cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TDefCooSetRep(nout=nZon)
    "Replicate the default cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConCooVar1(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    TResInt=0.5,
    setChaWaiTim=600,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
    nZon=nZon,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1)
    "A zone temperature setpoint change controller for cooling under Variant 1 of zone control"
    annotation (Placement(transformation(extent={{40,92},{60,128}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar1[nZon](
    samplePeriod=fill(10, nZon),
    y_start=fill(273.15 + 20, nZon))
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 1 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={90,110})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResVar1[nZon](
    resInt=fill(0.1, nZon),
    refSet=fill(293.15, nZon))
    "Add setpoint resolution for Variant 1 of zone control"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
equation
  connect(rouZonFla.y, rouZonFlaRep.u)
    annotation (Line(points={{-118,110},{-102,110}}, color={255,0,255}));
  connect(rouZonFlaRep.y, setChaConCooVar2.rouZonFla)
    annotation (Line(points={{-78,110},{-30,110},{-30,-94},{38,-94}},
      color={255,0,255}));
  connect(tabTCurZon.y[1], TCurZonRep.u)
    annotation (Line(points={{-118,50},{-102,50}}, color={0,0,127}));
  connect(setChaConCooVar2.TComZonSet, delTZonSetVar2.u)
    annotation (Line(points={{62,-110},{78,-110}}, color={0,0,127}));
  connect(delTZonSetVar2.y, setResVar2.uSet)
    annotation (Line(points={{102,-110},{118,-110}}, color={0,0,127}));
  connect(TCurZonRep.y, TBia.u)
    annotation (Line(points={{-78,50},{-62,50}}, color={0,0,127}));
  connect(TBia.y, setChaConCooVar2.TCurZon)
    annotation (Line(points={{-38,50},{-20,50},{-20,-106},{38,-106}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar2.demFleMod)
    annotation (Line(points={{-118,-10},{-10,-10},{-10,-114},{38,-114}},
      color={255,127,0}));
  connect(zonSetGen.TPreTarCooSet, TPreTarCooSetRep.u)
    annotation (Line(points={{-118,-132},{-110,-132},{-110,-50},{-82,-50}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, TSheTarCooSetRep.u)
    annotation (Line(points={{-118,-136},{-100,-136},{-100,-90},{-82,-90}},
      color={0,0,127}));
  connect(zonSetGen.TDefCooSet, TDefCooSetRep.u)
    annotation (Line(points={{-118,-140},{-90,-140},{-90,-130},{-82,-130}},
      color={0,0,127}));
  connect(TPreTarCooSetRep.y, setChaConCooVar2.TPreTarSet)
    annotation (Line(points={{-58,-50},{0,-50},{0,-118},{38,-118}},
      color={0,0,127}));
  connect(TSheTarCooSetRep.y, setChaConCooVar2.TSheTarSet)
    annotation (Line(points={{-58,-90},{10,-90},{10,-122},{38,-122}},
      color={0,0,127}));
  connect(TDefCooSetRep.y, setChaConCooVar2.TDefSet)
    annotation (Line(points={{-58,-130},{20,-130},{20,-126},{38,-126}},
      color={0,0,127}));
  connect(setResVar2.ySet, setChaConCooVar2.TCurZonSet)
    annotation (Line(points={{142,-110},{150,-110},{150,-140},{30,-140},{30,-110},
      {38,-110}}, color={0,0,127}));
  connect(rouZonFlaRep.y, setChaConCooVar1.rouZonFla)
    annotation (Line(points={{-78,110},{-30,110},{-30,126},{38,126}},
      color={255,0,255}));
  connect(setChaConCooVar1.TComZonSet, delTZonSetVar1.u)
    annotation (Line(points={{62,110},{78,110}}, color={0,0,127}));
  connect(delTZonSetVar1.y, setResVar1.uSet)
    annotation (Line(points={{102,110},{112,110},{112,110},{118,110}},
      color={0,0,127}));
  connect(setResVar1.ySet, setChaConCooVar1.TCurZonSet)
    annotation (Line(points={{142,110},{150,110},{150,80},{30,80},{30,110},{38,110}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar1.demFleMod)
    annotation (Line(points={{-118,-10},{-10,-10},{-10,106},{38,106}},
      color={255,127,0}));
  connect(TBia.y, setChaConCooVar1.TCurZon)
    annotation (Line(points={{-38,50},{-20,50},{-20,114},{38,114}},
      color={0,0,127}));
  connect(TPreTarCooSetRep.y, setChaConCooVar1.TPreTarSet)
    annotation (Line(points={{-58,-50},{0,-50},{0,102},{38,102}}, color={0,0,127}));
  connect(TSheTarCooSetRep.y, setChaConCooVar1.TSheTarSet)
    annotation (Line(points={{-58,-90},{10,-90},{10,98},{38,98}}, color={0,0,127}));
  connect(TDefCooSetRep.y, setChaConCooVar1.TDefSet)
    annotation (Line(points={{-58,-130},{20,-130},{20,94},{38,94}},
      color={0,0,127}));
  annotation (experiment(
      StartTime=43200,
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Validation/MultipleZoneCoolingVariant1And2.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling</a>
for the cooling operation of a 5-zone building under Variant <i>1</i> and Variant
<i>2</i> of zone temperature setpoint control.
</p>
</html>",revisions="<html>
<ul>
<li>
August 25, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-160},{160,
            160}})));
end MultipleZoneCoolingVariant1And2;
