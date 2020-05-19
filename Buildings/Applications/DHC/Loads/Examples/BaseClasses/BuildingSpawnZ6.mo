within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model BuildingSpawnZ6
  "Six-zone EnergyPlus building model based on URBANopt GeoJSON export, with distribution pumps"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = Buildings.Media.Water,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_pum=true,
    final have_weaBus=false);
  package Medium2 = Buildings.Media.Air "Medium model";
  parameter Integer nZon = 6
    "Number of thermal zones";
  parameter Integer facSca=1
    "Scaling factor to be applied to on each extensive quantity";
  parameter String idfName=
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Name of the IDF file";
  parameter String weaName=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Name of the weather file";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(293.15,
        nZon),
    y(each final unit="K", each displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,250},{-260,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(297.15,
        nZon),
    y(each final unit="K", each displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-66,128},{-46,148}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-66,168},{-46,188}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,128},{0,148}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-66,88},{-46,108}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znAttic(
    redeclare package Medium = Medium2,
    zoneName="Attic",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,84},{64,124}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znCore_ZN(
    redeclare package Medium = Medium2,
    zoneName="Core_ZN",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,42},{64,82}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_1",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,0},{64,40}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_2",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,-40},{64,0}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_3",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_4",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(idfName),
    weaName=Modelica.Utilities.Files.loadResource(weaName))
    "Building outer component"
    annotation (Placement(transformation(extent={{30,138},{52,158}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=6)
    annotation (Placement(transformation(extent={{260,110},{280,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum3(nin=2)
    annotation (Placement(transformation(extent={{260,70},{280,90}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.FanCoil4Pipe terUni[
    nZon](
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium2,
    each facSca=facSca,
    QHea_flow_nominal={50000,10000,10000,10000,10000,10000},
    QCoo_flow_nominal={-10000,-10000,-10000,-10000,-10000,-10000},
    each T_aLoaHea_nominal=293.15,
    each T_aLoaCoo_nominal=297.15,
    each T_bHeaWat_nominal=308.15,
    each T_bChiWat_nominal=285.15,
    each T_aHeaWat_nominal=313.15,
    each T_aChiWat_nominal=280.15,
    each mLoaHea_flow_nominal=5,
    each mLoaCoo_flow_nominal=5) "Terminal unit"
    annotation (Placement(transformation(extent={{-140,-2},{-116,22}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium,
    m_flow_nominal=sum(terUni.mHeaWat_flow_nominal .* terUni.facSca),
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-236,-188},{-216,-168}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=sum(terUni.mChiWat_flow_nominal .* terUni.facSca),
    typDis=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
equation
  connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
      points={{-45,178},{-26,178},{-26,145},{-22,145}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(
      points={{-45,138},{-22,138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-22,131},{-26,131},{-26,98},{-45,98}},   color={0,0,127}));
  connect(multiplex3_1.y,znAttic.qGai_flow)
    annotation (Line(points={{1,138},{20,138},{20,114},{22,114}}, color={0,0,127}));
  connect(multiplex3_1.y,znCore_ZN.qGai_flow)
    annotation (Line(points={{1,138},{20,138},{20,72},{22,72}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
    annotation (Line(points={{1,138},{20,138},{20,30},{22,30}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
      annotation (Line(points={{1,138},{20,138},{20,-10},{22,-10}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
    annotation (Line(points={{1,138},{20,138},{20,-50},{22,-50}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
    annotation (Line(points={{1,138},{20,138},{20,-90},{22,-90}}, color={0,0,127}));
  connect(ports_a[1], disFloHea.port_a)
    annotation (Line(points={{-300,0},{-280,0},{-280,-178},{-236,-178}},
                                         color={0,127,255}));
  connect(disFloHea.port_b, ports_b[1])
    annotation (Line(points={{-216,-178},{260,-178},{260,0},{300,0}},
                                      color={0,127,255}));
  connect(ports_a[2], disFloCoo.port_a) annotation (Line(points={{-300,0},{-280,
          0},{-280,-220},{-160,-220}},  color={0,127,255}));
  connect(disFloCoo.port_b, ports_b[2]) annotation (Line(points={{-140,-220},{
          280,-220},{280,0},{300,0}},
                                    color={0,127,255}));
  connect(znAttic.ports[1], terUni[1].port_aLoa) annotation (Line(points={{42,84.9},
          {-8,84.9},{-8,20},{-116,20}},      color={0,127,255}));
  connect(terUni[1].port_bLoa, znAttic.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,84.9},{46,84.9}},      color={0,127,255}));
  connect(znCore_ZN.ports[1], terUni[2].port_aLoa) annotation (Line(points={{42,42.9},
          {-8,42.9},{-8,20},{-116,20}},      color={0,127,255}));
  connect(terUni[2].port_bLoa, znCore_ZN.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,42.9},{46,42.9}},      color={0,127,255}));
  connect(znPerimeter_ZN_1.ports[1], terUni[3].port_aLoa) annotation (Line(points={{42,0.9},
          {-8,0.9},{-8,20},{-116,20}},              color={0,127,255}));
  connect(terUni[3].port_bLoa, znPerimeter_ZN_1.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,0.9},{46,0.9}},               color={0,127,255}));
  connect(znPerimeter_ZN_2.ports[1], terUni[4].port_aLoa) annotation (Line(points={{42,
          -39.1},{-8,-39.1},{-8,20},{-116,20}},         color={0,127,255}));
  connect(terUni[4].port_bLoa, znPerimeter_ZN_2.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,-39.1},{46,-39.1}},               color={0,127,255}));
  connect(znPerimeter_ZN_3.ports[1], terUni[5].port_aLoa) annotation (Line(points={{42,
          -79.1},{-8,-79.1},{-8,20},{-116,20}},         color={0,127,255}));
  connect(terUni[5].port_bLoa, znPerimeter_ZN_3.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,-79.1},{46,-79.1}},               color={0,127,255}));
  connect(znPerimeter_ZN_4.ports[1], terUni[6].port_aLoa) annotation (Line(points={{42,
          -119.1},{-8,-119.1},{-8,20},{-116,20}},         color={0,127,255}));
  connect(terUni[6].port_bLoa, znPerimeter_ZN_4.ports[2]) annotation (Line(points={{-140,20},
          {-20,20},{-20,-119.1},{46,-119.1}},               color={0,127,255}));
  connect(terUni.port_bHeaWat, disFloHea.ports_a1) annotation (Line(points={{-116,0},
          {-40,0},{-40,-172},{-216,-172}},  color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.port_aHeaWat) annotation (Line(points={{-236,-172},
          {-260,-172},{-260,0},{-140,0}},        color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.port_aChiWat) annotation (Line(points={{-160,
          -214},{-260,-214},{-260,2},{-140,2}},color={0,127,255}));
  connect(terUni.port_bChiWat, disFloCoo.ports_a1) annotation (Line(points={{-116,2},
          {-38,2},{-38,-214},{-140,-214}}, color={0,127,255}));
  connect(terUni.mReqChiWat_flow, disFloCoo.mReq_flow) annotation (Line(points={{-115,4},
          {-104,4},{-104,-80},{-180,-80},{-180,-224},{-161,-224}},
                                                          color={0,0,127}));
  connect(terUni.mReqHeaWat_flow, disFloHea.mReq_flow) annotation (Line(points={{-115,6},
          {-100,6},{-100,-90.5},{-237,-90.5},{-237,-182}},
                                                        color={0,0,127}));
  connect(terUni.PFan, mulSum.u[1:6]) annotation (Line(points={{-115,10},{-100,
          10},{-100,220},{220,220},{220,118.333},{258,118.333}},
                                              color={0,0,127}));
  connect(mulSum.y, PFan) annotation (Line(points={{282,120},{302,120},{302,120},
          {320,120}}, color={0,0,127}));
  connect(PPum, mulSum3.y)
    annotation (Line(points={{320,80},{302,80},{302,80},{282,80}},
                                                 color={0,0,127}));
  connect(disFloHea.PPum, mulSum3.u[1]) annotation (Line(points={{-215,-186},{
          220.5,-186},{220.5,81},{258,81}}, color={0,0,127}));
  connect(disFloCoo.PPum, mulSum3.u[2]) annotation (Line(points={{-139,-228},{
          224,-228},{224,79},{258,79}}, color={0,0,127}));
  connect(disFloHea.QActTot_flow, QHea_flow) annotation (Line(points={{-215,
          -184},{-2,-184},{-2,-182},{212,-182},{212,280},{320,280}}, color={0,0,
          127}));
  connect(disFloCoo.QActTot_flow, QCoo_flow) annotation (Line(points={{-139,
          -226},{28,-226},{28,-224},{216,-224},{216,240},{320,240}}, color={0,0,
          127}));
  connect(znAttic.TAir, terUni[1].TSen) annotation (Line(points={{65,117.8},{72,
          118},{80,118},{80,160},{-152,160},{-152,12},{-141,12}}, color={0,0,
          127}));
  connect(znCore_ZN.TAir, terUni[2].TSen) annotation (Line(points={{65,75.8},{
          65,76},{80,76},{80,160},{-152,160},{-152,12},{-141,12}}, color={0,0,
          127}));
  connect(znPerimeter_ZN_1.TAir, terUni[3].TSen) annotation (Line(points={{65,
          33.8},{72,33.8},{72,34},{80,34},{80,160},{-152,160},{-152,12},{-141,
          12}}, color={0,0,127}));
  connect(znPerimeter_ZN_2.TAir, terUni[4].TSen) annotation (Line(points={{65,
          -6.2},{80,-6.2},{80,-140},{-152,-140},{-152,12},{-141,12}}, color={0,
          0,127}));
  connect(znPerimeter_ZN_3.TAir, terUni[5].TSen) annotation (Line(points={{65,
          -46.2},{80,-46.2},{80,-140},{-152,-140},{-152,12},{-141,12}}, color={
          0,0,127}));
  connect(znPerimeter_ZN_4.TAir, terUni[6].TSen) annotation (Line(points={{65,
          -86.2},{80,-86.2},{80,-140},{-152,-140},{-152,12},{-141,12}}, color={
          0,0,127}));
  connect(maxTSet.y, terUni.TSetCoo) annotation (Line(points={{-258,220},{-200,220},
          {-200,14},{-141,14}}, color={0,0,127}));
  connect(minTSet.y, terUni.TSetHea) annotation (Line(points={{-258,260},{-180,260},
          {-180,16},{-141,16}}, color={0,0,127}));
  annotation (
  Documentation(info="
<html>
<p>
This is a simplified six-zone building model based on an EnergyPlus
building envelope model.
It was generated from translating a GeoJSON model specified within the URBANopt UI.
The heating and cooling loads are computed with a four-pipe
fan coil unit model derived from
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and connected to the room model by means of fluid ports.
</p>
</html>",
revisions=
"<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={Bitmap(extent={{-108,-100},{92,100}},
  fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6;
