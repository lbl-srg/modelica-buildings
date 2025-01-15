within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation;
model ModeAndSetPoints
  "Validation models of reseting the zone setpoint temperature"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    setPoi(
    final have_winSen=false,
    final have_occSen=false,
    final cooAdj=true,
    final heaAdj=true) "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,68},{40,88}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    setPoi1(final have_occSen=true, final have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,28},{40,48}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    setPoi2(
    final have_winSen=false,
    final have_occSen=false,
    final cooAdj=true,
    final heaAdj=true) "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,-22},{40,-2}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    setPoi3(final have_occSen=true, final have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,-62},{40,-42}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5) "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,-2},{-26,18}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin cooSetAdj(
    final freqHz=1/28800) "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,38},{-26,58}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon1(
    final amplitude=5,
    final offset=18 + 273.15,
    final freqHz=1/86400) "Zone 1 temperature"
    annotation (Placement(transformation(extent={{-88,38},{-68,58}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon2(
    final offset=18 + 273.15,
    final freqHz=1/86400,
    final amplitude=7.5) "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta1(
    final k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-88,-82},{-68,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta2(
    final k=true)
    "Window status"
    annotation (Placement(transformation(extent={{-46,-82},{-26,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen1(
    final k=false)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-88,-42},{-68,-22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen2(
    final k=true)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-46,-42},{-26,-22}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev(
    final k=0) "Demand limit level"
    annotation (Placement(transformation(extent={{-66,-110},{-46,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant warCooTim(
    final k=1800)
    "Warm-up or cooldown time"
    annotation (Placement(transformation(extent={{-48,94},{-28,114}})));

equation
  connect(cooSetAdj.y, setPoi.setAdj)
    annotation (Line(points={{-24,48},{-20,48},{-20,76},{18,76}},
      color={0,0,127}));
  connect(heaSetAdj.y, setPoi.heaSetAdj)
    annotation (Line(points={{-24,8},{-16,8},{-16,74},{18,74}},
      color={0,0,127}));
  connect(occSen2.y, setPoi3.uOccSen) annotation (Line(points={{-24,-32},{-2,-32},
          {-2,-58},{18,-58}}, color={255,0,255}));
  connect(setPoi3.TZon, TZon2.y) annotation (Line(points={{18,-48},{-20,-48},{-20,
          -10},{-60,-10},{-60,8},{-66,8}}, color={0,0,127}));
  connect(setPoi2.TZon, TZon2.y) annotation (Line(points={{18,-8},{-20,-8},{-20,
          -10},{-60,-10},{-60,8},{-66,8}}, color={0,0,127}));
  connect(cooSetAdj.y, setPoi2.setAdj) annotation (Line(points={{-24,48},{-20,48},
          {-20,-2},{-4,-2},{-4,-14},{18,-14}}, color={0,0,127}));
  connect(heaSetAdj.y, setPoi2.heaSetAdj) annotation (Line(points={{-24,8},{-2,8},
          {-2,-16},{18,-16}}, color={0,0,127}));
  connect(TZon1.y, setPoi.TZon) annotation (Line(points={{-66,48},{-60,48},{-60,
          82},{18,82}}, color={0,0,127}));
  connect(setPoi1.TZon, setPoi.TZon) annotation (Line(points={{18,42},{-12,42},{
          -12,30},{-60,30},{-60,82},{18,82}}, color={0,0,127}));
  connect(occSch.tNexOcc, setPoi.tNexOcc)
    annotation (Line(points={{-69,86},{0,86},{0,78},{18,78}}, color={0,0,127}));
  connect(occSch.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{-69,86},{0,
          86},{0,38},{18,38}}, color={0,0,127}));
  connect(occSch.occupied, setPoi.uOcc) annotation (Line(points={{-69,74},{-6,74},
          {-6,80},{18,80}}, color={255,0,255}));
  connect(occSch.occupied, setPoi1.uOcc) annotation (Line(points={{-69,74},{-6,74},
          {-6,40},{18,40}}, color={255,0,255}));
  connect(occSch.occupied, setPoi2.uOcc) annotation (Line(points={{-69,74},{-6,74},
          {-6,-10},{18,-10}}, color={255,0,255}));
  connect(occSch.occupied, setPoi3.uOcc) annotation (Line(points={{-69,74},{-6,74},
          {-6,-50},{18,-50}}, color={255,0,255}));
  connect(occSen1.y, setPoi1.uOccSen) annotation (Line(points={{-66,-32},{-60,-32},
          {-60,-16},{-10,-16},{-10,32},{18,32}}, color={255,0,255}));
  connect(winSta1.y, setPoi1.uWin) annotation (Line(points={{-66,-72},{-60,-72},
          {-60,-52},{-8,-52},{-8,44},{18,44}}, color={255,0,255}));
  connect(winSta2.y, setPoi3.uWin) annotation (Line(points={{-24,-72},{-4,-72},{
          -4,-46},{18,-46}}, color={255,0,255}));
  connect(occSch.tNexOcc, setPoi2.tNexOcc) annotation (Line(points={{-69,86},{0,
          86},{0,-12},{18,-12}}, color={0,0,127}));
  connect(occSch.tNexOcc, setPoi3.tNexOcc) annotation (Line(points={{-69,86},{0,
          86},{0,-52},{18,-52}}, color={0,0,127}));
  connect(demLimLev.y, setPoi.uCooDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,70},{18,70}}, color={255,127,0}));
  connect(demLimLev.y, setPoi.uHeaDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,68},{18,68}}, color={255,127,0}));
  connect(demLimLev.y, setPoi1.uCooDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,30},{18,30}}, color={255,127,0}));
  connect(demLimLev.y, setPoi1.uHeaDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,28},{18,28}}, color={255,127,0}));
  connect(demLimLev.y, setPoi2.uCooDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,-20},{18,-20}}, color={255,127,0}));
  connect(demLimLev.y, setPoi2.uHeaDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,-22},{18,-22}}, color={255,127,0}));
  connect(demLimLev.y, setPoi3.uCooDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,-60},{18,-60}}, color={255,127,0}));
  connect(demLimLev.y, setPoi3.uHeaDemLimLev) annotation (Line(points={{-44,-100},
          {2,-100},{2,-62},{18,-62}}, color={255,127,0}));
  connect(warCooTim.y, setPoi.cooDowTim) annotation (Line(points={{-26,104},{4,104},
          {4,88},{18,88}}, color={0,0,127}));
  connect(warCooTim.y, setPoi.warUpTim) annotation (Line(points={{-26,104},{6,104},
          {6,86},{18,86}}, color={0,0,127}));
  connect(warCooTim.y, setPoi1.warUpTim) annotation (Line(points={{-26,104},{6,104},
          {6,46},{18,46}}, color={0,0,127}));
  connect(warCooTim.y, setPoi2.warUpTim) annotation (Line(points={{-26,104},{6,104},
          {6,-4},{18,-4}}, color={0,0,127}));
  connect(warCooTim.y, setPoi3.warUpTim) annotation (Line(points={{-26,104},{6,104},
          {6,-44},{18,-44}}, color={0,0,127}));
  connect(warCooTim.y, setPoi1.cooDowTim) annotation (Line(points={{-26,104},{4,
          104},{4,48},{18,48}}, color={0,0,127}));
  connect(warCooTim.y, setPoi2.cooDowTim) annotation (Line(points={{-26,104},{4,
          104},{4,-2},{18,-2}}, color={0,0,127}));
  connect(warCooTim.y, setPoi3.cooDowTim) annotation (Line(points={{-26,104},{4,
          104},{4,-42},{18,-42}}, color={0,0,127}));

annotation (experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Validation/ModeAndSetPoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2020, by Jianjun Hu:<br/>
Moved from TerminalUnits.Validation.ModeAndSetPoints to here.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}}),
        graphics={
        Text(
          extent={{50,84},{126,74}},
          textColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No window status sensor
No occupancy sensor
Zone 1"),
        Text(
          extent={{48,42},{102,34}},
          textColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment
          Zone 1"),
        Text(
          extent={{46,-48},{100,-56}},
          textColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment
          Zone 2"),
        Text(
          extent={{48,-6},{124,-16}},
          textColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No window status sensor
No occupancy sensor
Zone 2")}),
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
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ModeAndSetPoints;
