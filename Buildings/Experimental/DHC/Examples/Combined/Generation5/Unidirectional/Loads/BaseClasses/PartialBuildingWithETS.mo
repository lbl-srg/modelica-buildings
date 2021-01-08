within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads.BaseClasses;
model PartialBuildingWithETS
  extends DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    redeclare
      DHC.EnergyTransferStations.Combined.Generation5.HeatPumpHeatExchanger ets(
      final dT_nominal=dT_nominal,
      final TChiWatSup_nominal=TChiWatSup_nominal,
      final TChiWatRet_nominal=TChiWatRet_nominal,
      final THeaWatSup_nominal=THeaWatSup_nominal,
      final THeaWatRet_nominal=THeaWatRet_nominal,
      final dp_nominal=dp_nominal,
      final COPHeaWat_nominal=COPHeaWat_nominal));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal(min=0)=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=291.15
    "Chilled water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  final parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
     TChiWatSup_nominal + abs(dT_nominal)
     "Chilled water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=313.15
    "Heating water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  final parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
     THeaWatSup_nominal - abs(dT_nominal)
     "Heating water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Pressure dp_nominal=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Real COPHeaWat_nominal(final unit="1") = 5
    "COP of heat pump for heating water production"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real COPHotWat_nominal(final unit="1") = 2
    "COP of heat pump for hot water production"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupMaxSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point - Maximum value"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupMinSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point - Minimum value"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90})));
  // COMPONENTS
  Controls.OBC.CDL.Continuous.Line resTHeaWatSup "HW supply temperature reset"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "One"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Controls.OBC.CDL.Continuous.Gain mulPPumETS(u(final unit="W"), final k=facMul) if
                       have_pum "Scaling"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Controls.OBC.CDL.Interfaces.RealOutput PPumETS(final unit="W") if
                       have_pum "ETS pump power" annotation (Placement(
        transformation(extent={{220,-20},{260,20}}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,120})));
equation
  connect(TChiWatSupSet, ets.TChiWatSupSet) annotation (Line(points={{-240,80},{
          -52,80},{-52,-62},{-34,-62}},  color={0,0,127}));
  connect(resTHeaWatSup.y, ets.THeaWatSupSet) annotation (Line(points={{-88,-40},
          {-60,-40},{-60,-58},{-34,-58}}, color={0,0,127}));
  connect(THeaWatSupMaxSet, resTHeaWatSup.f2) annotation (Line(points={{-240,120},
          {-130,120},{-130,-48},{-112,-48}}, color={0,0,127}));
  connect(THeaWatSupMinSet, resTHeaWatSup.f1) annotation (Line(points={{-240,160},
          {-120,160},{-120,-36},{-112,-36}}, color={0,0,127}));
  connect(one.y, resTHeaWatSup.x2) annotation (Line(points={{-158,-60},{-126,-60},
          {-126,-44},{-112,-44}}, color={0,0,127}));
  connect(zer.y, resTHeaWatSup.x1) annotation (Line(points={{-158,-20},{-116,-20},
          {-116,-32},{-112,-32}}, color={0,0,127}));
  connect(mulPPumETS.y, PPumETS)
    annotation (Line(points={{212,0},{220,0},{226,0},{240,0}},
                                                 color={0,0,127}));
  connect(ets.PPum, mulPPumETS.u) annotation (Line(points={{34,-62},{180,-62},{
          180,0},{188,0}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialBuildingWithETS;
