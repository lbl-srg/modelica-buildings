within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model SingleZoneHeatingVariant3And4
  "Validation model for single-zone heating temperature setpoint change with Variant 3 and 4"

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar3(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 3 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={50,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse rouZonFla(period=172800) "Rogue zone flag"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 2,0; 4,2; 9,3; 11,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneSetpointGeneration zonSetGen(
    TDefOccHeaSet=273.15 + 20,
    TDefUnoHeaSet=273.15 + 12,
    TDefOccCooSet=273.15 + 24,
    TDefUnoCooSet=273.15 + 32,
    dTSheHeaSet=4,
    dTSheCooSet=4,
    dTPreHeaSet=1.5,
    dTPreCooSet=1.5,
    occHouSta=0,
    occHouEnd=18,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConHeaVar3(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    PBuiHys=100,
    PBuiThrCon=1000,
    TResInt=0.5,
    setChaWaiTim=300,
    airConMod=true,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3)
    "A zone temperature setpoint change controller for heating under Variant 3 of zone control"
    annotation (Placement(transformation(extent={{0,52},{20,88}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable tabTCurZon(
    table=[0,273.15 + 18; 0.25,273.15 + 20; 2,273.15 + 20; 2.25,273.15 + 21.5;
      4,273.15 + 21; 6,273.15 + 16; 7,273.15 + 15.5; 9,273.15 + 17; 10,273.15 + 20;
      12,273.15 + 23; 16,273.15 + 27; 17,273.15 + 27; 24,273.15 + 18],
    timeScale=3600)
    "A table of a current zone temperature profile that repeats every day"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar4(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 4 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={50,-70})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConHeaVar4(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    PBuiHys=100,
    TResInt=0.5,
    setChaWaiTim=300,
    airConMod=true,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4)
    "A zone temperature setpoint change controller for heating under Variant 4 of zone control"
    annotation (Placement(transformation(extent={{0,-88},{20,-52}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResVar3(
    resInt=0.1,
    refSet=293.15) "Add setpoint resolution for Variant 3 of zone control"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResVar4(
    resInt=0.1,
    refSet=293.15) "Add setpoint resolution for Variant 4 of zone control"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBui(
    amplitude=200,
    freqHz=1/86400,
    offset=1000) "Electricity demand of the building"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiThrVar(
    amplitude=305,
    freqHz=1/86400,
    offset=1000)
    "Variable threshold for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
equation
  connect(zonSetGen.TPreTarHeaSet,setChaConHeaVar3. TPreTarSet[1])
    annotation (Line(points={{-98,-120},{-40,-120},{-40,62},{-2,62}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarHeaSet,setChaConHeaVar3. TSheTarSet[1])
    annotation (Line(points={{-98,-124},{-30,-124},{-30,58},{-2,58}},
      color={0,0,127}));
  connect(zonSetGen.TDefHeaSet,setChaConHeaVar3. TDefSet[1])
    annotation (Line(points={{-98,-128},{-20,-128},{-20,54},{-2,54}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1],setChaConHeaVar3. demFleMod)
    annotation (Line(points={{-98,-10},{-60,-10},{-60,66},{-2,66}},
      color={255,127,0}));
  connect(rouZonFla.y,setChaConHeaVar3. rouZonFla[1])
    annotation (Line(points={{-98,130},{-50,130},{-50,86},{-2,86}},
      color={255,0,255}));
  connect(tabTCurZon.y[1],setChaConHeaVar3. TCurZon[1])
    annotation (Line(points={{-98,50},{-80,50},{-80,74},{-2,74}}, color={0,0,127}));
  connect(zonSetGen.TPreTarHeaSet,setChaConHeaVar4. TPreTarSet[1])
    annotation (Line(points={{-98,-120},{-40,-120},{-40,-78},{-2,-78}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarHeaSet,setChaConHeaVar4. TSheTarSet[1])
    annotation (Line(points={{-98,-124},{-30,-124},{-30,-82},{-2,-82}},
      color={0,0,127}));
  connect(zonSetGen.TDefHeaSet,setChaConHeaVar4. TDefSet[1])
    annotation (Line(points={{-98,-128},{-20,-128},{-20,-86},{-2,-86}},
      color={0,0,127}));
  connect(rouZonFla.y,setChaConHeaVar4. rouZonFla[1])
    annotation (Line(points={{-98,130},{-50,130},{-50,-54},{-2,-54}},
      color={255,0,255}));
  connect(tabTCurZon.y[1],setChaConHeaVar4. TCurZon[1])
    annotation (Line(points={{-98,50},{-80,50},{-80,-66},{-2,-66}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1],setChaConHeaVar4. demFleMod)
    annotation (Line(points={{-98,-10},{-60,-10},{-60,-74},{-2,-74}},
      color={255,127,0}));
  connect(setChaConHeaVar3.TComZonSet[1],delTZonSetVar3. u)
    annotation (Line(points={{22,70},{38,70}}, color={0,0,127}));
  connect(setChaConHeaVar4.TComZonSet[1],delTZonSetVar4. u)
    annotation (Line(points={{22,-70},{38,-70}}, color={0,0,127}));
  connect(delTZonSetVar3.y,setResVar3. uSet)
    annotation (Line(points={{62,70},{78,70}}, color={0,0,127}));
  connect(setResVar3.ySet,setChaConHeaVar3. TCurZonSet[1])
    annotation (Line(points={{102,70},{120,70},{120,40},{-10,40},{-10,70},{-2,70}},
      color={0,0,127}));
  connect(delTZonSetVar4.y,setResVar4. uSet)
    annotation (Line(points={{62,-70},{78,-70}}, color={0,0,127}));
  connect(setResVar4.ySet,setChaConHeaVar4. TCurZonSet[1])
    annotation (Line(points={{102,-70},{120,-70},{120,-100},{-10,-100},{-10,-70},
      {-2,-70}}, color={0,0,127}));
  connect(PBui.y, setChaConHeaVar3.PBui)
    annotation (Line(points={{-98,90},{-70,90},{-70,82},{-2,82}}, color={0,0,127}));
  connect(PBui.y, setChaConHeaVar4.PBui)
    annotation (Line(points={{-98,90},{-70,90},{-70,-58},{-2,-58}},
      color={0,0,127}));
  connect(PBuiThrVar.y, setChaConHeaVar4.PBuiThrVar)
    annotation (Line(points={{-98,-90},{-90,-90},{-90,-62},{-2,-62}},
      color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Validation/SingleZoneHeatingVariant3And4.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling</a>
for the heating operation of a single zone building under Variant <i>3</i> and
Variant <i>4</i> of zone temperature setpoint control while responding to both a
rogue zone flag signal and the electricity demand of the building.
</p>
</html>",revisions="<html>
<ul>
<li>
August 25, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-160},{140,
            160}})));
end SingleZoneHeatingVariant3And4;
