within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model SingleZoneCoolingVariant1And2
  "Validation model for single zone cooling temperature setpoint change with Variant 1 and 2"

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar1(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 1 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={50,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conRouZonFla(
    k=false)
    "Boolean constant for the rogue zone flag"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
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
    occHouSta=7,
    occHouEnd=19,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConCooVar1(
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
    annotation (Placement(transformation(extent={{0,52},{20,88}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable tabTCurZon(table=[0,273.15 +
        18; 4,273.15 + 14; 5,273.15 + 14; 11,273.15 + 20; 16,273.15 + 22; 18,273.15
         + 28.5; 19,273.15 + 28; 19.25,273.15 + 33.5; 20,273.15 + 34; 21,273.15 +
        31; 22,273.15 + 22; 24,273.15 + 18],
    timeScale=3600)
    "A table of a current zone temperature profile that repeats every day"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetVar2(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received; used for Variant 2 of zone control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={50,-70})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling setChaConCooVar2(
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
    annotation (Placement(transformation(extent={{0,-88},{20,-52}})));
  Generic.SetpointResolution setResVar1(resInt=0.1, refSet=293.15)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Generic.SetpointResolution setResVar2(resInt=0.1, refSet=293.15)
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
equation
  connect(zonSetGen.TPreTarCooSet, setChaConCooVar1.TPreTarSet[1])
    annotation (Line(points={{-98,-132},{-40,-132},{-40,62},{-2,62}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, setChaConCooVar1.TSheTarSet[1])
    annotation (Line(points={{-98,-136},{-30,-136},{-30,58},{-2,58}},
      color={0,0,127}));
  connect(zonSetGen.TDefCooSet, setChaConCooVar1.TDefSet[1])
    annotation (Line(points={{-98,-140},{-20,-140},{-20,54},{-2,54}},
                                                                  color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar1.demFleMod)
    annotation (Line(points={{-98,-10},{-60,-10},{-60,66},{-2,66}},
      color={255,127,0}));
  connect(conRouZonFla.y, setChaConCooVar1.rouZonFla[1])
    annotation (Line(points={{-98,110},{-50,110},{-50,86},{-2,86}},
      color={255,0,255}));
  connect(tabTCurZon.y[1], setChaConCooVar1.TCurZon[1])
    annotation (Line(points={{-98,50},{-80,50},{-80,74},{-2,74}}, color={0,0,127}));
  connect(zonSetGen.TPreTarCooSet, setChaConCooVar2.TPreTarSet[1])
    annotation (Line(points={{-98,-132},{-40,-132},{-40,-78},{-2,-78}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, setChaConCooVar2.TSheTarSet[1])
    annotation (Line(points={{-98,-136},{-30,-136},{-30,-82},{-2,-82}},
      color={0,0,127}));
  connect(zonSetGen.TDefCooSet, setChaConCooVar2.TDefSet[1])
    annotation (Line(points={{-98,-140},{-20,-140},{-20,-86},{-2,-86}},
      color={0,0,127}));
  connect(conRouZonFla.y, setChaConCooVar2.rouZonFla[1])
    annotation (Line(points={{-98,110},{-50,110},{-50,-54},{-2,-54}},
      color={255,0,255}));
  connect(tabTCurZon.y[1], setChaConCooVar2.TCurZon[1])
    annotation (Line(points={{-98,50},{-80,50},{-80,-66},{-2,-66}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1], setChaConCooVar2.demFleMod)
    annotation (Line(points={{-98,-10},{-60,-10},{-60,-74},{-2,-74}},
      color={255,127,0}));
  connect(setChaConCooVar1.TComZonSet[1], delTZonSetVar1.u)
    annotation (Line(points={{22,70},{38,70}}, color={0,0,127}));
  connect(setChaConCooVar2.TComZonSet[1], delTZonSetVar2.u)
    annotation (Line(points={{22,-70},{38,-70}}, color={0,0,127}));
  connect(delTZonSetVar1.y, setResVar1.uSet)
    annotation (Line(points={{62,70},{78,70}}, color={0,0,127}));
  connect(setResVar1.ySet, setChaConCooVar1.TCurZonSet[1]) annotation (Line(
        points={{102,70},{120,70},{120,28},{-10,28},{-10,70},{-2,70}}, color={0,
          0,127}));
  connect(delTZonSetVar2.y, setResVar2.uSet)
    annotation (Line(points={{62,-70},{78,-70}}, color={0,0,127}));
  connect(setResVar2.ySet, setChaConCooVar2.TCurZonSet[1]) annotation (Line(
        points={{102,-70},{120,-70},{120,-100},{-10,-100},{-10,-70},{-2,-70}},
        color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Validation/SingleZoneCoolingVariant1And2.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling</a>
for the cooling operation of a single zone building under Variant <i>1</i> and
Variant <i>2</i> of zone temperature setpoint control.
</p>
<p>
In this validation example, the single zone in the building is assumed to not be a
rogue zone. A table of daily demand flexibility modes and a daily current zone
temperature profile are provided as inputs. Two <code>HeatingOrCooling</code>
controller blocks are used to represent Variant <i>1</i> and Variant <i>2</i> each.
Two <code>UnitDelay</code> blocks emulate external zone temperature setpoint
controllers that have a small delay of setpoint change after a new setpoint is
received. The <code>zonSetGen</code> block generates zone setpoints and setpoint
targets in such a way that the setpoint change is active not only in the occupied
mode, but also in the unoccupied mode.
</p>
<p>
This validation example shows how the <code>HeatingOrCooling</code> controllers
respond to each of the demand flexibility modes, including the pre-cool mode, the
default mode, the load-shed mode, and the loadr-rebound mode, under Variant <i>1</i>
and Variant <i>2</i>. The <code>HeatingOrCooling</code> controller under Variant
<i>1</i> changes the zone cooling temperature setpoint in a single step for each of
the demand flexibility modes, whereas the <code>HeatingOrCooling</code> controller
under Variant <i>2</i> changes the zone cooling temperature setpoint in multiple
smaller steps.
</p>
</html>",revisions="<html>
<ul>
<li>
July 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-160},{140,
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-160},{140,
            160}})));
end SingleZoneCoolingVariant1And2;
