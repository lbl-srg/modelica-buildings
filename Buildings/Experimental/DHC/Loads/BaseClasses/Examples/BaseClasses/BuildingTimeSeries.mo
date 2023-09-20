within Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and/or cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    have_heaWat=true,
    have_chiWat=true,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  replaceable package Medium2=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Load side medium";
  parameter Boolean have_hotWat = false
    "Set to true if SHW load is included in the time series"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter String filNam
    "File name with thermal loads as time series";
  parameter Real facMulHea(min=0)=QHea_flow_nominal /
    (QHea_flow_nominal_ref * abs(T_aLoaHea_nominal - T_aHeaWat_nominal) /
     abs(T_aLoaHea_nominal_ref - T_aHeaWat_nominal_ref) *
     mLoaHea_flow_nominal / mLoaHea_flow_nominal_ref)
    "Heating terminal unit multiplier factor"
    annotation(Dialog(enable=have_heaWat, group="Scaling", tab="Advanced"));
  parameter Real facMulCoo(min=0)=QCoo_flow_nominal /
    (QCoo_flow_nominal_ref * abs(h_aLoaCoo_nominal - hSat_nominal) /
     abs(h_aLoaCoo_nominal_ref - hSat_nominal_ref) *
     mLoaCoo_flow_nominal / mLoaCoo_flow_nominal_ref)
    "Cooling terminal unit scaling factor"
    annotation(Dialog(enable=have_chiWat, group="Scaling", tab="Advanced"));
  parameter Modelica.Units.SI.Temperature T_aHeaWat_nominal=323.15
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition", enable=have_heaWat));
  parameter Modelica.Units.SI.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC") = T_aHeaWat_nominal - 10
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition", enable=have_heaWat));
  parameter Modelica.Units.SI.Temperature T_aChiWat_nominal=280.15
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition", enable=have_chiWat));
  parameter Modelica.Units.SI.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC") = T_aChiWat_nominal + 5
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition", enable=have_chiWat));
  parameter Modelica.Units.SI.Temperature T_aLoaHea_nominal=293.15
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition", tab="Advanced"));
  parameter Modelica.Units.SI.Temperature T_aLoaCoo_nominal=298.15
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition", tab="Advanced", enable=have_chiWat));
  parameter Modelica.Units.SI.MassFraction w_aLoaCoo_nominal=0.01
    "Load side inlet humidity ratio at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition", tab="Advanced", enable=have_chiWat));
  parameter Modelica.Units.SI.MassFlowRate mLoaHea_flow_nominal(min=Modelica.Constants.eps)=0.5
    "Load side mass flow rate at nominal conditions in heating mode (single unit)"
    annotation (Dialog(group="Nominal condition", tab="Advanced", enable=have_heaWat));
  parameter Modelica.Units.SI.MassFlowRate mLoaCoo_flow_nominal(min=Modelica.Constants.eps)=
    mLoaHea_flow_nominal
    "Load side mass flow rate at nominal conditions in cooling mode (single unit)"
    annotation (Dialog(group="Nominal condition", tab="Advanced", enable=have_chiWat));

  parameter Modelica.Units.SI.Temperature T_aHeaWat_nominal_ref=323.15
    "Heating water inlet temperature at nominal conditions of reference terminal unit"
    annotation(Dialog(enable=have_heaWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.Temperature T_aLoaHea_nominal_ref=293.15
    "Load side inlet temperature at nominal conditions in heating mode of reference terminal unit"
    annotation(Dialog(enable=have_heaWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.MassFlowRate mLoaHea_flow_nominal_ref(min=Modelica.Constants.eps) = 0.5
    "Load side mass flow rate at nominal conditions in heating mode of reference terminal unit"
    annotation(Dialog(enable=have_heaWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal_ref(min=Modelica.Constants.eps) = 4.5E3
    "Heat flow at nominal conditions in heating mode of reference terminal unit"
    annotation(Dialog(enable=have_heaWat, group="Reference terminal unit performance", tab="Advanced"));

  parameter Modelica.Units.SI.Temperature T_aChiWat_nominal_ref=279.15
    "Chilled water inlet temperature at nominal conditions of reference terminal unit"
    annotation(Dialog(enable=have_chiWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.Temperature T_aLoaCoo_nominal_ref=298.15
    "Load side inlet temperature at nominal conditions in cooling mode of reference terminal unit"
    annotation(Dialog(enable=have_chiWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.MassFraction w_aLoaCoo_nominal_ref=0.01
    "Load side inlet humidity ratio at nominal conditions in cooling mode of reference terminal unit"
    annotation(Dialog(enable=have_chiWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.MassFlowRate mLoaCoo_flow_nominal_ref(min=Modelica.Constants.eps) = 0.5
    "Load side mass flow rate at nominal conditions in cooling mode of reference terminal unit"
    annotation(Dialog(enable=have_chiWat, group="Reference terminal unit performance", tab="Advanced"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_ref(max=-Modelica.Constants.eps) = -5.8E3
    "Heat flow at nominal conditions in cooling mode of reference terminal unit"
    annotation(Dialog(enable=have_chiWat, group="Reference terminal unit performance", tab="Advanced"));

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=0)=
    if have_chiWat then
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string=
    "#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    else 0
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Nominal condition", enable=have_chiWat));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=0)=
    if have_heaWat then
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string=
    "#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    else 0
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(min=0)=
      QCoo_flow_nominal/cp_default/(T_aChiWat_nominal - T_bChiWat_nominal)
    "Chilled water mass flow rate at nominal conditions (all units)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(min=0)=
      QHea_flow_nominal/cp_default/(T_aHeaWat_nominal - T_bHeaWat_nominal)
    "Heating water mass flow rate at nominal conditions (all units)"
    annotation (Dialog(group="Nominal condition"));
  parameter Real k(
    min=0)=0.1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 10
    "Time constant of integrator block";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqHotWat_flow(
    final unit="W") if have_hotWat
    "SHW load" annotation (Placement(
      transformation(extent={{300,-140},{340,-100}}), iconTransformation(
      extent={{-40,-40},{40,40}},
      rotation=-90,
      origin={280,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqHea_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_heaLoa
    "Heating load"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={200,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqCoo_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_cooLoa
    "Cooling load"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={240,-340})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is space heating load, y[3] is domestic water heat load)"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    if have_heaWat
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    if have_chiWat
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  replaceable Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeating terUniHea(
    final k=k,
    final Ti=Ti) if have_heaWat
  constrainedby Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final allowFlowReversal=allowFlowReversal,
    final facMul=facMulHea,
    final facMulZon=1,
    final QHea_flow_nominal=QHea_flow_nominal/facMulHea,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{70,-22},{90,-2}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mHeaWat_flow_nominal,
    have_pum=true,
    typCtr=Buildings.Experimental.DHC.Loads.BaseClasses.Types.PumpControlType.ConstantHead,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) if have_heaWat
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mChiWat_flow_nominal,
    typDis=Buildings.Experimental.DHC.Loads.BaseClasses.Types.DistributionType.ChilledWater,
    have_pum=true,
    typCtr=Buildings.Experimental.DHC.Loads.BaseClasses.Types.PumpControlType.ConstantHead,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1) if have_chiWat
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  replaceable
    Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeCooling
    terUniCoo(
    final k=k,
    final Ti=Ti,
    final QEnv_flow_nominal=if have_heaWat then QHea_flow_nominal/facMulHea else -QCoo_flow_nominal/facMulCoo)
      if have_chiWat
    constrainedby
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium2,
    final allowFlowReversal=allowFlowReversal,
    final facMul=facMulCoo,
    final facMulZon=1,
    final QCoo_flow_nominal=QCoo_flow_nominal/facMulCoo,
    final mLoaCoo_flow_nominal=mLoaCoo_flow_nominal,
    final T_aChiWat_nominal=T_aChiWat_nominal,
    final T_bChiWat_nominal=T_bChiWat_nominal,
    final T_aLoaCoo_nominal=T_aLoaCoo_nominal,
    final w_aLoaCoo_nominal=w_aLoaCoo_nominal) "Cooling terminal unit"
    annotation (Placement(transformation(extent={{70,36},{90,56}})));
  Buildings.Controls.OBC.CDL.Reals.Add addPPum
    "Sum pump power"
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant noCoo(
    k=0) if not have_chiWat
    "No cooling system"
    annotation (Placement(transformation(extent={{130,70},{150,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant noHea(
    k=0) if not have_heaWat
    "No heating system"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Buildings.Controls.OBC.CDL.Reals.Add addPFan
    "Sum fan power"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQReqHea_flow(
    u(final unit="W"),
    final k=facMul) if have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{272,30},{292,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQReqCoo_flow(u(
        final unit="W"), final k=facMul) if have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{272,-10},{292,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQReqHot_flow(u(final
        unit="W"), final k=facMul) if have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{270,-130},{290,-110}})));
protected
  parameter Modelica.Units.SI.AbsolutePressure pSat_nominal=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(T_aChiWat_nominal)
    "Saturation pressure at entering water temperature";
  parameter Modelica.Units.SI.AbsolutePressure pSat_nominal_ref=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(T_aChiWat_nominal_ref)
    "Saturation pressure at entering water temperature for reference terminal unit";
  parameter Modelica.Units.SI.MassFraction X1_aLoaCoo_nominal=
     w_aLoaCoo_nominal / (1 + w_aLoaCoo_nominal)
     "Water vapor concentration in [kg/kg total air]";
  parameter Modelica.Units.SI.MassFraction X1Sat_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSat_nominal, p=Medium2.p_default, phi=1.0)
    "Water vapor concentration at saturation in [kg/kg total air]";
  parameter Modelica.Units.SI.MassFraction X1_aLoaCoo_nominal_ref=
     w_aLoaCoo_nominal_ref / (1 + w_aLoaCoo_nominal_ref)
     "Water vapor concentration in [kg/kg total air]";
  parameter Modelica.Units.SI.MassFraction X1Sat_nominal_ref=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSat_nominal_ref, p=Medium2.p_default, phi=1.0)
    "Water vapor concentration at saturation in [kg/kg total air]";
  parameter Modelica.Units.SI.SpecificEnthalpy h_aLoaCoo_nominal=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=Medium2.p_default, T=T_aLoaCoo_nominal, X={X1_aLoaCoo_nominal, 1-X1_aLoaCoo_nominal})
    "Specific enthalpy of enytering air at nominal conditions in cooling mode";
  parameter Modelica.Units.SI.SpecificEnthalpy hSat_nominal=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=Medium2.p_default, T=T_aChiWat_nominal, X={X1Sat_nominal, 1-X1Sat_nominal})
    "Specific enthalpy of saturated air at entering water temperature in cooling mode";
  parameter Modelica.Units.SI.SpecificEnthalpy h_aLoaCoo_nominal_ref=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=Medium2.p_default, T=T_aLoaCoo_nominal_ref, X={X1_aLoaCoo_nominal_ref, 1-X1_aLoaCoo_nominal_ref})
    "Specific enthalpy of enytering air at nominal conditions for reference terminal unit";
  parameter Modelica.Units.SI.SpecificEnthalpy hSat_nominal_ref=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=Medium2.p_default, T=T_aChiWat_nominal_ref, X={X1Sat_nominal_ref, 1-X1Sat_nominal_ref})
    "Specific enthalpy of saturated air at entering water temperature for reference terminal unit";
initial equation
  if have_chiWat then
    assert(QCoo_flow_nominal < -Modelica.Constants.eps, "QCoo_flow_nominal must be negative.");
    assert(T_aChiWat_nominal - T_bChiWat_nominal < 0, "Temperature difference (T_aChiWat_nominal - T_bChiWat_nominal) has wrong sign.");
  end if;
  if have_heaWat then
    assert(T_aHeaWat_nominal - T_bHeaWat_nominal > 0, "Temperature difference (T_aHeaWat_nominal - T_bHeaWat_nominal) has wrong sign.");
  end if;

equation
  connect(terUniHea.port_bHeaWat,disFloHea.ports_a1[1])
    annotation (Line(points={{90,-20.3333},{90,-20},{146,-20},{146,-54},{140,
          -54}},                                                                   color={0,127,255}));
  connect(disFloHea.ports_b1[1],terUniHea.port_aHeaWat)
    annotation (Line(points={{120,-54},{64,-54},{64,-20.3333},{70,-20.3333}},color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow,disFloHea.mReq_flow[1])
    annotation (Line(points={{90.8333,-15.3333},{100,-15.3333},{100,-64},{119,
          -64}},                                                                     color={0,0,127}));
  connect(loa.y[1],terUniCoo.QReqCoo_flow)
    annotation (Line(points={{-259,0},{40,0},{40,42.5},{69.1667,42.5}}, color={0,0,127}));
  connect(loa.y[2],terUniHea.QReqHea_flow)
    annotation (Line(points={{-259,0},{40,0},{40,-13.6667},{69.1667,-13.6667}}, color={0,0,127}));
  connect(disFloCoo.ports_b1[1],terUniCoo.port_aChiWat)
    annotation (Line(points={{120,-254},{60,-254},{60,39.3333},{70,39.3333}},color={0,127,255}));
  connect(terUniCoo.port_bChiWat,disFloCoo.ports_a1[1])
    annotation (Line(points={{90,39.3333},{160,39.3333},{160,-254},{140,-254}}, color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow,disFloCoo.mReq_flow[1])
    annotation (Line(points={{90.8333,41},{108,41},{108,-264},{119,-264}},color={0,0,127}));
  connect(minTSet.y,terUniHea.TSetHea)
    annotation (Line(points={{-258,180},{-20,180},{-20,-7},{69.1667,-7}}, color={0,0,127}));
  connect(maxTSet.y,terUniCoo.TSetCoo)
    annotation (Line(points={{-258,220},{0,220},{0,49.3333},{69.1667,49.3333}},color={0,0,127}));
  connect(disFloHea.PPum,addPPum.u1)
    annotation (Line(points={{141,-68},{170,-68},{170,86},{238,86}},color={0,0,127}));
  connect(disFloCoo.PPum,addPPum.u2)
    annotation (Line(points={{141,-268},{200,-268},{200,74},{238,74}},color={0,0,127}));
  connect(noHea.y,addPPum.u1)
    annotation (Line(points={{152,120},{170,120},{170,86},{238,86}}, color={0,0,127}));
  connect(noCoo.y,addPPum.u2)
    annotation (Line(points={{152,80},{200,80},{200,74},{238,74}}, color={0,0,127}));
  connect(noHea.y,addPFan.u1)
    annotation (Line(points={{152,120},{180,120},{180,126},{238,126}},
                                                                     color={0,0,127}));
  connect(noCoo.y,addPFan.u2)
    annotation (Line(points={{152,80},{200,80},{200,114},{238,114}},
                                                                   color={0,0,127}));
  connect(terUniCoo.PFan,addPFan.u2)
    annotation (Line(points={{90.8333,46},{160,46},{160,114},{238,114}},color={0,0,127}));
  connect(terUniHea.PFan,addPFan.u1)
    annotation (Line(points={{90.8333,-12},{180,-12},{180,126},{238,126}},color={0,0,127}));
  connect(disFloCoo.port_b, mulChiWatOut[1].port_a)
    annotation (Line(points={{140,-260},{260,-260}}, color={0,127,255}));
  connect(disFloHea.port_b, mulHeaWatOut[1].port_a)
    annotation (Line(points={{140,-60},{260,-60}}, color={0,127,255}));
  connect(mulHeaWatInl[1].port_b, disFloHea.port_a)
    annotation (Line(points={{-260,-60},{120,-60}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{120,-260}}, color={0,127,255}));
  connect(addPFan.y, mulPFan.u)
    annotation (Line(points={{262,120},{268,120}}, color={0,0,127}));
  connect(addPPum.y, mulPPum.u)
    annotation (Line(points={{262,80},{268,80}}, color={0,0,127}));
  connect(mulQReqCoo_flow.y, QReqCoo_flow)
    annotation (Line(points={{294,0},{320,0}}, color={0,0,127}));
  connect(mulQReqHea_flow.y, QReqHea_flow)
    annotation (Line(points={{294,40},{320,40}}, color={0,0,127}));
  connect(loa.y[1], mulQReqCoo_flow.u)
    annotation (Line(points={{-259,0},{270,0}}, color={0,0,127}));
  connect(loa.y[2], mulQReqHea_flow.u) annotation (Line(points={{-259,0},{260,0},
          {260,40},{270,40}}, color={0,0,127}));
  connect(disFloHea.QActTot_flow, mulQHea_flow.u) annotation (Line(points={{141,
          -66},{220,-66},{220,280},{268,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, mulQCoo_flow.u) annotation (Line(points={{141,
          -266},{224,-266},{224,240},{268,240}}, color={0,0,127}));
  connect(mulQReqHot_flow.y, QReqHotWat_flow)
    annotation (Line(points={{292,-120},{320,-120}}, color={0,0,127}));
  connect(mulQReqHot_flow.u, loa.y[3]) annotation (Line(points={{268,-120},{40,-120},
          {40,0},{-259,0}}, color={0,0,127}));
annotation (
    Documentation(
      info="<html>
<p>
This is a simplified building model where the space heating and cooling 
loads are provided as time series. In order to approximate the emission 
characteristic of the building HVAC system,
this model uses idealized fan coil models that are parameterized with 
the peak load, determined from the provided time series, and design 
values of the hot water and chilled water supply and return temperatures. 
</p>
<p>
The time series that provide the loads are read from the file <code>filNam</code>.
This file must have columns as shown in this example:
<pre>
#1
#Heating, cooling and domestic hot water loads
#
#First column: Seconds in the year (loads are hourly)
#Second column: cooling loads in Watts (as negative numbers).
#Third column: space heating loads in Watts
#Fourth column: domestic hot water loads in Watts
#
#Peak space cooling load = -146960 Watts
#Peak space heating load = 167690 Watts
#Peak water heating load = 9390 Watts
double tab1(8760,4)
0;0;18230;0
3600;0;17520;0
7200;0;20170;0
10800;0;22450;0
[further rows omitted]
</pre>
Specificallly, the format must be as follows:
<ul>
<li>
The first column must be the time of the year in seconds.
</li>
<li>
If <code>have_chiWat = true</code>, then the next column must be the space cooling load in Watts.
Note that cooling is a negative number.<br/>
If <code>have_chiWat = false</code>, this column must be present but it will be ignored, and hence
it can be set to any number such as <code>0</code>.
</li>
<li>
If <code>have_heaWat = true</code>, the next column must be the space heating load in Watts.<br/>
If <code>have_heaWat = false</code>, this column must be present but it will be ignored, and hence
it can be set to any number such as <code>0</code>.
</li>
<li>
If <code>have_hotWat = true</code>, the next column must be the domestic hot water load in Watts.<br/>
If <code>have_hotWat = false</code>, this column must be present but it will be ignored, and hence
it can be set to any number such as <code>0</code>.
</li>
</ul>
<p>
The entry <code>double tab1(8760,4)</code> shows how many columns and rows are present.
</p>
<p>
The header also needs to contain the lines that start with <code>#Peak</code> as shown in the example above.
</p>
<h4>Implementation details</h4>
<p>
The total space heating (resp. cooling) load is split between
<code>facMulHea</code> (resp. <code>facMulCoo</code>)
identical terminal units with heat transfer performance approximated based on 
design specifications of a reference terminal unit.
It is not expected that the user modifies the default values 
that are proposed for <code>facMulHea</code> and <code>facMulCoo</code>
unless detailed design data are available for the building 
HVAC system.
In that latter case, the following set of parameters should be 
modified consistently to match the design data.
</p>
<ul>
<li>Hot water (resp. chilled water) supply and return temperature
<code>T_aHeaWat_nominal</code> and <code>T_bHeaWat_nominal</code>
(resp. <code>T_aChiWat_nominal</code> and <code>T_bChiWat_nominal</code>)
</li>
<li>Terminal unit entering air temperature <code>T_aLoaHea_nominal</code>
(resp. <code>T_aLoaCoo_nominal</code>) and humidity ratio
<code>w_aLoaCoo_nominal</code>
</li>
<li>Terminal unit air mass flow rate <code>mLoaHea_flow_nominal</code>
(resp. <code>mLoaCoo_flow_nominal</code>)
</li>
<li>Terminal unit scaling factor <code>facMulHea</code>
(resp. <code>facMulCoo</code>)
</li>
</ul>
<p>
For reference, the default reference terminal unit performance is based on 
manufacturer data (Carrier fan coil model 42NL/NH) at selection conditions
as specified in the \"Advanced\" tab.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 3, 2023, by David Blum:<br/>
Applied <code>facMul</code> to domestic hot water load.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
issue 3379</a>.
</li>
<li>
November 21, 2022, by David Blum:<br/>
Scale <code>facMulHea</code> and <code>facMulCoo</code> with peak load.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2302\">
issue 2302</a>.
</li>
<li>
December 21, 2020, by Antoine Gautier:<br/>
Refactored for optional hot water and multiplier factor.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2291\">issue 2291</a>.
</li>
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
