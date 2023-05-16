within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Validation;
model Controller "Validation controller model"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller conAHU(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4B,
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final VUncDesOutAir_flow=0.05,
    final VDesTotOutAir_flow=0.05) "Multizone VAV AHU controller"
    annotation (Placement(transformation(extent={{100,-120},{180,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final duration=3600,
    final offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=0.02,
    final height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    final height=4,
    final duration=1,
    final offset=273.15 + 2,
    final startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TOut(
    final amplitude=5,
    final offset=18 + 273.15,
    final freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,180},{-220,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin ducStaPre(
    final offset=200,
    final amplitude=150,
    final freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sine2(
    final offset=3,
    final amplitude=2,
    final freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-240,220},{-220,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sine3(
    final amplitude=6,
    final freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs3
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round4(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-120,220},{-100,240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-200,240},{-180,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sumDesPopBreZon(
    final k=0.0125)
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sumDesAreBreZon(
    final k=0.03)
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    final offset=0.08,
    final height=0.02,
    final duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    final height=0.05,
    final offset=0.08,
    final duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uOutAirFra_max(
    final amplitude=0.005,
    final width=0.25,
    final period=3600,
    final offset=0.015)
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpBui(
    final height=40,
    final offset=0,
    final duration=1800) "Building static presure"
    annotation (Placement(transformation(extent={{-240,-220},{-220,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaCoi(
    final k=0)
    "Heating coil position"
    annotation (Placement(transformation(extent={{-240,-260},{-220,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp cooCoi(
    final height=-0.3,
    final offset=0.96,
    final duration=3600,
    startTime=1000) "Cooling coil position"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse freRes(
    final width=0.95,
    final period=3600)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Break loop"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));

equation
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-218,190},{62,190},{62,
          25.4545},{96,25.4545}},  color={0,0,127}));
  connect(ducStaPre.y, conAHU.dpDuc) annotation (Line(points={{-178,210},{68,
          210},{68,29.0909},{96,29.0909}}, color={0,0,127}));
  connect(sine2.y, abs3.u)
    annotation (Line(points={{-218,230},{-162,230}},   color={0,0,127}));
  connect(abs3.y,round4. u)
    annotation (Line(points={{-138,230},{-122,230}},  color={0,0,127}));
  connect(round4.y, ducPreResReq.u)
    annotation (Line(points={{-98,230},{-82,230}},   color={0,0,127}));
  connect(sine3.y, abs2.u)
    annotation (Line(points={{-218,160},{-162,160}},   color={0,0,127}));
  connect(abs2.y, round3.u)
    annotation (Line(points={{-138,160},{-122,160}},   color={0,0,127}));
  connect(round3.y, maxSupResReq.u)
    annotation (Line(points={{-98,160},{-82,160}},   color={0,0,127}));
  connect(maxSupResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{-58,160},
          {56,160},{56,20},{96,20}},  color={255,127,0}));
  connect(ducPreResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{-58,230},
          {74,230},{74,34.5455},{96,34.5455}},  color={255,127,0}));
  connect(TMixMea.y, conAHU.TAirMix) annotation (Line(points={{-178,-190},{62,-190},
          {62,-90.9091},{96,-90.9091}}, color={0,0,127}));
  connect(VOut_flow.y, conAHU.VAirOut_flow) annotation (Line(points={{-178,-60},
          {38,-60},{38,-27.2727},{96,-27.2727}}, color={0,0,127}));
  connect(TSup.y, conAHU.TAirSup) annotation (Line(points={{-178,140},{44,140},
          {44,10.9091},{96,10.9091}}, color={0,0,127}));
  connect(vavBoxFlo2.y, add2.u1) annotation (Line(points={{-158,20},{-140,20},{-140,
          6},{-122,6}}, color={0,0,127}));
  connect(vavBoxFlo1.y, add2.u2) annotation (Line(points={{-158,-20},{-140,-20},
          {-140,-6},{-122,-6}}, color={0,0,127}));
  connect(uOutAirFra_max.y, conAHU.uOutAirFra_max) annotation (Line(points={{-218,
          -40},{32,-40},{32,-9.09091},{96,-9.09091}},color={0,0,127}));
  connect(heaCoi.y, conAHU.uHeaCoi_actual) annotation (Line(points={{-218,-250},
          {80,-250},{80,-118.182},{96,-118.182}}, color={0,0,127}));
  connect(cooCoi.y, conAHU.uCooCoi_actual) annotation (Line(points={{-178,-230},
          {74,-230},{74,-114.545},{96,-114.545}}, color={0,0,127}));
  connect(dpBui.y, conAHU.dpBui) annotation (Line(points={{-218,-210},{68,-210},
          {68,-96.3636},{96,-96.3636}}, color={0,0,127}));
  connect(freRes.y,not1. u)
    annotation (Line(points={{-218,-160},{-202,-160}}, color={255,0,255}));
  connect(not1.y, conAHU.u1SofSwiRes) annotation (Line(points={{-178,-160},{56,
          -160},{56,-76.3636},{96,-76.3636}}, color={255,0,255}));
  connect(conAHU.y1SupFan, pre.u) annotation (Line(points={{184,-40},{200,-40},
          {200,40},{218,40}},          color={255,0,255}));
  connect(pre.y, conAHU.u1SupFan) annotation (Line(points={{242,40},{250,40},{
          250,70},{50,70},{50,16.3636},{96,16.3636}}, color={255,0,255}));

  connect(sumDesPopBreZon.y, conAHU.VSumAdjPopBreZon_flow) annotation (Line(
        points={{-178,100},{38,100},{38,5.45455},{96,5.45455}}, color={0,0,127}));
  connect(sumDesAreBreZon.y, conAHU.VSumAdjAreBreZon_flow) annotation (Line(
        points={{-218,80},{32,80},{32,1.81818},{96,1.81818}}, color={0,0,127}));
  connect(add2.y, conAHU.VSumZonPri_flow) annotation (Line(points={{-98,0},{32,0},
          {32,-3.63636},{96,-3.63636}}, color={0,0,127}));
  connect(opeMod.y, conAHU.uAhuOpeMod) annotation (Line(points={{-178,250},{80,
          250},{80,38.1818},{96,38.1818}}, color={255,127,0}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-260,-280},{260,280}})),
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
