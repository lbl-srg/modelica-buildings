within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block FreezeProtection
  "Freeze protection sequence for multizone air handling unit"

  parameter Boolean have_frePro=true
    "True: enable freeze protection"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Type of building pressure control system"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=have_frePro));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Design of minimum outdoor air and economizer function"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=have_frePro));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=have_frePro));
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has heating coil"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=have_frePro));
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation(__cdl(ValueInReference=true),
                Dialog(enable=have_hotWatCoi and have_frePro));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating coil controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller", enable=have_hotWatCoi and have_frePro));
  parameter Real k(unit="1")=1
    "Gain of coil controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller", enable=have_hotWatCoi and have_frePro));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller",
                       enable=have_hotWatCoi and have_frePro and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller",
                       enable=have_hotWatCoi and have_frePro and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMax=1
    "Upper limit of output"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller", enable=have_hotWatCoi and have_frePro));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Heating coil controller", enable=have_hotWatCoi and have_frePro));
  parameter Real Thys(unit="K")=0.25
    "Hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", enable=have_frePro));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1") if have_frePro
    "Minimum economizer damper position limit as returned by the damper position limits sequence"
    annotation (Placement(transformation(extent={{-480,740},{-440,780}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,700},{-440,740}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil commanded position"
    annotation (Placement(transformation(extent={{-480,620},{-440,660}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinOutDam(
    final min=0,
    final max=1,
    final unit="1")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,540},{-440,580}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1MinOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{-480,500},{-440,540}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer return air damper commanded position"
    annotation (Placement(transformation(extent={{-480,370},{-440,410}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_frePro
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,310},{-440,350}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta if freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS and
    have_frePro
    "Freeze protection stat signal. The stat is normally close (the input is normally true), when enabling freeze protection, the input becomes false"
    annotation (Placement(transformation(extent={{-480,110},{-440,150}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes if (freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat or freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,0},{-440,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{-480,-200},{-440,-160}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-248},{-440,-208}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{-480,-340},{-440,-300}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-388},{-440,-348}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan if buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{-480,-480},{-440,-440}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-528},{-440,-488}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil commanded position"
    annotation (Placement(transformation(extent={{-480,-608},{-440,-568}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi and
    have_frePro
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-716},{-440,-676}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage index"
    annotation (Placement(transformation(extent={{440,300},{480,340}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
 if have_frePro
    "Commanded on to energize chilled water pump"
    annotation (Placement(transformation(extent={{440,240},{480,280}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{440,140},{480,180}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,60},{480,100}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDam(
    final min=0,
    final max=1,
    final unit="1")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,-20},{480,20}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1MinOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{440,-90},{480,-50}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{440,-160},{480,-120}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{440,-240},{480,-200}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{440,-300},{480,-260}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{440,-380},{480,-340}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{440,-440},{480,-400}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{440,-520},{480,-480}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil commanded position"
    annotation (Placement(transformation(extent={{440,-600},{480,-560}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil commanded position"
    annotation (Placement(transformation(extent={{440,-720},{480,-680}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-800},{480,-760}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{440,-860},{480,-820}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4.4,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,810},{-340,830}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,810},{-280,830}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq
    if have_hotWatCoi and have_frePro
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,802},{80,822}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_hotWatCoi and have_frePro
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,830},{0,850}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen if have_frePro
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,730},{80,750}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi and have_frePro
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,680},{-300,700}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1
    if have_hotWatCoi and have_frePro
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,660},{140,680}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys) if have_frePro
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,600},{-360,620}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat if have_frePro
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,802},{-40,822}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,600},{-300,620}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne if have_frePro
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,592},{-240,612}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3.3,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,460},{-360,480}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,460},{-320,480}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0) if have_frePro
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,452},{-280,472}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2 if have_frePro
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,590},{140,610}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) if have_frePro
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,610},{60,630}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam2 if minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     and have_frePro
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{120,540},{140,560}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2 if have_frePro
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,408},{140,428}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1) if have_frePro
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-140,310},{-120,330}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_frePro
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,310},{140,330}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3) if have_frePro
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,340},{60,360}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_hotWatCoi and have_frePro
    "Zero request"
    annotation (Placement(transformation(extent={{-20,780},{0,800}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,240},{-280,260}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,200},{-340,220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,200},{-280,220}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 if have_frePro
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-220,192},{-200,212}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "Constant false"
    annotation (Placement(transformation(extent={{-300,50},{-280,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_frePro
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan if (not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-370},{140,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-510},{140,-490}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0) if have_frePro
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,48},{-120,68}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,70},{340,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-590},{140,-570}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3 if have_hotWatCoi
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-790},{340,-770}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_hotWatCoi and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-782},{-120,-762}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    if have_hotWatCoi and have_frePro
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-700},{-280,-680}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi and have_frePro
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-670},{60,-650}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_hotWatCoi and have_frePro
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-670},{-120,-650}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_hotWatCoi and (
    not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-710},{340,-690}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-850},{340,-830}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) if have_frePro
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-842},{-120,-822}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    if have_frePro
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,210},{400,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_frePro
    "Logical not"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    if have_frePro
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,452},{400,472}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_frePro
    "Logical not"
    annotation (Placement(transformation(extent={{120,452},{140,472}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600) if have_frePro
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,420},{-240,440}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam if minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{320,-10},{340,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0) if have_frePro
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,278},{60,298}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if have_frePro
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,452},{-160,472}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo if have_frePro
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,412},{-200,432}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if have_frePro
    "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-160,802},{-140,822}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,150},{340,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_hotWatCoi and have_frePro
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,680},{-360,700}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{380,310},{400,330}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{320,570},{340,590}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2) if have_frePro
    "Stage 2 freeze protection"
    annotation (Placement(transformation(extent={{160,620},{180,640}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{260,760},{280,780}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1) if have_frePro
    "Stage 1 freeze protection"
    annotation (Placement(transformation(extent={{140,830},{160,850}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=0) if have_frePro
    "Stage 0 freeze protection"
    annotation (Placement(transformation(extent={{140,730},{160,750}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam3 if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and have_frePro
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{120,510},{140,530}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=false) if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and have_frePro
    "False"
    annotation (Placement(transformation(extent={{-40,530},{-20,550}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam1 if (minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{320,-80},{340,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not norFal if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "The output is normally false"
    annotation (Placement(transformation(extent={{-360,120},{-340,140}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "Reset the freeze protection by the physical reset switch in freeze stat"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Disable return fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-290},{340,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta3 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and have_frePro
    "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-310},{180,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta1 if have_frePro
    "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-170},{180,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 if (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Disable supply fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-150},{340,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta2 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and have_frePro
    "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-450},{180,-430}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Disable relief fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-430},{340,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1) if (have_hotWatCoi and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,-650},{340,-630}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=1) if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-620},{140,-600}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=1) if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-540},{140,-520}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-470},{340,-450}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(
    final k=1) if ((buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-400},{140,-380}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-330},{340,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(
    final k=1) if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,120},{340,140}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai5(
    final k=1) if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,40},{340,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai6(
    final k=1) if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,-40},{340,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5 if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
     and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-110},{340,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6 if (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     or (not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-190},{340,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai7(
    final k=1) if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-260},{140,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai8(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(final k=0)
    if not have_frePro "Dummy constant"
    annotation (Placement(transformation(extent={{380,360},{400,380}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai9(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai10(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai11(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-260,-280},{-240,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai12(final k=1)
    if (not have_frePro) and (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-260,-420},{-240,-400}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai13(final k=1)
    if (not have_frePro) and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-260,-560},{-240,-540}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai14(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-260,-640},{-240,-620}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai15(final k=1)
    if (not have_frePro) and have_hotWatCoi
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-260,-740},{-240,-720}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10(final k=0)
    if (not have_frePro) and (have_hotWatCoi and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment))
    "Dummy constant"
    annotation (Placement(transformation(extent={{360,-820},{380,-800}})));
equation
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-338,820},{-302,820}}, color={255,0,255}));
  connect(TAirSup, lesThr.u) annotation (Line(points={{-460,330},{-420,330},{
          -420,820},{-362,820}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,840},{40,840},
          {40,820},{58,820}},color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,760},{0,760},
          {0,748},{58,748}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,690},{-322,690}}, color={0,0,127}));
  connect(TAirSup, heaCoiCon1.u_m) annotation (Line(points={{-460,330},{-420,
          330},{-420,660},{-310,660},{-310,678}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,690},{0,690},
          {0,678},{118,678}}, color={0,0,127}));
  connect(TAirSup, greThr.u) annotation (Line(points={{-460,330},{-420,330},{
          -420,610},{-382,610}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,610},{-322,610}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,602},{-262,602}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,602},{-130,602},{
          -130,806},{-62,806}},color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,812},{58,812}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,812},{20,812},{20,740},
          {58,740}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,812},{20,812},{20,
          670},{118,670}}, color={255,0,255}));
  connect(TAirSup, lesThr1.u) annotation (Line(points={{-460,330},{-420,330},{
          -420,470},{-382,470}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,470},{-342,470}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,462},{-302,462}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,620},{80,620},{80,608},
          {118,608}}, color={0,0,127}));
  connect(con.y, minOutDam2.u1) annotation (Line(points={{62,620},{80,620},{80,
          558},{118,558}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-118,320},{-20,320},{-20,
          426},{118,426}}, color={0,0,127}));
  connect(uRetDam, retDam2.u3) annotation (Line(points={{-460,390},{-40,390},{-40,
          410},{118,410}},      color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,350},{100,350},{
          100,328},{118,328}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,470},{-350,470},{
          -350,250},{-302,250}}, color={255,0,255}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-338,210},{-302,210}}, color={255,0,255}));
  connect(TAirSup, lesThr2.u) annotation (Line(points={{-460,330},{-420,330},{
          -420,210},{-362,210}}, color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,242},{-240,242},{
          -240,210},{-222,210}}, color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,202},{-222,202}}, color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,60},{-240,60},{-240,
          194},{-222,194}},      color={255,0,255}));
  connect(u1SofSwiRes, lat1.clr) annotation (Line(points={{-460,20},{-160,20},{
          -160,154},{-142,154}},        color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,160},{20,160},{20,
          -220},{118,-220}}, color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,160},{20,160},{20,-360},
          {118,-360}},       color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,160},{20,160},{20,-500},
          {118,-500}},       color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,58},{40,58},{40,-212},
          {118,-212}},       color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,58},{40,58},{40,-352},
          {118,-352}},       color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,58},{40,58},{40,-492},
          {118,-492}},       color={0,0,127}));
  connect(uSupFan, supFan.u3)
    annotation (Line(points={{-460,-228},{118,-228}}, color={0,0,127}));
  connect(uRetFan, retFan.u3)
    annotation (Line(points={{-460,-368},{118,-368}}, color={0,0,127}));
  connect(uRelFan, relFan.u3)
    annotation (Line(points={{-460,-508},{118,-508}}, color={0,0,127}));
  connect(supFan.y, ySupFan)
    annotation (Line(points={{142,-220},{460,-220}}, color={0,0,127}));
  connect(relFan.y, yRelFan)
    annotation (Line(points={{142,-500},{460,-500}}, color={0,0,127}));
  connect(retFan.y, yRetFan)
    annotation (Line(points={{142,-360},{460,-360}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,58},{40,58},{40,88},
          {318,88}},         color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,160},{20,160},{20,80},
          {318,80}},         color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-588},{118,-588}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,160},{20,160},{20,-580},
          {118,-580}},       color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-118,320},{-20,320},{-20,
          -572},{118,-572}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-772},{318,-772}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,160},{20,160},
          {20,-780},{318,-780}}, color={255,0,255}));
  connect(TAirMix, max1.u2)
    annotation (Line(points={{-460,-696},{-302,-696}}, color={0,0,127}));
  connect(TAirSup, max1.u1) annotation (Line(points={{-460,330},{-420,330},{-420,
          -684},{-302,-684}},      color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-690},{50,-690},
          {50,-672}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-660},{38,-660}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-660},{100,-660},
          {100,-692},{318,-692}},       color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,160},{20,160},{20,
          -700},{318,-700}},    color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,160},{20,160},{20,-840},
          {318,-840}},          color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-832},{318,-832}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,160},{20,160},{20,220},{118,220}}, color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{142,220},{378,220}}, color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,462},{378,462}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,462},{-270,462},{
          -270,430},{-262,430}}, color={255,0,255}));
  connect(lat1.y, minOutDam.u2) annotation (Line(points={{-118,160},{20,160},{20,
          0},{318,0}},          color={255,0,255}));
  connect(con3.y, minOutDam.u1) annotation (Line(points={{-118,58},{40,58},{40,8},
          {318,8}},             color={0,0,127}));
  connect(uOutDam, minVen.u3) annotation (Line(points={{-460,720},{-80,720},{-80,
          732},{58,732}}, color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,740},{100,740},{
          100,592},{118,592}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,600},{270,600},{270,
          72},{318,72}},       color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,790},{40,790},
          {40,804},{58,804}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,288},{100,288},{
          100,312},{118,312}}, color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,320},{210,320},{210,
          -848},{318,-848}},     color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-840},{460,-840}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,812},{230,
          812},{230,-788},{318,-788}},     color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-780},{460,-780}}, color={255,127,0}));
  connect(minOutDam2.y, minOutDam.u3) annotation (Line(points={{142,550},{220,550},
          {220,-8},{318,-8}},        color={0,0,127}));
  connect(minOutDam.y, yMinOutDam)
    annotation (Line(points={{342,0},{460,0}},     color={0,0,127}));
  connect(uMinOutDam, minOutDam2.u3) annotation (Line(points={{-460,560},{60,
          560},{60,542},{118,542}}, color={0,0,127}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,640},{-100,640},{-100,
          662},{118,662}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,670},{280,670},
          {280,-708},{318,-708}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-700},{460,-700}}, color={0,0,127}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,462},{-182,462}}, color={255,0,255}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,422},{-222,422}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,422},{-190,422},
          {-190,456},{-182,456}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,462},{20,462},{20,
          600},{118,600}}, color={255,0,255}));
  connect(lat2.y, minOutDam2.u2) annotation (Line(points={{-158,462},{20,462},{
          20,550},{118,550}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,462},{118,462}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,462},{20,462},{20,
          418},{118,418}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,462},{20,462},{20,
          320},{118,320}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,812},{-162,812}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-138,812},{-62,812}},color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,160},{318,160}},
          color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,58},{40,58},{40,168},
          {318,168}}, color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,418},{260,418},{
          260,152},{318,152}}, color={0,0,127}));
  connect(retDam.y, yRetDam)
    annotation (Line(points={{342,160},{460,160}}, color={0,0,127}));
  connect(lat1.y, y1EneCHWPum) annotation (Line(points={{-118,160},{20,160},{20,
          260},{460,260}}, color={255,0,255}));
  connect(outDam.y, yOutDam)
    annotation (Line(points={{342,80},{460,80}},   color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-580},{460,-580}}, color={0,0,127}));
  connect(conInt1.y, intSwi2.u1) annotation (Line(points={{62,350},{290,350},{
          290,328},{378,328}}, color={255,127,0}));
  connect(lat1.y, intSwi2.u2) annotation (Line(points={{-118,160},{20,160},{20,
          260},{292,260},{292,320},{378,320}}, color={255,0,255}));
  connect(lat2.y, intSwi4.u2) annotation (Line(points={{-158,462},{20,462},{20,
          580},{318,580}}, color={255,0,255}));
  connect(conInt6.y, intSwi4.u1) annotation (Line(points={{182,630},{290,630},{
          290,588},{318,588}}, color={255,127,0}));
  connect(intSwi4.y, intSwi2.u3) annotation (Line(points={{342,580},{360,580},{
          360,312},{378,312}}, color={255,127,0}));
  connect(lat.y, intSwi5.u2) annotation (Line(points={{-38,812},{20,812},{20,
          770},{258,770}}, color={255,0,255}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{282,770},{300,770},{
          300,572},{318,572}}, color={255,127,0}));
  connect(conInt7.y, intSwi5.u1) annotation (Line(points={{162,840},{240,840},{
          240,778},{258,778}}, color={255,127,0}));
  connect(intSwi2.y, yFreProSta)
    annotation (Line(points={{402,320},{460,320}}, color={255,127,0}));
  connect(conInt8.y, intSwi5.u3) annotation (Line(points={{162,740},{200,740},{
          200,762},{258,762}}, color={255,127,0}));
  connect(endStaTwo.y, or2.u2) annotation (Line(points={{-198,422},{-190,422},{-190,
          804},{-162,804}}, color={255,0,255}));
  connect(u1MinOutDam, minOutDam3.u3) annotation (Line(points={{-460,520},{-10,520},
          {-10,512},{118,512}},      color={255,0,255}));
  connect(lat2.y, minOutDam3.u2) annotation (Line(points={{-158,462},{20,462},{
          20,520},{118,520}}, color={255,0,255}));
  connect(con5.y, minOutDam3.u1) annotation (Line(points={{-18,540},{0,540},{0,
          528},{118,528}}, color={255,0,255}));
  connect(lat1.y, minOutDam1.u2) annotation (Line(points={{-118,160},{20,160},{20,
          -70},{318,-70}}, color={255,0,255}));
  connect(minOutDam1.y, y1MinOutDam)
    annotation (Line(points={{342,-70},{460,-70}},   color={255,0,255}));
  connect(minOutDam3.y, minOutDam1.u3) annotation (Line(points={{142,520},{200,520},
          {200,-78},{318,-78}},        color={255,0,255}));
  connect(con5.y, minOutDam1.u1) annotation (Line(points={{-18,540},{0,540},{0,-62},
          {318,-62}}, color={255,0,255}));
  connect(u1FreSta,norFal. u) annotation (Line(points={{-460,130},{-362,130}},
                                 color={255,0,255}));
  connect(or3.y, lat1.u) annotation (Line(points={{-198,202},{-160,202},{-160,
          160},{-142,160}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{-198,130},{-180,130},{
          -180,154},{-142,154}}, color={255,0,255}));
  connect(u1RetFan, and1.u1) annotation (Line(points={{-460,-320},{-80,-320},{-80,
          -280},{318,-280}}, color={255,0,255}));
  connect(and1.y, y1RetFan)
    annotation (Line(points={{342,-280},{460,-280}}, color={255,0,255}));
  connect(norSta3.y, and1.u2) annotation (Line(points={{182,-300},{300,-300},{300,
          -288},{318,-288}}, color={255,0,255}));
  connect(lat1.y, norSta3.u) annotation (Line(points={{-118,160},{20,160},{20,-300},
          {158,-300}}, color={255,0,255}));
  connect(u1SupFan, and2.u1) annotation (Line(points={{-460,-180},{-80,-180},{-80,
          -140},{318,-140}}, color={255,0,255}));
  connect(and2.y, y1SupFan)
    annotation (Line(points={{342,-140},{460,-140}}, color={255,0,255}));
  connect(norSta1.y, and2.u2) annotation (Line(points={{182,-160},{300,-160},{300,
          -148},{318,-148}}, color={255,0,255}));
  connect(lat1.y, norSta1.u) annotation (Line(points={{-118,160},{20,160},{20,-160},
          {158,-160}}, color={255,0,255}));
  connect(u1RelFan, and3.u1) annotation (Line(points={{-460,-460},{-80,-460},{-80,
          -420},{318,-420}}, color={255,0,255}));
  connect(and3.y, y1RelFan)
    annotation (Line(points={{342,-420},{460,-420}}, color={255,0,255}));
  connect(norSta2.y,and3. u2) annotation (Line(points={{182,-440},{300,-440},{300,
          -428},{318,-428}}, color={255,0,255}));
  connect(lat1.y, norSta2.u) annotation (Line(points={{-118,160},{20,160},{20,-440},
          {158,-440}}, color={255,0,255}));
  connect(uHeaCoi, gai.u) annotation (Line(points={{-460,640},{-100,640},{-100,-640},
          {318,-640}}, color={0,0,127}));
  connect(gai.y, yHeaCoi) annotation (Line(points={{342,-640},{360,-640},{360,-700},
          {460,-700}}, color={0,0,127}));
  connect(uCooCoi, gai1.u) annotation (Line(points={{-460,-588},{100,-588},{100,
          -610},{118,-610}}, color={0,0,127}));
  connect(gai1.y, yCooCoi) annotation (Line(points={{142,-610},{160,-610},{160,-580},
          {460,-580}}, color={0,0,127}));
  connect(uRelFan, gai2.u) annotation (Line(points={{-460,-508},{100,-508},{100,
          -530},{118,-530}}, color={0,0,127}));
  connect(gai2.y, yRelFan) annotation (Line(points={{142,-530},{160,-530},{160,-500},
          {460,-500}}, color={0,0,127}));
  connect(u1RelFan, or1.u1)
    annotation (Line(points={{-460,-460},{318,-460}}, color={255,0,255}));
  connect(u1RelFan, or1.u2) annotation (Line(points={{-460,-460},{-80,-460},{-80,
          -468},{318,-468}}, color={255,0,255}));
  connect(or1.y, y1RelFan) annotation (Line(points={{342,-460},{360,-460},{360,-420},
          {460,-420}}, color={255,0,255}));
  connect(uRetFan, gai3.u) annotation (Line(points={{-460,-368},{100,-368},{100,
          -390},{118,-390}}, color={0,0,127}));
  connect(gai3.y, yRetFan) annotation (Line(points={{142,-390},{160,-390},{160,-360},
          {460,-360}}, color={0,0,127}));
  connect(u1RetFan, or4.u1)
    annotation (Line(points={{-460,-320},{318,-320}}, color={255,0,255}));
  connect(u1RetFan, or4.u2) annotation (Line(points={{-460,-320},{-80,-320},{-80,
          -328},{318,-328}}, color={255,0,255}));
  connect(or4.y, y1RetFan) annotation (Line(points={{342,-320},{360,-320},{360,-280},
          {460,-280}}, color={255,0,255}));
  connect(uRetDam, gai4.u) annotation (Line(points={{-460,390},{-40,390},{-40,130},
          {318,130}}, color={0,0,127}));
  connect(gai4.y, yRetDam) annotation (Line(points={{342,130},{360,130},{360,160},
          {460,160}}, color={0,0,127}));
  connect(uOutDam, gai5.u) annotation (Line(points={{-460,720},{-80,720},{-80,50},
          {318,50}}, color={0,0,127}));
  connect(gai5.y, yOutDam) annotation (Line(points={{342,50},{360,50},{360,80},{
          460,80}}, color={0,0,127}));
  connect(uMinOutDam, gai6.u) annotation (Line(points={{-460,560},{-60,560},{-60,
          -30},{318,-30}}, color={0,0,127}));
  connect(gai6.y, yMinOutDam) annotation (Line(points={{342,-30},{360,-30},{360,
          0},{460,0}}, color={0,0,127}));
  connect(u1MinOutDam, or5.u1) annotation (Line(points={{-460,520},{-10,520},{-10,
          -100},{318,-100}}, color={255,0,255}));
  connect(u1MinOutDam, or5.u2) annotation (Line(points={{-460,520},{-10,520},{-10,
          -108},{318,-108}}, color={255,0,255}));
  connect(or5.y, y1MinOutDam) annotation (Line(points={{342,-100},{360,-100},{360,
          -70},{460,-70}}, color={255,0,255}));
  connect(u1SupFan, or6.u1)
    annotation (Line(points={{-460,-180},{318,-180}}, color={255,0,255}));
  connect(u1SupFan, or6.u2) annotation (Line(points={{-460,-180},{-80,-180},{-80,
          -188},{318,-188}}, color={255,0,255}));
  connect(or6.y, y1SupFan) annotation (Line(points={{342,-180},{360,-180},{360,-140},
          {460,-140}}, color={255,0,255}));
  connect(uSupFan, gai7.u) annotation (Line(points={{-460,-228},{100,-228},{100,
          -250},{118,-250}}, color={0,0,127}));
  connect(gai7.y, ySupFan) annotation (Line(points={{142,-250},{160,-250},{160,-220},
          {460,-220}}, color={0,0,127}));
  connect(norFal.y, falEdg.u)
    annotation (Line(points={{-338,130},{-222,130}}, color={255,0,255}));
  connect(norFal.y, or3.u3) annotation (Line(points={{-338,130},{-260,130},{-260,
          194},{-222,194}}, color={255,0,255}));
  connect(conInt9.y, yFreProSta) annotation (Line(points={{402,370},{420,370},{420,
          320},{460,320}}, color={255,127,0}));
  connect(gai8.y, yRetDam) annotation (Line(points={{-218,-50},{366,-50},{366,160},
          {460,160}}, color={0,0,127}));
  connect(gai9.y, yOutDam) annotation (Line(points={{-218,-80},{-200,-80},{-200,
          -50},{372,-50},{372,80},{460,80}}, color={0,0,127}));
  connect(uRetDam, gai8.u) annotation (Line(points={{-460,390},{-414,390},{-414,
          -50},{-242,-50}}, color={0,0,127}));
  connect(uOutDam, gai9.u) annotation (Line(points={{-460,720},{-406,720},{-406,
          -80},{-242,-80}}, color={0,0,127}));
  connect(gai10.y, yMinOutDam) annotation (Line(points={{-218,-110},{-192,-110},
          {-192,-50},{378,-50},{378,0},{460,0}}, color={0,0,127}));
  connect(uMinOutDam, gai10.u) annotation (Line(points={{-460,560},{-400,560},{-400,
          -110},{-242,-110}}, color={0,0,127}));
  connect(gai11.y, ySupFan) annotation (Line(points={{-238,-270},{300,-270},{300,
          -220},{460,-220}}, color={0,0,127}));
  connect(uSupFan, gai11.u) annotation (Line(points={{-460,-228},{-400,-228},{-400,
          -270},{-262,-270}}, color={0,0,127}));
  connect(uRetFan, gai12.u) annotation (Line(points={{-460,-368},{-400,-368},{-400,
          -410},{-262,-410}}, color={0,0,127}));
  connect(gai12.y, yRetFan) annotation (Line(points={{-238,-410},{300,-410},{300,
          -360},{460,-360}}, color={0,0,127}));
  connect(uRelFan, gai13.u) annotation (Line(points={{-460,-508},{-400,-508},{-400,
          -550},{-262,-550}}, color={0,0,127}));
  connect(gai13.y, yRelFan) annotation (Line(points={{-238,-550},{300,-550},{300,
          -500},{460,-500}}, color={0,0,127}));
  connect(uCooCoi, gai14.u) annotation (Line(points={{-460,-588},{-400,-588},{-400,
          -630},{-262,-630}}, color={0,0,127}));
  connect(gai14.y, yCooCoi) annotation (Line(points={{-238,-630},{300,-630},{300,
          -580},{460,-580}}, color={0,0,127}));
  connect(gai15.y, yHeaCoi) annotation (Line(points={{-238,-730},{380,-730},{380,
          -700},{460,-700}}, color={0,0,127}));
  connect(uHeaCoi, gai15.u) annotation (Line(points={{-460,640},{-390,640},{-390,
          -730},{-262,-730}}, color={0,0,127}));
  connect(conInt10.y, yHotWatPlaReq) annotation (Line(points={{382,-810},{400,-810},
          {400,-780},{460,-780}}, color={255,127,0}));
annotation (defaultComponentName="mulAHUFrePro",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
        graphics={
        Text(extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,200},{-14,182}},
          textColor={0,0,127},
          textString="uOutDamPosMin",
          visible=have_frePro),
        Text(
          extent={{-96,32},{-48,10}},
          textColor={255,0,255},
          visible=freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
               and have_frePro,
          textString="u1FreSta"),
        Text(
          extent={{-98,178},{-46,162}},
          textColor={0,0,127},
          textString="uOutDam"),
        Text(
          extent={{-98,150},{-52,134}},
          textColor={0,0,127},
          textString="uHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,120},{-20,102}},
          textColor={0,0,127},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow,
          textString="uMinOutDam"),
        Text(
          extent={{-98,78},{-46,62}},
          textColor={0,0,127},
          textString="uRetDam"),
        Text(
          extent={{-96,60},{-56,40}},
          textColor={0,0,127},
          textString="TAirSup",
          visible=have_frePro),
        Text(
          extent={{-96,-130},{-46,-148}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uRelFan"),
        Text(
          extent={{-96,-90},{-46,-108}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="uRetFan"),
        Text(
          extent={{-98,-40},{-44,-58}},
          textColor={0,0,127},
          textString="uSupFan"),
        Text(
          extent={{-96,-182},{-58,-198}},
          textColor={0,0,127},
          visible=have_hotWatCoi and have_frePro,
          textString="TAirMix"),
        Text(
          extent={{-96,-160},{-50,-178}},
          textColor={0,0,127},
          textString="uCooCoi"),
        Text(
          extent={{36,160},{100,144}},
          textColor={0,0,127},
          textString="yRetDam"),
        Text(
          extent={{38,140},{102,124}},
          textColor={0,0,127},
          textString="yOutDam"),
        Text(
          extent={{20,112},{98,94}},
          textColor={0,0,127},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow,
          textString="yMinOutDam"),
        Text(
          extent={{50,40},{96,24}},
          textColor={0,0,127},
          textString="ySupFan"),
        Text(
          extent={{52,-10},{98,-26}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="yRetFan"),
        Text(
          extent={{58,-58},{98,-76}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yRelFan"),
        Text(
          extent={{52,-90},{96,-106}},
          textColor={0,0,127},
          textString="yCooCoi"),
        Text(
          extent={{50,-110},{96,-126}},
          textColor={0,0,127},
          textString="yHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{22,-160},{96,-178}},
          textColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi and (not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)),
        Text(
          extent={{-96,12},{-30,-12}},
          textColor={255,0,255},
          visible=(freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
               or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
               and have_frePro,
          textString="u1SofSwiRes"),
        Text(
          extent={{24,200},{96,180}},
          textColor={255,0,255},
          textString="y1EneCHWPum",
          visible=have_frePro),
        Text(
          extent={{70,-178},{98,-196}},
          textColor={255,127,0},
          textString="yAla",
          visible=have_frePro),
        Text(
          extent={{42,-140},{96,-156}},
          textColor={255,127,0},
          textString="yFreProSta"),
        Text(
          extent={{-96,104},{-14,80}},
          textColor={255,0,255},
          textString="u1MinOutDamPos",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure),
        Text(
          extent={{16,92},{96,72}},
          textColor={255,0,255},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure,
          textString="y1MinOutDam"),
        Text(
          extent={{-96,-16},{-46,-40}},
          textColor={255,0,255},
          textString="u1SupFan"),
        Text(
          extent={{-96,-64},{-48,-86}},
          textColor={255,0,255},
          textString="u1RetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
        Text(
          extent={{50,64},{98,42}},
          textColor={255,0,255},
          textString="y1SupFan"),
        Text(
          extent={{48,16},{96,-6}},
          textColor={255,0,255},
          textString="y1RetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
        Text(
          extent={{50,-34},{98,-56}},
          textColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="y1RelFan"),
        Text(
          extent={{-94,-110},{-46,-132}},
          textColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="u1RelFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-880},{440,
            880}}),
          graphics={
        Text(
          extent={{-320,300},{-226,280}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,510},{-236,490}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,862},{-248,842}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 1")}),
 Documentation(info="<html>
<p>
Freeze protection sequence for multizone AHU system. It is developed based on Section
5.16.12 of ASHRAE Guideline 36, May 2020.
</p>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> drops below 4.4 &deg;C (40 &deg;F)
for 5 minutes, send two (or more, as required to ensure that heating plant is active,
<code>minHotWatReq</code>) heating hot-water plant requests, override the outdoor
air damper to the minimum position, and modulate the heating coil to maintain a suppy
air temperature of at least 6 &deg;C (42 &deg;F).
Disable this function when supply air temperature rises above 7 &deg;C (45 &deg;F) for
5 minutes.
</li>
<li>
If the supply air temperature <code>TAirSup</code> drops below 3.3 &deg;C (38 &deg;F)
for 5 minutes, fully close both the economizer damper and the minimum outdoor air
damper for 1 hour and set a Level 3 alarm noting that minimum ventilation was
interrupted. After 1 hour, the unit shall resume minimum outdoor air ventilation
and enter the previous stage of freeze protection.
<ul>
<li>
If it is warm enough that the supply air temperature rises above 7 &deg;C (45 &deg;F)
with minimum ventilation, the unit will remain in Stage 1 freeze protection for 5
minutes then resume normal operation.
</li>
</ul>
</li>
<li>
Upon signal from the freeze-stat (if installed),
or if supply air temperature drops below 3.3 &deg;C (38 &deg;F) for 15 minutes or
below 1 &deg;C (34 &deg;F) for 5 minutes, shut down supply and return (or relief)
fan(s), close outdoor air damper, open the cooling-coil valve to 100%, and energize
the CHW pump system. Also send two (or more, as required to ensure that heating plant
is active, <code>minHotWatReq</code>) heating hot-water plant requests,
modulate the heating coil to maintain the higher of the supply air temperature or
the mixed air temperature at 27 &deg;C (80 &deg;F), and set a Level 2 alarm indicating
the unit is shut down by freeze protection.
<ul>
<li>
If a freeze-protection shutdown is triggered by a low air temperature sensor reading,
it shall remain in effect until it is reset by a software switch from the operator's
workstation. (If a freeze-stat with a physical reset switch is used instead, there
shall be no software reset switch.)
</li>
</ul>
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
December 22, 2022, by Jianjun Hu:<br/>
Added flag to disable freeze protection.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
July 15, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtection;
