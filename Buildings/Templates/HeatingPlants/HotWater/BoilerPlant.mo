within Buildings.Templates.HeatingPlants.HotWater;
model BoilerPlant "Boiler plant"
  extends
    Buildings.Templates.HeatingPlants.HotWater.Interfaces.PartialBoilerPlant(
    final typCtl=ctl.typ,
    final nAirHan=ctl.nAirHan,
    final nEquZon=ctl.nEquZon,
    dat(
      have_senDpHeaWatLoc=ctl.have_senDpHeaWatLoc,
      nSenDpHeaWatRem=ctl.nSenDpHeaWatRem,
      have_senVHeaWatSec=ctl.have_senVHeaWatSec));

  Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup boiCon(
    redeclare final package Medium = Medium,
    final typMod=typMod,
    final nBoi=nBoiCon,
    final is_con=true,
    final typArrPumHeaWatPri=typArrPumHeaWatPriCon,
    final dat=dat.boiCon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_boiCon
    "Condensing boilers"
    annotation (Placement(transformation(extent={{-220,-260},{-140,-120}})));

  Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup boiNon(
    redeclare final package Medium=Medium,
    final typMod=typMod,
    final nBoi=nBoiNon,
    final is_con=false,
    final typArrPumHeaWatPri=typArrPumHeaWatPriNon,
    final dat=dat.boiNon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_boiNon
    "Non-condensing boilers"
    annotation (Placement(transformation(extent={{-220,-120},{-140,20}})));

  // Primary HW loop - Condensing boilers
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoiCon(
    redeclare final package Medium = Medium,
    final nPorts=nBoiCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dash=true,
    icon_offset=900,
    icon_dy=-300) if have_boiCon
    "Condensing boiler inlet manifold"
    annotation (Placement(transformation(extent={{-120,-250},{-140,-230}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPorts_b=nPumHeaWatPriCon,
    final have_comLeg=
    typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final nPorts_a=nBoiCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_extend=-300,
    icon_dy=-300) if have_boiCon
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPum=nPumHeaWatPriCon,
    final have_var=have_varPumHeaWatPriCon,
    final have_varCom=true,
    final dat=dat.pumHeaWatPriCon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300) if have_boiCon
    "Primary HW pumps - Condensing boilers"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPriCon(
    redeclare final package Medium = Medium,
    final nPorts=nPumHeaWatPriCon,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300) if have_boiCon
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valHeaWatMinBypCon(
    redeclare final package Medium = Medium,
    final dat=dat.valHeaWatMinBypCon,
    final allowFlowReversal=allowFlowReversal) if have_valHeaWatMinBypCon
    "HW minimum flow bypass valve - Condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-180})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriSupCon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPriCon and ctl.locSenVHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_boiCon
    "Primary HW volume flow rate - Condensing boilers"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriRetCon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPriCon and ctl.locSenVHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_boiCon
    "Primary HW volume flow rate - Condensing boilers"
    annotation (Placement(transformation(extent={{-20,-250},{-40,-230}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSupCon(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPriSupCon,
    final text_flip=false,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_boiCon
    "Primary HW supply temperature - Condensing boilers" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-140})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPlaRetCon(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPlaRetCon,
    final text_flip=true,
    final m_flow_nominal=mHeaWatPriCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_boiCon
    "Plant HW return temperature - Condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-240})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatBypCon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=true,
    final have_sen=have_varPumHeaWatPriCon
      and typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
      and ctl.typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_bypHeaWatFixCon
    "Decoupler HW volume flow rate / Fixed HW bypass - Condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-160})));
  Buildings.Fluid.FixedResistances.Junction junInlBoiCon(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(1E3, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={60,-230})));
  Buildings.Fluid.FixedResistances.Junction junOutBoiCon(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={60,-140})));

  Buildings.Templates.Components.Sensors.Temperature THeaWatIntSup(
    redeclare final package Medium = Medium,
    final have_sen=typ == Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Intermediate HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-120})));

  // Primary HW loop - Non-condensing boilers
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoiNon(
    redeclare final package Medium = Medium,
    final nPorts=nBoiNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dash=true,
    icon_offset=900,
    icon_dy=-300) if have_boiNon
    "Non-condensing boiler inlet manifold"
    annotation (Placement(transformation(extent={{-120,-110},{-140,-90}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPorts_b=nPumHeaWatPriNon,
    final have_comLeg=
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final nPorts_a=nBoiNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_extend=-300,
    icon_dy=-300) if have_boiNon
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPum=nPumHeaWatPriNon,
    final have_var=have_varPumHeaWatPriNon,
    final have_varCom=true,
    final dat=dat.pumHeaWatPriNon,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300) if have_boiNon
    "Primary HW pumps - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPriNon(
    redeclare final package Medium = Medium,
    final nPorts=nPumHeaWatPriNon,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300) if have_boiNon
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valHeaWatMinBypNon(
    redeclare final package Medium = Medium,
    final dat=dat.valHeaWatMinBypNon,
    final allowFlowReversal=allowFlowReversal) if have_valHeaWatMinBypNon
    "HW minimum flow bypass valve - Non-condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-60})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriSupNon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPriNon and ctl.locSenVHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_boiNon
    "Primary HW volume flow rate - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPriRetNon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPriNon and ctl.locSenVHeaWatPri ==
        Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_boiNon
    "Primary HW volume flow rate - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-20,-110},{-40,-90}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSupNon(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPriSupNon,
    final text_flip=false,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_boiNon
    "Primary HW supply temperature - Non-condensing boilers" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,0})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPlaRetNon(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatPlaRetNon,
    final text_flip=true,
    final m_flow_nominal=mHeaWatPriNon_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_boiNon
    "Plant HW return temperature - Non-condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatBypNon_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=true,
    final have_sen=have_varPumHeaWatPriNon
      and typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
      and ctl.typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_bypHeaWatFixNon
    "Decoupler HW volume flow rate / Fixed HW bypass - Non-condensing boilers"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-40})));

  Buildings.Fluid.FixedResistances.Junction junInlBoiNon(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(1E3, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (
    Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-100})));
  Buildings.Fluid.FixedResistances.Junction junOutBoiNon(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
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
        origin={60,-10})));

  // Secondary HW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium=Medium,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300)
    if have_pumHeaWatSec
    "Secondary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
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
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium=Medium,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300)
    if have_pumHeaWatSec
    "Secondary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWat(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    if not have_pumHeaWatSec
    "HW supply line - Without secondary HW pumps"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
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
        origin={260,-120})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec and ctl.locSenVHeaWatSec ==
      Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec and ctl.locSenVHeaWatSec ==
      Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{240,-250},{220,-230}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecRet(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatSecRet,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Secondary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={190,-240})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecSup(
    redeclare final package Medium = Medium,
    final have_sen=ctl.have_senTHeaWatSecSup,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Secondary HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={228,0})));

  // Controls
  replaceable Buildings.Templates.HeatingPlants.HotWater.Components.Controls.Guideline36 ctl
    constrainedby
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
      final dat=dat.ctl,
      final have_boiCon=have_boiCon,
      final have_boiNon=have_boiNon,
      final nBoiCon=nBoiCon,
      final nBoiNon=nBoiNon,
      final typPumHeaWatPriCon=typPumHeaWatPriCon,
      final typPumHeaWatPriNon=typPumHeaWatPriNon,
      final typPumHeaWatSec=typPumHeaWatSec,
      final nPumHeaWatPriCon=nPumHeaWatPriCon,
      final nPumHeaWatPriNon=nPumHeaWatPriNon,
      final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
      final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon,
      final nPumHeaWatSec=nPumHeaWatSec,
      final have_valHeaWatMinBypCon=have_valHeaWatMinBypCon,
      final have_valHeaWatMinBypNon=have_valHeaWatMinBypNon)
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
  connect(bus.valHeaWatMinByp, valHeaWatMinBypCon.bus);
  connect(bus.valHeaWatMinByp, valHeaWatMinBypNon.bus);
  connect(bus.pumHeaWatSec, pumHeaWatSec.bus);
  connect(dpHeaWatLoc.y, bus.dpHeaWatLoc);
  connect(VHeaWatPriSupCon_flow.y, bus.VHeaWatPriCon_flow);
  connect(VHeaWatPriRetCon_flow.y, bus.VHeaWatPriCon_flow);
  connect(VHeaWatPriSupNon_flow.y, bus.VHeaWatPriNon_flow);
  connect(VHeaWatPriRetNon_flow.y, bus.VHeaWatPriNon_flow);
  connect(VHeaWatSecSup_flow.y, bus.VHeaWatSec_flow);
  connect(VHeaWatSecRet_flow.y, bus.VHeaWatSec_flow);
  connect(VHeaWatBypCon_flow.y, bus.VHeaWatBypCon_flow);
  connect(VHeaWatBypNon_flow.y, bus.VHeaWatBypNon_flow);
  connect(THeaWatPriSupCon.y, bus.THeaWatPriSupCon);
  connect(THeaWatPlaRetCon.y, bus.THeaWatPlaRetCon);
  connect(THeaWatPriSupNon.y, bus.THeaWatPriSupNon);
  connect(THeaWatPlaRetNon.y, bus.THeaWatPlaRetNon);
  connect(THeaWatSecSup.y, bus.THeaWatSecSup);
  connect(THeaWatSecRet.y, bus.THeaWatSecRet);
  connect(THeaWatIntSup.y, bus.THeaWatIntSup);

  /* Control point connection - stop */

  connect(pumHeaWatPriNon.ports_b, outPumHeaWatPriNon.ports_a) annotation (Line(
        points={{-70,0},{-70,0}},               color={0,127,255}));
  connect(port_a, VHeaWatSecRet_flow.port_a)
    annotation (Line(points={{300,-240},{240,-240}}, color={0,127,255}));
  connect(VHeaWatSecRet_flow.port_b, THeaWatSecRet.port_a)
    annotation (Line(points={{220,-240},{200,-240}}, color={0,127,255}));
  connect(port_b, dpHeaWatLoc.port_a)
    annotation (Line(points={{300,0},{260,0},{260,-110}}, color={0,127,255}));
  connect(dpHeaWatLoc.port_b, port_a) annotation (Line(points={{260,-130},{260,-240},
          {300,-240}}, color={0,127,255}));
  connect(pumHeaWatPriCon.ports_b, outPumHeaWatPriCon.ports_a)
    annotation (Line(points={{-70,-140},{-70,-140}}, color={0,127,255}));
  connect(inlPumHeaWatPriCon.ports_b, pumHeaWatPriCon.ports_a)
    annotation (Line(points={{-90,-140},{-90,-140}}, color={0,127,255}));
  connect(boiCon.ports_bHeaWat, inlPumHeaWatPriCon.ports_a);
    // annotation (Line(points={{-140,-140},{-110,-140}}, color={0,127,255}));
  connect(THeaWatIntSup.port_b, junInlBoiNon.port_1)
    annotation (Line(points={{60,-110},{60,-110}}, color={0,127,255}));
  connect(inlBoiNon.ports_b, boiNon.ports_aHeaWat)
    annotation (Line(points={{-140,-100},{-140,-100}}, color={0,127,255}));
  connect(inlBoiCon.ports_b, boiCon.ports_aHeaWat)
    annotation (Line(points={{-140,-240},{-140,-240}}, color={0,127,255}));
  connect(junOutBoiCon.port_2, THeaWatIntSup.port_a)
    annotation (Line(points={{60,-130},{60,-130}}, color={0,127,255}));
  connect(outPumHeaWatSec.port_b, VHeaWatSecSup_flow.port_a)
    annotation (Line(points={{160,0},{180,0}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_a, inlPumHeaWatSec.ports_b)
    annotation (Line(points={{120,0},{120,0}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{140,0},{140,0}}, color={0,127,255}));
  connect(VHeaWatPriSupCon_flow.port_b, THeaWatPriSupCon.port_a)
    annotation (Line(points={{-20,-140},{0,-140}}, color={0,127,255}));
  connect(inlPumHeaWatPriNon.ports_b, pumHeaWatPriNon.ports_a)
    annotation (Line(points={{-90,0},{-90,0}},     color={0,127,255}));
  connect(VHeaWatSecSup_flow.port_b, THeaWatSecSup.port_a)
    annotation (Line(points={{200,0},{218,0}}, color={0,127,255}));
  connect(THeaWatSecSup.port_b, port_b)
    annotation (Line(points={{238,0},{300,0}}, color={0,127,255}));
  connect(bus, ctl.bus) annotation (Line(
      points={{-300,140},{-10,140}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatPlaRetCon.port_b, VHeaWatPriRetCon_flow.port_a)
    annotation (Line(points={{0,-240},{-20,-240}}, color={0,127,255}));
  connect(supHeaWat.port_b, VHeaWatSecSup_flow.port_a)
    annotation (Line(points={{140,-40},{160,-40},{160,0},{180,0}}, color={0,127,255}));
  connect(busAirHan, ctl.busAirHan) annotation (Line(
      points={{300,180},{280,180},{280,146},{10,146}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busEquZon, ctl.busEquZon) annotation (Line(
      points={{300,100},{280,100},{280,134},{10,134}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(junInlBoiCon.port_3, THeaWatPlaRetCon.port_a)
    annotation (Line(points={{50,-230},{40,-230},{40,-240},{20,-240}},
                                                   color={0,127,255}));
  connect(VHeaWatPriRetCon_flow.port_b, inlBoiCon.port_a)
    annotation (Line(points={{-40,-240},{-120,-240}}, color={0,127,255}));
  connect(junInlBoiCon.port_2, VHeaWatBypCon_flow.port_b)
    annotation (Line(points={{60,-220},{60,-170}}, color={0,127,255}));
  connect(junOutBoiCon.port_1, valHeaWatMinBypCon.port_a)
    annotation (Line(points={{60,-150},{60,-170}}, color={0,127,255}));
  connect(THeaWatSecRet.port_b, junInlBoiCon.port_1) annotation (Line(points={{180,
          -240},{60,-240}}, color={0,127,255}));
  connect(junOutBoiNon.port_2, inlPumHeaWatSec.port_a)
    annotation (Line(points={{60,0},{100,0}},          color={0,127,255}));
  connect(junOutBoiNon.port_2, supHeaWat.port_a) annotation (Line(points={{60,0},{
          100,0},{100,-40},{120,-40}},         color={0,127,255}));
  connect(THeaWatPriSupCon.port_b, junOutBoiCon.port_3)
    annotation (Line(points={{20,-140},{50,-140}}, color={0,127,255}));
  connect(outPumHeaWatPriCon.port_b, VHeaWatPriSupCon_flow.port_a)
    annotation (Line(points={{-50,-140},{-40,-140}}, color={0,127,255}));
  connect(junOutBoiCon.port_1, VHeaWatBypCon_flow.port_a)
    annotation (Line(points={{60,-150},{60,-150}}, color={0,127,255}));
  connect(valHeaWatMinBypCon.port_b, junInlBoiCon.port_2)
    annotation (Line(points={{60,-190},{60,-220}}, color={0,127,255}));
  connect(outPumHeaWatPriNon.port_b, VHeaWatPriSupNon_flow.port_a) annotation (
      Line(points={{-50,0},{-40,0}},                         color={0,127,255}));
  connect(VHeaWatPriSupNon_flow.port_b, THeaWatPriSupNon.port_a)
    annotation (Line(points={{-20,0},{0,0}},     color={0,127,255}));
  connect(THeaWatPriSupNon.port_b, junOutBoiNon.port_3)
    annotation (Line(points={{20,0},{40,0},{40,-10},{50,-10}},
                                                 color={0,127,255}));
  connect(junInlBoiNon.port_3, THeaWatPlaRetNon.port_a)
    annotation (Line(points={{50,-100},{20,-100}}, color={0,127,255}));
  connect(THeaWatPlaRetNon.port_b, VHeaWatPriRetNon_flow.port_a)
    annotation (Line(points={{0,-100},{-20,-100}}, color={0,127,255}));
  connect(VHeaWatPriRetNon_flow.port_b, inlBoiNon.port_a)
    annotation (Line(points={{-40,-100},{-120,-100}}, color={0,127,255}));
  connect(VHeaWatBypNon_flow.port_b, junInlBoiNon.port_2)
    annotation (Line(points={{60,-50},{60,-90}}, color={0,127,255}));
  connect(VHeaWatBypNon_flow.port_a, junOutBoiNon.port_1)
    annotation (Line(points={{60,-30},{60,-20}}, color={0,127,255}));
  connect(valHeaWatMinBypNon.port_a, junOutBoiNon.port_1)
    annotation (Line(points={{60,-50},{60,-20}}, color={0,127,255}));
  connect(valHeaWatMinBypNon.port_b, junInlBoiNon.port_2)
    annotation (Line(points={{60,-70},{60,-90}}, color={0,127,255}));
  connect(boiNon.ports_bHeaWat, inlPumHeaWatPriNon.ports_a);
    // annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This template represents a hot water plant with boilers.
</p>
<p>
The possible equipment configurations are enumerated in the table below.
If any default is provided, it is displayed in bold characters.
The user may refer to ASHRAE (2021) for further details.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>Type of boiler</td>
<td>
Condensing</b><br/>
Non-condensing</b><br/>
Hybrid (both condensing and non-condensing boilers)
</td>
<td></td>
</tr>
<tr><td>Type of primary HW pumps</td>
<td>
Constant speed<br/>
Variable speed<br/>
Constant speed, provided with boiler with factory controls<br/>
Variable speed, provided with boiler with factory controls
</td>
<td>
In case of hybrid plants, the type of primary HW pumps is specified
separately for the condensing boiler group and the non-condensing boiler group.
</td>
</tr>
<tr><td>Type of primary HW pump arrangement</td>
<td>
Headered<br/>
Dedicated
</td>
<td>
If the primary HW pumps are provided with the boilers, they are necessarily 
configured in a dedicated arrangement and this option is not available.
</td>
</tr>
<tr><td>Type of secondary HW pumps</td>
<td>
None (primary-only)<br/>
Variable speed, centralized<br/>
Variable speed, distributed
</td>
<td>
Constant speed secondary pumps are not supported as they are generally not 
advisable on any boiler system (see section 5.21.7.11 in ASHRAE, 2021 for 
further explanations).<br/>
In case of hybrid plants, the primary-only option is not available.<br/>
Centralized secondary pumps refers to configurations with a single group 
of secondary pumps that is typically integrated into the plant.<br/>
Distributed secondary pumps refers to configurations with multiple secondary 
loops, each loop being served by a dedicated group of secondary pumps.
</td>
</tr>
<tr><td>Controller</td>
<td>
<b>ASHRAE Guideline 36 controller</b>
</td>
<td>An open loop controller is also available for validation purposes only.</td>
</tr>
</table>
<h4>Controls</h4>
<p>
<p>
FIXME: The outdoor air temperature used for optimum start, plant lockout, and other global sequences shall
be the average of all valid sensor readings. If there are four or more valid outdoor air temperature
sensors, discard the highest and lowest temperature readings.
</p>
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end BoilerPlant;
