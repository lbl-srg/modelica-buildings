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
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 2,0; 4,2; 9,3; 11,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Setpoints zonSetGen(
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
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller setChaConHeaVar3(
    dTPre=0.5,
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    PBuiRedDifMin=100,
    PBuiRed_nominal=5000,
    PBuiRedTarCon=1000,
    setChaWaiTim=300,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
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
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller setChaConHeaVar4(
    dTPre=0.5,
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    PBuiRedDifMin=100,
    PBuiRed_nominal=5000,
    setChaWaiTim=300,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4)
    "A zone temperature setpoint change controller for heating under Variant 4 of zone control"
    annotation (Placement(transformation(extent={{0,-88},{20,-52}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiRed(
    amplitude=500,
    freqHz=1/86400,
    offset=900) "Actual electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiRedTarVar(
    amplitude=305,
    freqHz=1/86400,
    offset=1000) "Variable target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  CDL.Logical.Sources.Constant staZonFla(k=false) "starved zone flag"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Subsequences.Qualification qua(
    nZon=1,
    TZonMax(each displayUnit="K") = fill(301.15, 1),
    TZonHys=1,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling)
    "The zone qualification block"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
equation
  connect(zonSetGen.TPreTarHeaSet,setChaConHeaVar3. TPreTarSet[1])
    annotation (Line(points={{-98,-122},{-40,-122},{-40,62},{-2,62}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarHeaSet,setChaConHeaVar3. TSheTarSet[1])
    annotation (Line(points={{-98,-125},{-30,-125},{-30,58},{-2,58}},
      color={0,0,127}));
  connect(zonSetGen.TDefHeaSet,setChaConHeaVar3. TDefSet[1])
    annotation (Line(points={{-98,-128},{-20,-128},{-20,54},{-2,54}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1],setChaConHeaVar3. demFleMod)
    annotation (Line(points={{-98,-10},{-60,-10},{-60,66},{-2,66}},
      color={255,127,0}));
  connect(tabTCurZon.y[1],setChaConHeaVar3. TCurZon[1])
    annotation (Line(points={{-98,50},{-80,50},{-80,74},{-2,74}}, color={0,0,127}));
  connect(zonSetGen.TPreTarHeaSet,setChaConHeaVar4. TPreTarSet[1])
    annotation (Line(points={{-98,-122},{-40,-122},{-40,-78},{-2,-78}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarHeaSet,setChaConHeaVar4. TSheTarSet[1])
    annotation (Line(points={{-98,-125},{-30,-125},{-30,-82},{-2,-82}},
      color={0,0,127}));
  connect(zonSetGen.TDefHeaSet,setChaConHeaVar4. TDefSet[1])
    annotation (Line(points={{-98,-128},{-20,-128},{-20,-86},{-2,-86}},
      color={0,0,127}));
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
  connect(PBuiRed.y, setChaConHeaVar3.PBuiRed)
    annotation (Line(points={{-138,90},{-70,90},{-70,78},{-2,78}},color={0,0,127}));
  connect(PBuiRed.y, setChaConHeaVar4.PBuiRed)
    annotation (Line(points={{-138,90},{-70,90},{-70,-62},{-2,-62}},
      color={0,0,127}));
  connect(PBuiRedTarVar.y, setChaConHeaVar4.PBuiRedTarVar)
    annotation (Line(points={{-98,-90},{-90,-90},{-90,-58},{-2,-58}},
      color={0,0,127}));
  connect(delTZonSetVar3.y, setChaConHeaVar3.TCurZonSet[1]) annotation (Line(
        points={{62,70},{100,70},{100,40},{-10,40},{-10,70},{-2,70}}, color={0,
          0,127}));
  connect(delTZonSetVar4.y, setChaConHeaVar4.TCurZonSet[1]) annotation (Line(
        points={{62,-70},{100,-70},{100,-100},{-10,-100},{-10,-70},{-2,-70}},
        color={0,0,127}));
  connect(qua.yQua, setChaConHeaVar3.uQua) annotation (Line(points={{-58,130},{-50,
          130},{-50,86},{-2,86}}, color={255,0,255}));
  connect(qua.yQua, setChaConHeaVar4.uQua) annotation (Line(points={{-58,130},{-50,
          130},{-50,-54},{-2,-54}}, color={255,0,255}));
  connect(rouZonFla.y, qua.uRogZon[1]) annotation (Line(points={{-158,130},{-120,
          130},{-120,124},{-82,124}}, color={255,0,255}));
  connect(staZonFla.y, qua.uStaZon[1]) annotation (Line(points={{-158,170},{-100,
          170},{-100,130},{-82,130}}, color={255,0,255}));
  connect(tabTCurZon.y[1], qua.TZon[1]) annotation (Line(points={{-98,50},{-90,50},
          {-90,136},{-82,136}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Validation/SingleZoneHeatingVariant3And4.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller</a>
for the heating operation of a single-zone building under Variant <i>3</i> and
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
