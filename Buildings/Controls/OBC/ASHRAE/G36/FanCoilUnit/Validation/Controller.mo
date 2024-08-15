within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Validation;
model Controller
    "Validation of the top-level controller"

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU(
    final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
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
    final have_locAdj=false)
    "Validate the heating case"
    annotation (Placement(transformation(extent={{20,76},{60,136}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU1(
    final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2,
    final have_locAdj=false)
    "Validate the cooling case for a system with a window sensor but no occupancy sensor"
    annotation (Placement(transformation(extent={{20,0},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU2(
    final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final have_winSen=false,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2,
    final have_locAdj=false)
    "Validate the cooling case for a system with an occupancy sensor but no window sensor"
    annotation (Placement(transformation(extent={{20,-78},{60,-18}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU3(
    final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSet_max=297.15,
    final TSupSet_min=285.15,
    final heaSpe_max=0.6,
    final heaSpe_min=0.2,
    final cooSpe_min=0.2,
    final have_locAdj=false)
    "Validate the cooling case for a system with a window sensor but no occupancy sensor"
    annotation (Placement(transformation(extent={{20,-154},{60,-94}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSet(
    final k=293.15)
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSet(
    final k=297.15)
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnoHeaSet(
    final k=285.15)
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnoCooSet(
    final k=303.15)
    "Unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TZon(
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

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    final k=true)
    "True window status"
    annotation (Placement(transformation(extent={{-180,-152},{-160,-132}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TZon1(
    final duration=86400,
    final height=-3,
    final offset=273.15 + 26,
    y(unit="K"))
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup(
    final height=2,
    final duration=86400,
    final offset=273.15 + 22.5,
    y(unit="K"))
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup1(
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

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(
    final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

equation
  connect(TZon.y,conFCU. TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          101.5},{18,101.5}}, color={0,0,127}));
  connect(occSch.occupied,conFCU. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,113.65},{18,113.65}}, color={255,0,255}));
  connect(occSch.tNexOcc,conFCU. tNexOcc) annotation (Line(points={{-99,60},{-80,
          60},{-80,127},{18,127}}, color={0,0,127}));
  connect(TSup.y,conFCU. TSup) annotation (Line(points={{-158,40},{-140,40},{-140,
          104.5},{18,104.5}}, color={0,0,127}));
  connect(win.y,conFCU1. u1Win) annotation (Line(points={{-158,-142},{0,-142},{0,
          4.5},{18,4.5}},color={255,0,255}));
  connect(occSch.tNexOcc,conFCU1. tNexOcc) annotation (Line(points={{-99,60},{-20,
          60},{-20,51},{18,51}}, color={0,0,127}));
  connect(occSch.occupied,conFCU1. u1Occ)
    annotation (Line(points={{-99,48},{-40,48},{-40,37.65},{18,37.65}},
          color={255,0,255}));
  connect(TZon1.y,conFCU1. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,25.5},{18,25.5}}, color={0,0,127}));
  connect(TSup1.y,conFCU1. TSup) annotation (Line(points={{-158,-70},{-84,-70},{
          -84,28.5},{18,28.5}}, color={0,0,127}));
  connect(TSup1.y,conFCU2. TSup) annotation (Line(points={{-158,-70},{-84,-70},{
          -84,-49.5},{18,-49.5}}, color={0,0,127}));
  connect(occSch.occupied,conFCU2. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,-40.35},{18,-40.35}}, color={255,0,255}));
  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-99,60},{-80,
          60},{-80,-27},{18,-27}}, color={0,0,127}));
  connect(TZon1.y,conFCU2. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-52.5},{18,-52.5}}, color={0,0,127}));
  connect(occSch.occupied,conFCU3. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,-116.35},{18,-116.35}}, color={255,0,255}));
  connect(TSup1.y,conFCU3. TSup) annotation (Line(points={{-158,-70},{-84,-70},{
          -84,-125.5},{18,-125.5}}, color={0,0,127}));
  connect(TZon1.y,conFCU3. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-128.5},{18,-128.5}}, color={0,0,127}));
  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-99,60},{-80,
          60},{-80,-103},{18,-103}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,133},{18,133}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,130},{18,130}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU1. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,57},{18,57}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU1. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,54},{18,54}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-21},{18,-21}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-24},{18,-24}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-97},{18,-97}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-100},{18,-100}}, color={0,0,127}));
  connect(demLim.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-122.5},{18,-122.5}},color={255,127,0}));
  connect(demLim.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-119.5},{18,-119.5}},color={255,127,0}));
  connect(demLim.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-46.5},{18,-46.5}},  color={255,127,0}));
  connect(demLim.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-43.5},{18,-43.5}},  color={255,127,0}));
  connect(demLim.y,conFCU1. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,31.5},{18,31.5}},  color={255,127,0}));
  connect(demLim.y,conFCU1. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,34.5},{18,34.5}},  color={255,127,0}));
  connect(demLim.y,conFCU. uCooDemLimLev) annotation (Line(points={{-158,-100},{
          -4,-100},{-4,110.5},{18,110.5}}, color={255,127,0}));
  connect(demLim.y,conFCU. uHeaDemLimLev) annotation (Line(points={{-158,-100},{
          -4,-100},{-4,107.5},{18,107.5}}, color={255,127,0}));
  connect(nOcc.y, conFCU.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,86.5},
          {18,86.5}}, color={255,127,0}));
  connect(nOcc.y, conFCU2.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,-67.5},
          {18,-67.5}},  color={255,127,0}));
  connect(TOccHeaSet.y, conFCU.TOccHeaSet) annotation (Line(points={{-138,140},{
          -128,140},{-128,98.5},{18,98.5}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU.TOccCooSet) annotation (Line(points={{-98,140},{-88,
          140},{-88,95.5},{18,95.5}}, color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU.TUnoHeaSet) annotation (Line(points={{-58,140},{-48,
          140},{-48,92.5},{18,92.5}}, color={0,0,127}));
  connect(TUnoCooSet.y, conFCU.TUnoCooSet) annotation (Line(points={{-18,140},{-8,
          140},{-8,89.5},{18,89.5}}, color={0,0,127}));
  connect(TOccHeaSet.y, conFCU1.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,22.5},{18,22.5}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU1.TOccCooSet) annotation (Line(points={{-98,140},{
          -88,140},{-88,19.5},{18,19.5}}, color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,16.5},{18,16.5}}, color={0,0,127}));
  connect(TUnoCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-18,140},{
          -8,140},{-8,13.5},{18,13.5}}, color={0,0,127}));
  connect(TOccHeaSet.y, conFCU2.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-55.5},{18,-55.5}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU2.TOccCooSet) annotation (Line(points={{-98,140},{
          -88,140},{-88,-58.5},{18,-58.5}}, color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU2.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,-61.5},{18,-61.5}}, color={0,0,127}));
  connect(TUnoCooSet.y, conFCU2.TUnoCooSet) annotation (Line(points={{-18,140},{
          -8,140},{-8,-64.5},{18,-64.5}}, color={0,0,127}));
  connect(TOccHeaSet.y, conFCU3.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-131.5},{18,-131.5}}, color={0,0,127}));
  connect(TOccCooSet.y, conFCU3.TOccCooSet) annotation (Line(points={{-98,140},{
          -88,140},{-88,-134.5},{18,-134.5}}, color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU3.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,-137.5},{18,-137.5}}, color={0,0,127}));
  connect(TUnoCooSet.y, conFCU3.TUnoCooSet) annotation (Line(points={{-18,140},{
          -8,140},{-8,-140.5},{18,-140.5}}, color={0,0,127}));
  connect(conFCU1.y1Fan, conFCU1.u1Fan) annotation (Line(points={{62,45},{72,45},
          {72,-8},{12,-8},{12,7.5},{18,7.5}},  color={255,0,255}));
  connect(conFCU2.y1Fan, conFCU2.u1Fan) annotation (Line(points={{62,-33},{72,-33},
          {72,-86},{12,-86},{12,-70.5},{18,-70.5}}, color={255,0,255}));
  connect(conFCU3.y1Fan, conFCU3.u1Fan) annotation (Line(points={{62,-109},{72,-109},
          {72,-160},{10,-160},{10,-146.5},{18,-146.5}}, color={255,0,255}));
  connect(conFCU.y1Fan, conFCU.u1Fan) annotation (Line(points={{62,121},{70,121},
          {70,70},{10,70},{10,83.5},{18,83.5}}, color={255,0,255}));
  connect(nOcc.y, conFCU3.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          -143.5},{18,-143.5}}, color={255,127,0}));
  connect(win.y, conFCU3.u1Win) annotation (Line(points={{-158,-142},{0,-142},{
          0,-149.5},{18,-149.5}}, color={255,0,255}));
annotation (experiment(StopTime=86400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/FanCoilUnit/Validation/Controller.mos"
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller</a>.
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
