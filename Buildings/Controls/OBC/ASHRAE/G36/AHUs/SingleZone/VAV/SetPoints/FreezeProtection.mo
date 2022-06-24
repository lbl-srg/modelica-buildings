within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block FreezeProtection
  "Freeze protection sequence for single zone air handling unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta
    "Type of freeze stat";
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil";
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
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
    "Minimum economizer damper position limit as returned by the damper position limits  sequence"
    annotation (Placement(transformation(extent={{-480,490},{-440,530}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,450},{-440,490}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{-480,370},{-440,410}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer return air damper commanded position"
    annotation (Placement(transformation(extent={{-480,170},{-440,210}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,130},{-440,170}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta
    if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Freeze protection stat signal. If the stat is normal open (the input is normally true), when enabling freeze protection, the input becomes false. If the stat is normally close, vice versa."
    annotation (Placement(transformation(extent={{-480,-90},{-440,-50}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes
    if not (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
     or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC)
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,-130},{-440,-90}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-198},{-440,-158}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RetFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{-480,-240},{-440,-200}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFan(
    final min=0,
    final max=1,
    final unit="1") if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-308},{-440,-268}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan if buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{-480,-350},{-440,-310}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFan(
    final min=0,
    final max=1,
    final unit="1") if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-418},{-440,-378}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{-480,-458},{-440,-418}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if have_hotWatCoi
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-516},{-440,-476}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage index"
    annotation (Placement(transformation(extent={{440,110},{480,150}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{440,50},{480,90}}),
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
    annotation (Placement(transformation(extent={{440,-80},{480,-40}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{440,-160},{480,-120}}),
        iconTransformation(extent={{100,48},{140,88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{440,-190},{480,-150}}),
        iconTransformation(extent={{100,28},{140,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan if (buiPreCon
     == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{440,-240},{480,-200}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1") if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{440,-300},{480,-260}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan if buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{440,-350},{480,-310}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1") if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{440,-410},{480,-370}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{440,-450},{480,-410}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{440,-520},{480,-480}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-570},{480,-530}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla "Alarm level"
    annotation (Placement(transformation(extent={{440,-620},{480,-580}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,560},{-340,580}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,560},{-280,580}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq if have_hotWatCoi
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,552},{80,572}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,590},{0,610}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,480},{80,500}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,430},{-300,450}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1 if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,410},{140,430}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys)
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,350},{-360,370}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,552},{-40,572}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,350},{-300,370}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,342},{-240,362}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,260},{-360,280}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,260},{-320,280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0)
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,252},{-280,272}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,340},{140,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,360},{60,380}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,208},{140,228}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3)
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_hotWatCoi
    "Zero request"
    annotation (Placement(transformation(extent={{-20,530},{0,550}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,80},{-280,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,40},{-280,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-220,32},{-200,52}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,32},{-120,52}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-290},{140,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.
     ReliefFan
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-400},{140,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,-70},{340,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-440},{140,-420}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3 if have_hotWatCoi
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-560},{340,-540}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-552},{-120,-532}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if have_hotWatCoi
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-500},{-280,-480}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-470},{60,-450}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_hotWatCoi
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-470},{-120,-450}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-510},{340,-490}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-610},{340,-590}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-602},{-120,-582}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,32},{400,52}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{120,32},{140,52}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,252},{400,272}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{120,252},{140,272}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600)
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,88},{60,108}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,252},{-160,272}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,212},{-200,232}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-100,552},{-80,572}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Switch from stage 2 to stage 1"
    annotation (Placement(transformation(extent={{-140,520},{-120,540}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_hotWatCoi
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,430},{-360,450}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Alarm level"
    annotation (Placement(transformation(extent={{380,120},{400,140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Alarm level"
    annotation (Placement(transformation(extent={{320,320},{340,340}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2)
    "Stage 2 freeze protection"
    annotation (Placement(transformation(extent={{160,370},{180,390}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Alarm level"
    annotation (Placement(transformation(extent={{260,510},{280,530}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 freeze protection"
    annotation (Placement(transformation(extent={{140,580},{160,600}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=0)
    "Stage 0 freeze protection"
    annotation (Placement(transformation(extent={{140,480},{160,500}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 if (freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
     or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC)
    "Reset the freeze protection by the physical reset switch in freeze stat"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Freeze protection enabled by the freeze stat"
    annotation (Placement(transformation(extent={{-300,-40},{-280,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant norOpe(
    final k=freSta ==Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
         or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Without_reset_switch_NO) if not
    freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Check if the freeze stat is normally open"
    annotation (Placement(transformation(extent={{-360,-40},{-340,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not norFal if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "The output is normally false when the freeze stat is normally open (true)"
    annotation (Placement(transformation(extent={{-360,0},{-340,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(final k=false)
    if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Constant false"
    annotation (Placement(transformation(extent={{-300,-90},{-280,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta1
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-360},{140,-340}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Disable relief fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-340},{340,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Disable return fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-230},{340,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta2
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta3 "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Disable supply fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-150},{340,-130}})));

equation
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-338,570},{-302,570}}, color={255,0,255}));
  connect(TAirSup, lesThr.u) annotation (Line(points={{-460,150},{-420,150},{-420,
          570},{-362,570}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,600},{40,600},{
          40,570},{58,570}}, color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,510},{0,510},
          {0,498},{58,498}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,440},{-322,440}}, color={0,0,127}));
  connect(TAirSup, heaCoiCon1.u_m) annotation (Line(points={{-460,150},{-420,150},
          {-420,410},{-310,410},{-310,428}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,440},{0,440},
          {0,428},{118,428}}, color={0,0,127}));
  connect(TAirSup, greThr.u) annotation (Line(points={{-460,150},{-420,150},{-420,
          360},{-382,360}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,360},{-322,360}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,352},{-262,352}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,352},{-70,352},{-70,
          556},{-62,556}}, color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,562},{58,562}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,562},{20,562},{20,490},
          {58,490}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,562},{20,562},{20,420},
          {118,420}}, color={255,0,255}));
  connect(TAirSup, lesThr1.u) annotation (Line(points={{-460,150},{-420,150},{-420,
          270},{-382,270}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,270},{-342,270}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,262},{-302,262}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,370},{80,370},{80,358},
          {118,358}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-58,130},{-20,130},{-20,
          226},{118,226}}, color={0,0,127}));
  connect(uRetDam, retDam2.u3) annotation (Line(points={{-460,190},{-120,190},{-120,
          210},{118,210}}, color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,160},{100,160},{100,
          138},{118,138}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,270},{-350,270},{-350,
          90},{-302,90}},   color={255,0,255}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-338,50},{-302,50}},     color={255,0,255}));
  connect(TAirSup, lesThr2.u) annotation (Line(points={{-460,150},{-420,150},{-420,
          50},{-362,50}},   color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,82},{-240,82},{-240,
          50},{-222,50}},     color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,42},{-222,42}},     color={255,0,255}));
  connect(or3.y, lat1.u)
    annotation (Line(points={{-198,42},{-142,42}},     color={255,0,255}));
  connect(u1SofSwiRes, lat1.clr) annotation (Line(points={{-460,-110},{-160,-110},
          {-160,36},{-142,36}},   color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,42},{20,42},{20,-170},
          {118,-170}},       color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,42},{20,42},{20,-280},
          {118,-280}},       color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,42},{20,42},{20,-390},
          {118,-390}},       color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,-70},{40,-70},{40,-162},
          {118,-162}},       color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,-70},{40,-70},{40,-272},
          {118,-272}},       color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,-70},{40,-70},{40,-382},
          {118,-382}},       color={0,0,127}));
  connect(uSupFan, supFan.u3)
    annotation (Line(points={{-460,-178},{118,-178}}, color={0,0,127}));
  connect(uRetFan, retFan.u3)
    annotation (Line(points={{-460,-288},{118,-288}}, color={0,0,127}));
  connect(uRelFan, relFan.u3)
    annotation (Line(points={{-460,-398},{118,-398}}, color={0,0,127}));
  connect(supFan.y, ySupFan)
    annotation (Line(points={{142,-170},{460,-170}}, color={0,0,127}));
  connect(relFan.y, yRelFan)
    annotation (Line(points={{142,-390},{460,-390}}, color={0,0,127}));
  connect(retFan.y, yRetFan)
    annotation (Line(points={{142,-280},{460,-280}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,-70},{40,-70},{40,-52},
          {318,-52}},        color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,42},{20,42},{20,-60},
          {318,-60}},        color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-438},{118,-438}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,42},{20,42},{20,-430},
          {118,-430}},       color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-58,130},{-20,130},{-20,-422},
          {118,-422}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-542},{318,-542}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,42},{20,42},{
          20,-550},{318,-550}},  color={255,0,255}));
  connect(TAirMix, max1.u2)
    annotation (Line(points={{-460,-496},{-302,-496}}, color={0,0,127}));
  connect(TAirSup, max1.u1) annotation (Line(points={{-460,150},{-420,150},{-420,
          -484},{-302,-484}}, color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-490},{50,-490},
          {50,-472}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-460},{38,-460}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-460},{100,-460},
          {100,-492},{318,-492}}, color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,42},{20,42},{20,-500},
          {318,-500}},          color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,42},{20,42},{20,-600},
          {318,-600}},       color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-592},{318,-592}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,42},{118,42}},     color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{142,42},{378,42}},     color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,262},{378,262}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,262},{-270,262},{-270,
          230},{-262,230}}, color={255,0,255}));
  connect(uOutDam, minVen.u3) annotation (Line(points={{-460,470},{0,470},{0,482},
          {58,482}}, color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,490},{100,490},{100,
          342},{118,342}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,350},{270,350},{270,
          -68},{318,-68}},   color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,540},{40,540},
          {40,554},{58,554}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,98},{100,98},{100,
          122},{118,122}}, color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,130},{210,130},{210,
          -608},{318,-608}}, color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-600},{460,-600}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,562},{230,
          562},{230,-558},{318,-558}}, color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-550},{460,-550}}, color={255,127,0}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,390},{0,390},{0,412},
          {118,412}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,420},{280,420},
          {280,-508},{318,-508}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-500},{460,-500}}, color={0,0,127}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,262},{-182,262}}, color={255,0,255}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,222},{-222,222}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,222},{-190,222},
          {-190,256},{-182,256}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,262},{20,262},{20,350},
          {118,350}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,262},{118,262}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,262},{20,262},{20,218},
          {118,218}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,262},{20,262},{20,130},
          {118,130}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,562},{-102,562}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-78,562},{-62,562}}, color={255,0,255}));
  connect(falEdg.y, or2.u2) annotation (Line(points={{-118,530},{-110,530},{-110,
          554},{-102,554}}, color={255,0,255}));
  connect(lat2.y, falEdg.u) annotation (Line(points={{-158,262},{-150,262},{-150,
          530},{-142,530}}, color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,42},{20,42},{20,-10},
          {318,-10}},        color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,-70},{40,-70},{40,-2},
          {318,-2}},         color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,218},{260,218},{260,
          -18},{318,-18}},   color={0,0,127}));
  connect(retDam.y, yRetDam)
    annotation (Line(points={{342,-10},{460,-10}},   color={0,0,127}));
  connect(lat1.y, y1EneCHWPum) annotation (Line(points={{-118,42},{20,42},{20,70},
          {460,70}},       color={255,0,255}));
  connect(outDam.y, yOutDam)
    annotation (Line(points={{342,-60},{460,-60}},   color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-430},{460,-430}}, color={0,0,127}));
  connect(conInt1.y, intSwi2.u1) annotation (Line(points={{62,160},{290,160},{290,
          138},{378,138}}, color={255,127,0}));
  connect(lat1.y, intSwi2.u2) annotation (Line(points={{-118,42},{20,42},{20,70},
          {292,70},{292,130},{378,130}},color={255,0,255}));
  connect(lat2.y, intSwi4.u2) annotation (Line(points={{-158,262},{20,262},{20,330},
          {318,330}}, color={255,0,255}));
  connect(conInt6.y, intSwi4.u1) annotation (Line(points={{182,380},{290,380},{290,
          338},{318,338}}, color={255,127,0}));
  connect(intSwi4.y, intSwi2.u3) annotation (Line(points={{342,330},{360,330},{360,
          122},{378,122}}, color={255,127,0}));
  connect(lat.y, intSwi5.u2) annotation (Line(points={{-38,562},{20,562},{20,520},
          {258,520}}, color={255,0,255}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{282,520},{300,520},{300,
          322},{318,322}}, color={255,127,0}));
  connect(conInt7.y, intSwi5.u1) annotation (Line(points={{162,590},{240,590},{240,
          528},{258,528}}, color={255,127,0}));
  connect(intSwi2.y, yFreProSta)
    annotation (Line(points={{402,130},{460,130}}, color={255,127,0}));
  connect(conInt8.y, intSwi5.u3) annotation (Line(points={{162,490},{200,490},{200,
          512},{258,512}}, color={255,127,0}));
  connect(u1FreSta, norFal.u) annotation (Line(points={{-460,-70},{-400,-70},{-400,
          10},{-362,10}},        color={255,0,255}));
  connect(norOpe.y, logSwi.u2)
    annotation (Line(points={{-338,-30},{-302,-30}},   color={255,0,255}));
  connect(norFal.y, logSwi.u1) annotation (Line(points={{-338,10},{-320,10},{-320,
          -22},{-302,-22}},   color={255,0,255}));
  connect(u1FreSta, logSwi.u3) annotation (Line(points={{-460,-70},{-320,-70},{-320,
          -38},{-302,-38}},         color={255,0,255}));
  connect(logSwi.y, or3.u3) annotation (Line(points={{-278,-30},{-240,-30},{-240,
          34},{-222,34}},   color={255,0,255}));
  connect(logSwi.y, falEdg1.u)
    annotation (Line(points={{-278,-30},{-222,-30}},   color={255,0,255}));
  connect(falEdg1.y, lat1.clr) annotation (Line(points={{-198,-30},{-180,-30},{-180,
          36},{-142,36}},         color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,-80},{-240,-80},{-240,34},
          {-222,34}},       color={255,0,255}));
  connect(u1RelFan, and2.u1)
    annotation (Line(points={{-460,-330},{318,-330}}, color={255,0,255}));
  connect(lat1.y, norSta1.u) annotation (Line(points={{-118,42},{20,42},{20,-350},
          {118,-350}}, color={255,0,255}));
  connect(norSta1.y, and2.u2) annotation (Line(points={{142,-350},{160,-350},{160,
          -338},{318,-338}}, color={255,0,255}));
  connect(u1RetFan, and1.u1)
    annotation (Line(points={{-460,-220},{318,-220}}, color={255,0,255}));
  connect(lat1.y, norSta2.u) annotation (Line(points={{-118,42},{20,42},{20,-240},
          {118,-240}}, color={255,0,255}));
  connect(norSta2.y, and1.u2) annotation (Line(points={{142,-240},{160,-240},{160,
          -228},{318,-228}}, color={255,0,255}));
  connect(lat1.y, norSta3.u) annotation (Line(points={{-118,42},{20,42},{20,-120},
          {118,-120}}, color={255,0,255}));
  connect(u1SupFan, and3.u1)
    annotation (Line(points={{-460,-140},{318,-140}}, color={255,0,255}));
  connect(norSta3.y, and3.u2) annotation (Line(points={{142,-120},{160,-120},{160,
          -148},{318,-148}}, color={255,0,255}));
  connect(and2.y, y1RelFan)
    annotation (Line(points={{342,-330},{460,-330}}, color={255,0,255}));
  connect(and1.y, y1RetFan)
    annotation (Line(points={{342,-220},{460,-220}}, color={255,0,255}));
  connect(and3.y, y1SupFan)
    annotation (Line(points={{342,-140},{460,-140}}, color={255,0,255}));
annotation (defaultComponentName="sinAHUFrePro",
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
          textString="uOutDamPosMin"),
        Text(
          extent={{-96,62},{-54,42}},
          textColor={255,0,255},
          textString="u1FreSta",
          visible=not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat),
        Text(
          extent={{-102,178},{-46,162}},
          textColor={0,0,127},
          textString="uOutDam"),
        Text(
          extent={{-98,150},{-52,134}},
          textColor={0,0,127},
          textString="uHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,120},{-54,100}},
          textColor={0,0,127},
          textString="uRetDam"),
        Text(
          extent={{-96,90},{-58,74}},
          textColor={0,0,127},
          textString="TAirSup"),
        Text(
          extent={{-100,-120},{-50,-136}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uRelFan"),
        Text(
          extent={{-100,-70},{-50,-86}},
          textColor={0,0,127},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir or
                   buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="uRetFan"),
        Text(
          extent={{-98,-20},{-50,-36}},
          textColor={0,0,127},
          textString="uSupFan"),
        Text(
          extent={{-96,-182},{-66,-198}},
          textColor={0,0,127},
          visible=have_hotWatCoi,
          textString="TAirMix"),
        Text(
          extent={{-96,-150},{-54,-166}},
          textColor={0,0,127},
          textString="uCooCoi"),
        Text(
          extent={{48,162},{96,144}},
          textColor={0,0,127},
          textString="yRetDam"),
        Text(
          extent={{48,120},{96,104}},
          textColor={0,0,127},
          textString="yOutDam"),
        Text(
          extent={{50,58},{96,42}},
          textColor={0,0,127},
          textString="ySupFan"),
        Text(
          extent={{52,0},{98,-16}},
          textColor={0,0,127},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir or
                   buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="yRetFan"),
        Text(
          extent={{50,-40},{102,-56}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yRelFan"),
        Text(
          extent={{52,-80},{96,-96}},
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
          visible=have_hotWatCoi),
        Text(
          extent={{-96,32},{-34,8}},
          textColor={255,0,255},
          visible=not (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NO
               or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.With_reset_switch_NC),
          textString="u1SofSwiRes"),
        Text(
          extent={{24,200},{96,180}},
          textColor={255,0,255},
          textString="y1EneCHWPum"),
        Text(
          extent={{70,-178},{98,-196}},
          textColor={255,127,0},
          textString="yAla"),
        Text(
          extent={{42,-140},{96,-156}},
          textColor={255,127,0},
          textString="yFreProSta"),
        Text(
          extent={{-96,2},{-54,-18}},
          textColor={255,0,255},
          visible=not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
          textString="u1SupFan"),
        Text(
          extent={{-96,-48},{-54,-68}},
          textColor={255,0,255},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="u1RetFan"),
        Text(
          extent={{-96,-98},{-54,-118}},
          textColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="u1RelFan"),
        Text(
          extent={{54,80},{96,60}},
          textColor={255,0,255},
          visible=not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
          textString="y1SupFan"),
        Text(
          extent={{54,30},{96,10}},
          textColor={255,0,255},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="y1RetFan"),
        Text(
          extent={{54,-20},{96,-40}},
          textColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="y1RelFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-640},{440,640}}),
          graphics={
        Text(
          extent={{-332,132},{-238,112}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,310},{-236,290}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,612},{-248,592}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 1")}),
 Documentation(info="<html>
<p>
Freeze protection sequence for single zone AHU system. It is developed based on Section
5.18.11 of ASHRAE Guideline 36, May 2020.
</p>
<ol>
<li>
If the supply air temperature <code>TAirSup</code> drops below 4 &deg;C (40 &deg;F)
for 5 minutes, send two (or more, as required to ensure that heating plant is active,
<code>minHotWatReq</code>) heating hot-water plant requests, override the outdoor
air damper to the minimum position, and modulate the heating coil to maintain a suppy
air temperature of at least 6 &deg;C (42 &deg;F).
Disable this function when supply air temperature rises above 7 &deg;C (45 &deg;F) for
5 minutes.
</li>
<li>
If the supply air temperature <code>TAirSup</code> drops below 3 &deg;C (38 &deg;F)
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
or if supply air temperature drops below 3 &deg;C (38 &deg;F) for 15 minutes or
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
