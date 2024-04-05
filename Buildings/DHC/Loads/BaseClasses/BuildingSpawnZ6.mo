within Buildings.DHC.Loads.BaseClasses;
model BuildingSpawnZ6
  "Six-zone EnergyPlus building model based on URBANopt GeoJSON export, with distribution pumps"
  extends Buildings.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_pum=true,
    final have_weaBus=false);
  package Medium2=Buildings.Media.Air
    "Medium model";
  parameter Integer nZon=5
    "Number of conditioned thermal zones";
  parameter Real facMulTerUni[nZon]={5 for i in 1:nZon}
    "Multiplier factor for terminal units";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal[nZon]=fill(1, nZon)
    "Load side mass flow rate at nominal conditions (single terminal unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal[nZon]=fill(2000,
      nZon) ./ facMulTerUni
    "Design heating heat flow rate (single terminal unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal[nZon]=fill(-2000,
      nZon) ./ facMulTerUni
    "Design cooling heat flow rate (single terminal unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter String idfName="modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Name of the IDF file";
  parameter String epwName="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"
    "Name of the weather file";
  parameter String weaName="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Name of the weather file";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet[nZon](
    k=fill(
      293.15,
      nZon),
    y(each final unit="K",
      each displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,250},{-260,270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTSet[nZon](
    k=fill(
      297.15,
      nZon),
    y(each final unit="K",
      each displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(
    k=0)
    "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,104},{-40,124}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(
    k=0)
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,144},{-40,164}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,104},{0,124}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(
    k=0)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-60,64},{-40,84}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znAttic(
    redeclare package Medium=Medium2,
    zoneName="Attic")
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,84},{64,124}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znCore_ZN(
    redeclare package Medium=Medium2,
    zoneName="Core_ZN",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,42},{64,82}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium=Medium2,
    zoneName="Perimeter_ZN_1",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,0},{64,40}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium=Medium2,
    zoneName="Perimeter_ZN_2",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,-40},{64,0}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium=Medium2,
    zoneName="Perimeter_ZN_3",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium=Medium2,
    zoneName="Perimeter_ZN_4",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      idfName),
    epwName=Modelica.Utilities.Files.loadResource(
      epwName),
    weaName=Modelica.Utilities.Files.loadResource(
      weaName))
    "Building outer component"
    annotation (Placement(transformation(extent={{30,138},{52,158}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=nZon)
    annotation (Placement(transformation(extent={{230,110},{250,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum3(
    nin=2)
    annotation (Placement(transformation(extent={{230,70},{250,90}})));
  Buildings.DHC.Loads.BaseClasses.FanCoil4Pipe terUni[nZon](
    redeclare each final package Medium1=Medium,
    redeclare each final package Medium2=Medium2,
    final facMul=facMulTerUni,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    each T_aLoaHea_nominal=293.15,
    each T_aLoaCoo_nominal=297.15,
    each T_bHeaWat_nominal=308.15,
    each T_bChiWat_nominal=285.15,
    each T_aHeaWat_nominal=313.15,
    each T_aChiWat_nominal=280.15,
    final mLoaHea_flow_nominal=mLoa_flow_nominal,
    final mLoaCoo_flow_nominal=mLoa_flow_nominal)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-140,-2},{-116,22}})));
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=sum(
      terUni.mHeaWat_flow_nominal .* terUni.facMul),
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium=Medium,
    m_flow_nominal=sum(
      terUni.mChiWat_flow_nominal .* terUni.facMul),
    typDis=Buildings.DHC.Loads.BaseClasses.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{-198,-270},{-178,-250}})));
equation
  connect(qRadGai_flow.y,multiplex3_1.u1[1])
    annotation (Line(points={{-39,154},{-26,154},{-26,121},{-22,121}},color={0,0,127},smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(points={{-39,114},{-22,114}},color={0,0,127},smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-22,107},{-26,107},{-26,74},{-39,74}},  color={0,0,127}));
  connect(multiplex3_1.y,znAttic.qGai_flow)
    annotation (Line(points={{1,114},{22,114}},                  color={0,0,127}));
  connect(multiplex3_1.y,znCore_ZN.qGai_flow)
    annotation (Line(points={{1,114},{12,114},{12,72},{22,72}},color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
    annotation (Line(points={{1,114},{12,114},{12,30},{22,30}},color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
    annotation (Line(points={{1,114},{12,114},{12,-10},{22,-10}},color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
    annotation (Line(points={{1,114},{12,114},{12,-50},{22,-50}},color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
    annotation (Line(points={{1,114},{12,114},{12,-90},{22,-90}},color={0,0,127}));
  connect(znCore_ZN.ports[1],terUni[1].port_aLoa)
    annotation (Line(points={{42,42.9},{-8,42.9},{-8,20},{-116,20}},color={0,127,255}));
  connect(terUni[1].port_bLoa,znCore_ZN.ports[2])
    annotation (Line(points={{-140,20},{-20,20},{-20,42.9},{46,42.9}},color={0,127,255}));
  connect(znPerimeter_ZN_1.ports[1],terUni[2].port_aLoa)
    annotation (Line(points={{42,0.9},{-8,0.9},{-8,20},{-116,20}},color={0,127,255}));
  connect(terUni[2].port_bLoa,znPerimeter_ZN_1.ports[2])
    annotation (Line(points={{-140,20},{-20,20},{-20,0.9},{46,0.9}},color={0,127,255}));
  connect(znPerimeter_ZN_2.ports[1],terUni[3].port_aLoa)
    annotation (Line(points={{42,-39.1},{-8,-39.1},{-8,20},{-116,20}},color={0,127,255}));
  connect(terUni[3].port_bLoa,znPerimeter_ZN_2.ports[2])
    annotation (Line(points={{-140,20},{-20,20},{-20,-39.1},{46,-39.1}},color={0,127,255}));
  connect(znPerimeter_ZN_3.ports[1],terUni[4].port_aLoa)
    annotation (Line(points={{42,-79.1},{-8,-79.1},{-8,20},{-116,20}},color={0,127,255}));
  connect(terUni[4].port_bLoa,znPerimeter_ZN_3.ports[2])
    annotation (Line(points={{-140,20},{-20,20},{-20,-79.1},{46,-79.1}},color={0,127,255}));
  connect(znPerimeter_ZN_4.ports[1],terUni[5].port_aLoa)
    annotation (Line(points={{42,-119.1},{-8,-119.1},{-8,20},{-116,20}},color={0,127,255}));
  connect(terUni[5].port_bLoa,znPerimeter_ZN_4.ports[2])
    annotation (Line(points={{-140,20},{-20,20},{-20,-119.1},{46,-119.1}},color={0,127,255}));
  connect(terUni.port_bHeaWat,disFloHea.ports_a1)
    annotation (Line(points={{-116,0},{-116,-174},{-180,-174}},       color={0,127,255}));
  connect(disFloHea.ports_b1,terUni.port_aHeaWat)
    annotation (Line(points={{-200,-174},{-226,-174},{-226,0},{-140,0}},color={0,127,255}));
  connect(disFloCoo.ports_b1,terUni.port_aChiWat)
    annotation (Line(points={{-198,-254},{-216,-254},{-216,2},{-140,2}},color={0,127,255}));
  connect(terUni.port_bChiWat,disFloCoo.ports_a1)
    annotation (Line(points={{-116,2},{-116,-8},{-124,-8},{-124,-254},{-178,-254}},
                                                                      color={0,127,255}));
  connect(terUni.mReqChiWat_flow,disFloCoo.mReq_flow)
    annotation (Line(points={{-115,4},{-102,4},{-102,-234},{-210,-234},{-210,-264},
          {-199,-264}},                                                                       color={0,0,127}));
  connect(terUni.mReqHeaWat_flow,disFloHea.mReq_flow)
    annotation (Line(points={{-115,6},{-100,6},{-100,-88},{-220,-88},{-220,-184},
          {-201,-184}},                                                               color={0,0,127}));
  connect(terUni.PFan,mulSum.u)
    annotation (Line(points={{-115,10},{-100,10},{-100,220},{216,220},{216,120},
          {228,120}},                                                                      color={0,0,127}));
  connect(disFloHea.PPum,mulSum3.u[1])
    annotation (Line(points={{-179,-188},{220,-188},{220,81},{228,81}},    color={0,0,127}));
  connect(disFloCoo.PPum,mulSum3.u[2])
    annotation (Line(points={{-177,-268},{-116,-268},{-116,-188},{220,-188},{220,
          79},{228,79}},                                               color={0,0,127}));
  connect(znCore_ZN.TAir,terUni[1].TSen)
    annotation (Line(points={{65,80},{80,80},{80,198},{-152,198},{-152,12},{
          -141,12}},                                                                            color={0,0,127}));
  connect(znPerimeter_ZN_1.TAir,terUni[2].TSen)
    annotation (Line(points={{65,38},{80,38},{80,198},{-152,198},{-152,12},{
          -141,12}},                                                                                      color={0,0,127}));
  connect(znPerimeter_ZN_2.TAir,terUni[3].TSen)
    annotation (Line(points={{65,-2},{80,-2},{80,-140},{-152,-140},{-152,12},{-141,
          12}},                                                                             color={0,0,127}));
  connect(znPerimeter_ZN_3.TAir,terUni[4].TSen)
    annotation (Line(points={{65,-42},{80,-42},{80,-140},{-152,-140},{-152,12},{
          -141,12}},                                                                          color={0,0,127}));
  connect(znPerimeter_ZN_4.TAir,terUni[5].TSen)
    annotation (Line(points={{65,-82},{80,-82},{80,-140},{-152,-140},{-152,12},{
          -141,12}},                                                                          color={0,0,127}));
  connect(maxTSet.y,terUni.TSetCoo)
    annotation (Line(points={{-258,220},{-200,220},{-200,14},{-141,14}},color={0,0,127}));
  connect(minTSet.y,terUni.TSetHea)
    annotation (Line(points={{-258,260},{-180,260},{-180,16},{-141,16}},color={0,0,127}));
  connect(disFloHea.QActTot_flow, mulQHea_flow.u) annotation (Line(points={{-179,
          -186},{212,-186},{212,280},{268,280}}, color={0,0,127}));
  connect(mulSum3.y, mulPPum.u)
    annotation (Line(points={{252,80},{268,80}}, color={0,0,127}));
  connect(mulSum.y, mulPFan.u)
    annotation (Line(points={{252,120},{268,120}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, mulQCoo_flow.u) annotation (Line(points={{-177,
          -266},{-108,-266},{-108,-176},{216,-176},{216,128},{220,128},{220,240},
          {268,240}},                                 color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, disFloHea.port_a) annotation (Line(points={{-260,
          -60},{-240,-60},{-240,-180},{-200,-180}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{-198,-260}}, color={0,127,255}));
  connect(mulChiWatOut[1].port_a, disFloCoo.port_b)
    annotation (Line(points={{260,-260},{-178,-260}}, color={0,127,255}));
  connect(mulHeaWatOut[1].port_a, disFloHea.port_b) annotation (Line(points={{260,
          -60},{240,-60},{240,-180},{-180,-180}}, color={0,127,255}));
  annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified six-zone building model based on an EnergyPlus
building envelope model.
It was generated from translating a GeoJSON model specified within the URBANopt UI.
The heating and cooling loads are computed with a four-pipe
fan coil unit model derived from
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and connected to the room model by means of fluid ports. The <code>Attic</code> zone
is unconditionned, with a free floating temperature.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 15, 2021, by Michael Wetter:<br/>
Added parameter <code>epwName</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2054\">#2054</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Bitmap(
          extent={{-108,-100},{92,100}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus_9_6_0/EnergyPlusLogo.png")}));
end BuildingSpawnZ6;
