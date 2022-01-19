within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Validation;
model Controller "Validation of the top-level controller"
  Controller_new                                                   conVAV(
    kHea=1,
    AFlo=50,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the heating case"
    annotation (Placement(transformation(extent={{20,74},{60,122}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    duration=86400,
    height=6,
    offset=273.15 + 16)  "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,68},{-160,88}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-120,44},{-100,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCut(final k=273.15
         + 16) "Fixed dry bulb temperature high limit cutoff for economizer"
    annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nOcc(final k=2)
    "Number of occupants"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(final k=273.15 +
        17) "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,112},{-160,132}})));
  Controller_new                                                   conVAV1(
    kCoo=1,
    kHea=1,
    AFlo=50,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,12},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(final k=273.15
         + 28) "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    duration=86400,
    height=-3,
    offset=273.15 + 26)  "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Controller_new                                                   conVAV2(
    kCoo=1,
    kHea=1,
    AFlo=50,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-48},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(
    final k=273.15 + 22) "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Controller_new                                                   conVAV3(
    kCoo=1,
    kHea=1,
    AFlo=50,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-108},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(
    final k=273.15 + 16)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-148},{-160,-128}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=2,
    duration=86400,
    offset=273.15 + 22.5) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup1(
    height=-3,
    duration=86400,
    offset=273.15 + 24) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
equation
  connect(TZon.y, conVAV.TZon) annotation (Line(points={{-158,78},{-30,78},{-30,
          113},{18,113}}, color={0,0,127}));
  connect(occSch.occupied, conVAV.uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,116},{18,116}},
                               color={255,0,255}));
  connect(occSch.tNexOcc, conVAV.tNexOcc) annotation (Line(points={{-99,60},{
          -78,60},{-78,114.8},{18,114.8}},
                                   color={0,0,127}));
  connect(TCut.y, conVAV.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          98.6},{18,98.6}},
                     color={0,0,127}));
  connect(win.y, conVAV.uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          96.8},{18,96.8}},
                    color={255,0,255}));
  connect(TOut.y, conVAV.TOut)
    annotation (Line(points={{-158,122},{-70,122},{-70,120.8},{18,120.8}},
                                                   color={0,0,127}));
  connect(TSup.y, conVAV.TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,99.8},{18,99.8}},
                          color={0,0,127}));
  connect(win.y, conVAV1.uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          34.8},{18,34.8}},
                    color={255,0,255}));
  connect(occSch.tNexOcc, conVAV1.tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,52.8},{18,52.8}},
                                 color={0,0,127}));
  connect(occSch.occupied, conVAV1.uOcc)
    annotation (Line(points={{-99,48},{-40,48},{-40,54},{18,54}},
                                                color={255,0,255}));
  connect(TOut1.y, conVAV1.TOut)
    annotation (Line(points={{-158,4},{6,4},{6,58.8},{18,58.8}},
                                                             color={0,0,127}));
  connect(TZon1.y, conVAV1.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,51},{18,51}},color={0,0,127}));
  connect(TSup1.y, conVAV1.TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,37.8},{18,37.8}},
                            color={0,0,127}));
  connect(TCut.y, conVAV1.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          36.6},{18,36.6}},
                        color={0,0,127}));
  connect(win.y,conVAV2. uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          -25.2},{18,-25.2}},  color={255,0,255}));
  connect(TSup1.y,conVAV2. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-22.2},{18,-22.2}},
                              color={0,0,127}));
  connect(occSch.occupied,conVAV2. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-6},{18,-6}},                       color={255,0,255}));
  connect(occSch.tNexOcc,conVAV2. tNexOcc) annotation (Line(points={{-99,60},{
          -78,60},{-78,-7.2},{18,-7.2}},
                                       color={0,0,127}));
  connect(TCut.y,conVAV2. TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          -23.4},{18,-23.4}},                 color={0,0,127}));
  connect(TZon1.y, conVAV2.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-9},{18,-9}},color={0,0,127}));
  connect(TOut2.y, conVAV2.TOut) annotation (Line(points={{-158,-100},{-40,-100},
          {-40,-1.2},{18,-1.2}},
                           color={0,0,127}));
  connect(win.y, conVAV3.uWin) annotation (Line(points={{-98,-120},{0,-120},{0,
          -85.2},{18,-85.2}},
                     color={255,0,255}));
  connect(occSch.occupied, conVAV3.uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-66},{18,-66}}, color={255,0,255}));
  connect(TCut.y, conVAV3.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          -83.4},{18,-83.4}},
                          color={0,0,127}));
  connect(TSup1.y, conVAV3.TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-82.2},{18,-82.2}},
                              color={0,0,127}));
  connect(TZon1.y, conVAV3.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-69},{18,-69}},color={0,0,127}));
  connect(occSch.tNexOcc, conVAV3.tNexOcc) annotation (Line(points={{-99,60},{
          -78,60},{-78,-67.2},{18,-67.2}},
                                   color={0,0,127}));
  connect(TOut3.y, conVAV3.TOut) annotation (Line(points={{-158,-138},{8,-138},
          {8,-61.2},{18,-61.2}},
                            color={0,0,127}));
  annotation (experiment(StopTime=86400, Interval=300, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{80,140}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2019, by Kun Zhang:<br/>
Included more validation cases.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
