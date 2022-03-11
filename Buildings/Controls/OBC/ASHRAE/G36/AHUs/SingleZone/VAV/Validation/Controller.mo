within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Validation;
model Controller "Validation of the top-level controller"
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller conVAV(
    final have_winSen=true,
    final have_CO2Sen=false,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final desZonPop=3,
    final kHea=1,
    final AFlo=50,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final TDewSupMax=297.15,
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.1,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25,
    final minRelPos=0.1,
    final maxRelPos=0.6)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,0},{60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final duration=86400,
    final height=6,
    final offset=273.15 + 16)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCut(
    final k=273.15 + 16)
    "Fixed dry bulb temperature high limit cutoff for economizer"
    annotation (Placement(transformation(extent={{-120,-82},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=273.15 +17)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800)
    "Cooling down time"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800)
    "Warm-up time"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    final freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=14400,
    final shift=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerAdj(
    final k=0)
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=28800,
    final width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev(
    final k=0)
    "Demand limit level"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse freRes(
    final width=0.95,
    final period=86400)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp mixTem(
    final height=-5,
    final offset=273.15 + 8,
    final duration=3600)
    "Mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDam(
    final height=0.6,
    final offset=0.2,
    final duration=86400)
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp cooCoi(
    final height=-0.3,
    final offset=0.96,
    final duration=86400,
    startTime=1000) "Cooling coil position"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaCoi(
    final k=0)
    "Heating coil position"
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=2,
    final duration=86400,
    final offset=273.15 + 22.5)
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-66},{-160,-46}})));

equation
  connect(TZon.y, conVAV.TZon) annotation (Line(points={{-158,110},{-36,110},{-36,
          65},{18,65}},   color={0,0,127}));
  connect(TCut.y, conVAV.TCut) annotation (Line(points={{-98,-72},{-24,-72},{-24,
          41},{18,41}}, color={0,0,127}));
  connect(TOut.y, conVAV.TOut)
    annotation (Line(points={{-158,190},{-16,190},{-16,78},{18,78}}, color={0,0,127}));
  connect(TSup.y, conVAV.TSup) annotation (Line(points={{-158,-56},{-28,-56},{-28,
          43},{18,43}},   color={0,0,127}));
  connect(cooDowTim.y, conVAV.cooDowTim) annotation (Line(points={{-118,170},{-20,
          170},{-20,75},{18,75}}, color={0,0,127}));
  connect(warUpTim.y, conVAV.warUpTim) annotation (Line(points={{-158,150},{-24,
          150},{-24,73},{18,73}}, color={0,0,127}));
  connect(occSch.tNexOcc, conVAV.tNexOcc) annotation (Line(points={{-119,136},{-28,
          136},{-28,68},{18,68}}, color={0,0,127}));
  connect(occSch.occupied, conVAV.uOcc) annotation (Line(points={{-119,124},{-32,
          124},{-32,70},{18,70}}, color={255,0,255}));
  connect(winSta.y,swi2. u2)
    annotation (Line(points={{-118,40},{-100,40},{-100,60},{-82,60}},
          color={255,0,255}));
  connect(winSta.y,swi1. u2)
    annotation (Line(points={{-118,40},{-100,40},{-100,10},{-82,10}},
          color={255,0,255}));
  connect(zerAdj.y,swi2. u1)
    annotation (Line(points={{-118,80},{-90,80},{-90,68},{-82,68}},  color={0,0,127}));
  connect(zerAdj.y,swi1. u1)
    annotation (Line(points={{-118,80},{-90,80},{-90,18},{-82,18}},color={0,0,127}));
  connect(cooSetAdj.y,swi2. u3)
    annotation (Line(points={{-158,60},{-110,60},{-110,52},{-82,52}}, color={0,0,127}));
  connect(heaSetAdj.y,swi1. u3)
    annotation (Line(points={{-118,0},{-110,0},{-110,2},{-82,2}}, color={0,0,127}));
  connect(swi2.y, conVAV.cooSetAdj) annotation (Line(points={{-58,60},{-40,60},{
          -40,59},{18,59}}, color={0,0,127}));
  connect(swi1.y, conVAV.heaSetAdj) annotation (Line(points={{-58,10},{-40,10},{
          -40,57},{18,57}}, color={0,0,127}));
  connect(occSta.y, conVAV.uOccSen) annotation (Line(points={{-158,-20},{-36,-20},
          {-36,54},{18,54}}, color={255,0,255}));
  connect(demLimLev.y, conVAV.uCooDemLimLev) annotation (Line(points={{-118,-40},
          {-32,-40},{-32,51},{18,51}}, color={255,127,0}));
  connect(demLimLev.y, conVAV.uHeaDemLimLev) annotation (Line(points={{-118,-40},
          {-32,-40},{-32,49},{18,49}}, color={255,127,0}));
  connect(winSta.y, conVAV.uWin) annotation (Line(points={{-118,40},{-100,40},{-100,
          38},{18,38}}, color={255,0,255}));
  connect(freRes.y, not1.u)
    annotation (Line(points={{-158,-100},{-122,-100}}, color={255,0,255}));
  connect(not1.y, conVAV.uSofSwiRes) annotation (Line(points={{-98,-100},{-20,-100},
          {-20,22},{18,22}}, color={255,0,255}));
  connect(mixTem.y, conVAV.TMix) annotation (Line(points={{-118,-130},{-16,-130},
          {-16,16},{18,16}}, color={0,0,127}));
  connect(outDam.y, conVAV.uOutDamPos) annotation (Line(points={{-158,-150},{-12,
          -150},{-12,12},{18,12}}, color={0,0,127}));
  connect(cooCoi.y, conVAV.uCooCoi) annotation (Line(points={{-118,-170},{-8,-170},
          {-8,6.2},{18,6.2}},   color={0,0,127}));
  connect(heaCoi.y, conVAV.uHeaCoi) annotation (Line(points={{-158,-190},{-4,-190},
          {-4,4},{18,4}},   color={0,0,127}));

  annotation (experiment(StopTime=86400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{80,220}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
