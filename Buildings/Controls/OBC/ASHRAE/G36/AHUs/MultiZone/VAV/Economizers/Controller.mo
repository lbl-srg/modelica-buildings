within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers;
block Controller
  "Multi zone VAV AHU economizer control sequence"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection minOADes
    "Design of minimum outdoor air and economizer function";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon
    "Economizer high limit control device";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));

  // Limits
  parameter Real minSpe(unit="1")=0.1
    "Minimum supply fan speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController minOAConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of minimum outdoor air controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));
  parameter Real kMinOA(unit="1")=1
    "Gain of controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));
  parameter Real TiMinOA(unit="s")=0.5
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
           and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdMinOA(unit="s")=0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
           and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Types.VentilationStandard venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Ventilation standard, ASHRAE 62.1 or Title 24"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Boolean have_CO2Sen=false
    "True: some zones have CO2 sensor"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
           and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)));
  parameter Real dpAbsMinOutDam=5
    "Absolute minimum pressure difference across the minimum outdoor air damper. It provides the absolute minimum outdoor airflow"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=(venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
           and minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)));
  parameter Real dpDesMinOutDam(unit="Pa")=20
    "Design minimum pressure difference across the minimum outdoor air damper. It provides the design minimum outdoor airflow"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of differential pressure setpoint controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Real kDp(unit="1")=1
    "Gain of controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Real TiDp(unit="s")=0.5
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
           and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDp(unit="s")=0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="With DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
           and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real uRetDam_min(unit="1")=0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Limits", group="Common",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));

  // Enable
  parameter Real delTOutHis(
    unit="K",
    displayUnit="K")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Enable", group="Hysteresis"));
  parameter Real delEntHis(unit="J/kg")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Enable", group="Hysteresis",
                       enable=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                           or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb));
  parameter Real retDamFulOpeTim(unit="s")=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control at disable to avoid pressure fluctuations"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Enable", group="Delays"));
  parameter Real disDel(unit="s")=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Enable", group="Delays"));

  // Commissioning
  parameter Real retDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the return air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits"));
  parameter Real retDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the return air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits"));
  parameter Real outDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits"));
  parameter Real outDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits"));
  parameter Real minOutDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the minimum outdoor air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow));
  parameter Real minOutDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the minimum outdoor air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow));
  parameter Real uHeaMax(unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Modulation"));
  parameter Real uCooMin(unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Modulation"));
  parameter Real uOutDamMax(unit="1")=(uHeaMax + uCooMin)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Modulation",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real uRetDamMin(unit="1")=(uHeaMax + uCooMin)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Modulation",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-280,210},{-240,250}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow_normalized(
    final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
    "Measured outdoor volumetric airflow rate, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-280,170},{-240,210}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan(final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
    "Commanded supply fan speed"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput effAbsOutAir_normalized(
    final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)
    "Effective minimum outdoor airflow setpoint, normalized by the absolute outdoor airflow rate "
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCO2Loo_max(
    final unit="1")
    if (have_CO2Sen and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)
     and minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Maximum Zone CO2 control loop"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput effDesOutAir_normalized(
    final unit="1")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Effective minimum outdoor airflow setpoint, normalized by the design outdoor airflow rate "
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    final quantity="PressureDifference")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-280,-10},{-240,30}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(
    final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-280,-50},{-240,-10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirOut(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-280,-210},{-240,-170}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-280,-270},{-240,-230}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_min(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{260,220},{300,260}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaMinOut
    "True: enable minimum outdoor air control loop"
    annotation (Placement(transformation(extent={{260,180},{300,220}}),
        iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDam(
    final min=0,
    final max=1,
    final unit="1")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Minimum outdoor air flow damper commanded position"
    annotation (Placement(transformation(extent={{260,120},{300,160}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1MinOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{260,80},{300,120}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{260,50},{300,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
    "Relief air damper commanded position"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{260,-90},{300,-50}}),
        iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS
    sepAFMS(
    final minSpe=minSpe,
    final minOAConTyp=minOAConTyp,
    final kMinOA=kMinOA,
    final TiMinOA=TiMinOA,
    final TdMinOA=TdMinOA,
    final retDamPhy_max=retDamPhy_max,
    final retDamPhy_min=retDamPhy_min,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min,
    final minOutDamPhy_max=minOutDamPhy_max,
    final minOutDamPhy_min=minOutDamPhy_min)
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Damper position limits for units with separated minimum outdoor air damper and airflow measurement"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithDP
    sepDp(
    final venStd=venStd,
    final have_CO2Sen=have_CO2Sen,
    final dpAbsMinOutDam=dpAbsMinOutDam,
    final dpDesMinOutDam=dpDesMinOutDam,
    final minSpe=minSpe,
    final dpCon=dpConTyp,
    final kDp=kDp,
    final TiDp=TiDp,
    final TdDp=TdDp,
    final retDamPhy_max=retDamPhy_max,
    final retDamPhy_min=retDamPhy_min,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min)
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Damper position limits for units with separated minimum outdoor air damper and differential pressure measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common
    damLim(
    final uRetDam_min=uRetDam_min,
    final controllerType=minOAConTyp,
    final k=kMinOA,
    final Ti=TiMinOA,
    final Td=TdMinOA,
    final retDamPhy_max=retDamPhy_max,
    final retDamPhy_min=retDamPhy_min,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min)
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper
    "Damper position limits for units with common damper"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis(
    final use_enthalpy=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                       or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel) "Enable or disable economizer"
    annotation (Placement(transformation(extent={{20,-100},{40,-72}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan modRet(
    final have_dirCon=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
    final uMin=uHeaMax,
    final uMax=uCooMin)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Modulate economizer dampers position for buildings with return fan controlling pressure"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs modRel(
    final uMin=uHeaMax,
    final uMax=uCooMin,
    final uOutDamMax=uOutDamMax,
    final uRetDamMin=uRetDamMin)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief)
    "Modulate economizer dampers position for buildings with relief damper or fan controlling pressure"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim(
    final eneStd=eneStd,
    final ecoHigLimCon=ecoHigLimCon,
    final ashCliZon=ashCliZon,
    final tit24CliZon=tit24CliZon) "High limits"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
equation
  connect(sepAFMS.VOutMinSet_flow_normalized, VOutMinSet_flow_normalized)
    annotation (Line(points={{-142,149},{-160,149},{-160,230},{-260,230}},
        color={0,0,127}));
  connect(sepAFMS.uSupFan, uSupFan) annotation (Line(points={{-142,131},{-178,131},
          {-178,130},{-260,130}}, color={0,0,127}));
  connect(sepDp.dpMinOutDam, dpMinOutDam) annotation (Line(points={{-142,83},{-184,
          83},{-184,10},{-260,10}},         color={0,0,127}));
  connect(VOutMinSet_flow_normalized, sepDp.VOutMinSet_flow_normalized)
    annotation (Line(points={{-260,230},{-160,230},{-160,81},{-142,81}},
        color={0,0,127}));
  connect(uSupFan, sepDp.uSupFan) annotation (Line(points={{-260,130},{-178,130},
          {-178,71},{-142,71}}, color={0,0,127}));
  connect(u1SupFan, sepAFMS.u1SupFan) annotation (Line(points={{-260,-190},{-196,
          -190},{-196,143},{-142,143}}, color={255,0,255}));
  connect(u1SupFan, sepDp.u1SupFan) annotation (Line(points={{-260,-190},{-196,-190},
          {-196,78},{-142,78}}, color={255,0,255}));
  connect(u1SupFan, damLim.u1SupFan) annotation (Line(points={{-260,-190},{-196,
          -190},{-196,30},{-142,30}}, color={255,0,255}));
  connect(uOpeMod, sepAFMS.uOpeMod) annotation (Line(points={{-260,-220},{-190,-220},
          {-190,137},{-142,137}},       color={255,127,0}));
  connect(uOpeMod, sepDp.uOpeMod) annotation (Line(points={{-260,-220},{-190,-220},
          {-190,76},{-142,76}},         color={255,127,0}));
  connect(uOpeMod, damLim.uOpeMod) annotation (Line(points={{-260,-220},{-190,-220},
          {-190,22},{-142,22}},       color={255,127,0}));
  connect(VOutMinSet_flow_normalized, damLim.VOutMinSet_flow_normalized)
    annotation (Line(points={{-260,230},{-160,230},{-160,38},{-142,38}}, color=
          {0,0,127}));
  connect(u1SupFan, enaDis.u1SupFan) annotation (Line(points={{-260,-190},{-196,
          -190},{-196,-83},{18,-83}}, color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta) annotation (Line(points={{-260,-250},{
          -184,-250},{-184,-85},{18,-85}},  color={255,127,0}));
  connect(damLim.yOutDam_min, enaDis.uOutDam_min) annotation (Line(points={{-118,39},
          {-80,39},{-80,-90},{18,-90}},     color={0,0,127}));
  connect(damLim.yOutDam_max, enaDis.uOutDam_max) annotation (Line(points={{-118,36},
          {-86,36},{-86,-88},{18,-88}},     color={0,0,127}));
  connect(damLim.yRetDam_min, enaDis.uRetDam_min) annotation (Line(points={{-118,32},
          {-92,32},{-92,-99},{18,-99}},     color={0,0,127}));
  connect(damLim.yRetDam_max, enaDis.uRetDam_max) annotation (Line(points={{-118,29},
          {-98,29},{-98,-97},{18,-97}},     color={0,0,127}));
  connect(damLim.yRetDamPhy_max, enaDis.uRetDamPhy_max) annotation (Line(points={{-118,25},
          {-104,25},{-104,-95},{18,-95}},           color={0,0,127}));
  connect(sepDp.yOutDam_min, enaDis.uOutDam_min) annotation (Line(points={{-118,
          85},{-40,85},{-40,-90},{18,-90}}, color={0,0,127}));
  connect(sepDp.yOutDam_max, enaDis.uOutDam_max) annotation (Line(points={{-118,
          83},{-46,83},{-46,-88},{18,-88}}, color={0,0,127}));
  connect(sepDp.yRetDam_min, enaDis.uRetDam_min) annotation (Line(points={{-118,
          77},{-52,77},{-52,-99},{18,-99}}, color={0,0,127}));
  connect(sepDp.yRetDam_max, enaDis.uRetDam_max) annotation (Line(points={{-118,
          75},{-58,75},{-58,-97},{18,-97}}, color={0,0,127}));
  connect(sepDp.yRetDamPhy_max, enaDis.uRetDamPhy_max) annotation (Line(points={
          {-118,71},{-64,71},{-64,-95},{18,-95}}, color={0,0,127}));
  connect(sepAFMS.yOutDam_min, enaDis.uOutDam_min) annotation (Line(points={{-118,
          143},{0,143},{0,-90},{18,-90}}, color={0,0,127}));
  connect(sepAFMS.yOutDam_max, enaDis.uOutDam_max) annotation (Line(points={{-118,
          141},{-6,141},{-6,-88},{18,-88}}, color={0,0,127}));
  connect(sepAFMS.yRetDam_min, enaDis.uRetDam_min) annotation (Line(points={{-118,
          137},{-12,137},{-12,-99},{18,-99}}, color={0,0,127}));
  connect(sepAFMS.yRetDam_max, enaDis.uRetDam_max) annotation (Line(points={{-118,
          135},{-18,135},{-18,-97},{18,-97}}, color={0,0,127}));
  connect(sepAFMS.yRetDamPhy_max, enaDis.uRetDamPhy_max) annotation (Line(
        points={{-118,131},{-24,131},{-24,-95},{18,-95}}, color={0,0,127}));
  connect(uTSup, modRet.uTSup) annotation (Line(points={{-260,-30},{60,-30},{60,
          36},{98,36}}, color={0,0,127}));
  connect(uTSup, modRel.uTSup) annotation (Line(points={{-260,-30},{98,-30}},
                     color={0,0,127}));
  connect(damLim.yOutDam_min, modRel.uOutDam_min) annotation (Line(points={{-118,39},
          {-80,39},{-80,-39},{98,-39}},     color={0,0,127}));
  connect(sepDp.yOutDam_min, modRel.uOutDam_min) annotation (Line(points={{-118,
          85},{-40,85},{-40,-39},{98,-39}}, color={0,0,127}));
  connect(sepAFMS.yOutDam_min, modRel.uOutDam_min) annotation (Line(points={{-118,
          143},{0,143},{0,-39},{98,-39}}, color={0,0,127}));
  connect(enaDis.yOutDam_max, modRel.uOutDam_max) annotation (Line(points={{42,
          -76},{60,-76},{60,-35},{98,-35}}, color={0,0,127}));
  connect(enaDis.yRetDam_max, modRel.uRetDam_max) annotation (Line(points={{42,
          -86},{66,-86},{66,-21},{98,-21}}, color={0,0,127}));
  connect(enaDis.yRetDam_min, modRel.uRetDam_min) annotation (Line(points={{42,
          -96},{72,-96},{72,-25},{98,-25}}, color={0,0,127}));
  connect(enaDis.yRetDam_max, modRet.uRetDam_max) annotation (Line(points={{42,
          -86},{66,-86},{66,30},{98,30}}, color={0,0,127}));
  connect(enaDis.yRetDam_min, modRet.uRetDam_min) annotation (Line(points={{42,
          -96},{72,-96},{72,24},{98,24}}, color={0,0,127}));
  connect(modRet.yRetDam, yRetDam) annotation (Line(points={{122,36},{140,36},{140,
          70},{280,70}},        color={0,0,127}));
  connect(modRel.yRetDam, yRetDam) annotation (Line(points={{122,-24},{140,-24},
          {140,70},{280,70}},   color={0,0,127}));
  connect(modRet.yOutDam, yOutDam) annotation (Line(points={{122,24},{160,24},
          {160,-70},{280,-70}}, color={0,0,127}));
  connect(modRel.yOutDam, yOutDam) annotation (Line(points={{122,-36},{160,-36},
          {160,-70},{280,-70}}, color={0,0,127}));
  connect(modRet.yRelDam, yRelDam) annotation (Line(points={{122,30},{180,30},{180,
          0},{280,0}},        color={0,0,127}));
  connect(sepAFMS.yMinOutDam, yMinOutDam) annotation (Line(points={{-118,149},{100,
          149},{100,140},{280,140}},color={0,0,127}));
  connect(damLim.yOutDam_min, yOutDam_min) annotation (Line(points={{-118,39},{-80,
          39},{-80,240},{280,240}}, color={0,0,127}));
  connect(sepDp.yOutDam_min, yOutDam_min) annotation (Line(points={{-118,85},{-80,
          85},{-80,240},{280,240}}, color={0,0,127}));
  connect(sepAFMS.yOutDam_min, yOutDam_min) annotation (Line(points={{-118,143},
          {-80,143},{-80,240},{280,240}}, color={0,0,127}));
  connect(ecoHigLim.TCut, enaDis.TOutCut) annotation (Line(points={{-118,-44},{
          -30,-44},{-30,-75},{18,-75}}, color={0,0,127}));
  connect(ecoHigLim.hCut, enaDis.hOutCut) annotation (Line(points={{-118,-56},{
          -70,-56},{-70,-80},{18,-80}}, color={0,0,127}));
  connect(hAirRet, ecoHigLim.hRet) annotation (Line(points={{-260,-160},{-160,-160},
          {-160,-56},{-142,-56}}, color={0,0,127}));
  connect(TAirRet, ecoHigLim.TRet) annotation (Line(points={{-260,-100},{-202,-100},
          {-202,-44},{-142,-44}}, color={0,0,127}));
  connect(TOut, enaDis.TOut) annotation (Line(points={{-260,-70},{-180,-70},{-180,
          -73},{18,-73}}, color={0,0,127}));
  connect(hAirOut, enaDis.hOut) annotation (Line(points={{-260,-130},{6,-130},{
          6,-78},{18,-78}}, color={0,0,127}));
  connect(effAbsOutAir_normalized, sepDp.effAbsOutAir_normalized) annotation (
      Line(points={{-260,100},{-208,100},{-208,89},{-142,89}}, color={0,0,127}));
  connect(uCO2Loo_max, sepDp.uCO2Loo_max) annotation (Line(points={{-260,70},{-208,
          70},{-208,87},{-142,87}}, color={0,0,127}));
  connect(effDesOutAir_normalized, sepDp.effDesOutAir_normalized) annotation (
      Line(points={{-260,40},{-202,40},{-202,85},{-142,85}}, color={0,0,127}));
  connect(modRet.yOutDam, sepAFMS.uOutDam) annotation (Line(points={{122,24},
          {160,24},{160,160},{-172,160},{-172,134},{-142,134}}, color={0,0,127}));
  connect(modRet.yOutDam, sepDp.uOutDam) annotation (Line(points={{122,24},{160,
          24},{160,160},{-172,160},{-172,73},{-142,73}}, color={0,0,127}));
  connect(modRel.yOutDam, sepAFMS.uOutDam) annotation (Line(points={{122,-36},
          {160,-36},{160,160},{-172,160},{-172,134},{-142,134}}, color={0,0,127}));
  connect(modRel.yOutDam, sepDp.uOutDam) annotation (Line(points={{122,-36},{
          160,-36},{160,160},{-172,160},{-172,73},{-142,73}}, color={0,0,127}));
  connect(sepDp.y1MinOutDam, y1MinOutDam) annotation (Line(points={{-118,88},{40,
          88},{40,100},{280,100}},                    color={255,0,255}));
  connect(VOut_flow_normalized, sepAFMS.VOut_flow_normalized) annotation (Line(
        points={{-260,190},{-166,190},{-166,146},{-142,146}}, color={0,0,127}));
  connect(VOut_flow_normalized, damLim.VOut_flow_normalized) annotation (Line(
        points={{-260,190},{-166,190},{-166,34},{-142,34}}, color={0,0,127}));
  connect(sepAFMS.yEnaMinOut, yEnaMinOut) annotation (Line(points={{-118,147},{6,
          147},{6,200},{280,200}}, color={255,0,255}));
  connect(sepDp.y1MinOutDam, yEnaMinOut) annotation (Line(points={{-118,88},{40,
          88},{40,200},{280,200}}, color={255,0,255}));
  connect(damLim.yEnaMinOut, yEnaMinOut) annotation (Line(points={{-118,21},{6,21},
          {6,200},{280,200}}, color={255,0,255}));

annotation (defaultComponentName="ecoCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
    graphics={
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-200},{100,200}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,200},{6,180}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOutMinSet_flow_normalized"),
        Text(
          extent={{-96,178},{-12,164}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOut_flow_normalized",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
               or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)),
        Text(
          extent={{-96,128},{-56,112}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
               or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure),
          textString="uSupFan"),
        Text(
          extent={{-96,30},{-30,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpMinOutDam",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure),
        Text(
          extent={{-98,-2},{-66,-18}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTSup"),
        Text(
          extent={{-100,-34},{-72,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-100,-52},{-58,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
          textString="TAirRet"),
        Text(
          extent={{-100,-82},{-58,-98}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
               or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb),
          textString="hAirOut"),
        Text(
          extent={{-98,-104},{-62,-120}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=(eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
               and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
          textString="hAirRet"),
        Text(
          extent={{-98,-132},{-56,-146}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1SupFan"),
        Text(
          extent={{-98,-184},{-42,-198}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uFreProSta"),
        Text(
          extent={{-100,-162},{-50,-176}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{34,142},{98,124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
          textString="yMinOutDam"),
        Text(
          extent={{40,70},{96,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDam"),
        Text(
          extent={{42,-50},{98,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir,
          textString="yRelDam"),
        Text(
          extent={{42,-110},{98,-126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDam"),
        Text(
          extent={{34,200},{96,184}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDam_min"),
        Text(
          extent={{-96,100},{6,80}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="effAbsOutAir_normalized",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
               and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)),
        Text(
          extent={{-96,80},{6,60}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="effDesOutAir_normalized",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
               and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{-96,58},{-28,40}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=(have_CO2Sen and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)
               and minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure,
          textString="uCO2Loo_max"),
        Text(
          extent={{34,120},{98,102}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure,
          textString="y1MinOutDam"),
        Text(
          extent={{42,180},{96,162}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEnaMinOut")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-260},{260,260}}),
    graphics={
        Line(points={{156,122}}, color={28,108,200})}),
  Documentation(info="<html>
<p>
Multi zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, May 2020, Sections: 5.16.2.3,5.16.4, 5.16.5, 5.16.6, 5.16.7.
</p>
<p>
The sequence consists of three sets of subsequences.
</p>
<ul>
<li>
First set of sequences compute the damper position limits to satisfy
outdoor air requirements. Different sequence will be enabled depending on the
designes minimum outdoor air and economizer function, which include
<ol type=\"i\">
<li>
separate minimum outdoor air damper, with airflow measurement. 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS</a>
for a description.
</li>
<li>
separate minimum outdoor air damper, with differential pressure measurement. 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithDP\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithDP</a>
for a description.
</li>
<li>
single common minimum outdoor air and economizer damper. 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common</a>
for a description.
</li>
</ol>
</li>

<li>
The second set of sequences which have one sequence enable or disable the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable</a>
for a description.
</li>

<li>
Third set of sequences modulate the outdoor and return damper position
to track the supply air temperature setpoint, subject to the limits of the damper positions
that were computed in the above blocks. Different sequence will be enabled depending
on the types of building pressure control system, which include
<ol type=\"i\">
<li>
relief damper or relief fan control. 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs</a>
for a description.
</li>
<li>
return fan control with airflow tracking, or with direct building pressure control. 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan</a>
for a description.
</li>
</ol>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
Updated implementation according to ASHRAE G36 official release.
</li>
<li>
October 11, 2017, by Michael Wetter:<br/>
Corrected implementation to use control loop signal as input.
</li>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
