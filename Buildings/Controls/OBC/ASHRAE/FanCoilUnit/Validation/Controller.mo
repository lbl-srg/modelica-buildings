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
    final have_coolingCoil=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the heating case"
    annotation (Placement(transformation(extent={{20,80},{60,132}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU1(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_coolingCoil=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,12},{60,64}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU2(
    final have_winSen=false,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_coolingCoil=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-50},{60,2}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller conFCU3(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final have_coolingCoil=true,
    final have_heatingCoil=true,
    final heaSpeMax=0.6,
    final heaSpeMin=0.2,
    final cooSpeMin=0.2)
    "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-112},{60,-60}})));

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

  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Logical pre block"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3
    "Logical pre block"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

equation
  connect(TZon.y,conFCU. TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          110},{18,110}}, color={0,0,127}));

  connect(occSch.occupied,conFCU. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,106},{18,106}},     color={255,0,255}));

  connect(occSch.tNexOcc,conFCU. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,122},{18,122}},     color={0,0,127}));

  connect(TSup.y,conFCU. TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,94},{18,94}},      color={0,0,127}));

  connect(win.y,conFCU1. uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          14},{18,14}},  color={255,0,255}));

  connect(occSch.tNexOcc,conFCU1. tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,54},{18,54}},       color={0,0,127}));

  connect(occSch.occupied,conFCU1. uOcc)
    annotation (Line(points={{-99,48},{-40,48},{-40,38},{18,38}},
          color={255,0,255}));

  connect(TZon1.y,conFCU1. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,42},{18,42}},color={0,0,127}));

  connect(TSup1.y,conFCU1. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,26},{18,26}},          color={0,0,127}));

  connect(TSup1.y,conFCU2. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-36},{18,-36}},          color={0,0,127}));

  connect(occSch.occupied,conFCU2. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-24},{18,-24}},           color={255,0,255}));

  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-8},{18,-8}},         color={0,0,127}));

  connect(TZon1.y,conFCU2. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-20},{18,-20}},color={0,0,127}));

  connect(win.y,conFCU3. uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          -110},{18,-110}},
                          color={255,0,255}));

  connect(occSch.occupied,conFCU3. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-86},{18,-86}},           color={255,0,255}));

  connect(TSup1.y,conFCU3. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-98},{18,-98}},          color={0,0,127}));

  connect(TZon1.y,conFCU3. TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-82},{18,-82}},color={0,0,127}));

  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-70},{18,-70}},       color={0,0,127}));

  connect(cooWarTim.y,conFCU. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,130},{18,130}},     color={0,0,127}));

  connect(cooWarTim.y,conFCU. cooDowTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,126},{18,126}},         color={0,0,127}));

  connect(cooWarTim.y,conFCU1. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,62},{18,62}},           color={0,0,127}));

  connect(cooWarTim.y,conFCU1. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,58},{18,58}},       color={0,0,127}));

  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,0},{18,0}},               color={0,0,127}));

  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,-4},{18,-4}},         color={0,0,127}));

  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-98,20},{-14,
          20},{-14,-62},{18,-62}},           color={0,0,127}));

  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-98,20},{
          -14,20},{-14,-66},{18,-66}},       color={0,0,127}));

  connect(demLim.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-94},{18,-94}},      color={255,127,0}));

  connect(demLim.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-90},{18,-90}},      color={255,127,0}));

  connect(demLim.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-32},{18,-32}},      color={255,127,0}));

  connect(demLim.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,-28},{18,-28}},      color={255,127,0}));

  connect(demLim.y,conFCU1. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,30},{18,30}},      color={255,127,0}));

  connect(demLim.y,conFCU1. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,34},{18,34}},      color={255,127,0}));

  connect(demLim.y,conFCU. uCooDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,102},{18,102}},    color={255,127,0}));

  connect(demLim.y,conFCU. uHeaDemLimLev) annotation (Line(points={{-128,-100},
          {-4,-100},{-4,98},{18,98}},      color={255,127,0}));

  connect(conFCU.yFan, pre.u) annotation (Line(points={{62,118},{68,118},{68,
          110},{78,110}},                             color={255,0,255}));

  connect(pre.y, conFCU.uFan) annotation (Line(points={{102,110},{120,110},{120,
          136},{0,136},{0,90},{18,90}},
                         color={255,0,255}));

  connect(conFCU1.yFan, pre1.u) annotation (Line(points={{62,50},{72,50},{72,50},
          {78,50}},         color={255,0,255}));

  connect(pre1.y, conFCU1.uFan) annotation (Line(points={{102,50},{110,50},{110,
          66},{10,66},{10,22},{18,22}},           color={255,0,255}));

  connect(conFCU2.yFan, pre2.u) annotation (Line(points={{62,-12},{70,-12},{70,
          -20},{78,-20}},     color={255,0,255}));

  connect(pre2.y, conFCU2.uFan) annotation (Line(points={{102,-20},{108,-20},{
          108,4},{12,4},{12,-40},{18,-40}},       color={255,0,255}));

  connect(conFCU3.yFan, pre3.u) annotation (Line(points={{62,-74},{68,-74},{68,
          -70},{78,-70}},     color={255,0,255}));

  connect(pre3.y, conFCU3.uFan) annotation (Line(points={{102,-70},{110,-70},{
          110,-54},{12,-54},{12,-102},{18,-102}},     color={255,0,255}));

  connect(nOcc.y, conFCU.nOcc) annotation (Line(points={{-128,0},{-10,0},{-10,
          86},{18,86}},
                    color={255,127,0}));
  connect(nOcc.y, conFCU2.nOcc) annotation (Line(points={{-128,0},{-10,0},{-10,
          -44},{18,-44}},
                     color={255,127,0}));
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{140,140}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller\">
Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Controller</a>.
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
