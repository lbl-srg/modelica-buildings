within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Validation;
model Controller
    "Validation of the top-level controller"

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU(
    final have_hotWatCoi=true,
    final have_eleHeaCoi=false,
    final have_winSen=false,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2,
    final have_cooCoi=true)
    "Validate the heating case"
    annotation (Placement(transformation(extent={{20,76},{60,136}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU1(
    final have_hotWatCoi=true,
    final have_eleHeaCoi=false,
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final have_cooCoi=true,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,0},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU2(
    final have_hotWatCoi=true,
    final have_eleHeaCoi=false,
    final have_winSen=false,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final have_cooCoi=true,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-78},{60,-18}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU3(
    final have_hotWatCoi=true,
    final have_eleHeaCoi=false,
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final have_cooCoi=true,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-154},{60,-94}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccHeaSet(
    final k=293.15)
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccCooSet(
    final k=297.15)
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoHeaSet(
    final k=285.15)
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoCooSet(
    final k=303.15)
    "Unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final duration=86400,
    final height=6,
    final offset=273.15 + 16,
    y(unit="K"))
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-120,44},{-100,64}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nOcc(
    final k=2)
    "Number of occupants"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(final k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    final duration=86400,
    final height=-3,
    final offset=273.15 + 26,
    y(unit="K"))
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=2,
    final duration=86400,
    final offset=273.15 + 22.5,
    y(unit="K"))
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup1(
    final height=-3,
    final duration=86400,
    final offset=273.15 + 24,
    y(unit="K"))
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(
    final k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooWarTim(
    final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

equation
  connect(TZon.y,conFCU. TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          106},{18,106}}, color={0,0,127}));

  connect(occSch.occupied,conFCU. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,118.632},{18,118.632}},
                                       color={255,0,255}));

  connect(occSch.tNexOcc,conFCU. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,128.105},{18,128.105}},
                                           color={0,0,127}));

  connect(TSup.y,conFCU. TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,109.158},{18,109.158}},
                                  color={0,0,127}));

  connect(win.y,conFCU1. u1Win) annotation (Line(points={{-158,-140},{0,-140},{0,
          7.89474},{18,7.89474}},
                         color={255,0,255}));

  connect(occSch.tNexOcc,conFCU1. tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,52.1053},{18,52.1053}},
                                           color={0,0,127}));

  connect(occSch.occupied,conFCU1. u1Occ)
    annotation (Line(points={{-99,48},{-40,48},{-40,42.6316},{18,42.6316}},
          color={255,0,255}));

  connect(TZon1.y,conFCU1. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,30},{18,30}}, color={0,0,127}));

  connect(TSup1.y,conFCU1. TSup) annotation (Line(points={{-158,-70},{-84,-70},{
          -84,33.1579},{18,33.1579}}, color={0,0,127}));

  connect(TSup1.y,conFCU2. TSup) annotation (Line(points={{-158,-70},{-84,-70},{
          -84,-44.8421},{18,-44.8421}}, color={0,0,127}));

  connect(occSch.occupied,conFCU2. u1Occ) annotation (Line(points={{-99,48},{
          -74,48},{-74,-35.3684},{18,-35.3684}},
                                             color={255,0,255}));

  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-25.8947},{18,-25.8947}},
                                             color={0,0,127}));

  connect(TZon1.y,conFCU2. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-48},{18,-48}}, color={0,0,127}));

  connect(win.y,conFCU3. u1Win) annotation (Line(points={{-158,-140},{0,-140},{
          0,-146.105},{18,-146.105}},
                          color={255,0,255}));

  connect(occSch.occupied,conFCU3. u1Occ) annotation (Line(points={{-99,48},{
          -74,48},{-74,-111.368},{18,-111.368}},
                                             color={255,0,255}));

  connect(TSup1.y,conFCU3. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-120.842},{18,-120.842}},color={0,0,127}));

  connect(TZon1.y,conFCU3. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-124},{18,-124}},
                              color={0,0,127}));

  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-101.895},{18,-101.895}},
                                             color={0,0,127}));

  connect(cooWarTim.y,conFCU. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,134.421},{18,134.421}},
                                       color={0,0,127}));

  connect(cooWarTim.y,conFCU. cooDowTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,131.263},{18,131.263}},
                                           color={0,0,127}));

  connect(cooWarTim.y,conFCU1. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,58.4211},{18,58.4211}},
                                           color={0,0,127}));

  connect(cooWarTim.y,conFCU1. cooDowTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,55.2632},{18,55.2632}},
                                           color={0,0,127}));

  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-19.5789},{18,-19.5789}},
                                             color={0,0,127}));

  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-22.7368},{18,-22.7368}},
                                             color={0,0,127}));

  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-95.5789},{18,-95.5789}},
                                             color={0,0,127}));

  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-98.7368},{18,-98.7368}},
                                             color={0,0,127}));

  connect(demLim.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-117.684},{18,-117.684}},
                                             color={255,127,0}));

  connect(demLim.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-114.526},{18,-114.526}},
                                             color={255,127,0}));

  connect(demLim.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-41.6842},{18,-41.6842}},
                                             color={255,127,0}));

  connect(demLim.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-38.5263},{18,-38.5263}},
                                             color={255,127,0}));

  connect(demLim.y,conFCU1. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,36.3158},{18,36.3158}},
                                           color={255,127,0}));

  connect(demLim.y,conFCU1. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,39.4737},{18,39.4737}},
                                           color={255,127,0}));

  connect(demLim.y,conFCU. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,115.474},{18,115.474}},
                                           color={255,127,0}));

  connect(demLim.y,conFCU. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,112.316},{18,112.316}},
                                           color={255,127,0}));

  connect(nOcc.y, conFCU.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          90.2105},{18,90.2105}},
                    color={255,127,0}));
  connect(nOcc.y, conFCU2.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          -63.7895},{18,-63.7895}},
                     color={255,127,0}));
  connect(conFCU.yHeaCoi, conFCU.uHeaCoi) annotation (Line(points={{62,109.158},
          {68,109.158},{68,72},{14,72},{14,80.7368},{18,80.7368}},
                                                 color={0,0,127}));
  connect(conFCU.yCooCoi, conFCU.uCooCoi) annotation (Line(points={{62,106},{66,
          106},{66,70},{16,70},{16,77.5789},{18,77.5789}},
                                                 color={0,0,127}));
  connect(conFCU1.yHeaCoi, conFCU1.uHeaCoi) annotation (Line(points={{62,33.1579},
          {70,33.1579},{70,-6},{14,-6},{14,4.73684},{18,4.73684}},
                                                 color={0,0,127}));
  connect(conFCU1.yCooCoi, conFCU1.uCooCoi) annotation (Line(points={{62,30},{68,
          30},{68,-4},{16,-4},{16,1.57895},{18,1.57895}},
                                                 color={0,0,127}));
  connect(conFCU2.yHeaCoi, conFCU2.uHeaCoi) annotation (Line(points={{62,
          -44.8421},{70,-44.8421},{70,-84},{14,-84},{14,-73.2632},{18,-73.2632}},
                                                        color={0,0,127}));
  connect(conFCU2.yCooCoi, conFCU2.uCooCoi) annotation (Line(points={{62,-48},{
          68,-48},{68,-82},{16,-82},{16,-76.4211},{18,-76.4211}},
                                                        color={0,0,127}));
  connect(conFCU3.yHeaCoi, conFCU3.uHeaCoi) annotation (Line(points={{62,
          -120.842},{70,-120.842},{70,-158},{12,-158},{12,-149.263},{18,
          -149.263}},                                         color={0,0,127}));
  connect(conFCU3.yCooCoi, conFCU3.uCooCoi) annotation (Line(points={{62,-124},
          {68,-124},{68,-156},{14,-156},{14,-152.421},{18,-152.421}},
                                                              color={0,0,127}));
  connect(TOccHeaSet.y, conFCU.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,102.842},{18,102.842}},color={0,0,127}));
  connect(TOccCooSet.y, conFCU.TOccCooSet) annotation (Line(points={{-98,140},{
          -88,140},{-88,99.6842},{18,99.6842}},
                                            color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,96.5263},{18,96.5263}},
                                            color={0,0,127}));
  connect(TUnoCooSet.y, conFCU.TUnoCooSet) annotation (Line(points={{-18,140},{
          -8,140},{-8,93.3684},{18,93.3684}},
                                           color={0,0,127}));
  connect(TOccHeaSet.y, conFCU1.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,26.8421},{18,26.8421}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU1.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,23.6842},{18,23.6842}},color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-58,140},
          {-48,140},{-48,20.5263},{18,20.5263}},color={0,0,127}));
  connect(TUnoCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,17.3684},{18,17.3684}},color={0,0,127}));
  connect(TOccHeaSet.y, conFCU2.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-51.1579},{18,-51.1579}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU2.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,-54.3158},{18,-54.3158}},color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU2.TUnoHeaSet) annotation (Line(points={{-58,140},
          {-48,140},{-48,-57.4737},{18,-57.4737}},color={0,0,127}));
  connect(TUnoCooSet.y, conFCU2.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,-60.6316},{18,-60.6316}},color={0,0,127}));
  connect(TOccHeaSet.y, conFCU3.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-127.158},{18,-127.158}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU3.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,-130.316},{18,-130.316}},color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU3.TUnoHeaSet) annotation (Line(points={{-58,140},
          {-48,140},{-48,-133.474},{18,-133.474}},color={0,0,127}));
  connect(TUnoCooSet.y, conFCU3.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,-136.632},{18,-136.632}},color={0,0,127}));
  connect(conFCU.y1Fan, conFCU.u1Fan) annotation (Line(points={{62,121.789},{62,
          122},{70,122},{70,68},{10,68},{10,87.0526},{18,87.0526}}, color={255,
          0,255}));
  connect(conFCU1.y1Fan, conFCU1.u1Fan) annotation (Line(points={{62,45.7895},{
          72,45.7895},{72,-8},{12,-8},{12,11.0526},{18,11.0526}}, color={255,0,
          255}));
  connect(conFCU2.y1Fan, conFCU2.u1Fan) annotation (Line(points={{62,-32.2105},
          {72,-32.2105},{72,-86},{12,-86},{12,-66.9474},{18,-66.9474}}, color={
          255,0,255}));
  connect(conFCU3.y1Fan, conFCU3.u1Fan) annotation (Line(points={{62,-108.211},
          {72,-108.211},{72,-160},{10,-160},{10,-142.947},{18,-142.947}}, color
        ={255,0,255}));
annotation (experiment(StopTime=86400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/FanCoilUnit/Validation/Controller.mos"
    "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics={
       Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}}),
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
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{140,160}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller\">
Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller</a>.
<br>
<code>conFCU</code> represents an instance of the controller with heating mode 
operation, with the open-loop signals for measured zone temperature and measured 
supply air temperature increasing with time.
<br>
<code>conFCU1</code> represents an instance of the controller with cooling mode 
operation, with the open-loop signals for measured zone temperature and measured 
supply air temperature decreasing with time.
<br>
<code>conFCU2</code> and <code>conFCU3</code> represent instances of the controller 
with cooling mode operation, with different parameter settings for the window and occupancy sensors.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
