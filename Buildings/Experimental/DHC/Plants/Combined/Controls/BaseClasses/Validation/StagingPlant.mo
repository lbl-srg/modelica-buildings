within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.Validation;
model StagingPlant "Validation of plant staging block"
  extends Modelica.Icons.Example;

  parameter Integer nChi(final min=1, start=1)=2
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate QChiWatChi_flow_nominal=-4.4E6
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Integer nChiHea(final min=1, start=1)=3
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real PLRStaTra(final unit="1", final min=0, final max=1) = 0.85
    "Part load ratio triggering stage transition";
  parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal=-6E6
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=6.4E6
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.HeatFlowRate mChiWat_flow_nominal=
    abs(QChiWatChi_flow_nominal+QChiWatCasCoo_flow_nominal) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /
    5
    "CHW design mass flow rate"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.HeatFlowRate mHeaWat_flow_nominal=
    QHeaWat_flow_nominal /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /
    10
    "HW design mass flow rate"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  BaseClasses.StagingPlant
    staChi(
    final nChi=nChi,
    final nChiHea=nChiHea,
    final QChiWatChi_flow_nominal=QChiWatChi_flow_nominal,
    final QChiWatCasCoo_flow_nominal=QChiWatCasCoo_flow_nominal,
    final QHeaWat_flow_nominal=QHeaWat_flow_nominal) "Chiller staging block"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable ratFlo(table=[0,0,0; 1,
        0,0; 4,0.3,0.1; 5,1,0.1; 10,0.1,0.1; 13,1,0.3; 16,0.3,1;20,0.1,0.1; 24,0.1,0.3; 25,
        0.1,1; 30,0,0],
    timeScale=1000) "Source signal"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1(k=true)
    "Enable signal"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=7 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatPriRet(k=12 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=60 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatPriRet(k=50 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Modelica.Blocks.Noise.TruncatedNormalNoise noi(
    samplePeriod=300,
    y_min=-0.3,
    y_max=+0.3) "Noise"
    annotation (Placement(transformation(extent={{-114,10},{-94,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter sca(final k=
        mChiWat_flow_nominal) "Scale signal"
    annotation (Placement(transformation(extent={{12,40},{32,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addNoi[2] "Add noise"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter sca1(final k=
        mHeaWat_flow_nominal) "Scale signal"
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Continuous.FirstOrder fil(T=60, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter noise"
    annotation (Placement(transformation(extent={{-86,10},{-66,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim[2](each uMax=1.1, each uMin
      =0) "Limit signal"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(u1.y, staChi.u1Coo) annotation (Line(points={{52,80},{60,80},{60,
          8.57143},{78,8.57143}},
               color={255,0,255}));
  connect(u1.y, staChi.u1Hea) annotation (Line(points={{52,80},{60,80},{60,
          7.14286},{78,7.14286}},
               color={255,0,255}));
  connect(TChiWatSupSet.y, staChi.TChiWatSupSet) annotation (Line(points={{-38,-20},
          {40,-20},{40,2.85714},{78,2.85714}},
                                 color={0,0,127}));
  connect(THeaWatPriRet.y, staChi.THeaWatPriRet) annotation (Line(points={{-78,-80},
          {50,-80},{50,-8.57143},{78,-8.57143}},
                                     color={0,0,127}));
  connect(THeaWatSupSet.y, staChi.THeaWatSupSet) annotation (Line(points={{-38,-60},
          {48,-60},{48,-7.14286},{78,-7.14286}},
                                   color={0,0,127}));
  connect(TChiWatPriRet.y, staChi.TChiWatPriRet) annotation (Line(points={{-78,-40},
          {42,-40},{42,0},{78,0}}, color={0,0,127}));
  connect(sca.y, staChi.mChiWatPri_flow)
    annotation (Line(points={{34,50},{40,50},{40,4.28571},{78,4.28571}},
                                                           color={0,0,127}));
  connect(sca1.y, staChi.mHeaWatPri_flow) annotation (Line(points={{34,20},{38,
          20},{38,-5.71429},{78,-5.71429}},
                                color={0,0,127}));
  connect(ratFlo.y[1:2], addNoi[1:2].u1) annotation (Line(points={{-78,80},{-60,
          80},{-60,56},{-52,56}}, color={0,0,127}));
  connect(noi.y, fil.u)
    annotation (Line(points={{-93,20},{-88,20}}, color={0,0,127}));
  connect(lim[1].y, sca.u)
    annotation (Line(points={{2,50},{10,50}}, color={0,0,127}));
  connect(lim[2].y, sca1.u)
    annotation (Line(points={{2,50},{6,50},{6,20},{10,20}}, color={0,0,127}));
  connect(fil.y, addNoi[1].u2) annotation (Line(points={{-65,20},{-60,20},{-60,44},
          {-52,44}}, color={0,0,127}));
  connect(fil.y, addNoi[2].u2) annotation (Line(points={{-65,20},{-60,20},{-60,44},
          {-52,44}}, color={0,0,127}));
  connect(addNoi.y, lim.u)
    annotation (Line(points={{-28,50},{-22,50}}, color={0,0,127}));
          annotation (
              __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Controls/BaseCLasses/Validation/StagingPlant.mos"
      "Simulate and plot"),
    experiment(
      StopTime=30000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end StagingPlant;
