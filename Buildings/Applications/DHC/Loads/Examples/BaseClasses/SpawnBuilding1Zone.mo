within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model SpawnBuilding1Zone "Spawn building model based on Urbanopt GeoJSON export"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final heaLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nHeaLoa),
    final cooLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nCooLoa),
    final nHeaLoa=1,
    final nCooLoa=1,
    Q_flowCoo_nominal={10000},
    Q_flowHea_nominal={10000});
  package Medium = Buildings.Media.Air "Medium model";
  parameter String idfPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago1.idf"
    "Path of the IDF file";
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nHeaLoa](k=fill(20, nHeaLoa))
    "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nHeaLoa]
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT[nHeaLoa](
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=false,
    each yMin=0,
    each Ti=120) "PID controller for minimum temperature"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nCooLoa](k=fill(24, nCooLoa))
    "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nCooLoa]
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMax[nCooLoa](
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=true,
    each yMax=1,
    each yMin=0,
    each Ti=120) "PID controller for maximum temperature"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
  Buildings.Experimental.EnergyPlus.ThermalZone zon(
    redeclare package Medium = Medium,
    zoneName="Core_ZN")   "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  inner Buildings.Experimental.EnergyPlus.Building
                 building(
    idfName=Modelica.Utilities.Files.loadResource(idfPath),
    weaName=Modelica.Utilities.Files.loadResource(weaPath),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    showWeatherData=false)
    "Building model"
    annotation (Placement(transformation(extent={{42,60},{62,80}})));

equation
  connect(from_degC1.y,conPIDMinT.u_s) annotation (Line(points={{-78,130},{-62,130}}, color={0,0,127}));
  connect(from_degC2.y,conPIDMax.u_s) annotation (Line(points={{-78,-130},{-62,-130}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2.u) annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-118,130},{-110,130},{-110,130},{-102,130}}, color={0,0,127}));
  connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
      points={{-53,40},{-40,40},{-40,7},{-30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1]) annotation (Line(
      points={{-53,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));
  connect(conPIDMax.y, yCoo)
    annotation (Line(points={{-38,-130},{134,-130},{134,-192},{310,-192}}, color={0,0,127}));
  connect(conPIDMinT.y, yHea) annotation (Line(points={{-38,130},{134,130},{134,200},{310,200}}, color={0,0,127}));
  connect(zon.TAir, conPIDMinT[1].u_m)
    annotation (Line(points={{81,13.8},{16.5,13.8},{16.5,118},{-50,118}}, color={0,0,127}));
  connect(zon.TAir, conPIDMax[1].u_m)
    annotation (Line(points={{81,13.8},{81,-81.1},{-50,-81.1},{-50,-142}}, color={0,0,127}));
  connect(multiplex3_1.y, zon.qGai_flow) annotation (Line(points={{-7,0},{16,0},{16,10},{38,10}}, color={0,0,127}));
  connect(heaFloHeaLoaH[1].port_b, zon.heaPorAir)
    annotation (Line(points={{-260,150},{-99,150},{-99,0},{60,0}}, color={191,0,0}));
  connect(heaFloCooLoaH[1].port_b, zon.heaPorAir)
    annotation (Line(points={{-260,-150},{-100,-150},{-100,0},{60,0}}, color={191,0,0}));
  annotation (
  Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
  Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end SpawnBuilding1Zone;
