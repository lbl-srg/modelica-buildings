within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseDebug
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi=2
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems dat(
    CHI(
      final typChi=CHI.typChi,
      final nChi=CHI.nChi,
      final typDisChiWat=CHI.typDisChiWat,
      final have_pumChiWatSec=CHI.have_pumChiWatSec,
      final nPumChiWatSec=CHI.nPumChiWatSec,
      final typCoo=CHI.typCoo,
      final nCoo=CHI.nCoo,
      final typCtrSpePumConWat=CHI.typCtrSpePumConWat))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,72},{90,92}})));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  replaceable Buildings.Templates.ChilledWaterPlants.AirCooled CHI(
    redeclare Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoopDebug ctr)
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare replaceable package MediumCon = MediumConWat,
    final nChi=nChi,
    final tau=tau,
    final energyDynamics=energyDynamics,
    typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only,
    typArrPumChiWatPri_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typArrPumConWat_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typCtrSpePumConWat_select=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Constant,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None,
    final dat=dat.CHI,
    chi(typValChiWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
        typValConWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating))
    "CHW plant"
    annotation (Placement(transformation(extent={{-40,-30},{0,10}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumChiWat,
    nPorts=3)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=CHI.mChiWat_flow_nominal,
    dp_nominal=dat.dpChiWatDis_nominal)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.Pressure pDem(
    redeclare final package Medium=MediumChiWat) "Demand side pressure"
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));

  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus" annotation (Placement(transformation(extent=
           {{-280,0},{-240,40}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-200,20},{-160,60}}), iconTransformation(extent=
           {{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus" annotation (Placement(transformation(extent={{-220,0},
            {-180,40}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{-200,40},
            {-160,80}}), iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valves control bus"
    annotation (Placement(
    transformation(extent={{-220,120},{-180,160}}),
                                                  iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{-186,120},{-146,160}}),iconTransformation(extent={
            {-422,198},{-382,238}})));
  Controls.OBC.CDL.Logical.Sources.Constant  y1Chi[nChi](
    k=fill(true, nChi))
    "Chiller, coolers Start/Stop signal"
    annotation (Placement(transformation(extent={{-320,110},{-300,130}})));
  Controls.OBC.CDL.Continuous.Sources.Constant yPum(k=1)
    "CW and CHW pump speed signal"
    annotation (Placement(transformation(extent={{-320,-50},{-300,-30}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1ValIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Two-position isolation valve opening signal"
    annotation (Placement(transformation(extent={{-320,70},{-300,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    final k=dat.CHI.chi.TChiWatChiSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-320,150},{-300,170}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    "Secondary CHW pumps control bus"
    annotation (Placement(transformation(
          extent={{-250,0},{-210,40}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busCoo[CHI.nCoo]
    "Coolers control bus" annotation (Placement(transformation(extent={{-180,0},
            {-140,40}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Controls.OBC.CDL.Continuous.Sources.Constant  yCoo[CHI.nCoo](
    k=fill(1, CHI.nCoo))
    "Coolers fan speed signal"
    annotation (Placement(transformation(extent={{-320,-90},{-300,-70}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[CHI.nCoo]
    "Cooler inlet isolation valve control bus" annotation (Placement(
        transformation(extent={{-156,60},{-116,100}}), iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[CHI.nCoo]
    "Cooler outlet isolation valve control bus" annotation (Placement(
        transformation(extent={{-126,60},{-86,100}}), iconTransformation(extent=
           {{-422,198},{-382,238}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1Pum[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-320,-10},{-300,10}})));
equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{60,0},{60,-11.3333}}, color={0,127,255}));
  connect(bou.ports[2], pDem.port)
    annotation (Line(points={{60,-10},{60,30}}, color={0,127,255}));
  connect(weaDat.weaBus, CHI.busWea) annotation (Line(
      points={{-50,80},{-20,80},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(res.port_a, CHI.port_b)
    annotation (Line(points={{20,0},{0.2,0}}, color={0,127,255}));
  connect(CHI.port_a, bou.ports[3]) annotation (Line(points={{0.2,-20.2},{60,-20.2},
          {60,-8.66667}}, color={0,127,255}));
  connect(busChi, busPla.chi) annotation (Line(
      points={{-180,60},{-180,50},{-180,40},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, busPla.valChiWatChiIso) annotation (Line(
      points={{-166,140},{-166,42},{-180,42},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatChiIso, busPla.valConWatChiIso) annotation (Line(
      points={{-200,140},{-200,44},{-188,44},{-188,40},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumConWat, busPla.pumConWat) annotation (Line(
      points={{-200,20},{-184,20},{-184,30},{-180,30},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(yPum.y, busPumChiWatPri.y)
    annotation (Line(points={{-298,-40},{-260,-40},{-260,20}},
                                                           color={0,0,127}));
  connect(yPum.y, busPumConWat.y)
    annotation (Line(points={{-298,-40},{-200,-40},{-200,20}},
                                                           color={0,0,127}));
  connect(yPum.y, busPumChiWatSec.y)
    annotation (Line(points={{-298,-40},{-230,-40},{-230,20}},
                                                           color={0,0,127}));
  connect(busPumChiWatSec, busPla.pumChiWatSec) annotation (Line(
      points={{-230,20},{-230,36},{-182,36},{-182,40},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri, busPla.pumChiWatPri) annotation (Line(
      points={{-260,20},{-260,40},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y, busChi.y1) annotation (Line(points={{-298,120},{-184,120},
          {-184,60},{-180,60}},
                      color={255,0,255}));
  connect(busPla, CHI.bus) annotation (Line(
      points={{-180,40},{-60,40},{-60,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat.y, busChi.TChiWatSupSet) annotation (Line(points={{-298,160},{
          -180,160},{-180,60}}, color={0,0,127}));
  connect(y1Chi.y, busCoo.y1) annotation (Line(points={{-298,120},{-160,120},
          {-160,20}}, color={255,0,255}));
  connect(yCoo.y, busCoo.y) annotation (Line(points={{-298,-80},{-160,-80},{-160,
          20}}, color={0,0,127}));
  connect(y1ValIso.y[1], busValCooInlIso.y1) annotation (Line(points={{-298,80},
          {-280,80},{-280,100},{-136,100},{-136,80}}, color={255,0,255}));
  connect(y1ValIso.y[1], busValCooOutIso.y1) annotation (Line(points={{-298,80},
          {-280,80},{-280,100},{-106,100},{-106,80}}, color={255,0,255}));
  connect(busCoo, busPla.coo) annotation (Line(
      points={{-160,20},{-176,20},{-176,30},{-180,30},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooInlIso, busPla.valCooInlIso) annotation (Line(
      points={{-136,80},{-136,36},{-180,36},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooOutIso, busPla.valCooOutIso) annotation (Line(
      points={{-106,80},{-106,38},{-180,38},{-180,40}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Pum.y[1], busPumChiWatPri.y1)
    annotation (Line(points={{-298,0},{-260,0},{-260,20}}, color={255,0,255}));
  connect(y1Pum.y, busPumChiWatSec.y1)
    annotation (Line(points={{-298,0},{-230,0},{-230,20}}, color={255,0,255}));
  connect(y1Pum.y[1], busPumConWat.y1)
    annotation (Line(points={{-298,0},{-200,0},{-200,20}}, color={255,0,255}));
  connect(y1ValIso.y[1], busValConWatChiIso.y1) annotation (Line(points={{-298,
          80},{-280,80},{-280,140},{-200,140}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1ValIso.y[1], busValChiWatChiIso.y1) annotation (Line(points={{-298,
          80},{-280,80},{-280,140},{-166,140}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseDebug;
