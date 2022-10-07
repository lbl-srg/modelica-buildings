within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseDebug
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi=2
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec=nChi;
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi=
    Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel;
  parameter Buildings.Templates.Components.Types.Chiller typChi=
    Buildings.Templates.Components.Types.Chiller.AirCooled;
  parameter Buildings.Templates.Components.Types.Cooler typCoo=
    Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen;
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated;

  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat=Buildings.Templates.Components.Types.PumpArrangement.Dedicated;
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea=
    Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None;
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco=
    Buildings.Templates.ChilledWaterPlants.Types.Economizer.None;

  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat=
    Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only;
  parameter Boolean have_bypChiWatFix=false;
  parameter Boolean have_pumChiWatSec=false;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatPri=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatSec=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant;

  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso=chi.typValChiWatIso
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso=chi.typValConWatIso
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso=
    Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso=
    Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter
    Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems
    dat(CHI(
      final nChi=nChi,
      final nCoo=nCoo,
      final typChi=typChi,
      final typDisChiWat=typDisChiWat,
      final nPumChiWatSec=nPumChiWatSec,
      final typCoo=typCoo,
      final typCtrSpePumConWat=typCtrSpePumConWat))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{100,92},{120,112}})));

  parameter Boolean allowFlowReversal=true;
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  replaceable Components.ChillerGroups.Compression  chi(
    typValChiWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    typValConWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition)
    constrainedby Components.ChillerGroups.Compression(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumCon,
    final nChi=nChi,
    final typChi=typChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final typCtrSpePumConWat=typCtrSpePumConWat,
    final typCtrHea=typCtrHea,
    final typEco=typEco,
    final dat=dat.CHI.chi,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group"
    annotation (Placement(transformation(extent={{-20,-70},{20,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outConChi(
    redeclare final package Medium = MediumCon,
    final nPorts=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
     and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
     then nChi + 1 else nChi,
    final m_flow_nominal=sum(chi.mConChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group condenser fluid outlet"
    annotation (Placement(transformation(extent={{-32,30},{-52,50}})));
  Components.Controls.OpenLoop ctr(
    final typChi=typChi,
    final nChi=nChi,
    final typArrChi=typArrChi,
    final typDisChiWat=typDisChiWat,
    final have_bypChiWatFix=have_bypChiWatFix,
    final have_pumChiWatSec=have_pumChiWatSec,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final typCtrSpePumChiWatPri=typCtrSpePumChiWatPri,
    final typCtrSpePumChiWatSec=typCtrSpePumChiWatSec,
    final typCtrSpePumConWat=typCtrSpePumConWat,
    final typCtrHea=typCtrHea,
    final typEco=typEco,
    final typCoo=typCoo,
    final nCoo=nCoo,
    final nPumChiWatSec=nPumChiWatSec,
    final typValChiWatChiIso=typValChiWatChiIso,
    final typValConWatChiIso=typValConWatChiIso,
    final typValCooInlIso=typValCooInlIso,
    final typValCooOutIso=typValCooOutIso)
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium = MediumCon,
    final nPorts=1)
    "Air pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,40})));
  Fluid.Sources.MassFlowSource_WeatherData
                                 souAir[nChi](
    redeclare each final package Medium = MediumCon,
    each use_m_flow_in=true,
    each m_flow=1,
    each final nPorts=1) "Air flow source" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-60})));
  Components.Routing.ChillersToPrimaryPumps rou(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final typDisChiWat=typDisChiWat,
    final typArrChi=typArrChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typEco=typEco,
    final mChiWatPri_flow_nominal=sum(chi.mConChi_flow_nominal),
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Hydronic interface between chillers (and optional WSE) and primary pumps"
    annotation (Placement(transformation(extent={{40,-70},{80,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{188,30},{208,50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    final nPum=nChi,
    final typCtrSpe=typCtrSpePumChiWatPri,
    final dat=dat.CHI.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare final package Medium = MediumChiWat,
    final nPum=nPumChiWatSec,
    final typCtrSpe=typCtrSpePumChiWatSec,
    final dat=dat.CHI.pumChiWatSec,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{260,30},{280,50}})));
  Interfaces.Bus bus annotation (Placement(transformation(extent={{-80,60},{-40,
            100}}), iconTransformation(extent={{-222,-56},{-202,-36}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat,
    final nPorts=2) "CHW pressure boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={310,40})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    dp_nominal=dat.dpChiWatDis_nominal)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  Controls.OBC.CDL.Conversions.BooleanToReal y1Chi[nChi]
    "Convert chiller Start/Stop signal into real value"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter mCon_flow[nChi](
    k=dat.CHI.chi.mConChi_flow_nominal)
    "Compute air mass flow rate at condenser"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatMinByp(
    redeclare final package Medium = MediumChiWat,
    final dat=dat.CHI.valChiWatMinByp,
    final allowFlowReversal=allowFlowReversal)
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={140,10})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypChiWatFix(
      redeclare final package Medium = MediumChiWat, final allowFlowReversal=
        allowFlowReversal)
    if have_bypChiWatFix
    "Fixed CHW bypass (common leg)"
    annotation (Placement(transformation(extent={{150,-30},{130,-10}})));
  BoundaryConditions.WeatherData.ReaderTMY3  weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWat(redeclare
      final package Medium = MediumChiWat, final allowFlowReversal=
        allowFlowReversal)
    if not have_pumChiWatSec
    "CHW supply line - Without secondary CHW pumps"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-210,-80},
            {-170,-40}}), iconTransformation(extent={{-756,-40},{-716,0}})));
equation
  connect(chi.ports_bCon,outConChi.ports_a)
    annotation (Line(points={{-20,40},{-32,40}},
                                               color={0,127,255}));
  connect(outConChi.port_b, bouCon.ports[1])
    annotation (Line(points={{-52,40},{-60,40}},   color={0,127,255}));
  connect(souAir.ports[1], chi.ports_aCon) annotation (Line(points={{-60,-60},{-20,
          -60}},                             color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{140,40},{160,40},{160,40}}, color={0,127,255}));
  connect(outPumChiWatPri.port_b, inlPumChiWatSec.port_a)
    annotation (Line(points={{180,40},{188,40}}, color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{208,40},{220,40}}, color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{240,40},{260,40}}, color={0,127,255}));
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{80,40},{120,40}}, color={0,127,255}));
  connect(ctl.bus, bus) annotation (Line(
      points={{-100,80},{-60,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus, chi.bus) annotation (Line(
      points={{-60,80},{0,80},{0,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus, rou.bus) annotation (Line(
      points={{-60,80},{60,80},{60,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.pumChiWatPri, pumChiWatPri.bus) annotation (Line(
      points={{-60,80},{130,80},{130,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.pumChiWatSec, pumChiWatSec.bus) annotation (Line(
      points={{-60,80},{230,80},{230,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(outPumChiWatSec.port_b, bouChiWat.ports[1]) annotation (Line(points={{280,40},
          {290,40},{290,41},{300,41}},         color={0,127,255}));
  connect(res.port_b, rou.port_aRet) annotation (Line(points={{120,-60},{99.95,-60},
          {99.95,-60.1},{79.9,-60.1}}, color={0,127,255}));
  connect(res.port_a, bouChiWat.ports[2]) annotation (Line(points={{140,-60},{300,
          -60},{300,39}}, color={0,127,255}));
  connect(y1Chi.y,mCon_flow. u)
    annotation (Line(points={{-138,-60},{-122,-60}}, color={0,0,127}));
  connect(busChi.y1,y1Chi. u) annotation (Line(
      points={{-190,-60},{-162,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.chi,busChi)  annotation (Line(
      points={{-60,80},{-60,100},{-220,100},{-220,-60},{-190,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(mCon_flow.y, souAir.m_flow_in) annotation (Line(points={{-98,-60},{-90,
          -60},{-90,-68},{-80,-68}}, color={0,0,127}));
  connect(bypChiWatFix.port_b, rou.port_aByp) annotation (Line(points={{130,-20},
          {90,-20},{90,-10},{80,-10}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, rou.port_aByp) annotation (Line(points={{140,0},
          {90,0},{90,-10},{80,-10}},      color={0,127,255}));
  connect(bypChiWatFix.port_a, outPumChiWatPri.port_b) annotation (Line(points={{150,-20},
          {180,-20},{180,40}},                  color={0,127,255}));
  connect(outPumChiWatPri.port_b, valChiWatMinByp.port_a) annotation (Line(
        points={{180,40},{180,20},{140,20}},          color={0,127,255}));
  for i in 1:nChi loop
    connect(weaDat.weaBus, souAir[i].weaBus) annotation (Line(
      points={{-180,0},{-86,0},{-86,-60.2},{-80,-60.2}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(outPumChiWatPri.port_b, supChiWat.port_a)
    annotation (Line(points={{180,40},{180,0},{220,0}}, color={0,127,255}));
  connect(supChiWat.port_b, bouChiWat.ports[1]) annotation (Line(points={{240,0},
          {280,0},{280,41},{300,41}},           color={0,127,255}));
  connect(rou.ports_bRet[1:nChi], chi.ports_aChiWat)
    annotation (Line(points={{40,-60},{20,-60}}, color={0,127,255}));
  connect(chi.ports_bChiWat, rou.ports_aSup[1:nChi])
    annotation (Line(points={{20,40},{40,40}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-120},{340,140}})));
end BaseDebug;
