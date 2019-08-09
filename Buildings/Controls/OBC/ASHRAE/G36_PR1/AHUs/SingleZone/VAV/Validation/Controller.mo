within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model Controller "Validation controller model"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV(
    kHea=1,
    yHeaMax=1,
    yMin=0.1,
    AFlo=50,
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    use_TMix=false,
    controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the heating case"
    annotation (Placement(transformation(extent={{20,74},{60,122}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    each duration=86400,
    each height=6,
    each offset=273.15 + 16)
                         "Measured zone temperature"
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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV1(
    kCoo=1,
    kHea=1,
    yHeaMax=1,
    yMin=0.1,
    AFlo=50,
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    use_TMix=false,
    controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,12},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(final k=273.15
         + 28) "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    each duration=86400,
    each height=-3,
    each offset=273.15 + 26)
                         "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV2(
    kCoo=1,
    kHea=1,
    yHeaMax=1,
    yMin=0.1,
    AFlo=50,
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    use_TMix=false,
    controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-48},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(final k=273.15 +
        22)    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV3(
    kCoo=1,
    kHea=1,
    yHeaMax=1,
    yMin=0.1,
    AFlo=50,
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=285.15,
    use_TMix=false,
    controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kMod=1,
    VOutMin_flow=6e-3,
    VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-108},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(final k=273.15 +
        16)    "Outdoor air dry bulb temperature"
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
  connect(TZon.y, conVAV.TZon) annotation (Line(points={{-159,78},{-30,78},{-30,
          114},{18,114}}, color={0,0,127}));
  connect(occSch.occupied, conVAV.uOcc) annotation (Line(points={{-99,48},{-74,48},
          {-74,110},{18,110}}, color={255,0,255}));
  connect(occSch.tNexOcc, conVAV.tNexOcc) annotation (Line(points={{-99,60},{-78,
          60},{-78,118},{18,118}}, color={0,0,127}));
  connect(TCut.y, conVAV.TCut) annotation (Line(points={{-99,24},{-52,24},{-52,106},
          {18,106}}, color={0,0,127}));
  connect(win.y, conVAV.uWin) annotation (Line(points={{-99,-120},{0,-120},{0,90},
          {18,90}}, color={255,0,255}));
  connect(nOcc.y, conVAV.nOcc) annotation (Line(points={{-99,-24},{-8,-24},{-8,94},
          {18,94}}, color={0,0,127}));
  connect(TOut.y, conVAV.TOut)
    annotation (Line(points={{-159,122},{18,122}}, color={0,0,127}));
  connect(TSup.y, conVAV.TSup) annotation (Line(points={{-159,40},{-140,40},{-140,
          102},{18,102}}, color={0,0,127}));
  connect(win.y, conVAV1.uWin) annotation (Line(points={{-99,-120},{0,-120},{0,28},
          {18,28}}, color={255,0,255}));
  connect(nOcc.y, conVAV1.nOcc) annotation (Line(points={{-99,-24},{-20,-24},{-20,
          32},{18,32}}, color={0,0,127}));
  connect(occSch.tNexOcc, conVAV1.tNexOcc) annotation (Line(points={{-99,60},{-20,
          60},{-20,56},{18,56}}, color={0,0,127}));
  connect(occSch.occupied, conVAV1.uOcc)
    annotation (Line(points={{-99,48},{18,48}}, color={255,0,255}));
  connect(TOut1.y, conVAV1.TOut)
    annotation (Line(points={{-159,4},{6,4},{6,60},{18,60}}, color={0,0,127}));
  connect(TZon1.y, conVAV1.TZon) annotation (Line(points={{-159,-40},{-70,-40},{
          -70,52},{18,52}}, color={0,0,127}));
  connect(TSup1.y, conVAV1.TSup) annotation (Line(points={{-159,-70},{-84,-70},{
          -84,40},{18,40}}, color={0,0,127}));
  connect(TCut.y, conVAV1.TCut) annotation (Line(points={{-99,24},{-52,24},{-52,
          44},{18,44}}, color={0,0,127}));
  connect(win.y,conVAV2. uWin) annotation (Line(points={{-99,-120},{0,-120},{0,-32},
          {18,-32}},           color={255,0,255}));
  connect(TSup1.y,conVAV2. TSup) annotation (Line(points={{-159,-70},{-84,-70},{
          -84,-20},{18,-20}}, color={0,0,127}));
  connect(occSch.occupied,conVAV2. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-12},{18,-12}},                     color={255,0,255}));
  connect(occSch.tNexOcc,conVAV2. tNexOcc) annotation (Line(points={{-99,60},{-78,
          60},{-78,-4},{18,-4}},       color={0,0,127}));
  connect(TCut.y,conVAV2. TCut) annotation (Line(points={{-99,24},{-52,24},{-52,
          -16},{18,-16}},                     color={0,0,127}));
  connect(nOcc.y,conVAV2. nOcc) annotation (Line(points={{-99,-24},{-20,-24},{-20,
          -28},{18,-28}},                           color={0,0,127}));
  connect(TZon1.y, conVAV2.TZon) annotation (Line(points={{-159,-40},{-70,-40},{
          -70,-8},{18,-8}}, color={0,0,127}));
  connect(TOut2.y, conVAV2.TOut) annotation (Line(points={{-159,-100},{-40,-100},
          {-40,0},{18,0}}, color={0,0,127}));
  connect(win.y, conVAV3.uWin) annotation (Line(points={{-99,-120},{0,-120},{0,-92},
          {18,-92}}, color={255,0,255}));
  connect(occSch.occupied, conVAV3.uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-72},{18,-72}}, color={255,0,255}));
  connect(TCut.y, conVAV3.TCut) annotation (Line(points={{-99,24},{-52,24},{-52,
          -76},{18,-76}}, color={0,0,127}));
  connect(TSup1.y, conVAV3.TSup) annotation (Line(points={{-159,-70},{-84,-70},{
          -84,-80},{18,-80}}, color={0,0,127}));
  connect(nOcc.y, conVAV3.nOcc) annotation (Line(points={{-99,-24},{-20,-24},{-20,
          -88},{18,-88}}, color={0,0,127}));
  connect(TZon1.y, conVAV3.TZon) annotation (Line(points={{-159,-40},{-70,-40},{
          -70,-68},{18,-68}}, color={0,0,127}));
  connect(occSch.tNexOcc, conVAV3.tNexOcc) annotation (Line(points={{-99,60},{-78,
          60},{-78,-64},{18,-64}}, color={0,0,127}));
  connect(TOut3.y, conVAV3.TOut) annotation (Line(points={{-159,-138},{8,-138},{
          8,-60},{18,-60}}, color={0,0,127}));
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
