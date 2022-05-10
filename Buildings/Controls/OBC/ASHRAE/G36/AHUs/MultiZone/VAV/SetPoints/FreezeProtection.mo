within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block FreezeProtection
  "Freeze protection sequence for multizone air handling unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection minOADes
    "Design of minimum outdoor air and economizer function";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Without_reset_switch_NC
    "Type of freeze stat";
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has heating coil";
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating coil controller"
    annotation (Dialog(group="Heating coil controller", enable=have_hotWatCoi));
  parameter Real k(unit="1")=1
    "Gain of coil controller"
    annotation (Dialog(group="Heating coil controller", enable=have_hotWatCoi));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Heating coil controller",
                       enable=have_hotWatCoi and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Heating coil controller",
                       enable=have_hotWatCoi and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Heating coil controller", enable=have_hotWatCoi));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Heating coil controller", enable=have_hotWatCoi));
  parameter Real Thys(unit="K")=0.25
    "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits sequence"
    annotation (Placement(transformation(extent={{-480,520},{-440,560}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,480},{-440,520}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil commanded position"
    annotation (Placement(transformation(extent={{-480,400},{-440,440}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinOutDam(
    final min=0,
    final max=1,
    final unit="1") if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,320},{-440,360}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1MinOutDam if minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{-480,280},{-440,320}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer return air damper commanded position"
    annotation (Placement(transformation(extent={{-480,150},{-440,190}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,110},{-440,150}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta
    if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Freeze protection stat signal. If the stat is normal open (the input is normally true), when enabling freeze protection, the input becomes false. If the stat is normally close, vice versa."
    annotation (Placement(transformation(extent={{-480,-100},{-440,-60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes
    if not (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
         or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC)
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RetFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{-480,-290},{-440,-250}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-338},{-440,-298}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{-480,-380},{-440,-340}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-428},{-440,-388}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil commanded position"
    annotation (Placement(transformation(extent={{-480,-468},{-440,-428}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-536},{-440,-496}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage index"
    annotation (Placement(transformation(extent={{440,90},{480,130}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
    "Commanded on to energize chilled water pump"
    annotation (Placement(transformation(extent={{440,30},{480,70}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{440,-30},{480,10}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,-70},{480,-30}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDam(
    final min=0,
    final max=1,
    final unit="1") if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,-110},{480,-70}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1MinOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{440,-150},{480,-110}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{440,-190},{480,-150}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{440,-240},{480,-200}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan if (buiPreCon
     == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{440,-280},{480,-240}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{440,-330},{480,-290}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{440,-370},{480,-330}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{440,-420},{480,-380}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil commanded position"
    annotation (Placement(transformation(extent={{440,-460},{480,-420}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil commanded position"
    annotation (Placement(transformation(extent={{440,-540},{480,-500}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-590},{480,-550}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla "Alarm level"
    annotation (Placement(transformation(extent={{440,-640},{480,-600}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4.4,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,590},{-340,610}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,590},{-280,610}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq if have_hotWatCoi
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,582},{80,602}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,610},{0,630}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,510},{80,530}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,460},{-300,480}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1 if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,440},{140,460}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys)
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,380},{-360,400}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,582},{-40,602}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,380},{-300,400}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,372},{-240,392}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3.3,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,240},{-360,260}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,240},{-320,260}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0)
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,232},{-280,252}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,370},{140,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,390},{60,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam2
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{120,320},{140,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,188},{140,208}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3)
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_hotWatCoi
    "Zero request"
    annotation (Placement(transformation(extent={{-20,560},{0,580}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,60},{-280,80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,20},{-340,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,20},{-280,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-220,12},{-200,32}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false)
    if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Constant false"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-320},{140,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-410},{140,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,-60},{340,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-450},{140,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3 if have_hotWatCoi
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-580},{340,-560}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-572},{-120,-552}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if have_hotWatCoi
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-520},{-280,-500}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-490},{60,-470}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_hotWatCoi
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-490},{-120,-470}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-530},{340,-510}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-630},{340,-610}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-622},{-120,-602}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,12},{400,32}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{120,12},{140,32}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,232},{400,252}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{120,232},{140,252}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600)
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{320,-100},{340,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,68},{60,88}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,232},{-160,252}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,192},{-200,212}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-100,582},{-80,602}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_hotWatCoi
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,460},{-360,480}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Alarm level"
    annotation (Placement(transformation(extent={{380,100},{400,120}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Alarm level"
    annotation (Placement(transformation(extent={{320,350},{340,370}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2)
    "Stage 2 freeze protection"
    annotation (Placement(transformation(extent={{160,400},{180,420}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Alarm level"
    annotation (Placement(transformation(extent={{260,540},{280,560}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 freeze protection"
    annotation (Placement(transformation(extent={{140,610},{160,630}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=0)
    "Stage 0 freeze protection"
    annotation (Placement(transformation(extent={{140,510},{160,530}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam3
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=false)
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "False"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam1
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{320,-140},{340,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not norFal
    if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "The output is normally false when the freeze stat is normally open (true)"
    annotation (Placement(transformation(extent={{-360,-20},{-340,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Freeze protection enabled by the freeze stat"
    annotation (Placement(transformation(extent={{-300,-60},{-280,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant norOpe(
    final k=freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
         or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Without_reset_switch_NO)
    if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Check if the freeze stat is normally open"
    annotation (Placement(transformation(extent={{-360,-60},{-340,-40}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    if (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
     or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC)
    "Reset the freeze protection by the physical reset switch in freeze stat"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Disable return fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-270},{340,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta3
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-290},{180,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta1 "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Disable supply fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-180},{340,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta2
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Not in stage 3"
    annotation (Placement(transformation(extent={{160,-380},{180,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Disable relief fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-360},{340,-340}})));
equation
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-338,600},{-302,600}}, color={255,0,255}));
  connect(TAirSup, lesThr.u) annotation (Line(points={{-460,130},{-420,130},{
          -420,600},{-362,600}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,620},{40,620},
          {40,600},{58,600}},color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,540},{0,540},
          {0,528},{58,528}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,470},{-322,470}}, color={0,0,127}));
  connect(TAirSup, heaCoiCon1.u_m) annotation (Line(points={{-460,130},{-420,
          130},{-420,440},{-310,440},{-310,458}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,470},{0,470},
          {0,458},{118,458}}, color={0,0,127}));
  connect(TAirSup, greThr.u) annotation (Line(points={{-460,130},{-420,130},{
          -420,390},{-382,390}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,390},{-322,390}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,382},{-262,382}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,382},{-70,382},{
          -70,586},{-62,586}}, color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,592},{58,592}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,592},{20,592},{20,520},
          {58,520}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,592},{20,592},{20,
          450},{118,450}}, color={255,0,255}));
  connect(TAirSup, lesThr1.u) annotation (Line(points={{-460,130},{-420,130},{
          -420,250},{-382,250}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,250},{-342,250}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,242},{-302,242}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,400},{80,400},{80,388},
          {118,388}}, color={0,0,127}));
  connect(con.y, minOutDam2.u1) annotation (Line(points={{62,400},{80,400},{80,
          338},{118,338}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-58,110},{-20,110},{-20,
          206},{118,206}}, color={0,0,127}));
  connect(uRetDam, retDam2.u3) annotation (Line(points={{-460,170},{-120,170},{
          -120,190},{118,190}}, color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,140},{100,140},{
          100,118},{118,118}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,250},{-350,250},{
          -350,70},{-302,70}}, color={255,0,255}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-338,30},{-302,30}}, color={255,0,255}));
  connect(TAirSup, lesThr2.u) annotation (Line(points={{-460,130},{-420,130},{
          -420,30},{-362,30}}, color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,62},{-240,62},{
          -240,30},{-222,30}},color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,22},{-222,22}}, color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,-120},{-240,-120},{
          -240,14},{-222,14}},   color={255,0,255}));
  connect(u1SofSwiRes, lat1.clr) annotation (Line(points={{-460,-140},{-160,
          -140},{-160,-26},{-142,-26}}, color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -220},{118,-220}}, color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -310},{118,-310}}, color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -400},{118,-400}}, color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,-140},{40,-140},{40,
          -212},{118,-212}}, color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,-140},{40,-140},{40,
          -302},{118,-302}}, color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,-140},{40,-140},{40,
          -392},{118,-392}}, color={0,0,127}));
  connect(uSupFan, supFan.u3)
    annotation (Line(points={{-460,-228},{118,-228}}, color={0,0,127}));
  connect(uRetFan, retFan.u3)
    annotation (Line(points={{-460,-318},{118,-318}}, color={0,0,127}));
  connect(uRelFan, relFan.u3)
    annotation (Line(points={{-460,-408},{118,-408}}, color={0,0,127}));
  connect(supFan.y, ySupFan)
    annotation (Line(points={{142,-220},{460,-220}}, color={0,0,127}));
  connect(relFan.y, yRelFan)
    annotation (Line(points={{142,-400},{460,-400}}, color={0,0,127}));
  connect(retFan.y, yRetFan)
    annotation (Line(points={{142,-310},{460,-310}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,-140},{40,-140},{40,
          -42},{318,-42}},   color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -50},{318,-50}},   color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-448},{118,-448}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -440},{118,-440}}, color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-58,110},{-20,110},{-20,
          -432},{118,-432}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-562},{318,-562}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,-20},{20,-20},
          {20,-570},{318,-570}}, color={255,0,255}));
  connect(TAirMix, max1.u2)
    annotation (Line(points={{-460,-516},{-302,-516}}, color={0,0,127}));
  connect(TAirSup, max1.u1) annotation (Line(points={{-460,130},{-420,130},{
          -420,-504},{-302,-504}}, color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-510},{50,-510},
          {50,-492}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-480},{38,-480}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-480},{100,
          -480},{100,-512},{318,-512}}, color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,-20},{20,-20},{
          20,-520},{318,-520}}, color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -620},{318,-620}},    color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-612},{318,-612}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,-20},{20,-20},{20,22},{118,22}}, color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{142,22},{378,22}}, color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,242},{378,242}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,242},{-270,242},{
          -270,210},{-262,210}}, color={255,0,255}));
  connect(lat1.y, minOutDam.u2) annotation (Line(points={{-118,-20},{20,-20},{
          20,-90},{318,-90}},   color={255,0,255}));
  connect(con3.y, minOutDam.u1) annotation (Line(points={{-118,-140},{40,-140},
          {40,-82},{318,-82}},  color={0,0,127}));
  connect(uOutDam, minVen.u3) annotation (Line(points={{-460,500},{0,500},{0,
          512},{58,512}}, color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,520},{100,520},{
          100,372},{118,372}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,380},{270,380},{
          270,-58},{318,-58}}, color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,570},{40,570},
          {40,584},{58,584}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,78},{100,78},{100,
          102},{118,102}}, color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,110},{210,110},{
          210,-628},{318,-628}}, color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-620},{460,-620}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,592},{
          230,592},{230,-578},{318,-578}}, color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-570},{460,-570}}, color={255,127,0}));
  connect(minOutDam2.y, minOutDam.u3) annotation (Line(points={{142,330},{220,
          330},{220,-98},{318,-98}}, color={0,0,127}));
  connect(minOutDam.y, yMinOutDam)
    annotation (Line(points={{342,-90},{460,-90}}, color={0,0,127}));
  connect(uMinOutDam, minOutDam2.u3) annotation (Line(points={{-460,340},{60,
          340},{60,322},{118,322}}, color={0,0,127}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,420},{0,420},{0,
          442},{118,442}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,450},{280,450},
          {280,-528},{318,-528}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-520},{460,-520}}, color={0,0,127}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,242},{-182,242}}, color={255,0,255}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,202},{-222,202}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,202},{-190,202},
          {-190,236},{-182,236}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,242},{20,242},{20,
          380},{118,380}}, color={255,0,255}));
  connect(lat2.y, minOutDam2.u2) annotation (Line(points={{-158,242},{20,242},{
          20,330},{118,330}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,242},{118,242}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,242},{20,242},{20,
          198},{118,198}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,242},{20,242},{20,
          110},{118,110}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,592},{-102,592}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-78,592},{-62,592}}, color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          -10},{318,-10}},   color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,-140},{40,-140},{40,
          -2},{318,-2}},     color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,198},{260,198},{
          260,-18},{318,-18}}, color={0,0,127}));
  connect(retDam.y, yRetDam)
    annotation (Line(points={{342,-10},{460,-10}}, color={0,0,127}));
  connect(lat1.y, y1EneCHWPum) annotation (Line(points={{-118,-20},{20,-20},{20,
          50},{460,50}},   color={255,0,255}));
  connect(outDam.y, yOutDam)
    annotation (Line(points={{342,-50},{460,-50}}, color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-440},{460,-440}}, color={0,0,127}));
  connect(conInt1.y, intSwi2.u1) annotation (Line(points={{62,140},{290,140},{
          290,118},{378,118}}, color={255,127,0}));
  connect(lat1.y, intSwi2.u2) annotation (Line(points={{-118,-20},{20,-20},{20,
          50},{292,50},{292,110},{378,110}}, color={255,0,255}));
  connect(lat2.y, intSwi4.u2) annotation (Line(points={{-158,242},{20,242},{20,
          360},{318,360}}, color={255,0,255}));
  connect(conInt6.y, intSwi4.u1) annotation (Line(points={{182,410},{290,410},{
          290,368},{318,368}}, color={255,127,0}));
  connect(intSwi4.y, intSwi2.u3) annotation (Line(points={{342,360},{360,360},{
          360,102},{378,102}}, color={255,127,0}));
  connect(lat.y, intSwi5.u2) annotation (Line(points={{-38,592},{20,592},{20,
          550},{258,550}}, color={255,0,255}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{282,550},{300,550},{
          300,352},{318,352}}, color={255,127,0}));
  connect(conInt7.y, intSwi5.u1) annotation (Line(points={{162,620},{240,620},{
          240,558},{258,558}}, color={255,127,0}));
  connect(intSwi2.y, yFreProSta)
    annotation (Line(points={{402,110},{460,110}}, color={255,127,0}));
  connect(conInt8.y, intSwi5.u3) annotation (Line(points={{162,520},{200,520},{
          200,542},{258,542}}, color={255,127,0}));
  connect(endStaTwo.y, or2.u2) annotation (Line(points={{-198,202},{-190,202},{
          -190,584},{-102,584}}, color={255,0,255}));
  connect(u1MinOutDam, minOutDam3.u3) annotation (Line(points={{-460,300},{-20,
          300},{-20,292},{118,292}}, color={255,0,255}));
  connect(lat2.y, minOutDam3.u2) annotation (Line(points={{-158,242},{20,242},{
          20,300},{118,300}}, color={255,0,255}));
  connect(con5.y, minOutDam3.u1) annotation (Line(points={{-18,320},{0,320},{0,
          308},{118,308}}, color={255,0,255}));
  connect(lat1.y, minOutDam1.u2) annotation (Line(points={{-118,-20},{20,-20},{
          20,-130},{318,-130}},  color={255,0,255}));
  connect(minOutDam1.y, y1MinOutDam)
    annotation (Line(points={{342,-130},{460,-130}}, color={255,0,255}));
  connect(minOutDam3.y, minOutDam1.u3) annotation (Line(points={{142,300},{200,
          300},{200,-138},{318,-138}}, color={255,0,255}));
  connect(con5.y, minOutDam1.u1) annotation (Line(points={{-18,320},{0,320},{0,
          -122},{318,-122}}, color={255,0,255}));
  connect(norOpe.y, logSwi.u2)
    annotation (Line(points={{-338,-50},{-302,-50}}, color={255,0,255}));
  connect(u1FreSta, norFal.u) annotation (Line(points={{-460,-80},{-400,-80},{
          -400,-10},{-362,-10}}, color={255,0,255}));
  connect(norFal.y, logSwi.u1) annotation (Line(points={{-338,-10},{-320,-10},{
          -320,-42},{-302,-42}}, color={255,0,255}));
  connect(u1FreSta, logSwi.u3) annotation (Line(points={{-460,-80},{-320,-80},{
          -320,-58},{-302,-58}},  color={255,0,255}));
  connect(logSwi.y, or3.u3) annotation (Line(points={{-278,-50},{-260,-50},{
          -260,14},{-222,14}}, color={255,0,255}));
  connect(or3.y, lat1.u) annotation (Line(points={{-198,22},{-160,22},{-160,-20},
          {-142,-20}}, color={255,0,255}));
  connect(logSwi.y, falEdg.u)
    annotation (Line(points={{-278,-50},{-222,-50}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{-198,-50},{-180,-50},{
          -180,-26},{-142,-26}},    color={255,0,255}));
  connect(u1RetFan, and1.u1) annotation (Line(points={{-460,-270},{-80,-270},{
          -80,-260},{318,-260}}, color={255,0,255}));
  connect(and1.y, y1RetFan)
    annotation (Line(points={{342,-260},{460,-260}}, color={255,0,255}));
  connect(norSta3.y, and1.u2) annotation (Line(points={{182,-280},{300,-280},{
          300,-268},{318,-268}}, color={255,0,255}));
  connect(lat1.y, norSta3.u) annotation (Line(points={{-118,-20},{20,-20},{20,
          -280},{158,-280}}, color={255,0,255}));
  connect(u1SupFan, and2.u1) annotation (Line(points={{-460,-180},{-80,-180},{
          -80,-170},{318,-170}}, color={255,0,255}));
  connect(and2.y, y1SupFan)
    annotation (Line(points={{342,-170},{460,-170}}, color={255,0,255}));
  connect(norSta1.y, and2.u2) annotation (Line(points={{182,-190},{300,-190},{
          300,-178},{318,-178}}, color={255,0,255}));
  connect(lat1.y, norSta1.u) annotation (Line(points={{-118,-20},{20,-20},{20,
          -190},{158,-190}}, color={255,0,255}));
  connect(u1RelFan, and3.u1) annotation (Line(points={{-460,-360},{-80,-360},{
          -80,-350},{318,-350}}, color={255,0,255}));
  connect(and3.y, y1RelFan)
    annotation (Line(points={{342,-350},{460,-350}}, color={255,0,255}));
  connect(norSta2.y,and3. u2) annotation (Line(points={{182,-370},{300,-370},{
          300,-358},{318,-358}}, color={255,0,255}));
  connect(lat1.y, norSta2.u) annotation (Line(points={{-118,-20},{20,-20},{20,
          -370},{158,-370}}, color={255,0,255}));
annotation (defaultComponentName="mulAHUFrePro",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
        graphics={
        Text(extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,200},{-14,182}},
          lineColor={0,0,127},
          textString="uOutDamPosMin"),
        Text(
          extent={{-96,32},{-48,10}},
          lineColor={255,0,255},
          visible=not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
          textString="u1FreSta"),
        Text(
          extent={{-98,178},{-46,162}},
          lineColor={0,0,127},
          textString="uOutDam"),
        Text(
          extent={{-98,150},{-52,134}},
          lineColor={0,0,127},
          textString="uHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,120},{-20,102}},
          lineColor={0,0,127},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow,
          textString="uMinOutDam"),
        Text(
          extent={{-98,78},{-46,62}},
          lineColor={0,0,127},
          textString="uRetDam"),
        Text(
          extent={{-96,60},{-56,40}},
          lineColor={0,0,127},
          textString="TAirSup"),
        Text(
          extent={{-96,-130},{-46,-148}},
          lineColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uRelFan"),
        Text(
          extent={{-96,-90},{-46,-108}},
          lineColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="uRetFan"),
        Text(
          extent={{-98,-40},{-44,-58}},
          lineColor={0,0,127},
          textString="uSupFan"),
        Text(
          extent={{-96,-182},{-58,-198}},
          lineColor={0,0,127},
          visible=have_hotWatCoi,
          textString="TAirMix"),
        Text(
          extent={{-96,-160},{-50,-178}},
          lineColor={0,0,127},
          textString="uCooCoi"),
        Text(
          extent={{36,160},{100,144}},
          lineColor={0,0,127},
          textString="yRetDam"),
        Text(
          extent={{38,140},{102,124}},
          lineColor={0,0,127},
          textString="yOutDam"),
        Text(
          extent={{20,112},{98,94}},
          lineColor={0,0,127},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow,
          textString="yMinOutDam"),
        Text(
          extent={{50,40},{96,24}},
          lineColor={0,0,127},
          textString="ySupFan"),
        Text(
          extent={{52,-10},{98,-26}},
          lineColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="yRetFan"),
        Text(
          extent={{58,-58},{98,-76}},
          lineColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yRelFan"),
        Text(
          extent={{52,-90},{96,-106}},
          lineColor={0,0,127},
          textString="yCooCoi"),
        Text(
          extent={{50,-110},{96,-126}},
          lineColor={0,0,127},
          textString="yHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{22,-160},{96,-178}},
          lineColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,12},{-30,-12}},
          lineColor={255,0,255},
          visible=not (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
                       or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC),
          textString="u1SofSwiRes"),
        Text(
          extent={{24,200},{96,180}},
          lineColor={255,0,255},
          textString="y1EneCHWPum"),
        Text(
          extent={{70,-178},{98,-196}},
          lineColor={255,127,0},
          textString="yAla"),
        Text(
          extent={{42,-140},{96,-156}},
          lineColor={255,127,0},
          textString="yFreProSta"),
        Text(
          extent={{-96,104},{-14,80}},
          lineColor={255,0,255},
          textString="u1MinOutDamPos",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure),
        Text(
          extent={{16,92},{96,72}},
          lineColor={255,0,255},
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure,
          textString="y1MinOutDam"),
        Text(
          extent={{-96,-16},{-46,-40}},
          lineColor={255,0,255},
          textString="u1SupFan"),
        Text(
          extent={{-96,-64},{-48,-86}},
          lineColor={255,0,255},
          textString="u1RetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
        Text(
          extent={{50,64},{98,42}},
          lineColor={255,0,255},
          textString="y1SupFan"),
        Text(
          extent={{48,16},{96,-6}},
          lineColor={255,0,255},
          textString="y1RetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
        Text(
          extent={{50,-34},{98,-56}},
          lineColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="y1RelFan"),
        Text(
          extent={{-94,-110},{-46,-132}},
          lineColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="u1RelFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-640},{440,
            640}}),
          graphics={
        Text(
          extent={{-332,112},{-238,92}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,290},{-236,270}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,642},{-248,622}},
          lineColor={0,0,255},
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
July 15, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtection;
