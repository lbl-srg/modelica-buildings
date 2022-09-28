within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model ModeAndSetPoints
  "Validate block for specifying zone mode and setpoints"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    modSetPoi(
    final have_winSen=false,
    final have_occSen=true,
    have_locAdj=true,
    sepAdj=true,
    ignDemLim=false) "Operating mode and temperature setpoints"
    annotation (Placement(transformation(extent={{80,40},{100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    final freqHz=1/28800) "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    final k=0)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=0)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=14400,
    final shift=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=14400,
    final width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerAdj(
    final k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800)
    "Cooling down time"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800)
    "Warm-up time"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=12.5)
    "Gain factor"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  CDL.Continuous.Sources.Constant                        THeaSetOcc(final k=
        293.15) "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Continuous.Sources.Constant                        TCooSetOcc(final k=
        297.15) "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Continuous.Sources.Constant                        THeaSetUno(final k=
        285.15) "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Sources.Constant                        TCooSetUno(final k=
        303.15) "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
equation
  connect(winSta.y, swi2.u2)
    annotation (Line(points={{-98,-70},{-30,-70},{-30,-40},{-2,-40}},
          color={255,0,255}));
  connect(winSta.y, swi1.u2)
    annotation (Line(points={{-98,-70},{-30,-70},{-30,-80},{-2,-80}},
          color={255,0,255}));
  connect(zerAdj.y, swi2.u1)
    annotation (Line(points={{-98,-30},{-20,-30},{-20,-32},{-2,-32}},
                                                                 color={0,0,127}));
  connect(zerAdj.y, swi1.u1)
    annotation (Line(points={{-98,-30},{-20,-30},{-20,-72},{-2,-72}},
                                                                   color={0,0,127}));
  connect(cooSetAdj.y, swi2.u3)
    annotation (Line(points={{-58,-50},{-30,-50},{-30,-48},{-2,-48}},
                                                                   color={0,0,127}));
  connect(heaSetAdj.y, swi1.u3)
    annotation (Line(points={{-98,-100},{-40,-100},{-40,-88},{-2,-88}},color={0,0,127}));
  connect(cooDowTim.y, modSetPoi.cooDowTim) annotation (Line(points={{-98,160},
          {60,160},{60,78},{78,78}},color={0,0,127}));
  connect(warUpTim.y, modSetPoi.warUpTim) annotation (Line(points={{-58,140},{
          56,140},{56,76},{78,76}},
                                 color={0,0,127}));
  connect(ramp2.y, sin2.u)
    annotation (Line(points={{-98,110},{-82,110}}, color={0,0,127}));
  connect(sin2.y, gai.u)
    annotation (Line(points={{-58,110},{-42,110}}, color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-18,110},{-2,110}}, color={0,0,127}));
  connect(zonTem.y, modSetPoi.TZon) annotation (Line(points={{22,110},{52,110},
          {52,70},{78,70}},color={0,0,127}));
  connect(occSch.tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-59,6},{
          40,6},{40,56},{78,56}},  color={0,0,127}));
  connect(occSch.occupied, modSetPoi.u1Occ) annotation (Line(points={{-59,-6},{
          36,-6},{36,58},{78,58}}, color={255,0,255}));
  connect(swi2.y, modSetPoi.cooSetAdj) annotation (Line(points={{22,-40},{44,
          -40},{44,51},{78,51}},
                            color={0,0,127}));
  connect(swi1.y, modSetPoi.heaSetAdj) annotation (Line(points={{22,-80},{48,
          -80},{48,49},{78,49}},
                            color={0,0,127}));
  connect(occSta.y, modSetPoi.u1OccSen) annotation (Line(points={{-58,-120},{52,
          -120},{52,46},{78,46}}, color={255,0,255}));
  connect(cooDemLimLev.y, modSetPoi.uCooDemLimLev) annotation (Line(points={{-98,
          -140},{56,-140},{56,44},{78,44}}, color={255,127,0}));
  connect(heaDemLimLev.y, modSetPoi.uHeaDemLimLev) annotation (Line(points={{
          -58,-160},{60,-160},{60,42},{78,42}}, color={255,127,0}));
  connect(THeaSetOcc.y,modSetPoi.TOccHeaSet)  annotation (Line(points={{-58,80},
          {48,80},{48,67},{78,67}}, color={0,0,127}));
  connect(TCooSetOcc.y,modSetPoi.TOccCooSet)  annotation (Line(points={{-98,60},
          {24,60},{24,65},{78,65}}, color={0,0,127}));
  connect(TCooSetUno.y,modSetPoi.TUnoCooSet)  annotation (Line(points={{-98,20},
          {32,20},{32,61},{78,61}}, color={0,0,127}));
  connect(THeaSetUno.y,modSetPoi.TUnoHeaSet)  annotation (Line(points={{-58,40},
          {28,40},{28,63},{78,63}}, color={0,0,127}));
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
