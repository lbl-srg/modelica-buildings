within Buildings.Templates.ChilledWaterPlants;
model ChilledWaterPlant "Chilled water plant"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterPlant;

  Components.ChillerGroups.Compression chi(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumCon,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group"
    annotation (Placement(transformation(extent={{-60,-110},{-20,10}})));
  Components.Routing.ChillersToPrimaryPumps rou
    "Hydronic interface between chillers (and optional WSE) and primary pumps"
    annotation (Placement(transformation(extent={{0,-110},{40,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package MediumChiWat=MediumChiWat,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package MediumConWat=MediumCon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Components.CoolerGroups.CoolingTower coo(
    redeclare final package MediumConWat=MediumCon,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Cooler group"
    annotation (Placement(transformation(extent={{-180,-40},{-260,40}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium=MediumCon,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outConWatChi(
    redeclare final package Medium=MediumCon,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{210,-10},{230,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal)
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWat(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    "CHW supply line - Without secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-40})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypChiWat(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    "CHW bypass (common leg) - Without CHW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{92,-90},{72,-70}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat(
    redeclare final package Medium=MediumConWat,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-88,-110},{-68,-90}})));
equation
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{40,0},{60,0}},     color={0,127,255}));
  connect(coo.port_b, inlPumConWat.port_a) annotation (Line(points={{-230,0},{-320,
          0},{-320,-100},{-140,-100}},        color={0,127,255}));
  connect(chi.ports_bCon, outConWatChi.ports_a)
    annotation (Line(points={{-60,0},{-60,0}},     color={0,127,255}));
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
          {240,-20},{280,-20},{280,0},{300,0}}, color={0,127,255}));
  connect(outPumChiWatSec.port_b, port_b) annotation (Line(points={{230,0},{240,
          0},{240,-20},{280,-20},{280,0},{300,0}},   color={0,127,255}));
  connect(outPumChiWatPri.port_b, valChiWatMinByp.port_a) annotation (Line(
        points={{100,0},{120,0},{120,-30}},      color={0,127,255}));
  connect(bypChiWat.port_b, rou.port_aByp) annotation (Line(points={{72,-80},{60,
          -80},{60,-50},{40,-50}},    color={0,127,255}));
  connect(valChiWatMinByp.port_b, rou.port_aByp) annotation (Line(points={{120,-50},
          {40,-50}},                      color={0,127,255}));
  connect(port_a, rou.port_aRet) annotation (Line(points={{300,-240},{60,-240},{
          60,-100.1},{39.9,-100.1}}, color={0,127,255}));
  connect(rou.ports_bRet[1:nChi], chi.ports_aChiWat)
    annotation (Line(points={{0,-100},{-20,-100}}, color={0,127,255}));
  connect(chi.ports_bChiWat, rou.ports_aSup[1:nChi])
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(outConWatChi.port_b, coo.port_a)
    annotation (Line(points={{-80,0},{-210,0}}, color={0,127,255}));
  connect(bypChiWat.port_a, outPumChiWatPri.port_b) annotation (Line(points={{92,
          -80},{120,-80},{120,0},{100,0}}, color={0,127,255}));
  connect(outPumConWat.ports_b, chi.ports_aCon)
    annotation (Line(points={{-68,-100},{-60,-100}}, color={0,127,255}));
  connect(pumConWat.ports_b, outPumConWat.ports_a)
    annotation (Line(points={{-100,-100},{-88,-100}}, color={0,127,255}));
end ChilledWaterPlant;
