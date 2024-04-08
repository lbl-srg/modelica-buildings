within Buildings.Experimental.DHC.Loads.Combined.BaseClasses;
model PartialBuildingWithETS
  "Partial model with ETS model and partial building model"
  extends
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    nPorts_heaWat=1,
    nPorts_chiWat=1);
  parameter Modelica.Units.SI.Temperature TDisWatMin=6 + 273.15
    "District water minimum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TDisWatMax=17 + 273.15
    "District water maximum temperature" annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 4
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=18 + 273.15
    "Chilled water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=38 + 273.15
    "Heating water supply temperature"
    annotation (Dialog(group="ETS model parameters"));
  parameter Modelica.Units.SI.Temperature THotWatSup_nominal=63 + 273.15
    "Domestic hot water supply temperature to fixtures"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));
  parameter Modelica.Units.SI.Temperature TColWat_nominal=288.15
    "Cold water temperature (for hot water production)"
    annotation (Dialog(group="ETS model parameters", enable=have_hotWat));
  parameter Modelica.Units.SI.Pressure dp_nominal=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real COPHeaWat_nominal(final unit="1") = 4.0
    "COP of heat pump for heating water production"
    annotation (Dialog(group="ETS model parameters"));
  parameter Real COPHotWat_nominal(final unit="1") = 2.3
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
        origin={-320,80}), iconTransformation(
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
        origin={-320,120}), iconTransformation(
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
        origin={-320,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Reals.Line resTHeaWatSup
    "HW supply temperature reset"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(k=1)
    "One"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPPumETS(u(final
        unit="W"), final k=facMul) if have_pum "Scaling"
    annotation (Placement(transformation(extent={{270,-10},{290,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPumETS(
    final unit="W") if have_pum
    "ETS pump power"
    annotation (Placement(
        transformation(extent={{300,-20},{340,20}}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,120})));
equation
  connect(TChiWatSupSet, ets.TChiWatSupSet) annotation (Line(points={{-320,80},{
          -132,80},{-132,-62},{-34,-62}},color={0,0,127}));
  connect(resTHeaWatSup.y, ets.THeaWatSupSet) annotation (Line(points={{-88,-40},
          {-60,-40},{-60,-58},{-34,-58}}, color={0,0,127}));
  connect(THeaWatSupMaxSet, resTHeaWatSup.f2) annotation (Line(points={{-320,120},
          {-280,120},{-280,-48},{-112,-48}}, color={0,0,127}));
  connect(THeaWatSupMinSet, resTHeaWatSup.f1) annotation (Line(points={{-320,160},
          {-276,160},{-276,-36},{-112,-36}}, color={0,0,127}));
  connect(one.y, resTHeaWatSup.x2) annotation (Line(points={{-158,-60},{-126,-60},
          {-126,-44},{-112,-44}}, color={0,0,127}));
  connect(zer.y, resTHeaWatSup.x1) annotation (Line(points={{-158,-20},{-116,-20},
          {-116,-32},{-112,-32}}, color={0,0,127}));
  connect(mulPPumETS.y, PPumETS)
    annotation (Line(points={{292,0},{320,0}},   color={0,0,127}));
  connect(ets.PPum, mulPPumETS.u) annotation (Line(points={{34,-60},{240,-60},{
          240,0},{268,0}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model is composed of a heat pump based energy transfer station model
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger</a>
connected to a repleacable building load model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2024, by David Blum:<br/>
Added parameters <code>TDisWatMin</code> and <code>TDisWatMax</code>
in lieu of using <code>datDes</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3697\">issue 3697</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBuildingWithETS;
