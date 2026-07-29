within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZoneControl "Zone control"

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
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl zonConSinSte(
    airConMod=false,
    incSetCha=false)
    "Zone control block for single-step cooling setpoint change"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uEnaVar(
    period=172800)
    "Boolean variable to enable setpoint change when true"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
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
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl zonConMulSte(
    dTShe=0.5,
    dTReb=0.5,
    airConMod=false,
    incSetCha=true)
    "Zone control block for incremental, multiple-step cooling setpoint change"
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
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResSinSte(
    resInt=0.1,
    refSet=293.15)
    "Add setpoint resolution for single-step cooling setpoint change"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setResMulSte(
    resInt=0.1,
    refSet=293.15)
    "Add setpoint resolution for multiple-step cooling setpoint change"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation
  connect(uEnaVar.y, zonConSinSte.uEna)
    annotation (Line(points={{-118,70},{-100,70},{-100,60},{-22,60}},
      color={255,0,255}));
  connect(zonConSinSte.TComZonSet, samSinSte.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(samSinSte.y, delTZonSetSinSte.u)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(zonSetGen.TPreTarCooSet, zonConSinSte.TPreTarSet)
    annotation (Line(points={{-118,-72},{-60,-72},{-60,48},{-22,48}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonConSinSte.TSheTarSet)
    annotation (Line(points={{-118,-76},{-50,-76},{-50,44},{-22,44}},
      color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonConSinSte.TDefSet)
    annotation (Line(points={{-118,-80},{-40,-80},{-40,40},{-22,40}},
      color={0,0,127}));
  connect(tabDemFleMod.y[1], zonConSinSte.demFleMod)
    annotation (Line(points={{-118,10},{-80,10},{-80,56},{-22,56}},
      color={255,127,0}));
  connect(zonConMulSte.TComZonSet, samMulSte.u)
    annotation (Line(points={{2,-50},{18,-50}}, color={0,0,127}));
  connect(samMulSte.y, delTZonSetMulSte.u)
    annotation (Line(points={{42,-50},{58,-50}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], zonConMulSte.demFleMod)
    annotation (Line(points={{-118,10},{-80,10},{-80,-44},{-22,-44}},
      color={255,127,0}));
  connect(uEnaVar.y, zonConMulSte.uEna)
    annotation (Line(points={{-118,70},{-100,70},{-100,-40},{-22,-40}},
      color={255,0,255}));
  connect(zonSetGen.TPreTarCooSet, zonConMulSte.TPreTarSet)
    annotation (Line(points={{-118,-72},{-60,-72},{-60,-52},{-22,-52}},
      color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonConMulSte.TSheTarSet)
    annotation (Line(points={{-118,-76},{-50,-76},{-50,-56},{-22,-56}},
      color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonConMulSte.TDefSet)
    annotation (Line(points={{-118,-80},{-40,-80},{-40,-60},{-22,-60}},
      color={0,0,127}));
  connect(delTZonSetSinSte.y, setResSinSte.uSet)
    annotation (Line(points={{82,50},{98,50}}, color={0,0,127}));
  connect(delTZonSetMulSte.y, setResMulSte.uSet)
    annotation (Line(points={{82,-50},{98,-50}}, color={0,0,127}));
  connect(setResSinSte.ySet, zonConSinSte.TCurZonSet)
    annotation (Line(points={{122,50},{140,50},{140,20},{-30,20},{-30,51.8},
      {-22,51.8}}, color={0,0,127}));
  connect(setResMulSte.ySet, zonConMulSte.TCurZonSet)
    annotation (Line(points={{122,-50},{140,-50},{140,-80},{-30,-80},{-30,-48.2},
      {-22,-48.2}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointChange.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl</a>
for the cooling operation of a single zone under either a single-step setpoint
change operation or an incremental, multiple-step setpoint change operation.
</p>
<p>
In this validation example, the setpoint change enabling signal <code>uEna</code> is
set to <code>true</code> for the first day and <code>false</code> for the second day.
A table of daily demand flexibility modes is provided as an input. Two
<code>ZoneControl</code> controller blocks are used to represent the single-step
setpoint change operation and multiple-step setpoint change operation, respectively.
Two <code>UnitDelay</code> blocks emulate external zone temperature setpoint
controllers that have a small delay of setpoint change after a new setpoint is
received. Two <code>SetpointResolution</code> blocks emulate temperature setpoint
resolution in the external zone temperature setpoint controllers. The
<code>zonSetGen</code> block generates zone setpoints and setpoint targets in such a
way that the setpoint change is active not only in the occupied mode, but also in
the unoccupied mode.
</p>
<p>
This validation example shows how the <code>ZoneControl</code> controllers respond
to each of the demand flexibility modes, including the pre-cool mode, the default
mode, the load-shed mode, and the load-rebound mode,under either a single-step
setpoint change operation or a multiple-step setpoint change operation.
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
end ZoneControl;
