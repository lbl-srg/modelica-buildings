within Buildings.Templates.HeatingPlants.HotWater;
model BoilerPlant "Boiler plant"
  extends
    Buildings.Templates.HeatingPlants.HotWater.Interfaces.PartialBoilerPlant(
    final typCtl=ctl.typ,
    dat(
      typModBoiCon=boiCon.typMod,
      typModBoiNon=boiNon.typMod,
      have_senDpHeaWatLoc=ctl.have_senDpHeaWatLoc,
      nSenDpHeaWatRem=ctl.nSenDpHeaWatRem,
      have_senVHeaWatSec=ctl.have_senVHeaWatSec));

  replaceable
    Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupPolynomial
    boiCon if have_boiCon constrainedby
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.BoilerGroup(
    redeclare final package Medium = Medium,
    final nBoi=nBoiCon,
    final is_con=true,
    final typArrPumHeaWatPri=typArrPumHeaWatPriCon,
    final dat=dat.boiCon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Condensing boilers"
    annotation (
     Dialog(group="Boilers"),
     Placement(transformation(extent={{-190,-260},{-110,-140}})));

  replaceable Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupPolynomial boiNon
    if have_boiNon constrainedby
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.BoilerGroup(
    redeclare final package Medium=Medium,
    final nBoi=nBoiNon,
    final is_con=false,
    final typArrPumHeaWatPri=typArrPumHeaWatPriNon,
    final dat=dat.boiNon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Non-condensing boilers"
    annotation (
    Dialog(group="Boilers"),
    Placement(transformation(extent={{-190,-120},{-110,0}})));

  // Primary HW loop
  Buildings.Templates.Components.Sensors.Temperature THeaWatIntSup(
    redeclare final package Medium = Medium,
    final have_sen=typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Hybrid,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Intermediate HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-130})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoiCon(
    redeclare final package Medium = Medium,
    final nPorts=nBoiCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiCon
    "Condensing boiler inlet manifold"
    annotation (Placement(transformation(extent={{-80,-250},{-100,-230}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPorts_a=nPumHeaWatPriCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiCon
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPum=nPumHeaWatPriCon,
    final have_var=have_varPumHeaWatPriCon,
    final have_varCom=true,
    final dat=dat.pumHeaWatPriCon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) if have_boiCon
    "Primary HW pumps - Condensing boilers"
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPorts=nPumHeaWatPriCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiCon
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoiNon(
    redeclare final package Medium = Medium,
    final nPorts=nBoiNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiNon
    "Non-condensing boiler inlet manifold"
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPorts_a=nPumHeaWatPriNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiNon
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPum=nPumHeaWatPriNon,
    final have_var=have_varPumHeaWatPriNon,
    final have_varCom=true,
    final dat=dat.pumHeaWatPriNon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) if have_boiNon
    "Primary HW pumps - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPorts=nPumHeaWatPriNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) if have_boiNon
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valHeaWatMinByp(
    redeclare final package Medium=Medium,
    final dat=dat.valHeaWatMinByp,
    final allowFlowReversal=allowFlowReversal)
    if have_valHeaWatMinByp
    "HW minimum flow bypass valve"
    annotation (
    Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={130,-100})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypHeaWatFix(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    if have_bypHeaWatFix
    "Fixed HW bypass (common leg)"
    annotation (
    Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={150,-100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPri and ctl.locSenFloHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPri and ctl.locSenFloHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{80,-250},{60,-230}})));
  Buildings.Fluid.FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction at minimum flow bypass or common leg"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,0})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSup(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPriSup,
    final text_flip=false,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Primary HW supply temperature"
    annotation (
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPlaRet(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPlaRet,
    final text_flip=true,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant HW return temperature"
    annotation (
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-240})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatByp_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=have_varPumHeaWatPri and
      typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
      ctl.typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Decoupler HW volume flow rate"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={140,-150})));
  Buildings.Fluid.FixedResistances.Junction junInlBoiCon(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(1E3, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-240})));
  Buildings.Fluid.FixedResistances.Junction junOutBoiCon(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-160})));
  Buildings.Fluid.FixedResistances.Junction junInlBoiNon(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(1E3, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (
    Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-100})));
  Buildings.Fluid.FixedResistances.Junction junOutBoiNon(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction"
    annotation (
    Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-20})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypBoiCon(redeclare
      final package Medium = Medium) if typ == Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Hybrid
     or typ == Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.NonCondensing
    "Condensing boiler bypass" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-200})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypBoiNon(
    redeclare final package Medium = Medium)
    if typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Hybrid
      or typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Condensing
    "Condensing boiler bypass"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));
  Fluid.FixedResistances.Junction junBypRet(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction at minimum flow bypass or common leg" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={140,-240})));

  // Secondary HW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium=Medium,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_pumHeaWatSec
    "Secondary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    redeclare final package Medium=Medium,
    final nPum=nPumHeaWatSec,
    final have_var=true,
    final have_varCom=true,
    final dat=dat.pumHeaWatSec,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_pumHeaWatSec
    "Secondary HW pumps"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium=Medium,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    if have_pumHeaWatSec
    "Secondary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWat(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    if not have_pumHeaWatSec
    "HW supply line - Without secondary HW pumps"
    annotation (Placement(transformation(extent={{170,-50},{190,-30}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpHeaWatLoc(
    redeclare final package Medium=Medium,
    final have_sen=ctl.have_senDpHeaWatLoc,
    final allowFlowReversal=allowFlowReversal,
    final text_rotation=-90)
    "Local HW differential pressure sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={280,-120})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec and ctl.locSenFloHeaWatSec ==
      Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec and ctl.locSenFloHeaWatSec ==
      Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{260,-250},{240,-230}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecRet(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatSecRet,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Secondary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={200,-240})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecSup(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatSecSup,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Secondary HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={260,0})));

  // Controls
  replaceable Buildings.Templates.HeatingPlants.HotWater.Components.Controls.OpenLoop ctl
    constrainedby
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
      final dat=dat.ctl,
      final have_boiCon=have_boiCon,
      final have_boiNon=have_boiNon,
      final nBoiCon=nBoiCon,
      final nBoiNon=nBoiNon,
      final have_varPumHeaWatPri=have_varPumHeaWatPri,
      final typPumHeaWatSec=typPumHeaWatSec,
      final nPumHeaWatPriCon=nPumHeaWatPriCon,
      final nPumHeaWatPriNon=nPumHeaWatPriNon,
      final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
      final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon,
      final nPumHeaWatSec=nPumHeaWatSec,
      final have_valHeaWatMinByp=have_valHeaWatMinByp,
      final nAirHan=nAirHan,
      final nEquZon=nEquZon)
    "Plant controller"
    annotation (
    Dialog(group="Controls"),
    Placement(transformation(extent={{-10,130},{10,150}})));

equation
  /* Control point connection - start */
  connect(bus, boiCon.bus);
  connect(bus, boiNon.bus);
  connect(bus.pumHeaWatPriCon, pumHeaWatPriCon.bus);
  connect(bus.pumHeaWatPriNon, pumHeaWatPriNon.bus);
  connect(bus.valHeaWatMinByp, valHeaWatMinByp.bus);
  connect(bus.pumHeaWatSec, pumHeaWatSec.bus);
  connect(dpHeaWatLoc.y, bus.dpHeaWatLoc);
  connect(VHeaWatPriSup_flow.y, bus.VHeaWatPri_flow);
  connect(VHeaWatPriRet_flow.y, bus.VHeaWatPri_flow);
  connect(VHeaWatSecSup_flow.y, bus.VHeaWatSec_flow);
  connect(VHeaWatSecRet_flow.y, bus.VHeaWatSec_flow);
  connect(VHeaWatByp_flow.y, bus.VHeaWatByp_flow);
  connect(THeaWatPriSup.y, bus.THeaWatPriSup);
  connect(THeaWatPlaRet.y, bus.THeaWatPlaRet);
  connect(THeaWatSecSup.y, bus.THeaWatSecSup);
  connect(THeaWatSecRet.y, bus.THeaWatSecRet);
  connect(THeaWatIntSup.y, bus.THeaWatIntSup);

  /* Control point connection - stop */

  connect(pumHeaWatPriNon.ports_b, outPumHeaWatPriNon.ports_a) annotation (Line(
        points={{-50,-20},{-40,-20}},           color={0,127,255}));
  connect(port_a, VHeaWatSecRet_flow.port_a)
    annotation (Line(points={{300,-240},{260,-240}}, color={0,127,255}));
  connect(VHeaWatSecRet_flow.port_b, THeaWatSecRet.port_a)
    annotation (Line(points={{240,-240},{210,-240}}, color={0,127,255}));
  connect(port_b, dpHeaWatLoc.port_a)
    annotation (Line(points={{300,0},{280,0},{280,-110}}, color={0,127,255}));
  connect(dpHeaWatLoc.port_b, port_a) annotation (Line(points={{280,-130},{280,-240},
          {300,-240}}, color={0,127,255}));
  connect(pumHeaWatPriCon.ports_b, outPumHeaWatPriCon.ports_a)
    annotation (Line(points={{-50,-160},{-40,-160}}, color={0,127,255}));
  connect(inlPumHeaWatPriCon.ports_b, pumHeaWatPriCon.ports_a)
    annotation (Line(points={{-80,-160},{-70,-160}}, color={0,127,255}));
  connect(boiCon.ports_bHeaWat, inlPumHeaWatPriCon.ports_a)
    annotation (Line(points={{-110,-160},{-100,-160}}, color={0,127,255}));
  connect(junOutBoiNon.port_2, VHeaWatPriSup_flow.port_a)
    annotation (Line(points={{0,-10},{0,0},{60,0}}, color={0,127,255}));
  connect(THeaWatIntSup.port_b, junInlBoiNon.port_1)
    annotation (Line(points={{0,-120},{0,-110}}, color={0,127,255}));
  connect(outPumHeaWatPriNon.port_b, junOutBoiNon.port_3)
    annotation (Line(points={{-20,-20},{-10,-20}}, color={0,127,255}));
  connect(boiNon.ports_bHeaWat, inlPumHeaWatPriNon.ports_a)
    annotation (Line(points={{-110,-20},{-100,-20}}, color={0,127,255}));
  connect(outPumHeaWatPriCon.port_b, junOutBoiCon.port_3)
    annotation (Line(points={{-20,-160},{-10,-160}}, color={0,127,255}));
  connect(inlBoiNon.ports_b, boiNon.ports_aHeaWat)
    annotation (Line(points={{-100,-100},{-110,-100}}, color={0,127,255}));
  connect(junInlBoiNon.port_3, inlBoiNon.port_a)
    annotation (Line(points={{-10,-100},{-80,-100}}, color={0,127,255}));
  connect(junInlBoiCon.port_3, inlBoiCon.port_a)
    annotation (Line(points={{-10,-240},{-80,-240}}, color={0,127,255}));
  connect(inlBoiCon.ports_b, boiCon.ports_aHeaWat)
    annotation (Line(points={{-100,-240},{-110,-240}}, color={0,127,255}));
  connect(junOutBoiCon.port_2, THeaWatIntSup.port_a)
    annotation (Line(points={{0,-150},{0,-140}}, color={0,127,255}));
  connect(junInlBoiCon.port_2, bypBoiCon.port_a) annotation (Line(points={{0,-230},
          {0,-220},{-5.55112e-16,-220},{-5.55112e-16,-210}}, color={0,127,255}));
  connect(bypBoiCon.port_b, junOutBoiCon.port_1) annotation (Line(points={{6.10623e-16,
          -190},{6.10623e-16,-180},{0,-180},{0,-170}}, color={0,127,255}));
  connect(junInlBoiNon.port_2, bypBoiNon.port_a) annotation (Line(points={{0,-90},
          {0,-80},{-5.55112e-16,-80},{-5.55112e-16,-70}}, color={0,127,255}));
  connect(bypBoiNon.port_b, junOutBoiNon.port_1) annotation (Line(points={{6.10623e-16,
          -50},{6.10623e-16,-40},{0,-40},{0,-30}}, color={0,127,255}));
  connect(THeaWatSecRet.port_b, junBypRet.port_1)
    annotation (Line(points={{190,-240},{150,-240}}, color={0,127,255}));
  connect(VHeaWatByp_flow.port_b, junBypRet.port_3)
    annotation (Line(points={{140,-160},{140,-230}}, color={0,127,255}));
  connect(valHeaWatMinByp.port_b, VHeaWatByp_flow.port_a) annotation (Line(
        points={{130,-110},{130,-120},{140,-120},{140,-140}}, color={0,127,255}));
  connect(bypHeaWatFix.port_b, VHeaWatByp_flow.port_a) annotation (Line(points={
          {150,-110},{150,-120},{140,-120},{140,-140}}, color={0,127,255}));
  connect(THeaWatPriSup.port_b, junBypSup.port_1)
    annotation (Line(points={{120,0},{130,0}}, color={0,127,255}));
  connect(junBypSup.port_3, valHeaWatMinByp.port_a) annotation (Line(points={{140,-10},
          {140,-80},{130,-80},{130,-90}},      color={0,127,255}));
  connect(junBypSup.port_3, bypHeaWatFix.port_a) annotation (Line(points={{140,-10},
          {140,-80},{150,-80},{150,-90}}, color={0,127,255}));
  connect(junBypSup.port_2, inlPumHeaWatSec.port_a)
    annotation (Line(points={{150,0},{150,0}}, color={0,127,255}));
  connect(outPumHeaWatSec.port_b, VHeaWatSecSup_flow.port_a)
    annotation (Line(points={{210,0},{220,0}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_a, inlPumHeaWatSec.ports_b)
    annotation (Line(points={{170,0},{170,0}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{190,0},{190,0}}, color={0,127,255}));
  connect(VHeaWatPriSup_flow.port_b, THeaWatPriSup.port_a)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(inlPumHeaWatPriNon.ports_b, pumHeaWatPriNon.ports_a)
    annotation (Line(points={{-80,-20},{-70,-20}}, color={0,127,255}));
  connect(VHeaWatSecSup_flow.port_b, THeaWatSecSup.port_a)
    annotation (Line(points={{240,0},{250,0}}, color={0,127,255}));
  connect(THeaWatSecSup.port_b, port_b)
    annotation (Line(points={{270,0},{300,0}}, color={0,127,255}));
  connect(bus, ctl.bus) annotation (Line(
      points={{-300,140},{-10,140}},
      color={255,204,51},
      thickness=0.5));
  connect(VHeaWatPriRet_flow.port_b, junInlBoiCon.port_1) annotation (Line(
        points={{60,-240},{20,-240},{20,-260},{0,-260},{0,-250}}, color={0,127,255}));
  connect(junBypRet.port_2, THeaWatPlaRet.port_a)
    annotation (Line(points={{130,-240},{120,-240}}, color={0,127,255}));
  connect(THeaWatPlaRet.port_b, VHeaWatPriRet_flow.port_a)
    annotation (Line(points={{100,-240},{80,-240}}, color={0,127,255}));
  connect(junBypSup.port_2, supHeaWat.port_a)
    annotation (Line(points={{150,0},{150,-40},{170,-40}}, color={0,127,255}));
  connect(supHeaWat.port_b, VHeaWatSecSup_flow.port_a)
    annotation (Line(points={{190,-40},{220,-40},{220,0}}, color={0,127,255}));
  connect(busAirHan, ctl.busAirHan) annotation (Line(
      points={{300,180},{20,180},{20,146},{10,146}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busEquZon, ctl.busEquZon) annotation (Line(
      points={{300,100},{20,100},{20,134},{10,134}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
The outdoor air temperature used for optimum start, plant lockout, and other global sequences shall
be the average of all valid sensor readings. If there are four or more valid outdoor air temperature
sensors, discard the highest and lowest temperature readings.
</p>
</html>"));
end BoilerPlant;
