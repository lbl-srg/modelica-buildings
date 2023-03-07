within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Validation;
model Controller "Validation of the top-level controller"
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller conVAV(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
    final have_winSen=true,
    final have_CO2Sen=false,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final VAreBreZon_flow=0.015,
    final VPopBreZon_flow=0.0075,
    final kHea=1,
    final have_occSen=true,
    final TSup_max=297.15,
    final TSup_min=285.15,
    final TSupDew_max=297.15,
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.1,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25,
    final relDam_min=0.1,
    final relDam_max=0.6) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,0},{60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final duration=86400,
    final height=6,
    final offset=273.15 + 16)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=273.15 +17)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800)
    "Cooling down time"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800)
    "Warm-up time"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    final freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
    final freqHz=1/28800,
    final amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=14400,
    final shift=1200)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerAdj(
    final k=0)
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-70,-56},{-50,-36}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch to zero adjustment when window is open"
    annotation (Placement(transformation(extent={{-70,-26},{-50,-6}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=28800,
    final width=0.95)
    "Generate signal indicating occupancy status"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev(
    final k=0)
    "Demand limit level"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse freRes(
    final width=0.95,
    final period=86400)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp mixTem(
    final height=-5,
    final offset=273.15 + 8,
    final duration=3600)
    "Mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDam(
    final height=0.6,
    final offset=0.2,
    final duration=86400)
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp cooCoi(
    final height=-0.3,
    final offset=0.96,
    final duration=86400,
    startTime=1000) "Cooling coil position"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaCoi(
    final k=0)
    "Heating coil position"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=2,
    final duration=86400,
    final offset=273.15 + 22.5)
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetOcc(
    final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetOcc(
    final k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetUno(
    final k=285.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetUno(
    final k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  CDL.Logical.Not                        not2 "Logical not"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
equation
  connect(TZon.y, conVAV.TZon) annotation (Line(points={{-158,120},{-36,120},{
          -36,66},{18,66}}, color={0,0,127}));
  connect(TOut.y, conVAV.TOut)
    annotation (Line(points={{-158,200},{-16,200},{-16,79},{18,79}}, color={0,0,127}));
  connect(TSup.y, conVAV.TAirSup) annotation (Line(points={{-118,-100},{-24,-100},
          {-24,36},{18,36}}, color={0,0,127}));
  connect(cooDowTim.y, conVAV.cooDowTim) annotation (Line(points={{-118,180},{
          -20,180},{-20,76},{18,76}}, color={0,0,127}));
  connect(warUpTim.y, conVAV.warUpTim) annotation (Line(points={{-158,160},{-24,
          160},{-24,74},{18,74}}, color={0,0,127}));
  connect(occSch.tNexOcc, conVAV.tNexOcc) annotation (Line(points={{-119,146},{
          -28,146},{-28,69},{18,69}}, color={0,0,127}));
  connect(occSch.occupied, conVAV.u1Occ) annotation (Line(points={{-119,134},{-32,
          134},{-32,71},{18,71}}, color={255,0,255}));
  connect(zerAdj.y,swi2. u1)
    annotation (Line(points={{-128,20},{-90,20},{-90,-8},{-72,-8}},  color={0,0,127}));
  connect(zerAdj.y,swi1. u1)
    annotation (Line(points={{-128,20},{-90,20},{-90,-38},{-72,-38}}, color={0,0,127}));
  connect(cooSetAdj.y,swi2. u3)
    annotation (Line(points={{-128,-20},{-110,-20},{-110,-24},{-72,-24}}, color={0,0,127}));
  connect(heaSetAdj.y,swi1. u3)
    annotation (Line(points={{-158,-40},{-110,-40},{-110,-54},{-72,-54}}, color={0,0,127}));
  connect(swi2.y, conVAV.cooSetAdj) annotation (Line(points={{-48,-16},{-40,-16},
          {-40,54},{18,54}},color={0,0,127}));
  connect(swi1.y, conVAV.heaSetAdj) annotation (Line(points={{-48,-46},{-36,-46},
          {-36,52},{18,52}},color={0,0,127}));
  connect(occSta.y, conVAV.u1OccSen) annotation (Line(points={{-118,-60},{-32,-60},
          {-32,49},{18,49}}, color={255,0,255}));
  connect(demLimLev.y, conVAV.uCooDemLimLev) annotation (Line(points={{-158,-80},
          {-28,-80},{-28,46},{18,46}}, color={255,127,0}));
  connect(demLimLev.y, conVAV.uHeaDemLimLev) annotation (Line(points={{-158,-80},
          {-28,-80},{-28,44},{18,44}}, color={255,127,0}));
  connect(freRes.y, not1.u)
    annotation (Line(points={{-158,-120},{-82,-120}},  color={255,0,255}));
  connect(not1.y, conVAV.u1SofSwiRes) annotation (Line(points={{-58,-120},{-20,
          -120},{-20,21},{18,21}}, color={255,0,255}));
  connect(mixTem.y, conVAV.TAirMix) annotation (Line(points={{-118,-140},{-16,
          -140},{-16,11},{18,11}}, color={0,0,127}));
  connect(outDam.y, conVAV.uOutDam) annotation (Line(points={{-158,-160},{-12,-160},
          {-12,9},{18,9}}, color={0,0,127}));
  connect(cooCoi.y, conVAV.uCooCoi_actual) annotation (Line(points={{-118,-180},
          {-8,-180},{-8,3},{18,3}}, color={0,0,127}));
  connect(heaCoi.y, conVAV.uHeaCoi_actual) annotation (Line(points={{-158,-200},
          {-4,-200},{-4,1},{18,1}}, color={0,0,127}));
  connect(THeaSetOcc.y,conVAV.TOccHeaSet)  annotation (Line(points={{-118,100},
          {-40,100},{-40,64},{18,64}}, color={0,0,127}));
  connect(TCooSetOcc.y,conVAV.TOccCooSet)  annotation (Line(points={{-158,80},{
          -44,80},{-44,62},{18,62}}, color={0,0,127}));
  connect(THeaSetUno.y,conVAV.TUnoHeaSet)  annotation (Line(points={{-118,60},{
          -50,60},{-50,60},{18,60}}, color={0,0,127}));
  connect(TCooSetUno.y,conVAV.TUnoCooSet)  annotation (Line(points={{-158,40},{
          -44,40},{-44,58},{18,58}}, color={0,0,127}));
  connect(conVAV.ySupFan, conVAV.uSupFan_actual) annotation (Line(points={{62,
          44},{70,44},{70,-20},{0,-20},{0,6},{18,6}}, color={0,0,127}));

  connect(winSta.y, not2.u)
    annotation (Line(points={{-158,0},{-122,0}}, color={255,0,255}));
  connect(not2.y, swi1.u2) annotation (Line(points={{-98,0},{-80,0},{-80,-46},{
          -72,-46}}, color={255,0,255}));
  connect(not2.y, swi2.u2) annotation (Line(points={{-98,0},{-80,0},{-80,-16},{
          -72,-16}}, color={255,0,255}));
  connect(not2.y, conVAV.u1Win) annotation (Line(points={{-98,0},{-80,0},{-80,
          33},{18,33}}, color={255,0,255}));
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
