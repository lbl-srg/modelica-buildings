within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers;
block Controller_

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Real aveTimRan(
    final unit="s",
    final quantity="Time")=5
    "Time horizon over which the outdoor air flow measurment is averaged";

  // Limits
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum supply fan speed"
    annotation (Dialog(tab="Limits", enable=have_separateAFMS or have_separateDP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController minOAConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of minimum outdoor air controller"
    annotation (Dialog(tab="Limits", group="With AFMS",
      enable=have_separateAFMS or have_common));
  parameter Real kMinOA(
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Limits", group="With AFMS",
      enable=have_separateAFMS or have_common));
  parameter Real TiMinOA(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Limits", group="With AFMS",
      enable=(have_separateAFMS or have_common)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdMinOA(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Limits", group="With AFMS",
      enable=(have_separateAFMS or have_common)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dpDesOutDam_min(
    final unit="Pa",
    final quantity="PressureDifference")
    "Design pressure difference across the minimum outdoor air damper"
    annotation (Dialog(tab="Limits", group="With DP",
      enable=have_separateDP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of differential pressure setpoint controller"
    annotation (Dialog(tab="Limits", group="With DP",
      enable=have_separateDP));
  parameter Real kDp(
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Limits", group="With DP",
      enable=have_separateDP));
  parameter Real TiDp(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Limits", group="With DP",
      enable=(have_separateAFMS or have_common)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDp(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Limits", group="With DP",
      enable=(have_separateAFMS or have_common)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real uMinRetDam(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (Dialog(tab="Limits", group="Common",
      enable=have_common));

  // Enable
  parameter Boolean use_enthalpy=true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature"
    annotation (Dialog(tab="Enable"));
  parameter Real delTOutHis(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Enable", group="Hysteresis"));
  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Dialog(tab="Enable", group="Hysteresis"));
  parameter Real retDamFulOpeTim(
    final unit="s",
    final quantity="Time")=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Enable", group="Delays"));
  parameter Real disDel(
    final unit="s",
    final quantity="Time")=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Enable", group="Delays"));

  // Modulation
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=300
    "Sample period of component, used to limit the rate of change of the dampers (to avoid quick opening that can result in frost)"
    annotation (Dialog(tab="Modulation"));

  // Freeze protection
  parameter Real TFreSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")= 279.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Freeze protection", enable=use_TMix));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freProCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Freeze protection", enable=use_TMix));
  parameter Real kFre(
    final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Freeze protection", enable=use_TMix));
  parameter Real TiFre(
    final unit="s",
    final quantity="Time",
    final max=TiMinOut)=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
    annotation(Dialog(tab="Freeze protection",
      enable=use_TMix
        and (freProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or freProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for freeze protection"
    annotation (Dialog(tab="Freeze protection",
      enable=use_TMix and
          (freProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or freProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  // Commissioning
  parameter Real retDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Limits"));
  parameter Real retDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Limits"));
  parameter Real outDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Limits"));
  parameter Real outDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Limits"));
  parameter Real minOutDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Limits",
      enable=have_separateAFMS));
  parameter Real minOutDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Limits",
      enable=have_separateAFMS));
  parameter Real uMin(
    final unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Dialog(tab="Commissioning", group="Modulation"));
  parameter Real uMax(
    final unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Dialog(tab="Commissioning", group="Modulation"));
  parameter Real uOutDamMax(
    final unit="1")=(uMin + uMax)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (Dialog(tab="Commissioning", group="Modulation",
      enable=have_reliefs));
  parameter Real uRetDamMin(
    final unit="1")=(uMin + uMax)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (Dialog(tab="Commissioning", group="Modulation",
      enable=have_reliefs));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-280,210},{-240,250}}),
        iconTransformation(extent={{-326,220},{-286,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow_normalized(
    final unit="1") if have_separateAFMS or have_common
    "Measured outdoor volumetric airflow rate, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-280,170},{-240,210}}),
        iconTransformation(extent={{-322,192},{-282,232}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final unit="1") if have_separateAFMS or have_separateDP
    "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-280,130},{-240,170}}),
        iconTransformation(extent={{-318,156},{-278,196}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final unit="1") if have_separateAFMS or have_separateDP
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
        iconTransformation(extent={{-310,138},{-270,178}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    final quantity="PressureDifference") if
       have_separateDP
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
        iconTransformation(extent={{-310,140},{-270,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(
    final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
        iconTransformation(extent={{-206,-46},{-166,-6}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
        iconTransformation(extent={{-162,-94},{-122,-54}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-280,-50},{-240,-10}}),
        iconTransformation(extent={{-270,-28},{-230,12}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}}),
        iconTransformation(extent={{-270,-58},{-230,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-270,-88},{-230,-48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-270,-108},{-230,-68}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-280,-190},{-240,-150}}),
        iconTransformation(extent={{-326,58},{-286,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}}),
        iconTransformation(extent={{-326,28},{-286,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-326,-12},{-286,28}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{260,-10},{300,30}}),
        iconTransformation(extent={{558,-122},{598,-82}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{260,-90},{300,-50}}),
        iconTransformation(extent={{558,-202},{598,-162}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.LimitsPa.SeparateWithAFMS sepAFMS(final
      minSpe=minSpe,
    minOAConTyp=minOAConTyp,
    kMinOA=kMinOA,
    TiMinOA=TiMinOA,
    TdMinOA=TdMinOA,
    retDamPhyPosMax=retDamPhyPosMax,
    retDamPhyPosMin=retDamPhyPosMin,
    outDamPhyPosMax=outDamPhyPosMax,
    outDamPhyPosMin=outDamPhyPosMin,
    minOutDamPhyPosMax=minOutDamPhyPosMax,
    minOutDamPhyPosMin=minOutDamPhyPosMin) if
       have_separateAFMS
    "Damper position limits for units with separated minimum outdoor air damper and airflow measurement"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.LimitsPa.SeparateWithDP sepDp(
    dpDesOutDam_min=dpDesOutDam_min,
    minSpe=minSpe,
    dpCon=dpConTyp,
    kDp=kDp,
    TiDp=TiDp,
    TdDp=TdDp,
    retDamPhyPosMax=retDamPhyPosMax,
    retDamPhyPosMin=retDamPhyPosMin,
    outDamPhyPosMax=outDamPhyPosMax,
    outDamPhyPosMin=outDamPhyPosMin) if
       have_separateDP
    "Damper position limits for units with separated minimum outdoor air damper and differential pressure measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.LimitsPa.Common damLim(
    final uRetDamMin=uMinRetDam,
    final controllerType=minOAConTyp,
    final k=kMinOA,
    final Ti=TiMinOA,
    final Td=TdMinOA,
    retDamPhyPosMax=retDamPhyPosMax,
    retDamPhyPosMin=retDamPhyPosMin,
    outDamPhyPosMax=outDamPhyPosMax,
    outDamPhyPosMin=outDamPhyPosMin) if
       have_common
    "Damper position limits for units with common damper"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis(
    use_enthalpy=use_enthalpy,
    delTOutHis=delTOutHis,
    delEntHis=delEntHis,
    retDamFulOpeTim=retDamFulOpeTim,
    disDel=disDel)
    "Enable or disable economizer"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan modRet(
    final have_direct_control=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
    uMin=uMin,
    uMax=uMax,
    samplePeriod=samplePeriod) if
       have_returns
    "Modulate economizer dampers position for buildings with return fan controlling pressure"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs modRel(
    uMin=uMin,
    uMax=uMax,
    uOutDamMax=uOutDamMax,
    uRetDamMin=uRetDamMin,
    samplePeriod=samplePeriod) if
       have_reliefs
    "Modulate economizer dampers position for buildings with relief damper or fan controlling pressure"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.FreezeProtectionMixedAir freProTMix(
    final controllerType=freProCon,
    final TFreSet=TFreSet,
    final k=kFre,
    final Ti=TiFre,
    final Td=TdFre) if use_TMix
    "Block that tracks TMix against a freeze protection setpoint"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));

protected
  parameter Boolean have_separateAFMS=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
    "True: have separate minimum outdoor damper with airflow measurement";
  parameter Boolean have_separateDP=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP
    "True: have separate minimum outdoor damper with differential pressure measurement";
  parameter Boolean have_common=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    "True: have common damper";
  parameter Boolean have_returns=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir or
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "True: have return fan to control building pressure";
  parameter Boolean have_reliefs=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper or
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "True: have relief damper or fan to control building pressure";
  Buildings.Controls.OBC.CDL.Continuous.Min outDamMaxFre
    "Maximum control signal for outdoor air damper due to freeze protection"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max retDamMinFre
    "Minimum position for return air damper due to freeze protection"
    annotation (Placement(transformation(extent={{220,0},{240,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noTMix(
    final k=0) if not use_TMix
    "Ignore max evaluation if there is no mixed air temperature sensor"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noTMix1(
    final k=1) if not use_TMix
    "Ignore min evaluation if there is no mixed air temperature sensor"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movAve(final delta=aveTimRan) if
                          have_separateAFMS or have_common
    "Moving average of outdoor air flow measurement, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}})));

equation
  connect(sepAFMS.VOutMinSet_flow_normalized, VOutMinSet_flow_normalized)
    annotation (Line(points={{-142,149},{-160,149},{-160,230},{-260,230}},
        color={0,0,127}));
  connect(sepAFMS.uOutDamPos, uOutDamPos) annotation (Line(points={{-142,134},{-172,
          134},{-172,150},{-260,150}},      color={0,0,127}));
  connect(sepAFMS.uSupFanSpe, uSupFanSpe) annotation (Line(points={{-142,131},{-178,
          131},{-178,120},{-260,120}},      color={0,0,127}));
  connect(sepDp.dpMinOutDam, dpMinOutDam) annotation (Line(points={{-142,89},{-202,
          89},{-202,80},{-260,80}},         color={0,0,127}));
  connect(VOutMinSet_flow_normalized, sepDp.VOutMinSet_flow_normalized)
    annotation (Line(points={{-260,230},{-160,230},{-160,86},{-142,86}},
        color={0,0,127}));
  connect(uOutDamPos, sepDp.uOutDamPos) annotation (Line(points={{-260,150},{-172,
          150},{-172,74},{-142,74}},        color={0,0,127}));
  connect(uSupFanSpe, sepDp.uSupFanSpe) annotation (Line(points={{-260,120},{-178,
          120},{-178,71},{-142,71}},        color={0,0,127}));
  connect(uSupFan, sepAFMS.uSupFan) annotation (Line(points={{-260,-170},{-196,-170},
          {-196,143},{-142,143}},      color={255,0,255}));
  connect(uSupFan, sepDp.uSupFan) annotation (Line(points={{-260,-170},{-196,-170},
          {-196,83},{-142,83}},   color={255,0,255}));
  connect(uSupFan, damLim.uSupFan) annotation (Line(points={{-260,-170},{-196,-170},
          {-196,20},{-142,20}},      color={255,0,255}));
  connect(uFreProSta, sepAFMS.uFreProSta) annotation (Line(points={{-260,-240},{
          -184,-240},{-184,140},{-142,140}},  color={255,127,0}));
  connect(uFreProSta, sepDp.uFreProSta) annotation (Line(points={{-260,-240},{-184,
          -240},{-184,80},{-142,80}},        color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta) annotation (Line(points={{-260,-240},{-184,
          -240},{-184,16},{-142,16}},      color={255,127,0}));
  connect(uOpeMod, sepAFMS.uOpeMod) annotation (Line(points={{-260,-200},{-190,-200},
          {-190,137},{-142,137}},       color={255,127,0}));
  connect(uOpeMod, sepDp.uOpeMod) annotation (Line(points={{-260,-200},{-190,-200},
          {-190,77},{-142,77}},         color={255,127,0}));
  connect(uOpeMod, damLim.uOpeMod) annotation (Line(points={{-260,-200},{-190,-200},
          {-190,12},{-142,12}},       color={255,127,0}));
  connect(VOutMinSet_flow_normalized, damLim.VOutMinSet_flow_normalized)
    annotation (Line(points={{-260,230},{-160,230},{-160,28},{-142,28}}, color=
          {0,0,127}));
  connect(TOut, enaDis.TOut) annotation (Line(points={{-260,-30},{-128,-30},{-128,
          -70},{18,-70}},
                       color={0,0,127}));
  connect(TOutCut, enaDis.TOutCut) annotation (Line(points={{-260,-60},{-134,-60},
          {-134,-72},{18,-72}},color={0,0,127}));
  connect(hOut, enaDis.hOut) annotation (Line(points={{-260,-100},{-134,-100},{-134,
          -74},{18,-74}},color={0,0,127}));
  connect(hOutCut, enaDis.hOutCut) annotation (Line(points={{-260,-130},{-128,-130},
          {-128,-76},{18,-76}},     color={0,0,127}));
  connect(uSupFan, enaDis.uSupFan) annotation (Line(points={{-260,-170},{-196,-170},
          {-196,-78},{18,-78}},     color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta) annotation (Line(points={{-260,-240},{-184,
          -240},{-184,-80},{18,-80}},       color={255,127,0}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-118,28},
          {-80,28},{-80,-84},{18,-84}},              color={0,0,127}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{-118,24},
          {-86,24},{-86,-82},{18,-82}},              color={0,0,127}));
  connect(damLim.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{-118,20},
          {-92,20},{-92,-90},{18,-90}},              color={0,0,127}));
  connect(damLim.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{-118,16},
          {-98,16},{-98,-88},{18,-88}},              color={0,0,127}));
  connect(damLim.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-118,12},{-104,12},{-104,-86},{18,-86}},  color={0,0,127}));
  connect(sepDp.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-118,88},
          {-40,88},{-40,-84},{18,-84}},               color={0,0,127}));
  connect(sepDp.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{-118,84},
          {-46,84},{-46,-82},{18,-82}},               color={0,0,127}));
  connect(sepDp.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{-118,80},
          {-52,80},{-52,-90},{18,-90}},               color={0,0,127}));
  connect(sepDp.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{-118,76},
          {-58,76},{-58,-88},{18,-88}},               color={0,0,127}));
  connect(sepDp.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-118,72},{-64,72},{-64,-86},{18,-86}},      color={0,0,127}));
  connect(sepAFMS.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-118,
          145},{0,145},{0,-84},{18,-84}},             color={0,0,127}));
  connect(sepAFMS.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{-118,
          143},{-6,143},{-6,-82},{18,-82}},           color={0,0,127}));
  connect(sepAFMS.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{-118,
          137},{-12,137},{-12,-90},{18,-90}},         color={0,0,127}));
  connect(sepAFMS.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{-118,
          135},{-18,135},{-18,-88},{18,-88}},         color={0,0,127}));
  connect(sepAFMS.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-118,131},{-24,131},{-24,-86},{18,-86}},  color={0,0,127}));
  connect(uTSup, modRet.uTSup) annotation (Line(points={{-260,40},{40,40},{40,86},
          {98,86}},           color={0,0,127}));
  connect(uTSup, modRel.uTSup) annotation (Line(points={{-260,40},{40,40},{40,20},
          {98,20}},         color={0,0,127}));
  connect(damLim.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points={{-118,28},
          {-80,28},{-80,11},{98,11}},             color={0,0,127}));
  connect(sepDp.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points={{-118,88},
          {-40,88},{-40,11},{98,11}},              color={0,0,127}));
  connect(sepAFMS.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points={{-118,
          145},{0,145},{0,11},{98,11}},            color={0,0,127}));
  connect(enaDis.yOutDamPosMax, modRel.uOutDamPosMax) annotation (Line(points={{42,-74},
          {60,-74},{60,15},{98,15}},       color={0,0,127}));
  connect(enaDis.yRetDamPosMax, modRel.uRetDamPosMax) annotation (Line(points={{42,-80},
          {66,-80},{66,29},{98,29}},         color={0,0,127}));
  connect(enaDis.yRetDamPosMin, modRel.uRetDamPosMin) annotation (Line(points={{42,-86},
          {72,-86},{72,25},{98,25}},           color={0,0,127}));
  connect(enaDis.yRetDamPosMax, modRet.uRetDamPosMax) annotation (Line(points={{42,-80},
          {66,-80},{66,80},{98,80}},           color={0,0,127}));
  connect(enaDis.yRetDamPosMin, modRet.uRetDamPosMin) annotation (Line(points={{42,-86},
          {72,-86},{72,74},{98,74}},             color={0,0,127}));
  connect(retDamMinFre.y,yRetDamPos)
    annotation (Line(points={{242,10},{280,10}}, color={0,0,127}));
  connect(outDamMaxFre.y,yOutDamPos)
    annotation (Line(points={{242,-70},{280,-70}}, color={0,0,127}));
  connect(outDamMaxFre.u2,noTMix1. y)
    annotation (Line(points={{218,-76},{190,-76},{190,-90},{182,-90}},
                                                   color={0,0,127}));
  connect(retDamMinFre.u1,noTMix. y)
    annotation (Line(points={{218,16},{200,16},{200,30},{182,30}},
                                                color={0,0,127}));
  connect(freProTMix.yFrePro,retDamMinFre. u1)
    annotation (Line(points={{182,-43},{200,-43},{200,16},{218,16}}, color={0,0,127}));
  connect(freProTMix.yFreProInv,outDamMaxFre. u2)
    annotation (Line(points={{182,-37},{190,-37},{190,-76},{218,-76}},
      color={0,0,127}));
  connect(TMix, freProTMix.TMix) annotation (Line(points={{-260,0},{20,0},{20,-40},
          {158,-40}},       color={0,0,127}));
  connect(modRet.yRetDamPos, retDamMinFre.u2) annotation (Line(points={{122,86},
          {146,86},{146,4},{218,4}},  color={0,0,127}));
  connect(modRel.yRetDamPos, retDamMinFre.u2) annotation (Line(points={{122,26},
          {146,26},{146,4},{218,4}}, color={0,0,127}));
  connect(modRet.yOutDamPos, outDamMaxFre.u1) annotation (Line(points={{122,74},
          {140,74},{140,-64},{218,-64}},
                                    color={0,0,127}));
  connect(modRel.yOutDamPos, outDamMaxFre.u1) annotation (Line(points={{122,14},
          {140,14},{140,-64},{218,-64}},
                                   color={0,0,127}));
  connect(VOut_flow_normalized, movAve.u)
    annotation (Line(points={{-260,190},{-222,190}}, color={0,0,127}));
  connect(movAve.y, sepAFMS.VOut_flow_normalized) annotation (Line(points={{-198,
          190},{-166,190},{-166,146},{-142,146}},      color={0,0,127}));
  connect(movAve.y, damLim.VOut_flow_normalized) annotation (Line(points={{-198,
          190},{-166,190},{-166,24},{-142,24}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-260},
            {260,260}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-240,-260},{260,260}}), graphics={
        Rectangle(
          extent={{156,50},{244,-130}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                  Text(
          extent={{176,-116},{254,-126}},
          lineColor={95,95,95},
          textString="Freeze protection based on TMix,
not a part of G36",
          horizontalAlignment=TextAlignment.Left),
        Line(points={{156,122}}, color={28,108,200})}));
end Controller_;
