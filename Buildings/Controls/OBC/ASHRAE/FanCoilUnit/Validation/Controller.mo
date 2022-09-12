within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Validation;
model Controller
    "Validation of the top-level controller"
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU(
    final have_winSen=false,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_cooCoi=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the heating case"
    annotation (Placement(transformation(extent={{20,76},{60,136}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU1(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_cooCoi=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,0},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU2(
    final have_winSen=false,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_cooCoi=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-78},{60,-18}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU3(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_cooCoi=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-154},{60,-94}})));

protected
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
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(final k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

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
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooWarTim(
    final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

equation
  connect(TZon.y,conFCU. TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          98},{18,98}},   color={0,0,127}));

  connect(occSch.occupied,conFCU. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,114},{18,114}},     color={255,0,255}));

  connect(occSch.tNexOcc,conFCU. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,126},{18,126}},     color={0,0,127}));

  connect(TSup.y,conFCU. TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,102},{18,102}},    color={0,0,127}));

  connect(win.y,conFCU1. uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          10},{18,10}},  color={255,0,255}));

  connect(occSch.tNexOcc,conFCU1. tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,50},{18,50}},       color={0,0,127}));

  connect(occSch.occupied,conFCU1. uOcc)
    annotation (Line(points={{-99,48},{-40,48},{-40,38},{18,38}},
          color={255,0,255}));

  connect(TZon1.y,conFCU1. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,22},{18,22}},color={0,0,127}));

  connect(TSup1.y,conFCU1. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,26},{18,26}},          color={0,0,127}));

  connect(TSup1.y,conFCU2. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-52},{18,-52}},          color={0,0,127}));

  connect(occSch.occupied,conFCU2. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-40},{18,-40}},           color={255,0,255}));

  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-28},{18,-28}},       color={0,0,127}));

  connect(TZon1.y,conFCU2. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-56},{18,-56}},color={0,0,127}));

  connect(win.y,conFCU3. uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          -144},{18,-144}},
                          color={255,0,255}));

  connect(occSch.occupied,conFCU3. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-116},{18,-116}},         color={255,0,255}));

  connect(TSup1.y,conFCU3. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-128},{18,-128}},        color={0,0,127}));

  connect(TZon1.y,conFCU3. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-132},{18,-132}},
                              color={0,0,127}));

  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-104},{18,-104}},     color={0,0,127}));

  connect(cooWarTim.y,conFCU. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,134},{18,134}},     color={0,0,127}));

  connect(cooWarTim.y,conFCU. cooDowTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,130},{18,130}},         color={0,0,127}));

  connect(cooWarTim.y,conFCU1. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,58},{18,58}},           color={0,0,127}));

  connect(cooWarTim.y,conFCU1. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,54},{18,54}},       color={0,0,127}));

  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,-20},{18,-20}},           color={0,0,127}));

  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,-24},{18,-24}},       color={0,0,127}));

  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,-96},{18,-96}},           color={0,0,127}));

  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,-100},{18,-100}},     color={0,0,127}));

  connect(demLim.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-124},{18,-124}},    color={255,127,0}));

  connect(demLim.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-120},{18,-120}},    color={255,127,0}));

  connect(demLim.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-48},{18,-48}},      color={255,127,0}));

  connect(demLim.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-44},{18,-44}},      color={255,127,0}));

  connect(demLim.y,conFCU1. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,30},{18,30}},      color={255,127,0}));

  connect(demLim.y,conFCU1. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,34},{18,34}},      color={255,127,0}));

  connect(demLim.y,conFCU. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,110},{18,110}},    color={255,127,0}));

  connect(demLim.y,conFCU. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,106},{18,106}},    color={255,127,0}));

  connect(nOcc.y, conFCU.nOcc) annotation (Line(points={{-128,0},{-10,0},{-10,
          94},{18,94}},
                    color={255,127,0}));
  connect(nOcc.y, conFCU2.nOcc) annotation (Line(points={{-128,0},{-10,0},{-10,
          -60},{18,-60}},
                     color={255,127,0}));
  connect(conFCU.yFan, conFCU.uFan) annotation (Line(points={{62,126},{70,126},
          {70,74},{12,74},{12,90},{18,90}}, color={255,0,255}));
  connect(conFCU1.yFan, conFCU1.uFan) annotation (Line(points={{62,50},{72,50},
          {72,-8},{12,-8},{12,14},{18,14}},
                                          color={255,0,255}));
  connect(conFCU2.yFan, conFCU2.uFan) annotation (Line(points={{62,-28},{72,-28},
          {72,-86},{12,-86},{12,-64},{18,-64}}, color={255,0,255}));
  connect(conFCU3.yFan, conFCU3.uFan) annotation (Line(points={{62,-104},{72,
          -104},{72,-160},{10,-160},{10,-140},{18,-140}},
                                                    color={255,0,255}));
  connect(conFCU.yHeaCoi, conFCU.uHeaCoi) annotation (Line(points={{62,110},{68,
          110},{68,72},{14,72},{14,82},{18,82}}, color={0,0,127}));
  connect(conFCU.yCooCoi, conFCU.uCooCoi) annotation (Line(points={{62,106},{66,
          106},{66,70},{16,70},{16,78},{18,78}}, color={0,0,127}));
  connect(conFCU1.yHeaCoi, conFCU1.uHeaCoi) annotation (Line(points={{62,34},{
          70,34},{70,-6},{14,-6},{14,6},{18,6}}, color={0,0,127}));
  connect(conFCU1.yCooCoi, conFCU1.uCooCoi) annotation (Line(points={{62,30},{
          68,30},{68,-4},{16,-4},{16,2},{18,2}}, color={0,0,127}));
  connect(conFCU2.yHeaCoi, conFCU2.uHeaCoi) annotation (Line(points={{62,-44},{
          70,-44},{70,-84},{14,-84},{14,-72},{18,-72}}, color={0,0,127}));
  connect(conFCU2.yCooCoi, conFCU2.uCooCoi) annotation (Line(points={{62,-48},{
          68,-48},{68,-82},{16,-82},{16,-76},{18,-76}}, color={0,0,127}));
  connect(conFCU3.yHeaCoi, conFCU3.uHeaCoi) annotation (Line(points={{62,-120},
          {70,-120},{70,-158},{12,-158},{12,-148},{18,-148}}, color={0,0,127}));
  connect(conFCU3.yCooCoi, conFCU3.uCooCoi) annotation (Line(points={{62,-124},
          {68,-124},{68,-156},{14,-156},{14,-152},{18,-152}}, color={0,0,127}));
annotation (experiment(StopTime=86400, Interval=300, Tolerance=1e-06),
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
