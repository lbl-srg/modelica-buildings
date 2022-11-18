within Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples;
model Guideline36
  "Variable air volume flow system with single themal zone and ASHRAE Guideline 36 sequence control"
  extends Modelica.Icons.Example;
  extends
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop(
     hvac(QCoo_flow_nominal=-10000));
  parameter Modelica.Units.SI.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller con(
    have_winSen=true,
    TZonHeaOn=293.15,
    TZonCooOff=303.15,
    kCoo=4,
    kCooCoi=1,
    yHeaMax=0.2,
    AFlo=48,
    VOutMin_flow=0.0144,
    VOutDes_flow=0.025,
    yMin=0.1,
    kHea=4,
    kMod=4,
    have_occSen=false,
    TZonHeaOff=288.15,
    TZonCooOn=298.15,
    TSupSetMax=343.15,
    TSupSetMin=286.15,
    yDam_VOutMin_minSpe=0.2304,
    yDam_VOutMin_maxSpe=0.02304,
    yDam_VOutDes_minSpe=0.4,
    yDam_VOutDes_maxSpe=0.04)
    "VAV controller"
    annotation (Placement(transformation(extent={{-120,-28},{-80,20}})));
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
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(final k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooWarTim(final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));

protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));

equation
  connect(con.yFan, hvac.uFan) annotation (Line(points={{-78,7.07692},{-62,
          7.07692},{-62,18},{-42,18}}, color={0,0,127}));
  connect(con.yHeaCoi, hvac.uHea) annotation (Line(points={{-78,-9.53846},{-60,
          -9.53846},{-60,12},{-42,12}}, color={0,0,127}));
  connect(con.yOutDamPos, hvac.uEco) annotation (Line(points={{-78,-19.6923},{-56,
          -19.6923},{-56,-2},{-42,-2}}, color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-59,-130},
          {-46,-130},{-46,-18},{-42,-18}},
                                     color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u)   annotation (Line(points={{-91,-90},{-82,-90}},   color={0,0,127}));
  connect(zon.TRooAir, errTRooCoo.u1) annotation (Line(points={{81,0},{110,0},{110,
          -152},{-134,-152},{-134,-90},{-108,-90}},       color={0,0,127}));
  connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-58,-90},{-50,-90},
          {-50,-10},{-42,-10}},       color={255,0,255}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{-79,80},{-79,60},{-140,60},{-140,19.0769},{-122,19.0769}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zon.TRooAir, con.TZon) annotation (Line(points={{81,0},{110,0},{110,-152},
          {-134,-152},{-134,8},{-122,8}}, color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{1.2,-8},{10,-8},{10,
          -50},{-130,-50},{-130,-2.15385},{-122,-2.15385}}, color={0,0,127}));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{1.2,-4},{14,-4},{14,
          -46},{-128,-46},{-128,-7.69231},{-122,-7.69231}}, color={0,0,127}));
  connect(occSch.tNexOcc, con.tNexOcc) annotation (Line(points={{-159,16},{-150,
          16},{-150,10.7692},{-122,10.7692}}, color={0,0,127}));
  connect(con.uOcc, occSch.occupied) annotation (Line(points={{-122,5.23077},{-152,
          5.23077},{-152,4},{-159,4}}, color={255,0,255}));
  connect(uWin.y, con.uWin) annotation (Line(points={{-159,-80},{-136,-80},{
          -136,-13.2308},{-122,-13.2308}}, color={255,0,255}));
  connect(con.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-78,-4},{-74,
          -4},{-74,-40},{-120,-40},{-120,-110},{-100,-110},{-100,-98}}, color={
          0,0,127}));
  connect(hvac.TRet, con.TCut) annotation (Line(points={{1.2,-6},{12,-6},{12,
          -48},{-132,-48},{-132,-4.92308},{-122,-4.92308}}, color={0,0,127}));
  connect(demLim.y, con.uCooDemLimLev) annotation (Line(points={{-158,-40},{-138,
          -40},{-138,2.46154},{-122,2.46154}}, color={255,127,0}));
  connect(demLim.y, con.uHeaDemLimLev) annotation (Line(points={{-158,-40},{-138,
          -40},{-138,0.615385},{-122,0.615385}}, color={255,127,0}));
  connect(cooWarTim.y, con.warUpTim) annotation (Line(points={{-158,50},{-142,
          50},{-142,16.3077},{-122,16.3077}}, color={0,0,127}));
  connect(cooWarTim.y, con.cooDowTim) annotation (Line(points={{-158,50},{-142,
          50},{-142,13.5385},{-122,13.5385}}, color={0,0,127}));
  connect(con.yCooCoi, hvac.uCooVal) annotation (Line(points={{-78,-15.0769},{
          -58,-15.0769},{-58,5},{-42,5}}, color={0,0,127}));

  annotation (Diagram(coordinateSystem(extent={{-200,-160},{120,100}})),
    experiment(
      StopTime=864000,
      Interval=3600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
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
