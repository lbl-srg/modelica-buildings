within Buildings.Experimental.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    have_heaWat=true,
    have_chiWat=true,
    have_pum=true,
    final have_fan=false,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  parameter Boolean have_hotWat = false
    "Set to true if SHW load is included in the time series"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Types.TimeSeriesType typTimSer = Types.TimeSeriesType.Load
    "Type of time series"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Real fra_m_flow_min = if have_pum then 0.1 else 0
    "Minimum flow rate (ratio to nominal)"
    annotation(Dialog(enable=have_pum));
  parameter Modelica.SIunits.Time tau = 600
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  parameter String filNam
    "File name with thermal loads as time series";
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    start=313.15)
    "Heating hot water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC",
    start=T_aHeaWat_nominal-5)
    "Heating hot water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal(
    start=291.15)
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC",
    start=T_aChiWat_nominal+5)
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpChiWat_nominal
    "Chilled water distribution system overall pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoaHea_nominal(
    start=273.15 + 20)
    "Load temperature at nominal heating conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoaCoo_nominal(
    start=273.15 + 24)
    "Load temperature at nominal cooling conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpHeaWat_nominal
    "Heating hot water distribution system overall pressure drop"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(
    start=abs(QCoo_flow_nominal/cp_default/(T_bChiWat_nominal-T_aChiWat_nominal)))
    "Chilled water mass flow rate at nominal conditions (all units)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(
    start=abs(QHea_flow_nominal/cp_default/(T_bHeaWat_nominal-T_aHeaWat_nominal)))
    "Heating hot water mass flow rate at nominal conditions (all units)"
    annotation (Dialog(group="Nominal condition"));

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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqHea_flow(
    u(final unit="W"),
    final k=facMul) if have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{272,30},{292,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqCoo_flow(
    u(final unit="W"),
    final k=facMul) if have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{272,-10},{292,10}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2:4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.Load
    "Reader for thermal loads: y[1] cooling load, y[2] heating load, y[3] SHW load"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Modelica.Blocks.Sources.CombiTimeTable loaFlo(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2:6},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.LoadFlow
    "y[1] cooling load, y[2] heating load, y[3] SHW load, y[4] CHW flow rate, y[5] HHW flow rate"
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Modelica.Blocks.Sources.CombiTimeTable loaFloTem(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2:8},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.LoadFlowTemperature
    "y[1] cooling load, y[2] heating load, y[3] SHW load, y[4] CHW flow rate, y[5] HHW flow rate, y[6] CHWST, y[7] HHWST"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  EnergyMassFlowInterface eneMasFloHea(
    redeclare final package Medium=Medium,
    final have_masFlo=typTimSer==Types.TimeSeriesType.LoadFlow or
      typTimSer==Types.TimeSeriesType.LoadFlowTemperature,
    final have_pum=have_pum,
    final Q_flow_nominal=QHea_flow_nominal,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final dp_nominal=dpHeaWat_nominal,
    final TLoa_nominal=TLoaHea_nominal)
    "Hot water energy and mass flow rate"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  EnergyMassFlowInterface eneMasFloCoo(
    redeclare final package Medium=Medium,
    final have_masFlo=typTimSer==Types.TimeSeriesType.LoadFlow or
      typTimSer==Types.TimeSeriesType.LoadFlowTemperature,
    final have_pum=have_pum,
    final Q_flow_nominal=QCoo_flow_nominal,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dp_nominal=dpChiWat_nominal,
    final TLoa_nominal=TLoaCoo_nominal)
    "Chilled water energy and mass flow rate"
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));
equation
  connect(loa.y[3], QReqHotWat_flow) annotation (Line(points={{-219,60},{240,60},
          {240,-120},{320,-120}}, color={0,0,127}));
  connect(mulQReqCoo_flow.y, QReqCoo_flow)
    annotation (Line(points={{294,0},{320,0}}, color={0,0,127}));
  connect(mulQReqHea_flow.y, QReqHea_flow)
    annotation (Line(points={{294,40},{320,40}}, color={0,0,127}));
  connect(loa.y[1], mulQReqCoo_flow.u)
    annotation (Line(points={{-219,60},{260,60},{260,0},{270,0}},
                                                color={0,0,127}));
  connect(loa.y[2], mulQReqHea_flow.u) annotation (Line(points={{-219,60},{260,60},
          {260,40},{270,40}}, color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, eneMasFloHea.port_a)
    annotation (Line(points={{-260,-60},{-10,-60}}, color={0,127,255}));
  connect(eneMasFloHea.port_b, mulHeaWatOut[1].port_a)
    annotation (Line(points={{10,-60},{260,-60}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, eneMasFloCoo.port_a)
    annotation (Line(points={{-260,-260},{-10,-260}}, color={0,127,255}));
  connect(eneMasFloCoo.port_b, mulChiWatOut[1].port_a)
    annotation (Line(points={{10,-260},{260,-260}}, color={0,127,255}));
  connect(loa.y[2], eneMasFloHea.QPre_flow) annotation (Line(points={{-219,60},{
          -20,60},{-20,-53},{-12,-53}}, color={0,0,127}));
  connect(loa.y[1], eneMasFloCoo.QPre_flow) annotation (Line(points={{-219,60},{
          -20,60},{-20,-253},{-12,-253}}, color={0,0,127}));
  connect(loaFlo.y[5], eneMasFloHea.mPre_flow) annotation (Line(points={{-219,20},
          {-40,20},{-40,-55},{-12,-55}}, color={0,0,127}));
  connect(loaFlo.y[4], eneMasFloCoo.mPre_flow) annotation (Line(points={{-219,20},
          {-40,20},{-40,-255},{-12,-255}}, color={0,0,127}));
  connect(loaFloTem.y[7], eneMasFloHea.TSupSet) annotation (Line(points={{-219,-20},
          {-60,-20},{-60,-57},{-12,-57}}, color={0,0,127}));
  connect(loaFloTem.y[6], eneMasFloCoo.TSupSet) annotation (Line(points={{-219,-20},
          {-60,-20},{-60,-257},{-12,-257}}, color={0,0,127}));
    annotation (Line(points={{90.8333,-12},{180,-12},{180,126},{238,126}},color={0,0,127}),
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
