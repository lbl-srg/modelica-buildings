within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model HeatingOrCooling "Validation model for the heating or cooling block"

  CDL.Discrete.UnitDelay delTZonSetVar1(samplePeriod=10, y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 1 of zone control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,70})));
  CDL.Logical.Sources.Constant conRouZonFla(k=false)
    "Boolean constant for the rogue zone flag"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400) "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Subsequences.ZoneSetpointGeneration zonSetGen(
    TDefOccHeaSet=273.15 + 20,
    TDefUnoHeaSet=273.15 + 12,
    TDefOccCooSet=273.15 + 24,
    TDefUnoCooSet=273.15 + 32,
    dTSheHeaSet=4,
    dTSheCooSet=4,
    dTPreHeaSet=1.5,
    dTPreCooSet=1.5,
    occHouSta=7,
    occHouEnd=19,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling
    setChaConCooVar1(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    TResInt=0.5,
    samPerSetCha=300,
    airConMod=false,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1)
    "A zone temperature setpoint change controller for cooling under Variant 1 of zone control"
    annotation (Placement(transformation(extent={{20,52},{40,88}})));
  CDL.Reals.Sources.TimeTable tabTCurZon(table=[0,273.15 + 18; 4,273.15 + 14; 5,
        273.15 + 14; 11,273.15 + 20; 16,273.15 + 22; 18,273.15 + 28.5; 19,
        273.15 + 28; 21,273.15 + 24; 22,273.15 + 22; 24,273.15 + 18], timeScale
      =3600)
    "A table of a current zone temperature profile that repeats every day"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Discrete.UnitDelay                        delTZonSetVar2(samplePeriod=10,
      y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 2 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={70,-70})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling
    setChaConCooVar2(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    TResInt=0.5,
    samPerSetCha=300,
    airConMod=false,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_2)
    "A zone temperature setpoint change controller for cooling under Variant 2 of zone control"
    annotation (Placement(transformation(extent={{20,-88},{40,-52}})));
equation
  connect(zonSetGen.TPreTarCooSet, setChaConCooVar1.TPreTarSet[1]) annotation (
      Line(points={{-78,-132},{-20,-132},{-20,62},{18,62}}, color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, setChaConCooVar1.TSheTarSet[1]) annotation (
      Line(points={{-78,-136},{-10,-136},{-10,58},{18,58}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, setChaConCooVar1.TDefSet[1]) annotation (Line(
        points={{-78,-140},{0,-140},{0,54},{18,54}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar1.demFleMod) annotation (Line(
        points={{-78,-10},{-40,-10},{-40,66},{18,66}}, color={255,127,0}));
  connect(conRouZonFla.y, setChaConCooVar1.rouZonFla[1]) annotation (Line(
        points={{-78,110},{-10,110},{-10,86},{18,86}}, color={255,0,255}));
  connect(delTZonSetVar1.y, setChaConCooVar1.TCurZonSet[1]) annotation (Line(
        points={{82,70},{100,70},{100,40},{10,40},{10,70},{18,70}}, color={0,0,
          127}));
  connect(tabTCurZon.y[1], setChaConCooVar1.TCurZon[1]) annotation (Line(points
        ={{-78,50},{-60,50},{-60,74},{18,74}}, color={0,0,127}));
  connect(delTZonSetVar2.y, setChaConCooVar2.TCurZonSet[1]) annotation (Line(
        points={{82,-70},{100,-70},{100,-100},{8,-100},{8,-70},{18,-70}}, color
        ={0,0,127}));
  connect(zonSetGen.TPreTarCooSet, setChaConCooVar2.TPreTarSet[1]) annotation (
      Line(points={{-78,-132},{-20,-132},{-20,-78},{18,-78}}, color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, setChaConCooVar2.TSheTarSet[1]) annotation (
      Line(points={{-78,-136},{-10,-136},{-10,-82},{18,-82}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, setChaConCooVar2.TDefSet[1]) annotation (Line(
        points={{-78,-140},{0,-140},{0,-86},{18,-86}}, color={0,0,127}));
  connect(conRouZonFla.y, setChaConCooVar2.rouZonFla[1]) annotation (Line(
        points={{-78,110},{-30,110},{-30,-54},{18,-54}}, color={255,0,255}));
  connect(tabTCurZon.y[1], setChaConCooVar2.TCurZon[1]) annotation (Line(points
        ={{-78,50},{-60,50},{-60,-66},{18,-66}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar2.demFleMod) annotation (Line(
        points={{-78,-10},{-40,-10},{-40,-74},{18,-74}}, color={255,127,0}));
  connect(setChaConCooVar1.TComZonSet[1], delTZonSetVar1.u)
    annotation (Line(points={{42,70},{58,70}}, color={0,0,127}));
  connect(setChaConCooVar2.TComZonSet[1], delTZonSetVar2.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointChange.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
July 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-120,-160},{120,
            160}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-160},{120,
            160}})));
end HeatingOrCooling;
