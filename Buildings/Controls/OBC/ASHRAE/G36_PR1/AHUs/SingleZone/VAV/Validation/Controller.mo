within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model Controller "Validation of the top-level controller"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV(
    final have_winSen=false,
    final kHea=1,
    final yHeaMax=1,
    final yMin=0.1,
    final AFlo=50,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final use_TMix=false,
    final controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25) "Validate the heating case"
    annotation (Placement(transformation(extent={{20,74},{60,122}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV1(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final yHeaMax=1,
    final yMin=0.1,
    final AFlo=50,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final use_TMix=false,
    final controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,12},{60,60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV2(
    final have_winSen=false,
    final kCoo=1,
    final kHea=1,
    final yHeaMax=1,
    final yMin=0.1,
    final AFlo=50,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=true,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final use_TMix=false,
    final controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-48},{60,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller conVAV3(
    final have_winSen=true,
    final kCoo=1,
    final kHea=1,
    final yHeaMax=1,
    final yMin=0.1,
    final AFlo=50,
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final have_occSen=false,
    final TSupSetMax=297.15,
    final TSupSetMin=285.15,
    final use_TMix=false,
    final controllerTypeMod=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kMod=1,
    final VOutMin_flow=6e-3,
    final VOutDes_flow=0.25) "Validate the cooling case"
    annotation (Placement(transformation(extent={{20,-108},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final duration=86400,
    final height=6,
    final offset=273.15 + 16)  "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{4,20})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-120,44},{-100,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCut(
    final k=289.15)
    "Fixed dry bulb temperature high limit cutoff for economizer"
    annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nOcc(final k=2)
    "Number of occupants"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(final k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(final k=290.15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=301.15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    final duration=86400,
    final height=-3,
    final offset=273.15 + 26)  "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(final k=295.15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(
    final k=289.15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=2,
    final duration=86400,
    final offset=273.15 + 22.5) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup1(
    final height=-3,
    final duration=86400,
    final offset=273.15 + 24) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

equation
  connect(TZon.y, conVAV.TZon) annotation (Line(points={{-158,80},{-20,80},{-20,
          111.846},{18,111.846}}, color={0,0,127}));
  connect(occSch.occupied, conVAV.uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,108.154},{18,108.154}},
                                       color={255,0,255}));
  connect(occSch.tNexOcc, conVAV.tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,117.385},{18,117.385}},
                                           color={0,0,127}));
  connect(TCut.y, conVAV.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          104.462},{18,104.462}},
                         color={0,0,127}));
  connect(nOcc.y, conVAV.nOcc) annotation (Line(points={{-98,-24},{-8,-24},{-8,
          93.3846},{18,93.3846}},
                         color={0,0,127}));
  connect(TOut.y, conVAV.TOut)
    annotation (Line(points={{-158,120},{-20,120},{-20,120.154},{18,120.154}},
          color={0,0,127}));
  connect(TSup.y, conVAV.TSup) annotation (Line(points={{-158,40},{-140,40},{
          -140,100.769},{18,100.769}},
                                  color={0,0,127}));
  connect(win.y, conVAV1.uWin) annotation (Line(points={{-98,-120},{0,-120},{0,27.6923},
          {18,27.6923}}, color={255,0,255}));
  connect(occSch.tNexOcc, conVAV1.tNexOcc) annotation (Line(points={{-99,60},{
          -20,60},{-20,55.3846},{18,55.3846}},
                                           color={0,0,127}));
  connect(occSch.occupied, conVAV1.uOcc)
    annotation (Line(points={{-99,48},{-40,48},{-40,46.1538},{18,46.1538}},
          color={255,0,255}));
  connect(TOut1.y, conVAV1.TOut)
    annotation (Line(points={{-158,4},{6,4},{6,58.1538},{18,58.1538}}, color={0,0,127}));
  connect(TZon1.y, conVAV1.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,49.8462},{18,49.8462}},color={0,0,127}));
  connect(TSup1.y, conVAV1.TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,38.7692},{18,38.7692}},color={0,0,127}));
  connect(TCut.y, conVAV1.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          42.4615},{18,42.4615}}, color={0,0,127}));
  connect(TSup1.y,conVAV2. TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-21.2308},{18,-21.2308}},color={0,0,127}));
  connect(occSch.occupied,conVAV2. uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-13.8462},{18,-13.8462}},           color={255,0,255}));
  connect(occSch.tNexOcc,conVAV2. tNexOcc) annotation (Line(points={{-99,60},{-80,
          60},{-80,-4.61538},{18,-4.61538}}, color={0,0,127}));
  connect(TCut.y,conVAV2. TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          -17.5385},{18,-17.5385}}, color={0,0,127}));
  connect(TZon1.y, conVAV2.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-10.1538},{18,-10.1538}},color={0,0,127}));
  connect(TOut2.y, conVAV2.TOut) annotation (Line(points={{-158,-100},{-40,-100},
          {-40,-1.84615},{18,-1.84615}}, color={0,0,127}));
  connect(win.y, conVAV3.uWin) annotation (Line(points={{-98,-120},{0,-120},{0,-92.3077},
          {18,-92.3077}}, color={255,0,255}));
  connect(occSch.occupied, conVAV3.uOcc) annotation (Line(points={{-99,48},{-74,
          48},{-74,-73.8462},{18,-73.8462}}, color={255,0,255}));
  connect(TCut.y, conVAV3.TCut) annotation (Line(points={{-98,24},{-52,24},{-52,
          -77.5385},{18,-77.5385}}, color={0,0,127}));
  connect(TSup1.y, conVAV3.TSup) annotation (Line(points={{-158,-70},{-84,-70},
          {-84,-81.2308},{18,-81.2308}},color={0,0,127}));
  connect(TZon1.y, conVAV3.TZon) annotation (Line(points={{-158,-40},{-70,-40},
          {-70,-70.1538},{18,-70.1538}},color={0,0,127}));
  connect(occSch.tNexOcc, conVAV3.tNexOcc) annotation (Line(points={{-99,60},{
          -80,60},{-80,-64.6154},{18,-64.6154}},
                                             color={0,0,127}));
  connect(TOut3.y, conVAV3.TOut) annotation (Line(points={{-158,-140},{8,-140},
          {8,-61.8462},{18,-61.8462}},color={0,0,127}));
  connect(nOcc.y, conVAV2.nOcc) annotation (Line(points={{-98,-24},{-8,-24},{-8,
          -28.6154},{18,-28.6154}}, color={0,0,127}));

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
