within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Validation;
model Controller "Validation controller model"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller mulAHUCon(
      VPriSysMax_flow=0.35, peaSysPop=6) "Multizone VAV AHU controller"
    annotation (Placement(transformation(extent={{100,-80},{180,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-160,189},{-140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20) "Heating on setpoint"
    annotation (Placement(transformation(extent={{-220,209},{-200,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15)
    "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine2(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine3(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs3
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round4(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-100,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sumDesZonPop(
    final k=5)
    "Sum of design zone population"
    annotation (Placement(transformation(extent={{-220,119},{-200,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sumDesPopBreZon(
    final k=0.0125)
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-160,101},{-140,122}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sumDesAreBreZon(
    final k=0.03)
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-220,79},{-200,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desSysVenEff(
    final k=1)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{-160,51},{-140,72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uncOutAir(
    amplitude=0.01,
    width=0.25,
    period=3600,
    offset=0.0375) "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uOutAirFra_max(
    amplitude=0.005,
    width=0.25,
    period=3600,
    offset=0.015)
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));

equation
  connect(TOut.y, mulAHUCon.TOut) annotation (Line(points={{-198,180},{92,180},
          {92,64},{96,64}}, color={0,0,127}));
  connect(ducStaPre.y, mulAHUCon.ducStaPre) annotation (Line(points={{-138,160},
          {30,160},{30,60},{88,60},{88,68},{96,68}}, color={0,0,127}));
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
  connect(opeMod.y, mulAHUCon.uOpeMod) annotation (Line(points={{-158,-140},{42,
          -140},{42,72},{94,72},{94,74},{96,74},{96,78}}, color={255,127,0}));
  connect(maxSupResReq.y, mulAHUCon.uZonTemResReq) annotation (Line(points={{
          -38,-160},{44,-160},{44,58},{96,58}}, color={255,127,0}));
  connect(ducPreResReq.y, mulAHUCon.uZonPreResReq) annotation (Line(points={{
          -38,-200},{48,-200},{48,74},{96,74}}, color={255,127,0}));
  connect(TMixMea.y, mulAHUCon.TMix) annotation (Line(points={{-38,-120},{88,
          -120},{88,-66},{96,-66}}, color={0,0,127}));
  connect(VOut_flow.y, mulAHUCon.VOut_flow) annotation (Line(points={{-158,-100},
          {50,-100},{50,2},{96,2}}, color={0,0,127}));
  connect(TOutCut.y, mulAHUCon.TOutCut) annotation (Line(points={{-78,-80},{84,
          -80},{84,-24},{96,-24}}, color={0,0,127}));
  connect(TSup.y, mulAHUCon.TSup) annotation (Line(points={{-158,-60},{54,-60},
          {54,48},{96,48}}, color={0,0,127}));
  connect(sumDesZonPop.y, mulAHUCon.sumDesZonPop) annotation (Line(points={{
          -198,129.5},{46,129.5},{46,42},{96,42}}, color={0,0,127}));
  connect(sumDesPopBreZon.y, mulAHUCon.VSumDesPopBreZon_flow) annotation (Line(
        points={{-138,111.5},{50,111.5},{50,28},{88,28},{88,34},{96,34}}, color=
         {0,0,127}));
  connect(sumDesAreBreZon.y, mulAHUCon.VSumDesAreBreZon_flow) annotation (Line(
        points={{-198,89.5},{48,89.5},{48,26},{84,26},{84,30},{96,30}}, color={
          0,0,127}));
  connect(desSysVenEff.y, mulAHUCon.uDesSysVenEff) annotation (Line(points={{
          -138,61.5},{28,61.5},{28,28},{82,28},{82,24},{96,24}}, color={0,0,127}));
  connect(uncOutAir.y, mulAHUCon.VSumUncOutAir_flow) annotation (Line(points={{
          -198,40},{56,40},{56,18},{96,18}}, color={0,0,127}));
  connect(vavBoxFlo2.y, add2.u1) annotation (Line(points={{-138,20},{-120,20},{-120,
          6},{-102,6}}, color={0,0,127}));
  connect(vavBoxFlo1.y, add2.u2) annotation (Line(points={{-138,-20},{-120,-20},
          {-120,-6},{-102,-6}}, color={0,0,127}));
  connect(add2.y, mulAHUCon.VSumSysPriAir_flow) annotation (Line(points={{-78,0},
          {88,0},{88,14},{96,14}}, color={0,0,127}));
  connect(uOutAirFra_max.y, mulAHUCon.uOutAirFra_max) annotation (Line(points={
          {-198,-40},{58,-40},{58,8},{96,8}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
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
