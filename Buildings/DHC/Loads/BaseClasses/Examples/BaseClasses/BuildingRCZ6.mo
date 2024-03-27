within Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses;
model BuildingRCZ6
  "Six-zone RC building model based on URBANopt GeoJSON export, with distribution pumps"
  extends Buildings.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    final have_weaBus=true,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_fan=false,
    final have_pum=true);
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter Integer nZon=6
    "Number of thermal zones";
  parameter Real facMulTerUni[nZon]={15 for i in 1:nZon}
    "Multiplier factor for terminal units";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal[nZon]=fill(1, nZon)
    "Load side mass flow rate at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal[nZon]=fill(10000,
      nZon) ./ facMulTerUni "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal[nZon]=cat(
      1,
      fill(-10000, nZon - 1),
      {-50000}) ./ facMulTerUni "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet[nZon](
    k=fill(
      293.15,
      nZon),
    y(each final unit="K",
      each displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-290,230},{-270,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTSet[nZon](
    k=fill(
      297.15,
      nZon),
    y(each final unit="K",
      each displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-290,190},{-270,210}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Office office
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Floor floor
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Storage storage
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Meeting meeting
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Restroom restroom
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.ICT iCT
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    nin=2)
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.FanCoil4PipeHeatPorts terUni[nZon](
    redeclare each final package Medium1=Medium,
    redeclare each final package Medium2=Medium2,
    final facMul=facMulTerUni,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    each T_aLoaHea_nominal=293.15,
    each T_aLoaCoo_nominal=297.15,
    each T_bHeaWat_nominal=35+273.15,
    each T_bChiWat_nominal=12+273.15,
    each T_aHeaWat_nominal=40+273.15,
    each T_aChiWat_nominal=7+273.15,
    each mLoaHea_flow_nominal=5,
    each mLoaCoo_flow_nominal=5)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=sum(
      terUni.mHeaWat_flow_nominal .* terUni.facMul),
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
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
    annotation (Placement(transformation(extent={{-138,-270},{-118,-250}})));
equation
  connect(terUni.port_bHeaWat,disFloHea.ports_a1)
    annotation (Line(points={{-180,-58.3333},{-100,-58.3333},{-100,-94},{-120,
          -94}},                                                                    color={0,127,255}));
  connect(terUni.port_bChiWat,disFloCoo.ports_a1)
    annotation (Line(points={{-180,-56.6667},{-80,-56.6667},{-80,-254},{-118,
          -254}},                                                                   color={0,127,255}));
  connect(disFloHea.ports_b1,terUni.port_aHeaWat)
    annotation (Line(points={{-140,-94},{-220,-94},{-220,-58.3333},{-200,
          -58.3333}},                                                               color={0,127,255}));
  connect(disFloCoo.ports_b1,terUni.port_aChiWat)
    annotation (Line(points={{-138,-254},{-224,-254},{-224,-56.6667},{-200,
          -56.6667}},                                                                 color={0,127,255}));
  connect(weaBus,office.weaBus)
    annotation (Line(points={{1,300},{0,300},{0,20},{-66,20},{-66,-10.2},{-96,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBus,floor.weaBus)
    annotation (Line(points={{1,300},{1,160},{0,20},{-56,20},{-56,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,storage.weaBus)
    annotation (Line(points={{1,300},{0,300},{0,-10.2},{-16,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBus,meeting.weaBus)
    annotation (Line(points={{1,300},{1,20},{24,20},{24,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,restroom.weaBus)
    annotation (Line(points={{1,300},{2,300},{2,20},{68,20},{68,-10.2},{64,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBus,iCT.weaBus)
    annotation (Line(points={{1,300},{0,300},{0,19.8},{104,19.8},{104,-10.2}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(terUni[1].heaPorCon,office.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{-90,0}},color={191,0,0}));
  connect(terUni[2].heaPorCon,floor.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{-50,0}},color={191,0,0}));
  connect(terUni[3].heaPorCon,storage.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{-10,0}},color={191,0,0}));
  connect(terUni[4].heaPorCon,meeting.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{30,0}},color={191,0,0}));
  connect(terUni[5].heaPorCon,restroom.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{70,0}},color={191,0,0}));
  connect(terUni[6].heaPorCon,iCT.port_a)
    annotation (Line(points={{-193.333,-50},{-192,-50},{-192,0},{110,0}},color={191,0,0}));
  connect(terUni[1].heaPorRad,office.port_a)
    annotation (Line(points={{-186.667,-50},{-90,-50},{-90,0}},color={191,0,0}));
  connect(terUni[2].heaPorRad,floor.port_a)
    annotation (Line(points={{-186.667,-50},{-50,-50},{-50,0}},color={191,0,0}));
  connect(terUni[3].heaPorRad,storage.port_a)
    annotation (Line(points={{-186.667,-50},{-10,-50},{-10,0}},color={191,0,0}));
  connect(terUni[4].heaPorRad,meeting.port_a)
    annotation (Line(points={{-186.667,-50},{30,-50},{30,0}},color={191,0,0}));
  connect(terUni[5].heaPorRad,restroom.port_a)
    annotation (Line(points={{-186.667,-50},{70,-50},{70,0}},color={191,0,0}));
  connect(terUni[6].heaPorRad,iCT.port_a)
    annotation (Line(points={{-186.667,-50},{110,-50},{110,0}},color={191,0,0}));
  connect(terUni.mReqHeaWat_flow,disFloHea.mReq_flow)
    annotation (Line(points={{-179.167,-53.3333},{-179.167,-54},{-170,-54},{
          -170,-104},{-141,-104}},                                                                  color={0,0,127}));
  connect(terUni.mReqChiWat_flow,disFloCoo.mReq_flow)
    annotation (Line(points={{-179.167,-55},{-179.167,-56},{-172,-56},{-172,
          -264},{-139,-264}},                                                                  color={0,0,127}));
  connect(disFloHea.PPum,mulSum.u[1])
    annotation (Line(points={{-119,-108},{224,-108},{224,81},{238,81}},color={0,0,127}));
  connect(disFloCoo.PPum,mulSum.u[2])
    annotation (Line(points={{-117,-268},{226,-268},{226,79},{238,79}},color={0,0,127}));
  connect(maxTSet.y,terUni.TSetCoo)
    annotation (Line(points={{-268,200},{-240,200},{-240,-46.6667},{-200.833,
          -46.6667}},                                                                   color={0,0,127}));
  connect(minTSet.y,terUni.TSetHea)
    annotation (Line(points={{-268,240},{-220,240},{-220,-45},{-200.833,-45}},color={0,0,127}));
  connect(disFloHea.QActTot_flow, mulQHea_flow.u) annotation (Line(points={{-119,
          -106},{220,-106},{220,280},{268,280}},    color={0,0,127}));
  connect(disFloCoo.QActTot_flow, mulQCoo_flow.u) annotation (Line(points={{-117,
          -266},{222,-266},{222,240},{268,240}},      color={0,0,127}));
  connect(mulPPum.u, mulSum.y)
    annotation (Line(points={{268,80},{262,80}}, color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, disFloHea.port_a) annotation (Line(points={{-260,
          -60},{-240,-60},{-240,-100},{-140,-100}}, color={0,127,255}));
  connect(mulHeaWatOut[1].port_a, disFloHea.port_b) annotation (Line(points={{260,
          -60},{240,-60},{240,-100},{-120,-100}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{-138,-260}}, color={0,127,255}));
  connect(mulChiWatOut[1].port_a, disFloCoo.port_b) annotation (Line(points={{260,
          -260},{70,-260},{70,-260},{-118,-260}}, color={0,127,255}));
  annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified six-zone building model based on two-element reduced order
model.
It was generated from translating a GeoJSON model specified within the URBANopt UI.
The heating and cooling loads are computed with a four-pipe
fan coil unit model derived from
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and connected to the room model by means of heat ports.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingRCZ6;
