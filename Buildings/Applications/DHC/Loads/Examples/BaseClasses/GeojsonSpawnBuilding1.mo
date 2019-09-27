within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonSpawnBuilding1 "Spawn building model based on Urbanopt GeoJSON export"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final heaLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nHeaLoa),
    final cooLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nCooLoa),
    final nHeaLoa=6,
    final nCooLoa=6,
    Q_flowCoo_nominal={30000,5000,5000,5000,5000,20000},
    Q_flowHea_nominal={15000,10000,5000,8000,5000,1000});
  package Medium = Buildings.Media.Air "Medium model";
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago1.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
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
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[nHeaLoa](k=Q_flowHea_nominal)
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1[nCooLoa](k=-Q_flowCoo_nominal)
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Attic") "Thermal zone"
     annotation (Placement(transformation(extent={{24,80},{64,120}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Core_ZN") "Thermal zone"
     annotation (Placement(transformation(extent={{24,40},{64,80}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_1") "Thermal zone"
     annotation (Placement(transformation(extent={{24,0},{64,40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_2") "Thermal zone"
     annotation (Placement(transformation(extent={{24,-40},{64,0}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_3") "Thermal zone"
     annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_4") "Thermal zone"
     annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
equation
  connect(from_degC1.y,conPIDMinT. u_s) annotation (Line(points={{-78,130},{-62,130}}, color={0,0,127}));
  connect(conPIDMinT.y,gai. u) annotation (Line(points={{-38,130},{-22,130}}, color={0,0,127}));
  connect(from_degC2.y,conPIDMax. u_s) annotation (Line(points={{-78,-130},{-62,-130}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(conPIDMax.y,gai1. u) annotation (Line(points={{-38,-130},{-22,-130}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-118,130},{-110,130},{-110,130},{-102,130}}, color={0,0,127}));
  connect(gai1.y, Q_flowCooReq) annotation (Line(points={{2,-130},{152,-130},{152,-192},{310,-192}}, color={0,0,127}));
  connect(gai.y, Q_flowHeaReq) annotation (Line(points={{2,130},{152,130},{152,200},{310,200}}, color={0,0,127}));
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-53,40},{-40,40},{-40,7},{-30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-53,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y)
    annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));
  connect(multiplex3_1.y,znAttic. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,110},{22,110}},
                                                               color={0,0,127}));
  connect(multiplex3_1.y,znCore_ZN. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,70},{22,70}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_1. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,30},{22,30}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_2. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,-10},{22,-10}},
                                                               color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_3. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,-50},{22,-50}},
                                                               color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_4. qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,-90},{22,-90}},
                                                               color={0,0,127}));
  connect(znAttic.TAir, conPIDMinT[1].u_m)
    annotation (Line(points={{65,113.8},{79.5,113.8},{79.5,118},{-50,118}}, color={0,0,127}));
  connect(znCore_ZN.TAir, conPIDMinT[2].u_m)
    annotation (Line(points={{65,73.8},{7.5,73.8},{7.5,118},{-50,118}}, color={0,0,127}));
  connect(znPerimeter_ZN_1.TAir, conPIDMinT[3].u_m)
    annotation (Line(points={{65,33.8},{7.5,33.8},{7.5,118},{-50,118}}, color={0,0,127}));
  connect(znPerimeter_ZN_2.TAir, conPIDMinT[4].u_m)
    annotation (Line(points={{65,-6.2},{65,55.9},{-50,55.9},{-50,118}}, color={0,0,127}));
  connect(znPerimeter_ZN_3.TAir, conPIDMinT[5].u_m)
    annotation (Line(points={{65,-46.2},{65,34.9},{-50,34.9},{-50,118}}, color={0,0,127}));
  connect(znPerimeter_ZN_4.TAir, conPIDMinT[6].u_m)
    annotation (Line(points={{65,-86.2},{65,15.9},{-50,15.9},{-50,118}}, color={0,0,127}));
  connect(znAttic.TAir, conPIDMax[1].u_m)
    annotation (Line(points={{65,113.8},{65,-14.1},{-50,-14.1},{-50,-142}}, color={0,0,127}));
  connect(znCore_ZN.TAir, conPIDMax[2].u_m)
    annotation (Line(points={{65,73.8},{65,-33.1},{-50,-33.1},{-50,-142}}, color={0,0,127}));
  connect(znPerimeter_ZN_1.TAir, conPIDMax[3].u_m)
    annotation (Line(points={{65,33.8},{65,-54.1},{-50,-54.1},{-50,-142}}, color={0,0,127}));
  connect(znPerimeter_ZN_2.TAir, conPIDMax[4].u_m)
    annotation (Line(points={{65,-6.2},{65,-74.1},{-50,-74.1},{-50,-142}}, color={0,0,127}));
  connect(znPerimeter_ZN_3.TAir, conPIDMax[5].u_m)
    annotation (Line(points={{65,-46.2},{8.5,-46.2},{8.5,-142},{-50,-142}}, color={0,0,127}));
  connect(znPerimeter_ZN_4.TAir, conPIDMax[6].u_m)
    annotation (Line(points={{65,-86.2},{8.5,-86.2},{8.5,-142},{-50,-142}}, color={0,0,127}));
  connect(heaPorHea[1], znAttic.heaPorAir)
    annotation (Line(points={{-300,91.6667},{-128,91.6667},{-128,100},{44,100}}, color={191,0,0}));
  connect(heaPorHea[2], znCore_ZN.heaPorAir)
    annotation (Line(points={{-300,95},{-128,95},{-128,60},{44,60}}, color={191,0,0}));
  connect(heaPorHea[3], znPerimeter_ZN_1.heaPorAir)
    annotation (Line(points={{-300,98.3333},{-128,98.3333},{-128,20},{44,20}}, color={191,0,0}));
  connect(heaPorHea[4], znPerimeter_ZN_2.heaPorAir)
    annotation (Line(points={{-300,101.667},{-128,101.667},{-128,-20},{44,-20}}, color={191,0,0}));
  connect(heaPorHea[5], znPerimeter_ZN_3.heaPorAir)
    annotation (Line(points={{-300,105},{-134,105},{-134,-58},{38,-58},{38,-60},{44,-60}}, color={191,0,0}));
  connect(heaPorHea[6], znPerimeter_ZN_4.heaPorAir)
    annotation (Line(points={{-300,108.333},{-128,108.333},{-128,-100},{44,-100}}, color={191,0,0}));
  connect(heaPorCoo[1], znAttic.heaPorAir)
    annotation (Line(points={{-300,-108.333},{-128,-108.333},{-128,100},{44,100}}, color={191,0,0}));
  connect(heaPorCoo[2], znCore_ZN.heaPorAir)
    annotation (Line(points={{-300,-105},{-128,-105},{-128,60},{44,60}}, color={191,0,0}));
  connect(heaPorCoo[3], znPerimeter_ZN_1.heaPorAir)
    annotation (Line(points={{-300,-101.667},{-128,-101.667},{-128,20},{44,20}}, color={191,0,0}));
  connect(heaPorCoo[4], znPerimeter_ZN_2.heaPorAir)
    annotation (Line(points={{-300,-98.3333},{-128,-98.3333},{-128,-20},{44,-20}}, color={191,0,0}));
  connect(heaPorCoo[5], znPerimeter_ZN_3.heaPorAir)
    annotation (Line(points={{-300,-95},{-128,-95},{-128,-60},{44,-60}}, color={191,0,0}));
  connect(heaPorCoo[6], znPerimeter_ZN_4.heaPorAir)
    annotation (Line(points={{-300,-91.6667},{-128,-91.6667},{-128,-100},{44,-100}}, color={191,0,0}));
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
end GeojsonSpawnBuilding1;
