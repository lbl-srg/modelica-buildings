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
        origin={-120,70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90})));
  // COMPONENTS
  Modelica.Blocks.Sources.RealExpression reqHeaCoo[2]
    "Signal representing heating and cooling request from building"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold enaHeaCoo[2]
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Modelica.Blocks.Sources.BooleanConstant enaSHW(k=true) if
                                                         have_hotWat
    "SHW production enable signal"
    annotation (Placement(transformation(extent={{0,-130},{-20,-110}})));
equation
  connect(THeaWatSupSet, ets.THeaWatSupSet) annotation (Line(points={{-240,120},
          {-80,120},{-80,-58},{-34,-58}}, color={0,0,127}));
  connect(TChiWatSupSet, ets.TChiWatSupSet) annotation (Line(points={{-240,80},{
          -84,80},{-84,-62},{-34,-62}},  color={0,0,127}));
  connect(reqHeaCoo.y, enaHeaCoo.u)
    annotation (Line(points={{-99,-100},{-82,-100}}, color={0,0,127}));
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-58,-100},{-48,
          -100},{-48,-46},{-34,-46}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-58,-100},{-44,
          -100},{-44,-50},{-34,-50}}, color={255,0,255}));
  connect(enaSHW.y, ets.uSHW) annotation (Line(points={{-21,-120},{-36,-120},{
          -36,-54},{-34,-54}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialBuildingWithETS;
