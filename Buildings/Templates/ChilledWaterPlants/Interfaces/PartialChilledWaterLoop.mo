within Buildings.Templates.ChilledWaterPlants.Interfaces;
partial model PartialChilledWaterLoop
  "Partial chilled water plant with chiller group and CHW loop"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterPlant(
    final typValChiWatChiIso=chi.typValChiWatIso,
    final typValConWatChiIso=chi.typValChiWatIso);

  replaceable Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups.Compression chi
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumCon,
    final nChi=nChi,
    final typChi=typChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final typCtrSpePumConWat=typCtrSpePumConWat,
    final typCtrHea=typCtrHea,
    final typEco=typEco,
    final dat=dat.chi,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group"
    annotation (Placement(transformation(extent={{-60,-110},{-20,10}})));

  // Primary CHW loop
  Components.Routing.ChillersToPrimaryPumps rou(
    redeclare final package MediumChiWat=MediumChiWat,
    final nChi=nChi,
    final typArrChi=typArrChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typEco=typEco,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Hydronic interface between chillers (and optional WSE) and primary pumps"
    annotation (Placement(transformation(extent={{0,-110},{40,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPum=nChi,
    final typCtrSpe=typCtrSpePumChiWatPri,
    final dat=dat.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final dat=dat.valChiWatMinByp,
    final allowFlowReversal=allowFlowReversal)
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-30})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypChiWatFix(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    if have_bypChiWatFix
    "Fixed CHW bypass (common leg)"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));

  // CW loop
  Buildings.Templates.Components.Routing.MultipleToSingle outConChi(
    redeclare final package Medium = MediumCon,
    final nPorts=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
         and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
         then nChi + 1 else nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group condenser fluid outlet"
    annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));

  // Secondary CHW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatSec,
    final typCtrSpe=typCtrSpePumChiWatSec,
    final dat=dat.pumChiWatSec,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{210,-10},{230,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWat(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    if not have_pumChiWatSec
    "CHW supply line - Without secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));

  // WSE
  replaceable Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco
    constrainedby Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat=MediumChiWat,
      redeclare final package MediumConWat=MediumCon,
      final dat=dat.eco,
      final allowFlowReversal=allowFlowReversal)
    "Waterside economizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-140})));

  // Controls
  replaceable Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoop ctr
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
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
    "Plant controller"
    annotation (
    Dialog(group="Controls"),
    Placement(transformation(extent={{-80,130},{-60,150}})));


equation
  /* Control point connection - start */
  connect(bus, ctr.bus);
  connect(bus, rou.bus);
  connect(bus, chi.bus);
  connect(bus, eco.bus);
  connect(bus.pumChiWatPri, pumChiWatPri.bus);
  connect(bus.valChiWatMinByp, valChiWatMinByp.bus);
  connect(bus.pumChiWatSec, pumChiWatSec.bus);
  /* Control point connection - stop */
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{40,0},{60,0}},     color={0,127,255}));
  connect(chi.ports_bCon, outConChi.ports_a)
    annotation (Line(points={{-60,0},{-80,0}}, color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{80,0},{80,0}},      color={0,127,255}));
  connect(outPumChiWatPri.port_b, inlPumChiWatSec.port_a) annotation (Line(
        points={{100,0},{150,0}},               color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{170,0},{180,0}},     color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{200,0},{210,0}},     color={0,127,255}));
  connect(outPumChiWatPri.port_b, supChiWat.port_a) annotation (Line(points={{100,0},
          {140,0},{140,-40},{180,-40}},
                                     color={0,127,255}));
  connect(supChiWat.port_b, port_b) annotation (Line(points={{200,-40},{240,-40},
          {240,0},{300,0}},                     color={0,127,255}));
  connect(outPumChiWatSec.port_b, port_b) annotation (Line(points={{230,0},{300,
          0}},                                       color={0,127,255}));
  connect(outPumChiWatPri.port_b, valChiWatMinByp.port_a) annotation (Line(
        points={{100,0},{120,0},{120,-20}},      color={0,127,255}));
  connect(bypChiWatFix.port_b, rou.port_aByp) annotation (Line(points={{80,-60},
          {60,-60},{60,-50},{40,-50}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, rou.port_aByp) annotation (Line(points={{120,-40},
          {60,-40},{60,-50},{40,-50}},    color={0,127,255}));
  connect(port_a, rou.port_aRet) annotation (Line(points={{300,-240},{60,-240},{
          60,-100.1},{39.9,-100.1}}, color={0,127,255}));
  connect(rou.ports_bRet[1:nChi], chi.ports_aChiWat)
    annotation (Line(points={{0,-100},{-20,-100}}, color={0,127,255}));
  connect(chi.ports_bChiWat, rou.ports_aSup[1:nChi])
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(bypChiWatFix.port_a, outPumChiWatPri.port_b) annotation (Line(points={
          {100,-60},{120,-60},{120,0},{100,0}}, color={0,127,255}));
  connect(rou.ports_bRet[nChi + 1], eco.port_a) annotation (Line(points={{0,-100},
          {0,-160},{-40,-160},{-40,-150}}, color={0,127,255}));
  connect(eco.port_b, rou.ports_aSup[nChi + 1]) annotation (Line(points={{-40,-130},
          {-40,-120},{-10,-120},{-10,-4},{0,-4},{0,0}}, color={0,127,255}));
end PartialChilledWaterLoop;
