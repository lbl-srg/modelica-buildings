within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Validation;
model Controller
    "Validation of the top-level controller"

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    have_winSen=false,
    kHea=1,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSet_max=297.15,
    TSupSet_min=285.15,
    heaSpe_max=0.6,
    heaSpe_min=0.2,
    cooSpe_min=0.2,
    have_locAdj=false)
    "Validate the heating case"
    annotation (Placement(transformation(extent={{20,76},{60,136}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU1(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    have_winSen=true,
    kCoo=1,
    kHea=1,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=false,
    TSupSet_max=297.15,
    TSupSet_min=285.15,
    heaSpe_max=0.6,
    heaSpe_min=0.2,
    cooSpe_min=0.2,
    have_locAdj=false)
    "Validate the cooling case for a system with a window sensor but no occupancy sensor"
    annotation (Placement(transformation(extent={{20,0},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU2(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    have_winSen=false,
    kCoo=1,
    kHea=1,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSet_max=297.15,
    TSupSet_min=285.15,
    heaSpe_max=0.6,
    heaSpe_min=0.2,
    cooSpe_min=0.2,
    have_locAdj=false)
    "Validate the cooling case for a system with an occupancy sensor but no window sensor"
    annotation (Placement(transformation(extent={{20,-78},{60,-18}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU3(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    have_winSen=true,
    kCoo=1,
    kHea=1,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSet_max=297.15,
    TSupSet_min=285.15,
    heaSpe_max=0.6,
    heaSpe_min=0.2,
    cooSpe_min=0.2,
    have_locAdj=false)
    "Validate the cooling case for a system with both a window sensor and an occupancy sensor"
    annotation (Placement(transformation(extent={{20,-154},{60,-94}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSet(
    k=293.15)
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSet(
    k=297.15)
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnoHeaSet(
    k=285.15)
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnoCooSet(
    k=303.15)
    "Unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TZon(
    duration=86400,
    height=6,
    offset=273.15 + 16,
    y(unit="K"))
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-120,44},{-100,64}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nOcc(
    k=2)
    "Number of occupants"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    k=true)
    "True window status"
    annotation (Placement(transformation(extent={{-180,-152},{-160,-132}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TZon1(
    duration=86400,
    height=-3,
    offset=273.15 + 26,
    y(unit="K"))
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup(
    height=2,
    duration=86400,
    offset=273.15 + 22.5,
    y(unit="K"))
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup1(
    height=-3,
    duration=86400,
    offset=273.15 + 24,
    y(unit="K"))
    "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(
    k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(
    k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win1(
    k=false)
    "Negative window status"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));

equation
  connect(TZon.y,conFCU. TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          101},{18,101}},     color={0,0,127}));
  connect(occSch.occupied,conFCU. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,114.5},{18,114.5}},   color={255,0,255}));
  connect(occSch.tNexOcc,conFCU. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,127.667},{18,127.667}},
                                   color={0,0,127}));
  connect(TSup.y,conFCU. TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,104.333},{18,104.333}},
                              color={0,0,127}));
  connect(win.y,conFCU1. u1Win) annotation (Line(points={{-158,-142},{0,-142},{0,
          1.66667},{18,1.66667}},
                         color={255,0,255}));
  connect(occSch.tNexOcc,conFCU1. tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,51.6667},{18,51.6667}},
                                 color={0,0,127}));
  connect(occSch.occupied,conFCU1. u1Occ)
    annotation (Line(points={{-99,48},{-40,48},{-40,38.5},{18,38.5}},
          color={255,0,255}));
  connect(TZon1.y,conFCU1. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,25},{18,25}},     color={0,0,127}));
  connect(TSup1.y,conFCU1. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,28.3333},{18,28.3333}},
                                color={0,0,127}));
  connect(TSup1.y,conFCU2. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-49.6667},{18,-49.6667}},
                                  color={0,0,127}));
  connect(occSch.occupied,conFCU2. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,-39.5},{18,-39.5}},   color={255,0,255}));
  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-26.3333},{18,-26.3333}},
                                   color={0,0,127}));
  connect(TZon1.y,conFCU2. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-53},{18,-53}},     color={0,0,127}));
  connect(occSch.occupied,conFCU3. u1Occ) annotation (Line(points={{-99,48},{-74,
          48},{-74,-115.5},{18,-115.5}},   color={255,0,255}));
  connect(TSup1.y,conFCU3. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-125.667},{18,-125.667}},
                                    color={0,0,127}));
  connect(TZon1.y,conFCU3. TZon) annotation (Line(points={{-158,-40},{-70,-40},{
          -70,-129},{18,-129}},     color={0,0,127}));
  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-102.333},{18,-102.333}},
                                     color={0,0,127}));
  connect(cooWarTim.y,conFCU. warUpTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,134.333},{18,134.333}},
                                    color={0,0,127}));
  connect(cooWarTim.y,conFCU. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,131},{18,131}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU1. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,58.3333},{18,58.3333}},
                                  color={0,0,127}));
  connect(cooWarTim.y,conFCU1. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,55},{18,55}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-19.6667},{18,-19.6667}},
                                    color={0,0,127}));
  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-23},{18,-23}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-98,-20},{
          -14,-20},{-14,-95.6667},{18,-95.6667}},
                                    color={0,0,127}));
  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-98,-20},{-14,
          -20},{-14,-99},{18,-99}},   color={0,0,127}));
  connect(demLim.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-122.333},{18,-122.333}},
                                             color={255,127,0}));
  connect(demLim.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-119},{18,-119}},    color={255,127,0}));
  connect(demLim.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-46.3333},{18,-46.3333}},
                                             color={255,127,0}));
  connect(demLim.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,-43},{18,-43}},      color={255,127,0}));
  connect(demLim.y,conFCU1. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,31.6667},{18,31.6667}},
                                           color={255,127,0}));
  connect(demLim.y,conFCU1. uCooDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,35},{18,35}},      color={255,127,0}));
  connect(demLim.y,conFCU. uCooDemLimLev) annotation (Line(points={{-158,-100},{
          -4,-100},{-4,111},{18,111}},     color={255,127,0}));
  connect(demLim.y,conFCU. uHeaDemLimLev) annotation (Line(points={{-158,-100},
          {-4,-100},{-4,107.667},{18,107.667}},
                                           color={255,127,0}));
  connect(nOcc.y, conFCU.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          84.3333},{18,84.3333}},
                      color={255,127,0}));
  connect(nOcc.y, conFCU2.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          -69.6667},{18,-69.6667}},
                        color={255,127,0}));
  connect(TOccHeaSet.y, conFCU.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,97.6667},{18,97.6667}},
                                            color={0,0,127}));
  connect(TOccCooSet.y, conFCU.TOccCooSet) annotation (Line(points={{-98,140},{
          -88,140},{-88,94.3333},{18,94.3333}},
                                      color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU.TUnoHeaSet) annotation (Line(points={{-58,140},{-48,
          140},{-48,91},{18,91}},     color={0,0,127}));
  connect(TUnoCooSet.y, conFCU.TUnoCooSet) annotation (Line(points={{-18,140},{
          -8,140},{-8,87.6667},{18,87.6667}},
                                     color={0,0,127}));
  connect(TOccHeaSet.y, conFCU1.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,21.6667},{18,21.6667}},
                                             color={0,0,127}));
  connect(TOccCooSet.y, conFCU1.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,18.3333},{18,18.3333}},
                                          color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,15},{18,15}},     color={0,0,127}));
  connect(TUnoCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,11.6667},{18,11.6667}},
                                        color={0,0,127}));
  connect(TOccHeaSet.y, conFCU2.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-56.3333},{18,-56.3333}},
                                               color={0,0,127}));
  connect(TOccCooSet.y, conFCU2.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,-59.6667},{18,-59.6667}},
                                            color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU2.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,-63},{18,-63}},     color={0,0,127}));
  connect(TUnoCooSet.y, conFCU2.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,-66.3333},{18,-66.3333}},
                                          color={0,0,127}));
  connect(TOccHeaSet.y, conFCU3.TOccHeaSet) annotation (Line(points={{-138,140},
          {-128,140},{-128,-132.333},{18,-132.333}},
                                                 color={0,0,127}));
  connect(TOccCooSet.y, conFCU3.TOccCooSet) annotation (Line(points={{-98,140},
          {-88,140},{-88,-135.667},{18,-135.667}},
                                              color={0,0,127}));
  connect(TUnoHeaSet.y, conFCU3.TUnoHeaSet) annotation (Line(points={{-58,140},{
          -48,140},{-48,-139},{18,-139}},     color={0,0,127}));
  connect(TUnoCooSet.y, conFCU3.TUnoCooSet) annotation (Line(points={{-18,140},
          {-8,140},{-8,-142.333},{18,-142.333}},
                                            color={0,0,127}));
  connect(conFCU1.y1Fan, conFCU1.u1Fan) annotation (Line(points={{62,46.6667},{
          72,46.6667},{72,-8},{12,-8},{12,5},{18,5}},
                                               color={255,0,255}));
  connect(conFCU2.y1Fan, conFCU2.u1Fan) annotation (Line(points={{62,-31.3333},
          {72,-31.3333},{72,-86},{12,-86},{12,-73},{18,-73}},
                                                    color={255,0,255}));
  connect(conFCU3.y1Fan, conFCU3.u1Fan) annotation (Line(points={{62,-107.333},
          {72,-107.333},{72,-160},{10,-160},{10,-149},{18,-149}},
                                                        color={255,0,255}));
  connect(conFCU.y1Fan, conFCU.u1Fan) annotation (Line(points={{62,122.667},{70,
          122.667},{70,70},{10,70},{10,81},{18,81}},
                                                color={255,0,255}));
  connect(nOcc.y, conFCU3.nOcc) annotation (Line(points={{-138,0},{-10,0},{-10,
          -145.667},{18,-145.667}},
                                color={255,127,0}));
  connect(win1.y, conFCU3.u1Win) annotation (Line(points={{-158,-170},{0,-170},
          {0,-152.333},{18,-152.333}},
                                  color={255,0,255}));
annotation (experiment(StopTime=86400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/FanCoilUnits/Validation/Controller.mos"
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a>.
</p>
<p>
<code>conFCU</code> represents an instance of the controller with heating mode 
operation, with the open-loop signals for measured zone temperature and measured 
supply air temperature increasing with time.
</p>
<p>
<code>conFCU1</code> represents an instance of the controller with cooling mode 
operation, with the open-loop signals for measured zone temperature and measured 
supply air temperature decreasing with time.
</p>
<p>
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
