within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model Adjustment "Zone setpoint adjustment"

  Buildings.Controls.OBC.CDL.Discrete.Sampler samSinSte(
    samplePeriod=300)
    "Sample period for single-step cooling setpoint change"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetSinSte(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received, used for single-step cooling setpoint change"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={70,50})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment
    zonSetAdjSinSte(airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
      use_mulSteSetCha=false)
    "Zone setpoint adjustment block for single-step cooling setpoint change"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uEnaVar(
    period=172800)
    "Boolean variable to enable setpoint change when true"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
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
    occHouEnd=19,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment
    zonSetAdjMulSte(
    dTPre=0.5,
    dTShe=0.5,
    dTReb=0.5,
    airConMod=Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
    use_mulSteSetCha=true)
    "Zone setpoint adjustment block for incremental, multiple-step cooling setpoint change"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samMulSte(
    samplePeriod=300)
    "Sample period for multiple-step cooling setpoint change"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay delTZonSetMulSte(
    samplePeriod=10,
    y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received, used for multiple-step cooling setpoint change"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={70,-50})));
equation
  connect(uEnaVar.y, zonSetAdjSinSte.uEna) annotation (Line(points={{-118,70},{
          -100,70},{-100,58.3333},{-22,58.3333}},
                                        color={255,0,255}));
  connect(zonSetAdjSinSte.TComZonSet, samSinSte.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(samSinSte.y, delTZonSetSinSte.u)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(zonSetGen.TPreTarCooSet, zonSetAdjSinSte.TPreTarSet) annotation (Line(
        points={{-118,-72},{-60,-72},{-60,48.3333},{-22,48.3333}},
                                                         color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonSetAdjSinSte.TSheTarSet) annotation (Line(
        points={{-118,-75},{-50,-75},{-50,45},{-22,45}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonSetAdjSinSte.TDefSet) annotation (Line(
        points={{-118,-78},{-40,-78},{-40,41.6667},{-22,41.6667}},
                                                         color={0,0,127}));
  connect(tabDemFleMod.y[1], zonSetAdjSinSte.demFleMod) annotation (Line(points={{-118,10},
          {-80,10},{-80,55},{-22,55}},           color={255,127,0}));
  connect(zonSetAdjMulSte.TComZonSet, samMulSte.u)
    annotation (Line(points={{2,-50},{18,-50}}, color={0,0,127}));
  connect(samMulSte.y, delTZonSetMulSte.u)
    annotation (Line(points={{42,-50},{58,-50}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], zonSetAdjMulSte.demFleMod) annotation (Line(points={{-118,10},
          {-80,10},{-80,-45},{-22,-45}},           color={255,127,0}));
  connect(uEnaVar.y, zonSetAdjMulSte.uEna) annotation (Line(points={{-118,70},{
          -100,70},{-100,-41.6667},{-22,-41.6667}},
                                          color={255,0,255}));
  connect(zonSetGen.TPreTarCooSet, zonSetAdjMulSte.TPreTarSet) annotation (Line(
        points={{-118,-72},{-60,-72},{-60,-51.6667},{-22,-51.6667}},
                                                           color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonSetAdjMulSte.TSheTarSet) annotation (Line(
        points={{-118,-75},{-50,-75},{-50,-55},{-22,-55}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonSetAdjMulSte.TDefSet) annotation (Line(
        points={{-118,-78},{-40,-78},{-40,-58.3333},{-22,-58.3333}},
                                                           color={0,0,127}));
  connect(delTZonSetSinSte.y, zonSetAdjSinSte.TCurZonSet) annotation (Line(
        points={{82,50},{120,50},{120,20},{-30,20},{-30,51.5},{-22,51.5}},
        color={0,0,127}));
  connect(delTZonSetMulSte.y, zonSetAdjMulSte.TCurZonSet) annotation (Line(
        points={{82,-50},{120,-50},{120,-80},{-30,-80},{-30,-48.5},{-22,-48.5}},
        color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Subsequences/Validation/Adjustment.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment</a>
for the cooling operation of a single zone under either a single-step setpoint
change operation or an incremental, multiple-step setpoint change operation.
</p>
</html>",revisions="<html>
<ul>
<li>
July 20, 2026, by Weiping Huang:<br/>
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-100},{160,
            100}})));
end Adjustment;
