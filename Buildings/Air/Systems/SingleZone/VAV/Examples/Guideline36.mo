within Buildings.Air.Systems.SingleZone.VAV.Examples;
model Guideline36
  "Variable air volume flow system with single themal zone and ASHRAE Guideline 36 sequence control"
  extends Modelica.Icons.Example;
  extends Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop;

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller controller(
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kCoo=1,
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
    TSupSetMax=323.15,
    TSupSetMin=285.15)
    "VAV controller"
    annotation (Placement(transformation(extent={{-120,-28},{-80,20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
    uLow=-1,
    uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-72,-120},{-52,-100}})));
  Modelica.Blocks.Math.Feedback errTRooCoo
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
  Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Modelica.Blocks.Math.BooleanToReal occPer "Conversion to number of occupants"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Modelica.Blocks.Math.Gain ppl(k=2) "Gain for number of occupants"
    annotation (Placement(transformation(extent={{-154,-86},{-142,-74}})));
protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
equation
  connect(controller.yFan, hvac.uFan) annotation (Line(points={{-78,7.07692},{-62,
          7.07692},{-62,18},{-42,18}},
                              color={0,0,127}));
  connect(controller.yHeaCoi, hvac.uHea) annotation (Line(points={{-78,-9.53846},
          {-60,-9.53846},{-60,12},{-42,12}},
                              color={0,0,127}));
  connect(controller.yOutDamPos, hvac.uEco) annotation (Line(points={{-78,-19.6923},
          {-56,-19.6923},{-56,-2},{-42,-2}},
                                 color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-51,-70},{
          -46,-70},{-46,-16},{-42,-16},{-42,-15}},
                                     color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u)
    annotation (Line(points={{-91,-110},{-74,-110}}, color={0,0,127}));
  connect(zon.TRooAir, errTRooCoo.u1) annotation (Line(points={{81,0},{110,0},{
          110,-152},{-134,-152},{-134,-110},{-108,-110}}, color={0,0,127}));
  connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-50,-110},{-48,-110},
          {-48,-10},{-42,-10}},       color={255,0,255}));
  connect(weaBus.TDryBul, controller.TOut) annotation (Line(
      points={{-30,80},{-30,60},{-140,60},{-140,18.1538},{-122,18.1538}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zon.TRooAir, controller.TZon) annotation (Line(points={{81,0},{110,0},
          {110,-152},{-134,-152},{-134,10.7692},{-122,10.7692}},
                                                       color={0,0,127}));
  connect(hvac.TSup, controller.TSup) annotation (Line(points={{1,-8},{10,-8},{10,
          -50},{-130,-50},{-130,-0.307692},{-122,-0.307692}},
                                                 color={0,0,127}));
  connect(hvac.TMix, controller.TMix) annotation (Line(points={{1,-4},{14,-4},{
          14,-46},{-128,-46},{-128,-4},{-122,-4}}, color={0,0,127}));
  connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-159,56},
          {-150,56},{-150,14.4615},{-122,14.4615}},
                                          color={0,0,127}));
  connect(controller.uOcc, occSch.occupied) annotation (Line(points={{-122,7.07692},
          {-152,7.07692},{-152,44},{-159,44}},
                                        color={255,0,255}));
  connect(uWin.y, controller.uWin) annotation (Line(points={{-159,-50},{-148,
          -50},{-148,-11.3846},{-122,-11.3846}},
                                       color={255,0,255}));
  connect(occSch.occupied, occPer.u) annotation (Line(points={{-159,44},{-152,
          44},{-152,0},{-190,0},{-190,-80},{-182,-80}},   color={255,0,255}));
  connect(occPer.y, ppl.u)
    annotation (Line(points={{-159,-80},{-155.2,-80}}, color={0,0,127}));
  connect(ppl.y, controller.nOcc) annotation (Line(points={{-141.4,-80},{-138,-80},
          {-138,-7.69231},{-122,-7.69231}},
                                     color={0,0,127}));
  connect(controller.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-78,-4},
          {-76,-4},{-76,-132},{-100,-132},{-100,-118}},
        color={0,0,127}));
  connect(hvac.uCooVal, controller.yCooCoi) annotation (Line(points={{-42,5},{
          -48,5},{-48,4},{-58,4},{-58,-15.0769},{-78,-15.0769}},
                                                       color={0,0,127}));
  connect(hvac.TRet, controller.TCut) annotation (Line(points={{1,-6},{12,-6},{12,
          -48},{-132,-48},{-132,3.38462},{-122,3.38462}},
                                                 color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-200,-160},{120,100}})),
    experiment(
      StartTime=0,
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
July 29, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Guideline36;
