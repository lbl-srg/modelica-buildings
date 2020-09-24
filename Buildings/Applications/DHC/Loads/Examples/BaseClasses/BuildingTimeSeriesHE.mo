within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeriesHE
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = MediumW,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);

  package MediumA = Buildings.Media.Air
    "Air medium";
  package MediumW = Buildings.Media.Water
    "Water medium";
  parameter String filNam
    "File name with thermal loads as time series";
  parameter Real facScaHea = 1
    "Heating terminal unit scaling factor";
  parameter Real facScaCoo = 1
    "Cooling terminal unit scaling factor";
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
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal= QHea_flow_nominal/(cp_air*deltaTAirHea)
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal= -QCoo_flow_nominal/(cp_air*deltaTAirCoo)
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference deltaTAirCoo
   "Nominal cooling air temperature difference";
  parameter Modelica.SIunits.TemperatureDifference deltaTAirHea
   "Nominal heating air temperature difference";

  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=facScaCoo*
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)= facScaHea*
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Real k(min=0) = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small) = 10
    "Time constant of integrator block";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance for fan air volume"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau=1
    "Time constant of fan air volume, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",
                       group="Nominal condition",
                       enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Boolean use_inputFilter=true
    "= true, if fan speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Modelica.SIunits.SpecificHeatCapacity cp_air= 1005;

  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=293.15,
      y(final unit="K", displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=297.15,
      y(final unit="K", displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeHeating terUniHea(
    redeclare final package Medium1 = MediumW,
    redeclare final package Medium2 = MediumA,
    final facSca=facScaHea,
    final QHea_flow_nominal=QHea_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final k=k,
    final Ti=Ti,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{70,-34},{90,-14}})));
  Buildings.Applications.DHC.Loads.FlowDistribution disFloHea(
    redeclare package Medium = MediumW,
    m_flow_nominal=terUniHea.mHeaWat_flow_nominal * facScaHea,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Applications.DHC.Loads.FlowDistribution disFloCoo(
    redeclare package Medium = MediumW,
    m_flow_nominal=terUniCoo.mChiWat_flow_nominal * facScaCoo,
    typDis=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    annotation (Placement(transformation(extent={{212,68},{232,88}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeCooling terUniCoo(
    redeclare final package Medium1 = MediumW,
    redeclare final package Medium2 = MediumA,
    final facSca=facScaCoo,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final mLoaCoo_flow_nominal=mLoaCoo_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_aChiWat_nominal=T_aChiWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_bChiWat_nominal=T_bChiWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final T_aLoaCoo_nominal=T_aLoaCoo_nominal,
    final k=k,
    final Ti=Ti,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime)
    "Cooling terminal unit"
    annotation (Placement(transformation(extent={{70,26},{90,46}})));
  Modelica.Blocks.Interfaces.RealOutput QReqHea_flow(final quantity=
        "HeatFlowRate", final unit="W") if            have_heaLoa
    "Heating load" annotation (Placement(transformation(extent={{300,20},{340,
            60}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={200,-320})));
  Modelica.Blocks.Interfaces.RealOutput QReqCoo_flow(final quantity=
        "HeatFlowRate", final unit="W") if            have_cooLoa
    "Cooling load" annotation (Placement(transformation(extent={{300,-20},{340,
            20}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={260,-320})));
  Modelica.Blocks.Continuous.Integrator ECooReq(y(unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{60,58},{80,78}})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(y(unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{28,-56},{48,-36}})));
  Modelica.Blocks.Continuous.Integrator mReq(y(unit="kg"))
    "Time integral of  heating water mass"
    annotation (Placement(transformation(extent={{190,-32},{208,-50}})));
equation
  connect(terUniHea.port_bHeaWat, disFloHea.ports_a1[1]) annotation (Line(
        points={{90,-32.3333},{90,-32},{146,-32},{146,-64},{140,-64}}, color={0,
          127,255}));
  connect(disFloHea.ports_b1[1],terUniHea. port_aHeaWat) annotation (Line(
        points={{120,-64},{64,-64},{64,-32.3333},{70,-32.3333}}, color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow, disFloHea.mReq_flow[1]) annotation (Line(
        points={{90.8333,-27.3333},{90.8333,-28},{100,-28},{100,-74},{119,-74}},
                 color={0,0,127}));
  connect(disFloHea.QActTot_flow, QHea_flow) annotation (Line(points={{141,-76},
          {260,-76},{260,280},{320,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, QCoo_flow) annotation (Line(points={{141,-266},
          {268,-266},{268,240},{320,240}}, color={0,0,127}));
  connect(mulSum.y, PPum) annotation (Line(points={{234,78},{308,78},{308,80},{320,
          80}}, color={0,0,127}));
  connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{141,-78},{176,
          -78},{176,79},{210,79}},
                              color={0,0,127}));
  connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{141,-268},{180,
          -268},{180,77},{210,77}}, color={0,0,127}));
  connect(loa.y[1], terUniCoo.QReqCoo_flow) annotation (Line(points={{9,2},{46,
          2},{46,32.5},{69.1667,32.5}},       color={0,0,127}));
  connect(loa.y[2], terUniHea.QReqHea_flow) annotation (Line(points={{9,2},{46,
          2},{46,-25.6667},{69.1667,-25.6667}},
                                      color={0,0,127}));
  connect(disFloCoo.ports_b1[1], terUniCoo.port_aChiWat) annotation (Line(
        points={{120,-254},{60,-254},{60,29.3333},{70,29.3333}}, color={0,127,255}));
  connect(terUniCoo.port_bChiWat, disFloCoo.ports_a1[1]) annotation (Line(
        points={{90,29.3333},{112,29.3333},{160,29.3333},{160,-254},{140,-254}},
        color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow, disFloCoo.mReq_flow[1]) annotation (Line(
        points={{90.8333,31},{108,31},{108,-264},{119,-264}}, color={0,0,127}));
  connect(minTSet.y, terUniHea.TSetHea) annotation (Line(points={{-258,180},{
          -20,180},{-20,-20},{24,-20},{24,-19},{69.1667,-19}}, color={0,0,127}));
  connect(maxTSet.y, terUniCoo.TSetCoo) annotation (Line(points={{-258,220},{0,
          220},{0,39.3333},{69.1667,39.3333}}, color={0,0,127}));
  connect(ports_aHeaWat[1], disFloHea.port_a)
    annotation (Line(points={{-300,-60},{-90,-60},{-90,-70},{120,-70}},
                                                    color={0,127,255}));
  connect(ports_bHeaWat[1], disFloHea.port_b)
    annotation (Line(points={{300,-60},{220,-60},{220,-70},{140,-70}},
                                                   color={0,127,255}));
  connect(ports_aChiWat[1], disFloCoo.port_a)
    annotation (Line(points={{-300,-260},{120,-260}}, color={0,127,255}));
  connect(ports_bChiWat[1], disFloCoo.port_b)
    annotation (Line(points={{300,-260},{140,-260}}, color={0,127,255}));
  connect(loa.y[1], QReqCoo_flow)
    annotation (Line(points={{9,2},{320,2},{320,0}},  color={0,0,127}));
  connect(loa.y[2], QReqHea_flow) annotation (Line(points={{9,2},{280,2},{280,
          40},{320,40}}, color={0,0,127}));
  connect(loa.y[1], ECooReq.u) annotation (Line(points={{9,2},{26,2},{26,70},{
          58,70},{58,68}}, color={0,0,127}));
  connect(loa.y[2], EHeaReq.u)
    annotation (Line(points={{9,2},{26,2},{26,-46}}, color={0,0,127}));
  connect(terUniHea.mReqHeaWat_flow, mReq.u) annotation (Line(points={{90.8333,
          -27.3333},{156,-27.3333},{156,-41},{188.2,-41}}, color={0,0,127}));
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
July 20, 2020, by Hagar Elarga:<br/>
The <code>mLoaCoo_flow_nominal</code> and <code>mLoaCoo_flow_nominal</code> are 
evaluated as a function of <code> QHea_flow_nominal</code> and 
<code>QCoo_flow_nominal</code>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},
            {300,300}})));
end BuildingTimeSeriesHE;
