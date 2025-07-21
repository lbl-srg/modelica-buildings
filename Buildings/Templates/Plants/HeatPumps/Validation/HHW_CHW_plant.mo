within Buildings.Templates.Plants.HeatPumps.Validation;
model HHW_CHW_plant "Validation of AWHP plant template"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal=mChiWatPri_flow_nominal,
    final m2_flow_nominal=mHeaWatPri_flow_nominal);
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Real mHeaWatPri_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal;
  parameter Real mChiWatPri_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal;
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  inner parameter UserProject.Data.AllSystems datAll(pla(
      cfg(
        typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
        typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
        have_heaWat=true,
        have_hotWat=false,
        have_chiWat=true,
        have_hrc=false,
        nHp=2,
        is_rev=true,
        have_valHpInlIso=true,
        have_valHpOutIso=true,
        typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
        nAirHan=1,
        nEquZon=1,
        rhoHeaWat_default(displayUnit="kg/m3") = 1000,
        cpHeaWat_default=4200,
        rhoChiWat_default(displayUnit="kg/m3") = 1000,
        cpChiWat_default=4200,
        rhoSou_default(displayUnit="kg/m3") = 1.225,
        cpSou_default=1005,
        typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
        nPumHeaWatPri=2,
        nPumHeaWatSec=pumHeaWatSec.nPum,
        have_valHeaWatMinByp=false,
        typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
        have_pumHeaWatPriVar=false,
        typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
        typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
        typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
        have_senDpHeaWatRemWir=true,
        nSenDpHeaWatRem=1,
        have_pumChiWatPriDed=false,
        typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
        nPumChiWatPri=2,
        nPumChiWatSec=pumChiWatSec.nPum,
        have_valChiWatMinByp=false,
        have_pumChiWatPriVar=false,
        typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
        typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
        have_senDpChiWatRemWir=true,
        nSenDpChiWatRem=1,
        have_inpSch=true),
      ctl(THeaWatSup_nominal=333.15, TChiWatSup_nominal=279.85),
      hp(
        mHeaWatHp_flow_nominal=0.3*58/18,
        capHeaHp_nominal=0.55*2.7e6/18,
        THeaWatSupHp_nominal=333.15,
        mChiWatHp_flow_nominal=0.3*68/9,
        capCooHp_nominal=0.3*2.4e6/18,
        TChiWatSupHp_nominal=279.85)))
    "Plant parameters"
    annotation (Placement(transformation(extent={{160,158},{180,178}})));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));

  Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={70,-530})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,
      origin={30,-176})));
  Fluid.Sensors.VolumeFlowRate
                             mChiWat_flow(
    redeclare final package Medium=Medium, m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    if have_chiWat
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
      origin={76,-206})));
  Fluid.Sensors.VolumeFlowRate
                             mHeaWat_flow(
    redeclare final package Medium=Medium, m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
      origin={114,-588})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max - max(
        datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{20,-598},{0,-578}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max - max(
        datAll.pla.ctl.dpChiWatRemSet_max))
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{56,-216},{36,-196}})));

  Fluid.Sensors.TemperatureTwoPort senTemCooSup(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Fluid.Sensors.TemperatureTwoPort senTemHeaSup(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{130,-520},{150,-500}})));

  Components.ValvesIsolation valIso(
    redeclare final package Medium = Medium,
    final nHp=2,
    final have_chiWat=true,
    final have_valHpInlIso=true,
    final have_valHpOutIso=true,
    final have_pumChiWatPriDed=false,
    final mHeaWatHp_flow_nominal=fill(datAll.pla.hp.mHeaWatHp_flow_nominal,
        valIso.nHp),
    final dpHeaWatHp_nominal=fill(datAll.pla.hp.dpHeaWatHp_nominal, valIso.nHp),
    final dpBalHeaWatHp_nominal=fill(0, valIso.nHp),
    final mChiWatHp_flow_nominal=fill(datAll.pla.hp.mChiWatHp_flow_nominal,
        valIso.nHp),
    final dpBalChiWatHp_nominal=fill(0, valIso.nHp),
    final allowFlowReversal=true,
    linearized=true)
    "Heat pump isolation valves"
    annotation (Placement(transformation(extent={{-678,-160},{-420,-106}})));

  Components.HeatPumpGroups.AirToWater                                      hp(
    redeclare final package MediumHeaWat = Medium,
    redeclare final package MediumAir = MediumAir,
    final nHp=2,
    final is_rev=true,
    dat=datAll.pla.hp,
    final energyDynamics=energyDynamics,
    final have_dpChiHeaWatHp=false,
    final have_dpSou=false,
    final allowFlowReversal=allowFlowReversal,
    final allowFlowReversalSou=false)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-838,-340},{-358,-260}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y mov[2](
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal,
    dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-508,-188})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypSup1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-146,-158})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-72,-158})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypRet1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-146,-206})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-168,-528})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={-168,-588})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-72,-508})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-72,-588})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-72,-206})));

  Controls.HeatPumps.AirToWater_hybridPlant                ctl(
    have_heaWat=true,
    have_chiWat=true,
    have_hrc_select=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed_select=true,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=3,
    is_heaRec={false,false,true},
    nPumHeaWatSec=pumHeaWatSec.nPum,
    nPumChiWatSec=pumChiWatSec.nPum,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=333.15,
    THeaWatSupSet_min=318.15,
    TOutHeaWatLck=303.15,
    VHeaWatHp_flow_nominal=1.1*fill(ctl.VHeaWatSec_flow_nominal/ctl.nHp, ctl.nHp),
    VHeaWatHp_flow_min=0.6*ctl.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal/1000,
    capHeaHp_nominal=fill(datAll.pla.hp.capHeaHp_nominal, ctl.nHp),
    dpHeaWatRemSet_max=datAll.pla.ctl.dpHeaWatRemSet_max,
    final TChiWatSup_nominal=279.95,
    TChiWatSupSet_max=288.15,
    TOutChiWatLck=283.15,
    VChiWatHp_flow_nominal=1.1*fill(ctl.VChiWatSec_flow_nominal/ctl.nHp, ctl.nHp),
    VChiWatHp_flow_min=0.6*ctl.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal/1000,
    capCooHp_nominal=fill(datAll.pla.hp.capCooHp_nominal, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max=datAll.pla.ctl.dpChiWatRemSet_max,
    staEquCooHea=[0,0,1; 1/2,1/2,1; 1,1,1],
    staEquOneMod=[1/2,1/2,0; 1,1,0; 1,1,1],
    idxEquAlt={1,2},
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min*(1 - 1/ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3*0.5*sum(ctl.capHeaHp_nominal),
    ctlPumHeaWatSec(ctlDpRem(y(start=1))))
    "Plant controller"
    annotation (Placement(transformation(extent={{-380,-30},{-340,42}})));
  Interfaces.Bus                                      bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-520,-46}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-100,0})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3[2](t=0.05, h=0.02)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-490,-230})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6[2] annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-400,-180})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[2] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-400,-150})));
  Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,-158})));
  Fluid.Sensors.VolumeFlowRate senVolFlo(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-106,-168},{-86,-148}})));
  Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-122,-206})));
  Fluid.Sensors.VolumeFlowRate senVolFlo1(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-88,-216},{-108,-196}})));
  Fluid.Sensors.TemperatureTwoPort senTem4(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-528})));
  Fluid.Sensors.VolumeFlowRate senVolFlo2(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-120,-538},{-100,-518}})));
  Fluid.Sensors.VolumeFlowRate senVolFlo3(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-90,-598},{-110,-578}})));
  Fluid.Sensors.TemperatureTwoPort senTem5(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-134,-588})));
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-438,
            140},{-364,210}})));
  Buildings.Templates.Components.Interfaces.Bus busSen annotation (Placement(
        transformation(extent={{42,-320},{82,-280}}), iconTransformation(extent
          ={{-980,164},{-940,204}})));
  Buildings.Templates.Components.Interfaces.Bus busSen2 annotation (Placement(
        transformation(extent={{-542,-20},{-502,20}}), iconTransformation(
          extent={{-980,164},{-940,204}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=2)
    annotation (Placement(transformation(extent={{-570,-192},{-550,-172}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[pumHeaWatSec.nPum]
    annotation (Placement(transformation(extent={{-348,-110},{-368,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[pumChiWatSec.nPum]
    annotation (Placement(transformation(extent={{-348,-86},{-368,-66}})));
// protected
  Buildings.Templates.Components.Interfaces.Bus busHp[2]
    "Heat pump control bus" annotation (Placement(transformation(extent={{-522,84},
            {-482,124}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[2]
    "Heat pump inlet HW isolation valve control bus" annotation (Placement(
        transformation(extent={{-526,44},{-486,84}}), iconTransformation(extent
          ={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[2]
    "Heat pump outlet HW isolation valve control bus" annotation (Placement(
        transformation(extent={{-522,8},{-482,48}}), iconTransformation(extent={
            {-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[2]
    "Heat pump inlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{-484,-46},{-444,-6}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[2]
    "Heat pump outlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{-484,-86},{-444,-46}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    have_valChe=true,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium = Medium,
    final have_var=true,
    final have_varCom=true,
    nPum=4,
    dat=datAll.pla.pumHeaWatSec) "Secondary HHW pumps"
    annotation (Placement(transformation(extent={{-2,-516},{18,-496}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumHeaWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{24,-516},{44,-496}})));

  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumHeaWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-30,-516},{-10,-496}})));

  Buildings.Templates.Components.Interfaces.Bus busPumSecHeaWat annotation (
      Placement(transformation(extent={{-260,160},{-220,200}}),
        iconTransformation(extent={{-980,164},{-940,204}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumChiWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));

  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    have_valChe=true,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium = Medium,
    final have_var=true,
    final have_varCom=true,
    nPum=4,
    dat=datAll.pla.pumChiWatSec) "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{-22,-170},{-2,-150}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumChiWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{4,-170},{24,-150}})));

  Buildings.Templates.Components.Interfaces.Bus busPumSecChiWat annotation (
      Placement(transformation(extent={{-320,160},{-280,200}}),
        iconTransformation(extent={{-980,164},{-940,204}})));

public
  FourPipeASHP_with_controls fourPipeASHP_with_controls(
    m1_flow_nominal=fourPipeASHP_with_controls.mChiWatPri_flow_nominal,
    m2_flow_nominal=fourPipeASHP_with_controls.mHeaWatPri_flow_nominal,
    datAll=datAll)
    annotation (Placement(transformation(extent={{-300,-400},{-280,-380}})));
  Fluid.Sensors.TemperatureTwoPort senTemCooRet(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-206})));
  Fluid.Sensors.TemperatureTwoPort senTemHeaRet(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={144,-588})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaHeaWat annotation (
      Placement(transformation(extent={{-740,40},{-700,80}}),
        iconTransformation(extent={{-160,-120},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaChiWat annotation (
      Placement(transformation(extent={{-740,0},{-700,40}}), iconTransformation(
          extent={{-160,-60},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResChiWat annotation (
      Placement(transformation(extent={{-740,-80},{-700,-40}}),
        iconTransformation(extent={{-160,20},{-120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResHeaWat annotation (
      Placement(transformation(extent={{-740,-40},{-700,0}}),
        iconTransformation(extent={{-160,80},{-120,120}})));
equation
  if have_chiWat then
  end if;
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{66,-206},{56,-206}},           color={0,127,255}));
  connect(mHeaWat_flow.port_b, pipHeaWat.port_a)
    annotation (Line(points={{104,-588},{20,-588}},           color={0,127,255}));
  connect(hp.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp) annotation (Line(
        points={{-648,-260},{-648,-242},{-650,-242},{-650,-156},{-575.875,-156},
          {-575.875,-160}},                                               color
        ={0,127,255}));
  connect(valIso.ports_bChiHeaWatHp, mov.port_a) annotation (Line(points={{-522.125,
          -160},{-524,-160},{-524,-168},{-508,-168},{-508,-178}},
                                          color={0,127,255}));
  connect(hp.ports_aChiHeaWat, mov.port_b) annotation (Line(points={{-548,-260},
          {-548,-212},{-508,-212},{-508,-198}}, color={0,127,255}));
  connect(valIso.port_bHeaWat, junHeaWatBypSup1.port_3) annotation (Line(points={{-678,
          -133},{-678,-206},{-676,-206},{-676,-560},{-168,-560},{-168,-538}},
                                                                      color={0,127,
          255}));
  connect(junHeaWatBypSup.port_3, junHeaWatBypRet.port_3)
    annotation (Line(points={{-72,-518},{-72,-578}}, color={0,127,255}));
  connect(junHeaWatBypSup2.port_2, valIso.port_aHeaWat) annotation (Line(points={{-178,
          -588},{-690,-588},{-690,-117.571},{-678,-117.571}},       color={0,127,
          255}));
  connect(junChiWatBypSup.port_3, junChiWatBypRet.port_3)
    annotation (Line(points={{-72,-168},{-72,-196}}, color={0,127,255}));
  connect(valIso.port_bChiWat, junChiWatBypSup1.port_1) annotation (Line(points={{-420,
          -109.857},{-164,-109.857},{-164,-158},{-156,-158}},
                  color={0,127,255}));
  connect(junChiWatBypRet1.port_2, valIso.port_aChiWat) annotation (Line(points={{-156,
          -206},{-168,-206},{-168,-125.286},{-420,-125.286}},
                      color={0,127,255}));
  connect(junChiWatBypRet.port_1, pipChiWat.port_b) annotation (Line(points={{-62,
          -206},{36,-206}},                                              color={
          0,127,255}));
  connect(junHeaWatBypRet.port_1, pipHeaWat.port_b) annotation (Line(points={{-62,
          -588},{0,-588}},                                           color={0,127,
          255}));
  connect(ctl.y1HeaHp[1:2], busHp.y1Hea) annotation (Line(points={{-338,38},{-324,
          38},{-324,136},{-504,136},{-504,104},{-502,104}}, color={255,127,0}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1Hp[1:2], busHp.y1) annotation (Line(points={{-338,40},{-328,40},
          {-328,104},{-502,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.TSupSet[1:2], busHp.TSet) annotation (Line(points={{-338,-12},{-306,
          -12},{-306,140},{-536,140},{-536,104},{-502,104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busHp.y1_actual, ctl.u1Hp_actual[1:2]) annotation (Line(
      points={{-502,104},{-396,104},{-396,36.2},{-382,36.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(busHp, bus.hp) annotation (Line(
      points={{-502,104},{-544,104},{-544,-16},{-520,-16},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus, hp.bus) annotation (Line(
      points={{-520,-46},{-520,-208},{-598,-208},{-598,-260}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus, valIso.bus) annotation (Line(
      points={{-520,-46},{-520,-76},{-549,-76},{-549,-117.571}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(busValHeaWatHpInlIso, bus.valHeaWatHpInlIso) annotation (Line(
      points={{-506,64},{-508,64},{-508,-16},{-488,-16},{-488,-48},{-520,-48},{-520,
          -46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValHeaWatHpOutIso, bus.valHeaWatHpOutIso) annotation (Line(
      points={{-502,28},{-556,28},{-556,-48},{-520,-48},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiWatHpInlIso, bus.valChiWatHpInlIso) annotation (Line(
      points={{-464,-26},{-464,-28},{-520,-28},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiWatHpOutIso, bus.valChiWatHpOutIso) annotation (Line(
      points={{-464,-66},{-464,-48},{-520,-48},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.y1ValHeaWatHpInlIso[1:2], busValHeaWatHpInlIso[:].y1) annotation (Line(
        points={{-338,34},{-328,34},{-328,-48},{-424,-48},{-424,64},{-506,64}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValHeaWatHpOutIso[1:2], busValHeaWatHpOutIso[:].y1) annotation (Line(
        points={{-338,32},{-324,32},{-324,-52},{-428,-52},{-428,28},{-502,28}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValChiWatHpOutIso[1:2], busValChiWatHpOutIso[:].y1) annotation (Line(
        points={{-338,28},{-316,28},{-316,-64},{-432,-64},{-432,-68},{-464,-68},
          {-464,-66}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValChiWatHpInlIso[1:2], busValChiWatHpInlIso[:].y1) annotation (Line(
        points={{-338,30},{-312,30},{-312,-48},{-320,-48},{-320,-56},{-432,-56},
          {-432,-28},{-464,-28},{-464,-26}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(mov.y_actual, greThr3.u) annotation (Line(points={{-501,-199},{-501,-200},
          {-490,-200},{-490,-218}},
                        color={0,0,127}));
  connect(greThr3[:].y, ctl.u1PumHeaWatPri_actual[1:2]) annotation (Line(points={{-490,
          -242},{-490,-252},{-440,-252},{-440,34.2},{-382,34.2}},
                                                color={255,0,255}));
  connect(greThr3[:].y, ctl.u1PumChiWatPri_actual[1:2]) annotation (Line(points={{-490,
          -242},{-490,-252},{-440,-252},{-440,32.2},{-382,32.2}},
                                                color={255,0,255}));
  connect(booToRea6.y, mov.y) annotation (Line(points={{-400,-192},{-400,-200},{
          -488,-200},{-488,-188},{-496,-188}}, color={0,0,127}));
  connect(or2.y, booToRea6.u)
    annotation (Line(points={{-400,-162},{-400,-168}}, color={255,0,255}));
  connect(ctl.y1PumHeaWatPri[1:2], or2.u1) annotation (Line(points={{-338,24},{-320,
          24},{-320,-136},{-400,-136},{-400,-138}}, color={255,0,255}));
  connect(ctl.y1PumChiWatPri[1:2], or2.u2) annotation (Line(points={{-338,22},{-328,
          22},{-328,-132},{-408,-132},{-408,-138}}, color={255,0,255}));
  connect(junChiWatBypSup1.port_2, senTem2.port_a)
    annotation (Line(points={{-136,-158},{-132,-158}},
                                                     color={0,127,255}));
  connect(senTem2.port_b, senVolFlo.port_a)
    annotation (Line(points={{-112,-158},{-106,-158}},
                                                     color={0,127,255}));
  connect(senVolFlo.port_b, junChiWatBypSup.port_1)
    annotation (Line(points={{-86,-158},{-82,-158}},
                                                   color={0,127,255}));
  connect(senVolFlo1.port_a, junChiWatBypRet.port_2)
    annotation (Line(points={{-88,-206},{-82,-206}}, color={0,127,255}));
  connect(junChiWatBypRet1.port_1, senTem3.port_b)
    annotation (Line(points={{-136,-206},{-132,-206}}, color={0,127,255}));
  connect(senTem3.port_a, senVolFlo1.port_b)
    annotation (Line(points={{-112,-206},{-108,-206}}, color={0,127,255}));
  connect(junHeaWatBypSup1.port_2, senTem4.port_a)
    annotation (Line(points={{-158,-528},{-150,-528}}, color={0,127,255}));
  connect(senTem4.port_b, senVolFlo2.port_a)
    annotation (Line(points={{-130,-528},{-120,-528}}, color={0,127,255}));
  connect(senVolFlo2.port_b, junHeaWatBypSup.port_1) annotation (Line(points={{-100,
          -528},{-96,-528},{-96,-508},{-82,-508}}, color={0,127,255}));
  connect(junHeaWatBypRet.port_2, senVolFlo3.port_a)
    annotation (Line(points={{-82,-588},{-90,-588}}, color={0,127,255}));
  connect(senVolFlo3.port_b, senTem5.port_a)
    annotation (Line(points={{-110,-588},{-124,-588}}, color={0,127,255}));
  connect(senTem5.port_b, junHeaWatBypSup2.port_1)
    annotation (Line(points={{-144,-588},{-158,-588}}, color={0,127,255}));
  connect(weaBus.TDryBul, ctl.TOut) annotation (Line(
      points={{-400.815,175.175},{-410,175.175},{-410,12},{-382,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen, busSen2) annotation (Line(
      points={{62,-300},{64,-300},{64,-270},{-540,-270},{-540,0},{-522,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetPri, ctl.THeaWatPriRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,8},{-382,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen2.TChiWatSupPri, ctl.TChiWatPriSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,4},{-382,4}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatSupPri, ctl.THeaWatPriSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,10},{-382,10}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VHeaWatPri_flow, ctl.VHeaWatPri_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,6},{-382,6}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetPri, ctl.TChiWatPriRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,2},{-382,2}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VChiWatPri_flow, ctl.VChiWatPri_flow) annotation (Line(
      points={{-522,0},{-382,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatSupSec, ctl.THeaWatSecSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,-2},{-382,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetSec, ctl.THeaWatSecRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,-4},{-382,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VHeaWatSec_flow, ctl.VHeaWatSec_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,-8},{-382,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetSec, ctl.THeaWatRetUpsHrc) annotation (Line(
      points={{-522,0},{-452,0},{-452,-6},{-382,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatSupSec, ctl.TChiWatSecSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,-10},{-382,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetSec, ctl.TChiWatSecRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,-12},{-382,-12}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VChiWatSec_flow, ctl.VChiWatSec_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,-16},{-382,-16}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetSec, ctl.TChiWatRetUpsHrc) annotation (Line(
      points={{-522,0},{-452,0},{-452,-14},{-382,-14}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChiWatRem[1].p_rel, busSen.dpChiWatRem) annotation (Line(points={{21,-176},
          {21,-178},{12,-178},{12,-274},{32,-274},{32,-300},{62,-300}},
                                                color={0,0,127}));
  connect(dpHeaWatRem[1].p_rel, busSen.dpHeaWatRem) annotation (Line(points={{61,-530},
          {52,-530},{52,-340},{62,-340},{62,-300}},               color={0,0,127}));
  connect(busSen2.dpHeaWatRem, ctl.dpHeaWatRem[1]) annotation (Line(
      points={{-522,0},{-452,0},{-452,-18},{-382,-18}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.dpChiWatRem, ctl.dpChiWatRem[1]) annotation (Line(
      points={{-522,0},{-452,0},{-452,-24},{-382,-24}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.y1HRC_actual, ctl.u1Hp_actual[3]) annotation (Line(
      points={{-522,0},{-464,0},{-464,44},{-396,44},{-396,36.8667},{-382,
          36.8667}},
      color={255,204,51},
      thickness=0.5));

  connect(busSen2.y1HRC_actual, ctl.u1Hrc_actual) annotation (Line(
      points={{-522,0},{-464,0},{-464,44},{-396,44},{-396,36},{-392,36},{-392,26.2},
          {-382,26.2}},
      color={255,204,51},
      thickness=0.5));
  connect(senTem2.T, busSen.TChiWatSupPri) annotation (Line(points={{-122,-147},
          {-122,-138},{-134,-138},{-134,-260},{62,-260},{62,-300}},
                                                                 color={0,0,127}));
  connect(senTem3.T, busSen.TChiWatRetPri) annotation (Line(points={{-122,-195},
          {-122,-186},{-134,-186},{-134,-260},{62,-260},{62,-300}}, color={0,0,127}));
  connect(senVolFlo.V_flow, busSen.VChiWatPri_flow) annotation (Line(points={{-96,
          -147},{-96,-142},{-54,-142},{-54,-300},{62,-300}},
                                                          color={0,0,127}));
  connect(senTemCooSup.T, busSen.TChiWatSupSec) annotation (Line(points={{50,-149},
          {50,-140},{92,-140},{92,-300},{62,-300}},
                      color={0,0,127}));
  connect(senTem4.T, busSen.THeaWatSupPri) annotation (Line(points={{-140,-517},
          {-140,-330},{62,-330},{62,-300}},
                  color={0,0,127}));
  connect(senTem5.T, busSen.THeaWatRetPri) annotation (Line(points={{-134,-577},
          {-134,-566},{104,-566},{104,-300},{62,-300}},             color={0,0,127}));
  connect(senVolFlo2.V_flow, busSen.VHeaWatPri_flow) annotation (Line(points={{-110,
          -517},{-110,-346},{96,-346},{96,-300},{62,-300}},
        color={0,0,127}));
  connect(senTemHeaSup.T, busSen.THeaWatSupSec) annotation (Line(points={{140,-499},
          {110,-499},{110,-300},{62,-300}}, color={0,0,127}));
  connect(bou.ports, mov.port_a) annotation (Line(points={{-550,-182},{-528,
          -182},{-528,-172},{-508,-172},{-508,-178}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_b, pipChiWat.port_b) annotation (Line(points={{30,-186},
          {30,-206},{36,-206}},
        color={0,127,255}));
  connect(dpHeaWatRem[1].port_b, pipHeaWat.port_b) annotation (Line(points={{70,
          -540},{70,-572},{-8,-572},{-8,-588},{0,-588}}, color={0,127,255}));
  connect(ctl.y1PumHeaWatSec, pre.u) annotation (Line(points={{-338,18},{-308,
          18},{-308,-100},{-346,-100}},
                                    color={255,0,255}));
  connect(pre.y, ctl.u1PumHeaWatSec_actual) annotation (Line(points={{-370,-100},
          {-388,-100},{-388,30.2},{-382,30.2}},
                                              color={255,0,255}));
  connect(pre1.y, ctl.u1PumChiWatSec_actual) annotation (Line(points={{-370,-76},
          {-392,-76},{-392,28.2},{-382,28.2}},    color={255,0,255}));
  connect(ctl.y1PumChiWatSec, pre1.u) annotation (Line(points={{-338,16},{-326,
          16},{-326,-76},{-346,-76}},    color={255,0,255}));

  connect(junHeaWatBypSup.port_2, inlPumHeaWatSec.port_a) annotation (Line(
        points={{-62,-508},{-60,-506},{-30,-506}}, color={0,127,255}));
  connect(outPumHeaWatSec.port_b, senTemHeaSup.port_a) annotation (Line(points={
          {44,-506},{44,-508},{124,-508},{124,-510},{130,-510}}, color={0,127,255}));
  connect(outPumHeaWatSec.port_b, dpHeaWatRem[1].port_a) annotation (Line(
        points={{44,-506},{44,-508},{70,-508},{70,-520}}, color={0,127,255}));
  connect(inlPumHeaWatSec.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{-10,-506},{-2,-506}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{18,-506},{24,-506}}, color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{-30,-160},{-22,-160}},
                                                 color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{-2,-160},{4,-160}},
                                              color={0,127,255}));
  connect(junChiWatBypSup.port_2, inlPumChiWatSec.port_a) annotation (Line(
        points={{-62,-158},{-56,-158},{-56,-160},{-50,-160}},
                                                        color={0,127,255}));
  connect(outPumChiWatSec.port_b, senTemCooSup.port_a) annotation (Line(points={{24,-160},
          {40,-160}},                                           color={0,127,255}));
  connect(dpChiWatRem[1].port_a, senTemCooSup.port_a) annotation (Line(points={{30,-166},
          {30,-160},{40,-160}},
        color={0,127,255}));
  connect(junHeaWatBypSup2.port_3, fourPipeASHP_with_controls.port_a2)
    annotation (Line(points={{-168,-578},{-168,-564},{-272,-564},{-272,-396},{-280,
          -396}}, color={0,127,255}));
  connect(junHeaWatBypSup1.port_1, fourPipeASHP_with_controls.port_b2)
    annotation (Line(points={{-178,-528},{-268,-528},{-268,-372},{-312,-372},{-312,
          -396},{-300,-396}}, color={0,127,255}));
  connect(junChiWatBypSup1.port_3, fourPipeASHP_with_controls.port_b1)
    annotation (Line(points={{-146,-168},{-172,-168},{-172,-384},{-280,-384}},
                              color={0,127,255}));
  connect(junChiWatBypRet1.port_3, fourPipeASHP_with_controls.port_a1)
    annotation (Line(points={{-146,-216},{-320,-216},{-320,-384},{-300,-384}},
                  color={0,127,255}));
  connect(busPumSecChiWat, pumChiWatSec.bus) annotation (Line(
      points={{-300,180},{-300,40},{-12,40},{-12,-150}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPumSecHeaWat, pumHeaWatSec.bus) annotation (Line(
      points={{-240,180},{-240,-388},{8,-388},{8,-496}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.TSupSet[3], fourPipeASHP_with_controls.TSupSet) annotation (Line(
        points={{-338,-11.3333},{-302,-11.3333},{-302,-380}}, color={0,0,127}));
  connect(ctl.yMod[3], fourPipeASHP_with_controls.uPlaOpeMod) annotation (Line(
        points={{-338,36.6667},{-304,36.6667},{-304,-386},{-302,-386}}, color={255,
          127,0}));
  connect(ctl.y1Hp[3], fourPipeASHP_with_controls.uHeaPumEna) annotation (Line(
        points={{-338,40.6667},{-324,40.6667},{-324,40},{-310,40},{-310,-390},{
          -302,-390}},
                  color={255,0,255}));
  connect(ctl.y1PumHeaWatPri[3], fourPipeASHP_with_controls.uPumConEna)
    annotation (Line(points={{-338,24},{-320,24},{-320,-136},{-328,-136},{-328,-394},
          {-302,-394}}, color={255,0,255}));
  connect(ctl.y1PumChiWatPri[3], fourPipeASHP_with_controls.uPumEvaEna)
    annotation (Line(points={{-338,22},{-328,22},{-328,-132},{-332,-132},{-332,-400},
          {-302,-400}}, color={255,0,255}));
  connect(fourPipeASHP_with_controls.yPumEvaEnaPro, ctl.u1PumChiWatPri_actual[3])
    annotation (Line(points={{-278,-390},{-330,-390},{-330,32.2},{-382,32.2}},
        color={255,0,255}));
  connect(fourPipeASHP_with_controls.yHPEnaPro, ctl.u1Hp_actual[3]) annotation
    (Line(points={{-278,-394},{-272,-394},{-272,36},{-304,36},{-304,44},{-320,
          44},{-320,108},{-396,108},{-396,36.8667},{-382,36.8667}},
                                                                color={255,0,255}));
  connect(fourPipeASHP_with_controls.yPumConEnaPro, ctl.u1PumHeaWatPri_actual[3])
    annotation (Line(points={{-278,-386},{-264,-386},{-264,52},{-316,52},{-316,112},
          {-400,112},{-400,48},{-392,48},{-392,34.2},{-382,34.2}}, color={255,0,
          255}));
  connect(senTemCooSup.port_b, port_b1) annotation (Line(points={{60,-160},{84,
          -160},{84,60},{100,60}},     color={0,127,255}));
  connect(ctl.y1PumChiWatSec, busPumSecChiWat.y1) annotation (Line(points={{-338,
          16},{-328,16},{-328,-76},{-324,-76},{-324,-104},{-268,-104},{-268,60},
          {-304,60},{-304,148},{-332,148},{-332,180},{-300,180}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.yPumChiWatSec, busPumSecChiWat.y) annotation (Line(points={{-338,2},
          {-292,2},{-292,148},{-300,148},{-300,180}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.y1PumHeaWatSec, busPumSecHeaWat.y1) annotation (Line(points={{-338,
          18},{-276,18},{-276,68},{-204,68},{-204,180},{-240,180}}, color={255,0,
          255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.yPumHeaWatSec, busPumSecHeaWat.y) annotation (Line(points={{-338,
          4},{-300,4},{-300,24},{-280,24},{-280,148},{-240,148},{-240,180}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTemHeaSup.port_b, port_b2) annotation (Line(points={{150,-510},{
          160,-510},{160,-120},{80,-120},{80,-68},{-80,-68},{-80,-60},{-100,-60}},
        color={0,127,255}));
  connect(mChiWat_flow.port_a, senTemCooRet.port_b)
    annotation (Line(points={{86,-206},{100,-206}}, color={0,127,255}));
  connect(senTemCooRet.port_a, port_a1) annotation (Line(points={{120,-206},{
          128,-206},{128,84},{-100,84},{-100,60}}, color={0,127,255}));
  connect(senTemCooRet.T, busSen.TChiWatRetSec) annotation (Line(points={{110,
          -217},{110,-268},{62,-268},{62,-300}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(mHeaWat_flow.port_a, senTemHeaRet.port_b)
    annotation (Line(points={{124,-588},{134,-588}}, color={0,127,255}));
  connect(senTemHeaRet.port_a, port_a2) annotation (Line(points={{154,-588},{
          164,-588},{164,-60},{100,-60}}, color={0,127,255}));
  connect(senTemHeaRet.T, busSen.THeaWatRetSec) annotation (Line(points={{144,
          -599},{144,-608},{80,-608},{80,-548},{88,-548},{88,-332},{62,-332},{
          62,-300}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(mChiWat_flow.V_flow, busSen.VChiWatSec_flow) annotation (Line(points=
          {{76,-217},{76,-264},{60,-264},{60,-272},{62,-272},{62,-300}}, color=
          {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mHeaWat_flow.V_flow, busSen.VHeaWatSec_flow) annotation (Line(points=
          {{114,-599},{114,-612},{84,-612},{84,-572},{108,-572},{108,-296},{92,
          -296},{92,-300},{62,-300}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(nReqPlaHeaWat, ctl.nReqPlaHeaWat) annotation (Line(points={{-720,60},
          {-548,60},{-548,140},{-540,140},{-540,144},{-452,144},{-452,20},{-382,
          20}}, color={255,127,0}));
  connect(nReqPlaChiWat, ctl.nReqPlaChiWat) annotation (Line(points={{-720,20},
          {-550,20},{-550,18},{-382,18}}, color={255,127,0}));
  connect(nReqResHeaWat, ctl.nReqResHeaWat) annotation (Line(points={{-720,-20},
          {-549,-20},{-549,16},{-382,16}}, color={255,127,0}));
  connect(nReqResChiWat, ctl.nReqResChiWat) annotation (Line(points={{-720,-60},
          {-552,-60},{-552,14},{-382,14}}, color={255,127,0}));
  connect(weaBus, hp.busWea) annotation (Line(
      points={{-401,175},{-556,175},{-556,32},{-564,32},{-564,-88},{-692,-88},{
          -692,-112},{-696,-112},{-696,-176},{-618,-176},{-618,-260}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, fourPipeASHP_with_controls.weaBus) annotation (Line(
      points={{-401,175},{-556,175},{-556,32},{-564,32},{-564,-88},{-692,-88},{
          -692,-112},{-696,-112},{-696,-176},{-620,-176},{-620,-248},{-508,-248},
          {-508,-212},{-336,-212},{-336,-399.7},{-328.7,-399.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StartTime=15638400,
      StopTime=16156800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
Buildings.Templates.Plants.HeatPumps.AirToWater</a>
by simulating a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
Three equally sized heat pumps are modeled, which can all be lead/lag alternated.
A heat recovery chiller is included (<code>pla.have_hrc_select=true</code>) 
and connected to the HW and CHW return pipes (sidestream integration).
A unique aggregated load is modeled on each loop by means of a cooling or heating
component controlled to maintain a constant <i>&Delta;T</i>
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
The user can toggle the top-level parameter <code>have_chiWat</code>
to switch between a cooling and heating system (the default setting)
to a heating-only system.
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging and controlling the secondary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<h4>Details</h4>
<p>
By default, all valves within the plant are modeled considering a linear
variation of the pressure drop with the flow rate (<code>pla.linearized=true</code>),
as opposed to the quadratic relationship usually considered for
a turbulent flow regime.
By limiting the size of the system of nonlinear equations, this setting
reduces the risk of solver failure and the time to solution for testing
various plant configurations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added sidestream HRC and refactored the model after updating the HP plant template.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-700,-640},{200,220}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HHW_CHW_plant;
