within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseDebug1
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
  parameter Buildings.Templates.Components.Types.Cooler typCoo=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen;
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated;

  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat=Buildings.Templates.Components.Types.PumpArrangement.Dedicated;
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None;
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None;

  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only;
  parameter Boolean have_bypChiWatFix=false;
  parameter Boolean have_pumChiWatSec=false;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatPri=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatSec=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon;
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat=
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon;

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
      final typChi=typChi,
      final nChi=nChi,
      final typDisChiWat=typDisChiWat,
      final nPumChiWatSec=nPumChiWatSec,
      final typCoo=typCoo,
      final nCoo=nCoo,
      final typCtrSpePumConWat=typCtrSpePumConWat))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));

  parameter Boolean allowFlowReversal=true;
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumChiWat,
    p=200000,
    nPorts=2)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{100,30},{80,50}})));

  replaceable Components.ChillerGroups.Compression  chi(typValChiWatIso_select=
        Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
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

  replaceable Components.Controls.OpenLoopDebug1 ctr constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoopDebug(
    final nChi=nChi)
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Fluid.Sources.Boundary_pT bouCon(redeclare final package Medium = MediumCon,
      final nPorts=1)
    "Air pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,40})));
  Fluid.Sources.MassFlowSource_T souAir[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow=1,
    each final nPorts=1) "Air flow source" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-60})));
  Buildings.Templates.Components.Routing.SingleToMultiple outPumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=sum(chi.mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
equation
  connect(chi.ports_bCon,outConChi.ports_a)
    annotation (Line(points={{-20,40},{-32,40}},
                                               color={0,127,255}));
  connect(outConChi.port_b, bouCon.ports[1])
    annotation (Line(points={{-52,40},{-60,40}},   color={0,127,255}));
  connect(souAir.ports[1], chi.ports_aCon) annotation (Line(points={{-60,-60},{-20,
          -60}},                             color={0,127,255}));
  connect(ctl.bus, chi.bus) annotation (Line(
      points={{-100,80},{0,80},{0,50}},
      color={255,204,51},
      thickness=0.5));
  connect(chi.ports_bChiWat, outPumChiWatPri.ports_a)
    annotation (Line(points={{20,40},{40,40}}, color={0,127,255}));
  connect(outPumChiWatPri.port_b, bou.ports[1]) annotation (Line(points={{60,40},
          {70,40},{70,39},{80,39}}, color={0,127,255}));
  connect(outPumChiWatPri1.ports_b, chi.ports_aChiWat)
    annotation (Line(points={{40,-60},{20,-60}}, color={0,127,255}));
  connect(outPumChiWatPri1.port_a, bou.ports[2])
    annotation (Line(points={{60,-60},{80,-60},{80,41}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{140,120}})));
end BaseDebug1;
