within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads.BaseClasses;
model PartialBuildingWithETS
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithETS(
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    redeclare EnergyTransferStations.ETSSimplified ets(
      final dT_nominal=dT_nominal,
      final TChiWatSup_nominal=TChiWatSup_nominal,
      final TChiWatRet_nominal=TChiWatRet_nominal,
      final THeaWatSup_nominal=THeaWatSup_nominal,
      final THeaWatRet_nominal=THeaWatRet_nominal,
      final dp_nominal=dp_nominal,
      final COP_nominal=COP_nominal));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal(min=0)=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=18 + 273.15
    "Chilled water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  final parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
     TChiWatSup_nominal + abs(dT_nominal)
     "Chilled water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=40 + 273.15
    "Heating water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  final parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
     THeaWatSup_nominal - abs(dT_nominal)
     "Heating water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Pressure dp_nominal=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Real COP_nominal=5
    "Heat pump COP at nominal conditions"
    annotation(Dialog(group="ETS model parameters"));
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TChiWatSupSet
    "Chilled water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput THeaWatSupSet
    "Heating water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
equation
  connect(THeaWatSupSet, ets.THeaWatSupSet) annotation (Line(points={{-160,120},
          {-80,120},{-80,-46},{-34,-46}}, color={0,0,127}));
  connect(TChiWatSupSet, ets.TChiWatSupSet) annotation (Line(points={{-160,80},{
          -88,80},{-88,-52},{-34,-52}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialBuildingWithETS;
