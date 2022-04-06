within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model ModeAndSetPoints
  "Validate block for specifying zone mode and setpoints"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    modSetPoi(
    final have_winSen=false,
    final have_occSen=true)
    annotation (Placement(transformation(extent={{80,40},{100,64}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    final freqHz=1/28800) "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    final k=0)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=0)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=14400,
    final shift=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=14400,
    final width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerAdj(
    final k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800)
    "Cooling down time"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800)
    "Warm-up time"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=12.5)
    "Gain factor"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

equation
  connect(winSta.y, swi2.u2)
    annotation (Line(points={{-98,-30},{-30,-30},{-30,10},{-2,10}},
          color={255,0,255}));
  connect(winSta.y, swi1.u2)
    annotation (Line(points={{-98,-30},{-30,-30},{-30,-50},{-2,-50}},
          color={255,0,255}));
  connect(zerAdj.y, swi2.u1)
    annotation (Line(points={{-98,30},{-20,30},{-20,18},{-2,18}},color={0,0,127}));
  connect(zerAdj.y, swi1.u1)
    annotation (Line(points={{-98,30},{-20,30},{-20,-42},{-2,-42}},color={0,0,127}));
  connect(cooSetAdj.y, swi2.u3)
    annotation (Line(points={{-58,-10},{-40,-10},{-40,2},{-2,2}},  color={0,0,127}));
  connect(heaSetAdj.y, swi1.u3)
    annotation (Line(points={{-98,-70},{-40,-70},{-40,-58},{-2,-58}},  color={0,0,127}));
  connect(cooDowTim.y, modSetPoi.cooDowTim) annotation (Line(points={{-98,150},{
          60,150},{60,63},{78,63}}, color={0,0,127}));
  connect(warUpTim.y, modSetPoi.warUpTim) annotation (Line(points={{-58,130},{56,
          130},{56,61},{78,61}}, color={0,0,127}));
  connect(ramp2.y, sin2.u)
    annotation (Line(points={{-98,100},{-82,100}}, color={0,0,127}));
  connect(sin2.y, gai.u)
    annotation (Line(points={{-58,100},{-42,100}}, color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={0,0,127}));
  connect(zonTem.y, modSetPoi.TZon) annotation (Line(points={{22,100},{52,100},{
          52,57},{78,57}}, color={0,0,127}));
  connect(occSch.tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-59,76},{
          44,76},{44,53},{78,53}}, color={0,0,127}));
  connect(occSch.occupied, modSetPoi.uOcc) annotation (Line(points={{-59,64},{48,
          64},{48,55},{78,55}}, color={255,0,255}));
  connect(swi2.y, modSetPoi.cooSetAdj) annotation (Line(points={{22,10},{44,10},
          {44,49},{78,49}}, color={0,0,127}));
  connect(swi1.y, modSetPoi.heaSetAdj) annotation (Line(points={{22,-50},{48,-50},
          {48,47},{78,47}}, color={0,0,127}));
  connect(occSta.y, modSetPoi.uOccSen) annotation (Line(points={{-58,-100},{52,-100},
          {52,45},{78,45}}, color={255,0,255}));
  connect(cooDemLimLev.y, modSetPoi.uCooDemLimLev) annotation (Line(points={{-98,
          -120},{56,-120},{56,43},{78,43}}, color={255,127,0}));
  connect(heaDemLimLev.y, modSetPoi.uHeaDemLimLev) annotation (Line(points={{-58,
          -140},{60,-140},{60,41},{78,41}}, color={255,127,0}));
annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/ModeAndSetPoints.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
        Ellipse(lineColor={75,138,73},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor={0,0,255},
                fillColor={75,138,73},
                pattern=LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ModeAndSetPoints;
