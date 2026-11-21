within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model SingleZoneHeatingVariant3And4
  "Validation model for single-zone heating temperature setpoint change with Variant 3 and 4"

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar3(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 3 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={90,30})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse rouZonFla(period=172800) "Rogue zone flag"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 2,0; 4,2; 9,3; 11,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller setChaConHeaVar3(
    dTPre=0.5,
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    PBuiRedDifMin=100,
    PBuiRed_nominal=5000,
    PBuiRedTarCon=1300,
    setChaWaiTim=300,
    TPreTarSet(each displayUnit="K") = fill(294.65, 1),
    TSheTarSet(each displayUnit="K") = fill(289.15, 1),
    TDefSet(each displayUnit="K") = fill(293.15, 1),
    occStaInt=true,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3)
    "A zone temperature setpoint change controller for heating under Variant 3 of zone control"
    annotation (Placement(transformation(extent={{40,12},{60,48}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable tabTCurZon(table=[0,273.15
         + 18; 0.25,273.15 + 20; 2,273.15 + 20; 2.25,273.15 + 21.5; 4,273.15 +
        21; 6,273.15 + 16; 7,273.15 + 15.5; 9,273.15 + 17; 10,273.15 + 20; 12,
        273.15 + 22; 16,273.15 + 23; 17,273.15 + 21; 24,273.15 + 18],
    timeScale=3600)
    "A table of a current zone temperature profile that repeats every day"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar4(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 4 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={90,-110})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Controller setChaConHeaVar4(
    dTPre=0.5,
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    PBuiRedDifMin=100,
    PBuiRed_nominal=5000,
    setChaWaiTim=300,
    TPreTarSet(each displayUnit="K") = fill(294.65, 1),
    TSheTarSet(each displayUnit="K") = fill(289.15, 1),
    TDefSet(each displayUnit="K") = fill(293.15, 1),
    occStaInt=true,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4)
    "A zone temperature setpoint change controller for heating under Variant 4 of zone control"
    annotation (Placement(transformation(extent={{40,-128},{60,-92}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiRed(
    amplitude=500,
    freqHz=1/86400,
    offset=900) "Actual electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin PBuiRedTarVar(
    amplitude=305,
    freqHz=1/86400,
    offset=1000) "Variable target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  CDL.Logical.Sources.Constant staZonFla(k=false) "Starved zone flag"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Subsequences.Qualification qua(
    nZon=1,
    TZonMax(each displayUnit="K") = fill(301.15, 1),
    TZonHys=1,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling)
    "The zone qualification block"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Logical.Sources.TimeTable occSta(
    table=[0,1; 7,1; 19,0; 24,1],
    timeScale=3600,
    period=86400) "Occupancy status"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(tabDemFleMod.y[1],setChaConHeaVar3. demFleMod)
    annotation (Line(points={{-58,-50},{-20,-50},{-20,14.5714},{38,14.5714}},
      color={255,127,0}));
  connect(tabTCurZon.y[1],setChaConHeaVar3. TCurZon[1])
    annotation (Line(points={{-58,10},{-40,10},{-40,24.8571},{38,24.8571}},
                                                                  color={0,0,127}));
  connect(tabTCurZon.y[1],setChaConHeaVar4. TCurZon[1])
    annotation (Line(points={{-58,10},{-40,10},{-40,-115.143},{38,-115.143}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1],setChaConHeaVar4. demFleMod)
    annotation (Line(points={{-58,-50},{-20,-50},{-20,-125.429},{38,-125.429}},
      color={255,127,0}));
  connect(setChaConHeaVar3.TComZonSet[1],delTZonSetVar3. u)
    annotation (Line(points={{62,30},{78,30}}, color={0,0,127}));
  connect(setChaConHeaVar4.TComZonSet[1],delTZonSetVar4. u)
    annotation (Line(points={{62,-110},{78,-110}},
                                                 color={0,0,127}));
  connect(PBuiRed.y, setChaConHeaVar3.PBuiRed)
    annotation (Line(points={{-98,50},{-30,50},{-30,30},{38,30}}, color={0,0,127}));
  connect(PBuiRed.y, setChaConHeaVar4.PBuiRed)
    annotation (Line(points={{-98,50},{-30,50},{-30,-110},{38,-110}},
      color={0,0,127}));
  connect(PBuiRedTarVar.y, setChaConHeaVar4.PBuiRedTarVar)
    annotation (Line(points={{-58,-130},{-50,-130},{-50,-104.857},{38,-104.857}},
      color={0,0,127}));
  connect(delTZonSetVar3.y, setChaConHeaVar3.TCurZonSet[1]) annotation (Line(
        points={{102,30},{120,30},{120,0},{30,0},{30,19.7143},{38,19.7143}},
                                                                      color={0,
          0,127}));
  connect(delTZonSetVar4.y, setChaConHeaVar4.TCurZonSet[1]) annotation (Line(
        points={{102,-110},{120,-110},{120,-140},{30,-140},{30,-120.286},{38,
          -120.286}},
        color={0,0,127}));
  connect(qua.yQua, setChaConHeaVar3.uQua) annotation (Line(points={{-18,90},{
          -10,90},{-10,40.2857},{38,40.2857}},
                                  color={255,0,255}));
  connect(qua.yQua, setChaConHeaVar4.uQua) annotation (Line(points={{-18,90},{
          -10,90},{-10,-99.7143},{38,-99.7143}},
                                    color={255,0,255}));
  connect(rouZonFla.y, qua.uRogZon[1]) annotation (Line(points={{-98,90},{-80,
          90},{-80,84},{-42,84}},     color={255,0,255}));
  connect(staZonFla.y, qua.uStaZon[1]) annotation (Line(points={{-98,130},{-60,
          130},{-60,90},{-42,90}},    color={255,0,255}));
  connect(tabTCurZon.y[1], qua.TZon[1]) annotation (Line(points={{-58,10},{-50,
          10},{-50,96},{-42,96}},
                                color={0,0,127}));
  connect(occSta.y[1], setChaConHeaVar4.occSta) annotation (Line(points={{-58,-90},
          {0,-90},{0,-94.5714},{38,-94.5714}},color={255,0,255}));
  connect(occSta.y[1], setChaConHeaVar3.occSta) annotation (Line(points={{-58,-90},
          {0,-90},{0,45.4286},{38,45.4286}},color={255,0,255}));
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
<p>
A
<a href=\"Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification</a>
block is used to indicate whether a zone is qualified for the setpoint change operation.
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
