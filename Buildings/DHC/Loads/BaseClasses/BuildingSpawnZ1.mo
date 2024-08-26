within Buildings.DHC.Loads.BaseClasses;
model BuildingSpawnZ1
  "One-zone EnergyPlus building model"
  extends Buildings.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_pum=false,
    final have_eleHea=false,
    final have_eleCoo=false);
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter Integer nZon=1
    "Number of thermal zones";
  parameter String idfName="modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_24_1_0/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Name of the IDF file";
  parameter String epwName="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"
    "Name of the weather file";
  parameter String weaName="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Name of the weather file";
  Modelica.Blocks.Sources.Constant qConGai_flow(
    k=0)
    "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(
    k=0)
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(
    k=0)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.ThermalZones.EnergyPlus_24_1_0.ThermalZone zon(
    redeclare package Medium=Medium2,
    zoneName="Core_ZN",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  inner Buildings.ThermalZones.EnergyPlus_24_1_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      idfName),
    epwName=Modelica.Utilities.Files.loadResource(
      epwName),
    weaName=Modelica.Utilities.Files.loadResource(
      weaName))
    "Building model"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,250},{-260,270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.DHC.Loads.BaseClasses.FanCoil4Pipe terUni(
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium2,
    QHea_flow_nominal=2000,
    QCoo_flow_nominal=-2000,
    T_aLoaHea_nominal=293.15,
    T_aLoaCoo_nominal=297.15,
    T_bHeaWat_nominal=308.15,
    T_bChiWat_nominal=285.15,
    T_aHeaWat_nominal=313.15,
    T_aChiWat_nominal=280.15,
    mLoaHea_flow_nominal=1,
    mLoaCoo_flow_nominal=1)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=terUni.mHeaWat_flow_nominal,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium=Medium,
    m_flow_nominal=terUni.mChiWat_flow_nominal,
    typDis=Buildings.DHC.Loads.BaseClasses.Types.DistributionType.ChilledWater,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
equation
  connect(qRadGai_flow.y,multiplex3_1.u1[1])
    annotation (Line(points={{-59,80},{-40,80},{-40,17},{-22,17}},  color={0,0,127},smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(points={{-59,40},{-48,40},{-48,10},{-22,10}},color={0,0,127},smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-22,3},{-40,3},{-40,0},{-59,0}},    color={0,0,127}));
  connect(multiplex3_1.y,zon.qGai_flow)
    annotation (Line(points={{1,10},{38,10}},                  color={0,0,127}));
  connect(zon.ports[1],terUni.port_aLoa)
    annotation (Line(points={{58,-19.1},{62,-19.1},{62,-41.6667},{-140,-41.6667}},color={0,127,255}));
  connect(terUni.port_bHeaWat,disFloHea.ports_a1[1])
    annotation (Line(points={{-140,-58.3333},{-140,-59.5833},{-100,-59.5833},{
          -100,-114}},                                                                    color={0,127,255}));
  connect(terUni.port_bChiWat,disFloCoo.ports_a1[1])
    annotation (Line(points={{-140,-56.6667},{-80,-56.6667},{-80,-254},{-100,
          -254}},                                                                   color={0,127,255}));
  connect(disFloHea.ports_b1[1],terUni.port_aHeaWat)
    annotation (Line(points={{-120,-114},{-180,-114},{-180,-58.3333},{-160,
          -58.3333}},                                                                 color={0,127,255}));
  connect(disFloCoo.ports_b1[1],terUni.port_aChiWat)
    annotation (Line(points={{-120,-254},{-200,-254},{-200,-56.6667},{-160,
          -56.6667}},                                                                 color={0,127,255}));
  connect(terUni.mReqHeaWat_flow,disFloHea.mReq_flow[1])
    annotation (Line(points={{-139.167,-53.3333},{-126,-53.3333},{-126,-124},{
          -121,-124}},                                                                    color={0,0,127}));
  connect(terUni.mReqChiWat_flow,disFloCoo.mReq_flow[1])
    annotation (Line(points={{-139.167,-55},{-139.167,-56},{-130,-56},{-130,
          -264},{-121,-264}},                                                                  color={0,0,127}));
  connect(terUni.port_bLoa,zon.ports[2])
    annotation (Line(points={{-160,-41.6667},{-162,-41.6667},{-162,-24},{58,-24},
          {58,-19.1},{62,-19.1}},                                                                     color={0,127,255}));
  connect(zon.TAir,terUni.TSen)
    annotation (Line(points={{81,18},{100,18},{100,-32},{-166,-32},{-166,
          -48.3333},{-160.833,-48.3333}},                                                                   color={0,0,127}));
  connect(maxTSet.y,terUni.TSetCoo)
    annotation (Line(points={{-258,220},{-240,220},{-240,-46.6667},{-160.833,
          -46.6667}},                                                                   color={0,0,127}));
  connect(minTSet.y,terUni.TSetHea)
    annotation (Line(points={{-258,260},{-220,260},{-220,-45},{-160.833,-45}},color={0,0,127}));
  connect(terUni.PFan, mulPFan.u) annotation (Line(points={{-139.167,-50},{240,
          -50},{240,120},{268,120}}, color={0,0,127}));
  connect(disFloHea.QActTot_flow, mulQHea_flow.u) annotation (Line(points={{-99,
          -126},{232,-126},{232,280},{268,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, mulQCoo_flow.u) annotation (Line(points={{-99,
          -266},{236,-266},{236,240},{268,240}}, color={0,0,127}));
  connect(mulChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{-120,-260}}, color={0,127,255}));
  connect(mulChiWatOut[1].port_a, disFloCoo.port_b)
    annotation (Line(points={{260,-260},{-100,-260}}, color={0,127,255}));
  connect(mulHeaWatInl[1].port_b, disFloHea.port_a) annotation (Line(points={{
          -260,-60},{-240,-60},{-240,-120},{-120,-120}}, color={0,127,255}));
  connect(mulHeaWatOut[1].port_a, disFloHea.port_b) annotation (Line(points={{
          260,-60},{240,-60},{240,-120},{-100,-120}}, color={0,127,255}));
  annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified one-zone building model based on EnergyPlus
building envelope model.
The heating and cooling loads are computed with a four-pipe
fan coil unit model derived from
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and connected to the room model by means of fluid ports.
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
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ1;
