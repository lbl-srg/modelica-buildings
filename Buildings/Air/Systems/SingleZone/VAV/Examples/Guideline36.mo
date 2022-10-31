within Buildings.Air.Systems.SingleZone.VAV.Examples;
model Guideline36
  "Variable air volume flow system with single themal zone and ASHRAE Guideline 36 sequence control"
  extends Modelica.Icons.Example;
  extends
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop(
    hvac(QCoo_flow_nominal=-10000));
  parameter Modelica.Units.SI.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller con(
    final VAreBreZon_flow=0.0144,
    final VPopBreZon_flow=0.0075,
    ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6B,
    freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
    have_winSen=true,
    have_CO2Sen=false,
    buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief,
    have_locAdj=false,
    ignDemLim=false,
    kCoo=0.1,
    TiCoo=120,
    TiHea=120,
    TSupDew_max=297.15,
    maxHeaSpe=0.2,
    maxCooSpe=1,
    minSpe=0.1,
    kCooCoi=1,
    VOutMin_flow=0.0144,
    VOutDes_flow=0.025,
    kHea=0.1,
    kMod=4,
    have_occSen=false,
    TSup_max=343.15,
    TSup_min=286.15,
    outDamMinFloMinSpe = 0.2304,
    outDamMinFloMaxSpe=0.02304,
    outDamDesFloMinSpe=0.4,
    outDamDesFloMaxSpe=0.04)
    "VAV controller"
    annotation (Placement(transformation(extent={{-120,-20},{-80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
    uLow=-1,
    uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Math.Feedback errTRooCoo
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-110,-100},{-90,-80}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(final k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooWarTim(final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccHeaSet(final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-210,170},{-190,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccCooSet(final k=298.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoHeaSet(final k=288.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-210,120},{-190,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoCooSet(final k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Modelica.Blocks.Sources.BooleanConstant freRes(k=true)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));

equation
  connect(con.yHeaCoi, hvac.uHea) annotation (Line(points={{-78,6},{-70,6},{-70,
          12},{-42,12}},                color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-59,-130},
          {-46,-130},{-46,-18},{-42,-18}}, color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u)   annotation (Line(points={{-91,-90},{-82,-90}},   color={0,0,127}));
  connect(zon.TRooAir, errTRooCoo.u1) annotation (Line(points={{81,0},{110,0},{110,
          -152},{-134,-152},{-134,-90},{-108,-90}},       color={0,0,127}));
  connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-58,-90},{-50,-90},
          {-50,-10},{-42,-10}},       color={255,0,255}));
  connect(zon.TRooAir, con.TZon) annotation (Line(points={{81,0},{110,0},{110,-152},
          {-134,-152},{-134,46},{-122,46}}, color={0,0,127}));
  connect(occSch.tNexOcc, con.tNexOcc) annotation (Line(points={{-179,16},{-170,
          16},{-170,49},{-122,49}},           color={0,0,127}));
  connect(con.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-78,39},{-74,
          39},{-74,-40},{-120,-40},{-120,-110},{-100,-110},{-100,-98}}, color={
          0,0,127}));
  connect(demLim.y, con.uCooDemLimLev) annotation (Line(points={{-178,-20},{-162,
          -20},{-162,26},{-122,26}},           color={255,127,0}));
  connect(demLim.y, con.uHeaDemLimLev) annotation (Line(points={{-178,-20},{-162,
          -20},{-162,24},{-122,24}},             color={255,127,0}));
  connect(cooWarTim.y, con.warUpTim) annotation (Line(points={{-178,50},{-170,50},
          {-170,54},{-122,54}},               color={0,0,127}));
  connect(cooWarTim.y, con.cooDowTim) annotation (Line(points={{-178,50},{-170,50},
          {-170,56},{-122,56}},               color={0,0,127}));
  connect(con.yCooCoi, hvac.uCooVal) annotation (Line(points={{-78,9},{-66,9},{-66,
          5},{-42,5}},                    color={0,0,127}));
  connect(TOccHeaSet.y, con.TOccHeaSet) annotation (Line(points={{-188,180},{-150,
          180},{-150,44},{-122,44}}, color={0,0,127}));
  connect(TOccCooSet.y, con.TOccCooSet) annotation (Line(points={{-158,160},{-150,
          160},{-150,42},{-122,42}}, color={0,0,127}));
  connect(TUnoHeaSet.y, con.TUnoHeaSet) annotation (Line(points={{-188,130},{-146,
          130},{-146,40},{-122,40}}, color={0,0,127}));
  connect(TUnoCooSet.y, con.TUnoCooSet) annotation (Line(points={{-158,110},{-146,
          110},{-146,38},{-122,38}}, color={0,0,127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{-79,80},{-80,80},{-80,68},{-130,68},{-130,59},{-122,59}},
      color={255,204,51},
      thickness=0.5));
  connect(uWin.y, con.u1Win) annotation (Line(points={{-179,-80},{-158,-80},{-158,
          13},{-122,13}}, color={255,0,255}));
  connect(occSch.occupied, con.u1Occ) annotation (Line(points={{-179,4},{-166,4},
          {-166,51},{-122,51}}, color={255,0,255}));
  connect(hvac.TSup, con.TAirSup) annotation (Line(points={{1.2,-8},{10,-8},{10,
          -50},{-154,-50},{-154,16},{-122,16}}, color={0,0,127}));
  connect(hvac.TMix, con.TAirMix) annotation (Line(points={{1.2,-4},{14,-4},{14,
          -52},{-150,-52},{-150,-9},{-122,-9}}, color={0,0,127}));
  connect(con.ySupFan, hvac.uFan) annotation (Line(points={{-78,24},{-58,24},{
          -58,18},{-42,18}},
                         color={0,0,127}));
  connect(con.yCooCoi, con.uCooCoi_actual) annotation (Line(points={{-78,9},{-66,
          9},{-66,-34},{-142,-34},{-142,-17},{-122,-17}}, color={0,0,127}));
  connect(con.yHeaCoi, con.uHeaCoi_actual) annotation (Line(points={{-78,6},{-70,
          6},{-70,-30},{-138,-30},{-138,-19},{-122,-19}}, color={0,0,127}));
  connect(freRes.y, con.u1SofSwiRes) annotation (Line(points={{-179,-120},{-166,
          -120},{-166,1},{-122,1}}, color={255,0,255}));
  connect(con.yOutDam, hvac.uEco) annotation (Line(points={{-78,29},{-62,29},{
          -62,-2},{-42,-2}}, color={0,0,127}));
  connect(con.ySupFan, con.uSupFan_actual) annotation (Line(points={{-78,24},{
          -58,24},{-58,-38},{-146,-38},{-146,-14},{-122,-14}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-220,-200},{120,200}})),
    experiment(
      StopTime=864000,
      Interval=3600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
Implementation of <a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>
with ASHRAE Guideline 36 control sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2022, by Jianjun Hu:<br/>
Replaced the AHU controller with the one based official release version.
</li>
<li>
July 27, 2020, by Kun Zhang:<br/>
Changed parameters of PID and design outdoor airflow and damper parameters.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1608\">issue 1608</a>.
</li>
<li>
June 30, 2020, by Jianjun  Hu:<br/>
Updated AHU controller which applies the sequence of specifying operating mode
according to G36 official release.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\"># 1893</a>.
</li>
<li>
June 22, 2020, by Michael Wetter:<br/>
Removed non-used occupant density.
</li>
<li>
July 29, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36;
