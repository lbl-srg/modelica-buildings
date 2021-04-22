within Buildings.Experimental.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    have_heaWat=true,
    have_chiWat=true,
    final have_pum=false,
    final have_fan=false,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  parameter Boolean have_hotWat = false
    "Set to true if SHW load is included in the time series"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_secPum = true
    "Set to true in case of in-building secondary pumps"
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
  parameter Modelica.SIunits.PressureDifference dpChiWat_nominal(
    start=1E5)
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
  parameter Modelica.SIunits.PressureDifference dpHeaWat_nominal(
    start=1E5)
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
  final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=
    abs(QCoo_flow_nominal/cp_default/(T_bChiWat_nominal-T_aChiWat_nominal))
    "Chilled water mass flow rate at nominal conditions (all units)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=
    abs(QHea_flow_nominal/cp_default/(T_bHeaWat_nominal-T_aHeaWat_nominal))
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    final k=T_aChiWat_nominal,
    y(final unit="K", displayUnit="degC")) if
      typTimSer <> Types.TimeSeriesType.LoadFlowTemperature
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    final k=T_aHeaWat_nominal,
    y(final unit="K", displayUnit="degC")) if
      typTimSer <> Types.TimeSeriesType.LoadFlowTemperature
    "Heating hot water supply temperature set point"
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
    columns=2:4,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.Load
    "Reader for thermal loads: y[1] cooling load, y[2] heating load, y[3] SHW load"
    annotation (Placement(transformation(extent={{-280,130},{-260,150}})));
  Modelica.Blocks.Sources.CombiTimeTable loaFlo(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns=2:6,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.LoadFlow
    "y[1] cooling load, y[2] heating load, y[3] SHW load, y[4] CHW flow rate, y[5] HHW flow rate"
    annotation (Placement(transformation(extent={{-280,90},{-260,110}})));
  Modelica.Blocks.Sources.CombiTimeTable loaFloTem(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns=2:8,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1) if
    typTimSer == Types.TimeSeriesType.LoadFlowTemperature
    "y[1] cooling load, y[2] heating load, y[3] SHW load, y[4] CHW flow rate, y[5] HHW flow rate, y[6] CHWST, y[7] HHWST"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  EnergyMassFlowInterface eneMasFloHea(
    redeclare final package Medium=Medium,
    final have_masFlo=typTimSer==Types.TimeSeriesType.LoadFlow or
      typTimSer==Types.TimeSeriesType.LoadFlowTemperature,
    final have_pum=have_secPum,
    final Q_flow_nominal=QHea_flow_nominal,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final dp_nominal=dpHeaWat_nominal,
    final TLoa_nominal=TLoaHea_nominal) if have_heaWat
    "Hot water energy and mass flow rate"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  EnergyMassFlowInterface eneMasFloCoo(
    redeclare final package Medium=Medium,
    final have_masFlo=typTimSer==Types.TimeSeriesType.LoadFlow or
      typTimSer==Types.TimeSeriesType.LoadFlowTemperature,
    final have_pum=have_secPum,
    final Q_flow_nominal=QCoo_flow_nominal,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dp_nominal=dpChiWat_nominal,
    final TLoa_nominal=TLoaCoo_nominal) if have_chiWat
    "Chilled water energy and mass flow rate"
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extLoa(
    final nin=3,
    final nout=3,
    final extract=1:3)
    "Extract loads: y[1] cooling load, y[2] heating load, y[3] SHW load"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extFlo(
    final nin=5,
    final nout=2,
    final extract=4:5) if typTimSer == Types.TimeSeriesType.LoadFlowTemperature or
      typTimSer == Types.TimeSeriesType.LoadFlow
    "Extract flow rates: y[1] CHW flow rate, y[2] HHW flow rate"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extTem(
    final nin=7,
    final nout=2,
    final extract=6:7) if typTimSer == Types.TimeSeriesType.LoadFlowTemperature
    "Extract supply temperatures: y[1] CHWST, y[2] HHWST"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset uEna[2](
    each duration=15*60)
    "Hold enable signal"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold ena[2](
    each t=1E-4,
    each h=0.5E-4)
    "Enable cooling or heating "
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain norLoa[2](
    final k={QCoo_flow_nominal, QHea_flow_nominal})
    "Normalize loads"
    annotation (Placement(transformation(extent={{-148,130},{-128,150}})));
equation
  connect(mulQReqCoo_flow.y, QReqCoo_flow)
    annotation (Line(points={{294,0},{320,0}}, color={0,0,127}));
  connect(mulQReqHea_flow.y, QReqHea_flow)
    annotation (Line(points={{294,40},{320,40}}, color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, eneMasFloHea.port_a)
    annotation (Line(points={{-260,-60},{-10,-60}}, color={0,127,255}));
  connect(eneMasFloHea.port_b, mulHeaWatOut[1].port_a)
    annotation (Line(points={{10,-60},{260,-60}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, eneMasFloCoo.port_a)
    annotation (Line(points={{-260,-260},{-10,-260}}, color={0,127,255}));
  connect(eneMasFloCoo.port_b, mulChiWatOut[1].port_a)
    annotation (Line(points={{10,-260},{260,-260}}, color={0,127,255}));
  connect(loa.y, extLoa.u)
    annotation (Line(points={{-259,140},{-202,140}}, color={0,0,127}));
  connect(loaFlo.y, extLoa.u) annotation (Line(points={{-259,100},{-240,100},{-240,
          140},{-202,140}}, color={0,0,127}));
  connect(loaFloTem.y, extLoa.u) annotation (Line(points={{-259,60},{-240,60},{-240,
          140},{-202,140}}, color={0,0,127}));
  connect(loaFlo.y, extFlo.u)
    annotation (Line(points={{-259,100},{-202,100}}, color={0,0,127}));
  connect(loaFloTem.y, extFlo.u) annotation (Line(points={{-259,60},{-220,60},{-220,
          100},{-202,100}}, color={0,0,127}));
  connect(loaFloTem.y, extTem.u)
    annotation (Line(points={{-259,60},{-202,60}}, color={0,0,127}));
  connect(ena.u, norLoa.y)
    annotation (Line(points={{-122,140},{-126,140}}, color={0,0,127}));
  connect(extLoa.y[1:2], norLoa.u)
    annotation (Line(points={{-178,140},{-150,140}}, color={0,0,127}));
  connect(ena.y, uEna.u)
    annotation (Line(points={{-98,140},{-92,140}},   color={255,0,255}));
  connect(uEna[2].y, eneMasFloHea.ena) annotation (Line(points={{-68,140},{-20,140},
          {-20,-51},{-12,-51}}, color={255,0,255}));
  connect(uEna[1].y, eneMasFloCoo.ena) annotation (Line(points={{-68,140},{-20,140},
          {-20,-251},{-12,-251}}, color={255,0,255}));
  connect(extFlo.y[2], eneMasFloHea.mPre_flow) annotation (Line(points={{-178,101},
          {-178,100},{-40,100},{-40,-55},{-12,-55}}, color={0,0,127}));
  connect(extFlo.y[1], eneMasFloCoo.mPre_flow) annotation (Line(points={{-178,99},
          {-178,100},{-40,100},{-40,-255},{-12,-255}}, color={0,0,127}));
  connect(extTem.y[2], eneMasFloHea.TSupSet) annotation (Line(points={{-178,61},
          {-178,60},{-60,60},{-60,-57},{-12,-57}}, color={0,0,127}));
  connect(extTem.y[1], eneMasFloCoo.TSupSet) annotation (Line(points={{-178,59},
          {-178,60},{-60,60},{-60,-257},{-12,-257}}, color={0,0,127}));
  connect(extLoa.y[2], eneMasFloHea.QPre_flow) annotation (Line(points={{-178,140},
          {-160,140},{-160,-53},{-12,-53}}, color={0,0,127}));
  connect(extLoa.y[1], eneMasFloCoo.QPre_flow) annotation (Line(points={{-178,
          138.667},{-178,140},{-160,140},{-160,-253},{-12,-253}},
                                                         color={0,0,127}));
  connect(THeaWatSupSet.y, eneMasFloHea.TSupSet) annotation (Line(points={{-258,
          220},{-60,220},{-60,-57},{-12,-57}}, color={0,0,127}));
  connect(TChiWatSupSet.y, eneMasFloCoo.TSupSet) annotation (Line(points={{-258,
          180},{-60,180},{-60,-257},{-12,-257}}, color={0,0,127}));
  connect(extLoa.y[1], mulQReqCoo_flow.u) annotation (Line(points={{-178,
          138.667},{-178,140},{-160,140},{-160,0},{270,0}},
                                                   color={0,0,127}));
  connect(extLoa.y[2], mulQReqHea_flow.u) annotation (Line(points={{-178,140},{-160,
          140},{-160,40},{270,40}}, color={0,0,127}));
  connect(extLoa.y[3], QReqHotWat_flow) annotation (Line(points={{-178,141.333},
          {-178,140},{-160,140},{-160,-120},{320,-120}}, color={0,0,127}));
  connect(eneMasFloHea.dH_flow, mulQHea_flow.u) annotation (Line(points={{12,-54},
          {20,-54},{20,280},{268,280}}, color={0,0,127}));
  connect(eneMasFloCoo.dH_flow, mulQCoo_flow.u) annotation (Line(points={{12,-254},
          {40,-254},{40,240},{268,240}}, color={0,0,127}));
  annotation (Line(points={{90.8333,-12},{180,-12},{180,126},{238,126}},color={0,0,127}),
    Documentation(
      info="<html>
<p>
This is a simplified building model where the space heating and cooling loads
are provided as time series.

Does not compute in-building secondary pump power.
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
