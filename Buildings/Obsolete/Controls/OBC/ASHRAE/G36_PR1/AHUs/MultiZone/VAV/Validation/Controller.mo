within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Validation;
model Controller "Validation controller model"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
      VPriSysMax_flow=0.35, peaSysPop=6) "Multizone VAV AHU controller"
    annotation (Placement(transformation(extent={{100,-60},{180,68}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-160,189},{-140,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20) "Heating on setpoint"
    annotation (Placement(transformation(extent={{-220,209},{-200,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutCut(
    final k=297.15)
    "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine2(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine3(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs3
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Round round3(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Round round4(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-100,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant sumDesZonPop(
    final k=5)
    "Sum of design zone population"
    annotation (Placement(transformation(extent={{-220,119},{-200,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant sumDesPopBreZon(
    final k=0.0125)
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-160,101},{-140,122}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant sumDesAreBreZon(
    final k=0.03)
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-220,79},{-200,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desSysVenEff(
    final k=1)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{-160,51},{-140,72}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uncOutAir(
    amplitude=0.01,
    width=0.25,
    period=3600,
    offset=0.0375) "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uOutAirFra_max(
    amplitude=0.005,
    width=0.25,
    period=3600,
    offset=0.015)
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));

equation
  connect(TSetRooHeaOn.y, conAHU.TZonHeaSet) annotation (Line(points={{-198,
          219.5},{40,219.5},{40,64.4444},{96,64.4444}},
                                                 color={0,0,127}));
  connect(TSetRooCooOn.y, conAHU.TZonCooSet) annotation (Line(points={{-138,
          199.5},{34,199.5},{34,59.1111},{96,59.1111}},
                                                 color={0,0,127}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-198,180},{28,180},{28,
          53.7778},{96,53.7778}}, color={0,0,127}));
  connect(ducStaPre.y, conAHU.ducStaPre) annotation (Line(points={{-138,160},{
          22,160},{22,48.4444},{96,48.4444}},
                                           color={0,0,127}));
  connect(sine2.y, abs3.u)
    annotation (Line(points={{-198,-200},{-142,-200}}, color={0,0,127}));
  connect(abs3.y,round4. u)
    annotation (Line(points={{-118,-200},{-102,-200}},color={0,0,127}));
  connect(round4.y, ducPreResReq.u)
    annotation (Line(points={{-78,-200},{-62,-200}}, color={0,0,127}));
  connect(sine3.y, abs2.u)
    annotation (Line(points={{-198,-160},{-142,-160}}, color={0,0,127}));
  connect(abs2.y, round3.u)
    annotation (Line(points={{-118,-160},{-102,-160}}, color={0,0,127}));
  connect(round3.y, maxSupResReq.u)
    annotation (Line(points={{-78,-160},{-62,-160}}, color={0,0,127}));
  connect(opeMod.y, conAHU.uOpeMod) annotation (Line(points={{-158,-140},{28,
          -140},{28,-40.4444},{96,-40.4444}},
                                        color={255,127,0}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{-38,
          -160},{34,-160},{34,-45.7778},{96,-45.7778}},
                                                  color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{-38,
          -200},{40,-200},{40,-51.1111},{96,-51.1111}},
                                                  color={255,127,0}));
  connect(TMixMea.y, conAHU.TMix) annotation (Line(points={{-38,-120},{22,-120},
          {22,-33.3333},{96,-33.3333}}, color={0,0,127}));
  connect(VOut_flow.y, conAHU.VOut_flow) annotation (Line(points={{-158,-100},{
          16,-100},{16,-26.2222},{96,-26.2222}},
                                              color={0,0,127}));
  connect(TOutCut.y, conAHU.TOutCut) annotation (Line(points={{-78,-80},{10,-80},
          {10,-10.2222},{96,-10.2222}}, color={0,0,127}));
  connect(TSup.y, conAHU.TSup) annotation (Line(points={{-158,-60},{4,-60},{4,-4.88889},
          {96,-4.88889}}, color={0,0,127}));
  connect(sumDesZonPop.y, conAHU.sumDesZonPop) annotation (Line(points={{-198,
          129.5},{16,129.5},{16,37.7778},{96,37.7778}},
                                                 color={0,0,127}));
  connect(sumDesPopBreZon.y, conAHU.VSumDesPopBreZon_flow) annotation (Line(
        points={{-138,111.5},{10,111.5},{10,32.4444},{96,32.4444}}, color={0,0,127}));
  connect(sumDesAreBreZon.y, conAHU.VSumDesAreBreZon_flow) annotation (Line(
        points={{-198,89.5},{4,89.5},{4,27.1111},{96,27.1111}}, color={0,0,127}));
  connect(desSysVenEff.y, conAHU.uDesSysVenEff) annotation (Line(points={{-138,
          61.5},{-2,61.5},{-2,21.7778},{96,21.7778}},
                                                color={0,0,127}));
  connect(uncOutAir.y, conAHU.VSumUncOutAir_flow) annotation (Line(points={{-198,40},
          {-8,40},{-8,16.4444},{96,16.4444}}, color={0,0,127}));
  connect(vavBoxFlo2.y, add2.u1) annotation (Line(points={{-138,20},{-120,20},{-120,
          6},{-102,6}}, color={0,0,127}));
  connect(vavBoxFlo1.y, add2.u2) annotation (Line(points={{-138,-20},{-120,-20},
          {-120,-6},{-102,-6}}, color={0,0,127}));
  connect(add2.y, conAHU.VSumSysPriAir_flow) annotation (Line(points={{-78,0},{
          -8,0},{-8,11.1111},{96,11.1111}},
                                         color={0,0,127}));
  connect(uOutAirFra_max.y, conAHU.uOutAirFra_max) annotation (Line(points={{-198,
          -40},{-2,-40},{-2,5.77778},{96,5.77778}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2020, by Jianjun Hu:<br/>
Reimplemented to validate new controller which does not have vector
related calculation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-240,-240},{240,240}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Controller;
