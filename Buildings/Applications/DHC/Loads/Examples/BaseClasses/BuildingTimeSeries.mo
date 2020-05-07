within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = Buildings.Media.Water,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter String filNam
    "File name with thermal loads as time series";
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15, displayUnit="degC") = T_aHeaWat_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 18
    "Chilled water inlet temperature at nominal conditions "
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15, displayUnit="degC") = T_aChiWat_nominal + 5
    "Chilled water outlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 24
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(min=0) = 10
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal(min=0) = 40
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=293.15,
      y(final unit="K", displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=297.15,
      y(final unit="K", displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Applications.DHC.Loads.Validation.BaseClasses.FanCoil2PipeHeating
    terUniHea(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHea_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal) "Heating terminal unit"
    annotation (Placement(transformation(extent={{70,-34},{90,-14}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium,
    m_flow_nominal=terUniHea.mHeaWat_flow_nominal,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=terUniCoo.mChiWat_flow_nominal,
    typDis=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1) "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    annotation (Placement(transformation(extent={{212,68},{232,88}})));
  Validation.BaseClasses.FanCoil2PipeCooling terUniCoo(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final mLoaCoo_flow_nominal=mLoaCoo_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_aChiWat_nominal=T_aChiWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_bChiWat_nominal=T_bChiWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final T_aLoaCoo_nominal=T_aLoaCoo_nominal) "Cooling terminal unit"
    annotation (Placement(transformation(extent={{70,26},{90,46}})));
equation
  connect(ports_a[1], disFloHea.port_a) annotation (Line(points={{-300,0},{
          -280,0},{-280,-70},{120,-70}},color={0,127,255}));
  connect(disFloHea.port_b, ports_b[1]) annotation (Line(points={{140,-70},{
          280,-70},{280,0},{300,0}}, color={0,127,255}));
  connect(ports_a[2], disFloCoo.port_a) annotation (Line(points={{-300,0},{
          -280,0},{-280,-110},{120,-110}},color={0,127,255}));
  connect(disFloCoo.port_b, ports_b[2]) annotation (Line(points={{140,-110},
          {280,-110},{280,0},{300,0}},color={0,127,255}));
  connect(terUniHea.port_bHeaWat, disFloHea.ports_a1[1]) annotation (Line(
        points={{90,-32.3333},{90,-22},{148,-22},{148,-64},{140,-64}}, color={0,
          127,255}));
  connect(disFloHea.ports_b1[1],terUniHea. port_aHeaWat) annotation (Line(
        points={{120,-64},{64,-64},{64,-32.3333},{70,-32.3333}}, color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow, disFloHea.mReq_flow[1]) annotation (Line(
        points={{90.8333,-27.3333},{92,-27.3333},{92,-18},{100,-18},{100,-74},{
          119,-74}},
                 color={0,0,127}));
  connect(disFloHea.QActTot_flow, QHea_flow) annotation (Line(points={{141,-76},
          {260,-76},{260,280},{320,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, QCoo_flow) annotation (Line(points={{141,-116},
          {268,-116},{268,240},{320,240}}, color={0,0,127}));
  connect(mulSum.y, PPum) annotation (Line(points={{234,78},{308,78},{308,80},{320,
          80}}, color={0,0,127}));
  connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{141,-78},{176,-78},
          {176,79},{210,79}}, color={0,0,127}));
  connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{141,-118},{180,
          -118},{180,77},{210,77}}, color={0,0,127}));
  connect(loa.y[1], terUniCoo.QReqCoo_flow) annotation (Line(points={{21,0},{46,
          0},{46,32.5},{69.1667,32.5}},       color={0,0,127}));
  connect(loa.y[2], terUniHea.QReqHea_flow) annotation (Line(points={{21,0},{46,
          0},{46,-25.6667},{69.1667,-25.6667}},
                                      color={0,0,127}));
  connect(disFloCoo.ports_b1[1], terUniCoo.port_aChiWat) annotation (Line(
        points={{120,-104},{60,-104},{60,29.3333},{70,29.3333}}, color={0,127,255}));
  connect(terUniCoo.port_bChiWat, disFloCoo.ports_a1[1]) annotation (Line(
        points={{90,29.3333},{112,29.3333},{112,14},{160,14},{160,-104},{140,
          -104}},
        color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow, disFloCoo.mReq_flow[1]) annotation (Line(
        points={{90.8333,31},{108,31},{108,-114},{119,-114}}, color={0,0,127}));
  connect(minTSet.y, terUniHea.TSetHea) annotation (Line(points={{-258,180},{
          -20,180},{-20,-20},{24,-20},{24,-19},{69.1667,-19}}, color={0,0,127}));
  connect(maxTSet.y, terUniCoo.TSetCoo) annotation (Line(points={{-258,220},{0,
          220},{0,39.3333},{69.1667,39.3333}}, color={0,0,127}));
  annotation (
  Documentation(info="
<html>
<p>
This is a simplified building model where the space heating and cooling loads
are provided as time series.
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
</html>"));
end BuildingTimeSeries;
