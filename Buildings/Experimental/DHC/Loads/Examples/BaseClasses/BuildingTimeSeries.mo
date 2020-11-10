within Buildings.Experimental.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter String filNam
    "File name with thermal loads as time series";
  parameter Real facScaHea=10
    "Heating terminal unit scaling factor";
  parameter Real facScaCoo=40
    "Cooling terminal unit scaling factor";
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal=273.15+40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal=273.15+18
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aChiWat_nominal+5
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal=273.15+20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal=273.15+24
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal=1
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal=1
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Modelica.Constants.small)=10
    "Time constant of integrator block";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance for fan air volume"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=1
    "Time constant of fan air volume, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Boolean use_inputFilter=true
    "= true, if fan speed is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (Dialog(tab="Dynamics",group="Filtered speed",enable=use_inputFilter));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(
      each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(
    k=297.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeHeating terUniHea(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facSca=facScaHea,
    final QHea_flow_nominal=QHea_flow_nominal/facScaHea,
    final mHeaWat_flow_nominal=mHeaWat_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final k=k,
    final Ti=Ti,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime) if have_watHea
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{70,-34},{90,-14}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=mHeaWat_flow_nominal*facScaHea,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) if have_watHea
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloCoo(
    redeclare package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal*facScaCoo,
    typDis=Buildings.Experimental.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1) if have_watCoo
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeCooling terUniCoo(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facSca=facScaCoo,
    final QHea_flow_nominal=QHea_flow_nominal/facScaHea,
    final QCoo_flow_nominal=QCoo_flow_nominal/facScaCoo,
    final mChiWat_flow_nominal=mChiWat_flow_nominal,
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
    final riseTime=riseTime) if have_watCoo
    "Cooling terminal unit"
    annotation (Placement(transformation(extent={{70,26},{90,46}})));
  Modelica.Blocks.Interfaces.RealOutput QReqHea_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_heaLoa
    "Heating load"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={200,-320})));
  Modelica.Blocks.Interfaces.RealOutput QReqCoo_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_cooLoa
    "Cooling load"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={260,-320})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPPum
    "Sum pump power"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noCoo(
    k=0) if not have_watCoo
    "No cooling system"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noHea(
    k=0) if not have_watHea
    "No heating system"
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPFan
    "Sum fan power"
    annotation (Placement(transformation(extent={{220,110},{240,130}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpHeaWat_nominal=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      T_aHeaWat_nominal))
    "Heating water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cpChiWat_nominal=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      T_aChiWat_nominal))
    "Chilled water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=abs(
    QCoo_flow_nominal/cpChiWat_nominal/(T_aChiWat_nominal-T_bChiWat_nominal))
    "Chilled water mass flow rate at nominal conditions";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=abs(
    QHea_flow_nominal/cpHeaWat_nominal/(T_aHeaWat_nominal-T_bHeaWat_nominal))
    "Heating water mass flow rate at nominal conditions";
equation
  connect(terUniHea.port_bHeaWat,disFloHea.ports_a1[1])
    annotation (Line(points={{90,-32.3333},{90,-32},{146,-32},{146,-64},{140,-64}},color={0,127,255}));
  connect(disFloHea.ports_b1[1],terUniHea.port_aHeaWat)
    annotation (Line(points={{120,-64},{64,-64},{64,-32.3333},{70,-32.3333}},color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow,disFloHea.mReq_flow[1])
    annotation (Line(points={{90.8333,-27.3333},{90.8333,-28},{100,-28},{100,-74},{119,-74}},color={0,0,127}));
  connect(disFloHea.QActTot_flow,QHea_flow)
    annotation (Line(points={{141,-76},{260,-76},{260,280},{320,280}},color={0,0,127}));
  connect(disFloCoo.QActTot_flow,QCoo_flow)
    annotation (Line(points={{141,-266},{268,-266},{268,240},{320,240}},color={0,0,127}));
  connect(loa.y[1],terUniCoo.QReqCoo_flow)
    annotation (Line(points={{21,0},{46,0},{46,32.5},{69.1667,32.5}},color={0,0,127}));
  connect(loa.y[2],terUniHea.QReqHea_flow)
    annotation (Line(points={{21,0},{46,0},{46,-25.6667},{69.1667,-25.6667}},color={0,0,127}));
  connect(disFloCoo.ports_b1[1],terUniCoo.port_aChiWat)
    annotation (Line(points={{120,-254},{60,-254},{60,29.3333},{70,29.3333}},color={0,127,255}));
  connect(terUniCoo.port_bChiWat,disFloCoo.ports_a1[1])
    annotation (Line(points={{90,29.3333},{112,29.3333},{160,29.3333},{160,-254},{140,-254}},color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow,disFloCoo.mReq_flow[1])
    annotation (Line(points={{90.8333,31},{108,31},{108,-264},{119,-264}},color={0,0,127}));
  connect(minTSet.y,terUniHea.TSetHea)
    annotation (Line(points={{-258,180},{-20,180},{-20,-20},{24,-20},{24,-19},{69.1667,-19}},color={0,0,127}));
  connect(maxTSet.y,terUniCoo.TSetCoo)
    annotation (Line(points={{-258,220},{0,220},{0,39.3333},{69.1667,39.3333}},color={0,0,127}));
  connect(ports_aHeaWat[1],disFloHea.port_a)
    annotation (Line(points={{-300,-60},{-90,-60},{-90,-70},{120,-70}},color={0,127,255}));
  connect(ports_bHeaWat[1],disFloHea.port_b)
    annotation (Line(points={{300,-60},{220,-60},{220,-70},{140,-70}},color={0,127,255}));
  connect(ports_aChiWat[1],disFloCoo.port_a)
    annotation (Line(points={{-300,-260},{120,-260}},color={0,127,255}));
  connect(ports_bChiWat[1],disFloCoo.port_b)
    annotation (Line(points={{300,-260},{140,-260}},color={0,127,255}));
  connect(loa.y[1],QReqCoo_flow)
    annotation (Line(points={{21,0},{320,0},{320,0}},color={0,0,127}));
  connect(loa.y[2],QReqHea_flow)
    annotation (Line(points={{21,0},{280,0},{280,40},{320,40}},color={0,0,127}));
  connect(disFloHea.PPum,addPPum.u1)
    annotation (Line(points={{141,-78},{170,-78},{170,86},{218,86}},color={0,0,127}));
  connect(disFloCoo.PPum,addPPum.u2)
    annotation (Line(points={{141,-268},{200,-268},{200,74},{218,74}},color={0,0,127}));
  connect(addPPum.y,PPum)
    annotation (Line(points={{242,80},{320,80}},color={0,0,127}));
  connect(noHea.y,addPPum.u1)
    annotation (Line(points={{92,120},{170,120},{170,86},{218,86}},color={0,0,127}));
  connect(noCoo.y,addPPum.u2)
    annotation (Line(points={{92,80},{200,80},{200,74},{218,74}},color={0,0,127}));
  connect(addPFan.y,PFan)
    annotation (Line(points={{242,120},{320,120}},color={0,0,127}));
  connect(noHea.y,addPFan.u1)
    annotation (Line(points={{92,120},{200,120},{200,126},{218,126}},color={0,0,127}));
  connect(noCoo.y,addPFan.u2)
    annotation (Line(points={{92,80},{200,80},{200,114},{218,114}},color={0,0,127}));
  connect(terUniCoo.PFan,addPFan.u2)
    annotation (Line(points={{90.8333,36},{160,36},{160,114},{218,114}},color={0,0,127}));
  connect(terUniHea.PFan,addPFan.u1)
    annotation (Line(points={{90.8333,-24},{180,-24},{180,126},{218,126}},color={0,0,127}));
  annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified building model where the space heating and cooling loads
are provided as time series.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 18, 2020, by Jianjun Hu:<br/>
Changed flow distribution components and the terminal units to be conditional depending
on if there is water-based heating, or cooling system.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2147\">issue 2147</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end BuildingTimeSeries;
