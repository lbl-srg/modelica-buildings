within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block FreezeProtection
  "Freeze protection sequence for single zone air handling unit"

  parameter Boolean have_frePro=true
    "True: enable freeze protection"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Type of building pressure control system"
    annotation (__cdl(ValueInReference=false), Dialog(enable=have_frePro));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation (__cdl(ValueInReference=false), Dialog(enable=have_frePro));
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil"
    annotation (__cdl(ValueInReference=false), Dialog(enable=have_frePro));
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (__cdl(ValueInReference=true),
                Dialog(enable=have_hotWatCoi and have_frePro));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
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
    "Minimum economizer damper position limit as returned by the damper position limits  sequence"
    annotation (Placement(transformation(extent={{-480,590},{-440,630}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,550},{-440,590}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{-480,470},{-440,510}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer return air damper commanded position"
    annotation (Placement(transformation(extent={{-480,270},{-440,310}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_frePro
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,230},{-440,270}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta if freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS and
    have_frePro
    "Freeze protection stat signal. The stat is normally close (the input is normally true), when enabling freeze protection, the input becomes false"
    annotation (Placement(transformation(extent={{-480,30},{-440,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes if (freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat or freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
     and have_frePro
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,-50},{-440,-10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{-480,-110},{-440,-70}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-168},{-440,-128}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{-480,-220},{-440,-180}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-288},{-440,-248}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{-480,-340},{-440,-300}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{-480,-408},{-440,-368}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{-480,-488},{-440,-448}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi and
    have_frePro
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-576},{-440,-536}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage index"
    annotation (Placement(transformation(extent={{440,210},{480,250}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
 if have_frePro
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{440,130},{480,170}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{440,50},{480,90}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,-30},{480,10}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{440,-110},{480,-70}}),
        iconTransformation(extent={{100,48},{140,88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{440,-160},{480,-120}}),
        iconTransformation(extent={{100,28},{140,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{440,-220},{480,-180}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{440,-280},{480,-240}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{440,-340},{480,-300}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{440,-400},{480,-360}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{440,-480},{480,-440}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{440,-580},{480,-540}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-660},{480,-620}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{440,-710},{480,-670}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,660},{-340,680}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,660},{-280,680}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq
    if have_hotWatCoi and have_frePro
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,652},{80,672}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_hotWatCoi and have_frePro
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,690},{0,710}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen if have_frePro
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,580},{80,600}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi and have_frePro
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,530},{-300,550}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1
    if have_hotWatCoi and have_frePro
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,510},{140,530}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys) if have_frePro
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,450},{-360,470}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat if have_frePro
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,652},{-40,672}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,450},{-300,470}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne if have_frePro
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,442},{-240,462}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,360},{-360,380}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,360},{-320,380}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0) if have_frePro
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,352},{-280,372}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2 if have_frePro
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,440},{140,460}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.0)
               if have_frePro
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,460},{60,480}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2 if have_frePro
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,308},{140,328}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=1.0)
               if have_frePro
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_frePro
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3) if have_frePro
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,228},{60,248}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_hotWatCoi and have_frePro
    "Zero request"
    annotation (Placement(transformation(extent={{-20,630},{0,650}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,160},{-280,180}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys) if have_frePro
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-400,120},{-380,140}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300) if have_frePro
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,120},{-280,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 if have_frePro
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-240,112},{-220,132}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_frePro
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,112},{-120,132}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Supply fan speed"
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan if (buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-390},{140,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0) if have_frePro
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-470},{140,-450}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3
    if have_hotWatCoi and have_frePro
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-650},{340,-630}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_hotWatCoi and have_frePro
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-642},{-120,-622}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    if have_hotWatCoi and have_frePro
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-560},{-280,-540}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi and have_frePro
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-530},{60,-510}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_hotWatCoi and have_frePro
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-530},{-120,-510}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_hotWatCoi and
    not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-570},{340,-550}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-700},{340,-680}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) if have_frePro
               "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-692},{-120,-672}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    if have_frePro
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,112},{400,132}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_frePro
    "Logical not"
    annotation (Placement(transformation(extent={{320,112},{340,132}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    if have_frePro
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,352},{400,372}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_frePro
    "Logical not"
    annotation (Placement(transformation(extent={{120,352},{140,372}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600) if have_frePro
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,320},{-240,340}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0) if have_frePro
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,166},{60,186}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if have_frePro
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,352},{-160,372}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo if have_frePro
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,312},{-200,332}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if have_frePro
                                            "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-100,652},{-80,672}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg if have_frePro
    "Switch from stage 2 to stage 1"
    annotation (Placement(transformation(extent={{-140,620},{-120,640}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam if not freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,60},{340,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_hotWatCoi and have_frePro
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,530},{-360,550}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{380,220},{400,240}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{320,420},{340,440}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2) if have_frePro
    "Stage 2 freeze protection"
    annotation (Placement(transformation(extent={{160,470},{180,490}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5 if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{260,610},{280,630}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1) if have_frePro
    "Stage 1 freeze protection"
    annotation (Placement(transformation(extent={{140,680},{160,700}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=0) if have_frePro
    "Stage 0 freeze protection"
    annotation (Placement(transformation(extent={{140,580},{160,600}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "Reset the freeze protection by the physical reset switch in freeze stat"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not norFal if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "The output is normally false"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
     and have_frePro
    "Constant false"
    annotation (Placement(transformation(extent={{-300,-10},{-280,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta1 if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and have_frePro
    "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-350},{140,-330}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Disable relief fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-330},{340,-310}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Disable return fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-210},{340,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta2 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and have_frePro
    "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Not norSta3 if have_frePro
                                                 "Not in stage 3"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 if not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Disable supply fan when in stage 3"
    annotation (Placement(transformation(extent={{320,-100},{340,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(final k=1)
 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,30},{340,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=1)
 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,-52},{340,-32}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-130},{340,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=1)
 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-174},{140,-154}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-240},{340,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(final k=1) if (
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-300},{140,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5 if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling conditional connection"
    annotation (Placement(transformation(extent={{320,-360},{340,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai5(final k=1) if (
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-420},{140,-400}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai6(final k=1)
 if freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     and have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{120,-500},{140,-480}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai7(final k=1)
 if have_hotWatCoi and (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment
     or not have_frePro)
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{320,-600},{340,-580}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre if have_frePro
    "Break loop"
    annotation (Placement(transformation(extent={{-200,112},{-180,132}})));
  CDL.Integers.Sources.Constant                        conInt9(final k=0)
    if not have_frePro "Dummy constant"
    annotation (Placement(transformation(extent={{380,270},{400,290}})));
  CDL.Integers.Sources.Constant                        conInt10(final k=0)
    if not have_frePro "Dummy constant"
    annotation (Placement(transformation(extent={{380,-680},{400,-660}})));
  CDL.Continuous.MultiplyByParameter                        gai8(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-80},{-280,-60}})));
  CDL.Continuous.MultiplyByParameter                        gai9(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  CDL.Continuous.MultiplyByParameter                        gai10(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-190},{-280,-170}})));
  CDL.Continuous.MultiplyByParameter                        gai11(final k=1)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
     and not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-310},{-280,-290}})));
  CDL.Continuous.MultiplyByParameter                        gai12(final k=1)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
     and not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-440},{-280,-420}})));
  CDL.Continuous.MultiplyByParameter                        gai13(final k=1)
    if not have_frePro
    "Dummy block for enabling and disabling the conditional connection"
    annotation (Placement(transformation(extent={{-300,-510},{-280,-490}})));
equation
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-338,670},{-302,670}}, color={255,0,255}));
  connect(TAirSup, lesThr.u) annotation (Line(points={{-460,250},{-420,250},{-420,
          670},{-362,670}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,700},{40,700},{
          40,670},{58,670}}, color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,610},{0,610},
          {0,598},{58,598}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,540},{-322,540}}, color={0,0,127}));
  connect(TAirSup, heaCoiCon1.u_m) annotation (Line(points={{-460,250},{-420,250},
          {-420,510},{-310,510},{-310,528}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,540},{0,540},
          {0,528},{118,528}}, color={0,0,127}));
  connect(TAirSup, greThr.u) annotation (Line(points={{-460,250},{-420,250},{-420,
          460},{-382,460}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,460},{-322,460}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,452},{-262,452}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,452},{-70,452},{-70,
          656},{-62,656}}, color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,662},{58,662}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,662},{20,662},{20,590},
          {58,590}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,662},{20,662},{20,520},
          {118,520}}, color={255,0,255}));
  connect(TAirSup, lesThr1.u) annotation (Line(points={{-460,250},{-420,250},{-420,
          370},{-382,370}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,370},{-342,370}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,362},{-302,362}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,470},{80,470},{80,458},
          {118,458}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-58,210},{-20,210},{-20,
          326},{118,326}}, color={0,0,127}));
  connect(uRetDam, retDam2.u3) annotation (Line(points={{-460,290},{-110,290},{-110,
          310},{118,310}}, color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,238},{100,238},{100,
          218},{118,218}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,370},{-350,370},{-350,
          170},{-302,170}}, color={255,0,255}));
  connect(TAirSup, lesThr2.u) annotation (Line(points={{-460,250},{-420,250},{
          -420,130},{-402,130}}, color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,162},{-260,162},{-260,
          130},{-242,130}},   color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,122},{-242,122}},   color={255,0,255}));
  connect(u1SofSwiRes, lat1.clr) annotation (Line(points={{-460,-30},{-160,-30},
          {-160,116},{-142,116}}, color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,122},{20,122},{20,-260},
          {118,-260}},       color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,122},{20,122},{20,-380},
          {118,-380}},       color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,10},{40,10},{40,-132},
          {158,-132}},       color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,10},{40,10},{40,-252},
          {118,-252}},       color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,10},{40,10},{40,-372},
          {118,-372}},       color={0,0,127}));
  connect(uSupFan, supFan.u3)
    annotation (Line(points={{-460,-148},{158,-148}}, color={0,0,127}));
  connect(uRetFan, retFan.u3)
    annotation (Line(points={{-460,-268},{118,-268}}, color={0,0,127}));
  connect(uRelFan, relFan.u3)
    annotation (Line(points={{-460,-388},{118,-388}}, color={0,0,127}));
  connect(supFan.y, ySupFan)
    annotation (Line(points={{182,-140},{460,-140}}, color={0,0,127}));
  connect(relFan.y, yRelFan)
    annotation (Line(points={{142,-380},{460,-380}}, color={0,0,127}));
  connect(retFan.y, yRetFan)
    annotation (Line(points={{142,-260},{460,-260}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,10},{40,10},{40,-2},
          {318,-2}},         color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,122},{20,122},{20,-10},
          {318,-10}},        color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-468},{118,-468}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,122},{20,122},{20,-460},
          {118,-460}},       color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-58,210},{-20,210},{-20,-452},
          {118,-452}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-632},{318,-632}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,122},{20,122},
          {20,-640},{318,-640}}, color={255,0,255}));
  connect(TAirMix, max1.u2)
    annotation (Line(points={{-460,-556},{-302,-556}}, color={0,0,127}));
  connect(TAirSup, max1.u1) annotation (Line(points={{-460,250},{-420,250},{-420,
          -544},{-302,-544}}, color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-550},{50,-550},
          {50,-532}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-520},{38,-520}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-520},{100,-520},
          {100,-552},{318,-552}}, color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,122},{20,122},{20,
          -560},{318,-560}},    color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,122},{20,122},{20,-690},
          {318,-690}},       color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-682},{318,-682}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,122},{318,122}},   color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{342,122},{378,122}},   color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,362},{378,362}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,362},{-270,362},{-270,
          330},{-262,330}}, color={255,0,255}));
  connect(uOutDam, minVen.u3) annotation (Line(points={{-460,570},{-100,570},{-100,
          582},{58,582}},  color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,590},{100,590},{100,
          442},{118,442}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,450},{270,450},{270,
          -18},{318,-18}},   color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,640},{40,640},
          {40,654},{58,654}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,176},{100,176},{100,
          202},{118,202}}, color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,210},{210,210},{210,
          -698},{318,-698}}, color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-690},{460,-690}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,662},{230,
          662},{230,-648},{318,-648}}, color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-640},{460,-640}}, color={255,127,0}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,490},{0,490},{0,512},
          {118,512}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,520},{280,520},
          {280,-568},{318,-568}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-560},{460,-560}}, color={0,0,127}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,322},{-222,322}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,322},{-190,322},
          {-190,356},{-182,356}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,362},{20,362},{20,450},
          {118,450}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,362},{118,362}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,362},{20,362},{20,318},
          {118,318}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,362},{20,362},{20,210},
          {118,210}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-78,662},{-62,662}}, color={255,0,255}));
  connect(falEdg.y, or2.u2) annotation (Line(points={{-118,630},{-110,630},{-110,
          654},{-102,654}}, color={255,0,255}));
  connect(lat2.y, falEdg.u) annotation (Line(points={{-158,362},{-150,362},{-150,
          630},{-142,630}}, color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,122},{20,122},{20,70},
          {318,70}},         color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,10},{40,10},{40,78},
          {318,78}},         color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,318},{260,318},{260,
          62},{318,62}},     color={0,0,127}));
  connect(retDam.y, yRetDam)
    annotation (Line(points={{342,70},{460,70}},     color={0,0,127}));
  connect(lat1.y, y1EneCHWPum) annotation (Line(points={{-118,122},{248,122},{248,
          150},{460,150}}, color={255,0,255}));
  connect(outDam.y, yOutDam)
    annotation (Line(points={{342,-10},{460,-10}},   color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-460},{460,-460}}, color={0,0,127}));
  connect(conInt1.y, intSwi2.u1) annotation (Line(points={{62,238},{378,238}},
          color={255,127,0}));
  connect(lat1.y, intSwi2.u2) annotation (Line(points={{-118,122},{248,122},{248,
          230},{378,230}},              color={255,0,255}));
  connect(lat2.y, intSwi4.u2) annotation (Line(points={{-158,362},{20,362},{20,430},
          {318,430}}, color={255,0,255}));
  connect(conInt6.y, intSwi4.u1) annotation (Line(points={{182,480},{290,480},{290,
          438},{318,438}}, color={255,127,0}));
  connect(intSwi4.y, intSwi2.u3) annotation (Line(points={{342,430},{360,430},{360,
          222},{378,222}}, color={255,127,0}));
  connect(lat.y, intSwi5.u2) annotation (Line(points={{-38,662},{20,662},{20,620},
          {258,620}}, color={255,0,255}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{282,620},{300,620},{300,
          422},{318,422}}, color={255,127,0}));
  connect(conInt7.y, intSwi5.u1) annotation (Line(points={{162,690},{240,690},{240,
          628},{258,628}}, color={255,127,0}));
  connect(intSwi2.y, yFreProSta)
    annotation (Line(points={{402,230},{460,230}}, color={255,127,0}));
  connect(conInt8.y, intSwi5.u3) annotation (Line(points={{162,590},{200,590},{200,
          612},{258,612}}, color={255,127,0}));
  connect(u1FreSta, norFal.u) annotation (Line(points={{-460,50},{-362,50}},
                                 color={255,0,255}));
  connect(falEdg1.y, lat1.clr) annotation (Line(points={{-198,50},{-160,50},{-160,
          116},{-142,116}},       color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,0},{-260,0},{-260,114},
          {-242,114}},      color={255,0,255}));
  connect(u1RelFan, and2.u1)
    annotation (Line(points={{-460,-320},{318,-320}}, color={255,0,255}));
  connect(lat1.y, norSta1.u) annotation (Line(points={{-118,122},{20,122},{20,-340},
          {118,-340}}, color={255,0,255}));
  connect(norSta1.y, and2.u2) annotation (Line(points={{142,-340},{160,-340},{160,
          -328},{318,-328}}, color={255,0,255}));
  connect(u1RetFan, and1.u1)
    annotation (Line(points={{-460,-200},{318,-200}}, color={255,0,255}));
  connect(lat1.y, norSta2.u) annotation (Line(points={{-118,122},{20,122},{20,-220},
          {118,-220}}, color={255,0,255}));
  connect(norSta2.y, and1.u2) annotation (Line(points={{142,-220},{160,-220},{160,
          -208},{318,-208}}, color={255,0,255}));
  connect(lat1.y, norSta3.u) annotation (Line(points={{-118,122},{20,122},{20,-70},
          {118,-70}},  color={255,0,255}));
  connect(u1SupFan, and3.u1)
    annotation (Line(points={{-460,-90},{318,-90}},   color={255,0,255}));
  connect(norSta3.y, and3.u2) annotation (Line(points={{142,-70},{160,-70},{160,
          -98},{318,-98}},   color={255,0,255}));
  connect(and2.y, y1RelFan)
    annotation (Line(points={{342,-320},{460,-320}}, color={255,0,255}));
  connect(and1.y, y1RetFan)
    annotation (Line(points={{342,-200},{460,-200}}, color={255,0,255}));
  connect(and3.y, y1SupFan)
    annotation (Line(points={{342,-90},{460,-90}},   color={255,0,255}));
  connect(uRetDam, gai4.u) annotation (Line(points={{-460,290},{-110,290},{-110,
          40},{318,40}}, color={0,0,127}));
  connect(gai4.y, yRetDam) annotation (Line(points={{342,40},{360,40},{360,70},{
          460,70}}, color={0,0,127}));
  connect(uOutDam, gai1.u) annotation (Line(points={{-460,570},{-100,570},{-100,
          -42},{318,-42}}, color={0,0,127}));
  connect(gai1.y, yOutDam) annotation (Line(points={{342,-42},{360,-42},{360,-10},
          {460,-10}}, color={0,0,127}));
  connect(u1SupFan, or1.u1) annotation (Line(points={{-460,-90},{300,-90},{300,-120},
          {318,-120}}, color={255,0,255}));
  connect(u1SupFan, or1.u2) annotation (Line(points={{-460,-90},{300,-90},{300,-128},
          {318,-128}}, color={255,0,255}));
  connect(or1.y, y1SupFan) annotation (Line(points={{342,-120},{360,-120},{360,-90},
          {460,-90}}, color={255,0,255}));
  connect(uSupFan, gai2.u) annotation (Line(points={{-460,-148},{100,-148},{100,
          -164},{118,-164}}, color={0,0,127}));
  connect(gai2.y, ySupFan) annotation (Line(points={{142,-164},{200,-164},{200,-140},
          {460,-140}}, color={0,0,127}));
  connect(u1RetFan, or4.u1) annotation (Line(points={{-460,-200},{300,-200},{300,
          -230},{318,-230}}, color={255,0,255}));
  connect(u1RetFan, or4.u2) annotation (Line(points={{-460,-200},{300,-200},{300,
          -238},{318,-238}}, color={255,0,255}));
  connect(or4.y, y1RetFan) annotation (Line(points={{342,-230},{360,-230},{360,-200},
          {460,-200}}, color={255,0,255}));
  connect(uRetFan, gai3.u) annotation (Line(points={{-460,-268},{100,-268},{100,
          -290},{118,-290}}, color={0,0,127}));
  connect(gai3.y, yRetFan) annotation (Line(points={{142,-290},{160,-290},{160,-260},
          {460,-260}}, color={0,0,127}));
  connect(u1RelFan, or5.u1) annotation (Line(points={{-460,-320},{300,-320},{300,
          -350},{318,-350}}, color={255,0,255}));
  connect(u1RelFan, or5.u2) annotation (Line(points={{-460,-320},{300,-320},{300,
          -358},{318,-358}}, color={255,0,255}));
  connect(or5.y, y1RelFan) annotation (Line(points={{342,-350},{360,-350},{360,-320},
          {460,-320}}, color={255,0,255}));
  connect(uRelFan, gai5.u) annotation (Line(points={{-460,-388},{100,-388},{100,
          -410},{118,-410}}, color={0,0,127}));
  connect(gai5.y, yRelFan) annotation (Line(points={{142,-410},{160,-410},{160,-380},
          {460,-380}}, color={0,0,127}));
  connect(uCooCoi, gai6.u) annotation (Line(points={{-460,-468},{100,-468},{100,
          -490},{118,-490}}, color={0,0,127}));
  connect(gai6.y, yCooCoi) annotation (Line(points={{142,-490},{160,-490},{160,-460},
          {460,-460}}, color={0,0,127}));
  connect(uHeaCoi, gai7.u) annotation (Line(points={{-460,490},{0,490},{0,-590},
          {318,-590}}, color={0,0,127}));
  connect(gai7.y, yHeaCoi) annotation (Line(points={{342,-590},{360,-590},{360,-560},
          {460,-560}}, color={0,0,127}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-378,130},{-302,130}}, color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,122},{20,122},{20,-140},
          {158,-140}},       color={255,0,255}));
  connect(or3.y, pre.u)
    annotation (Line(points={{-218,122},{-202,122}}, color={255,0,255}));
  connect(pre.y, lat1.u)
    annotation (Line(points={{-178,122},{-142,122}}, color={255,0,255}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,362},{-182,362}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,662},{-102,662}}, color={255,0,255}));
  connect(norFal.y, falEdg1.u)
    annotation (Line(points={{-338,50},{-222,50}}, color={255,0,255}));
  connect(norFal.y, or3.u3) annotation (Line(points={{-338,50},{-260,50},{-260,
          114},{-242,114}}, color={255,0,255}));
  connect(conInt9.y, yFreProSta) annotation (Line(points={{402,280},{420,280},{420,
          230},{460,230}}, color={255,127,0}));
  connect(conInt10.y, yHotWatPlaReq) annotation (Line(points={{402,-670},{420,-670},
          {420,-640},{460,-640}}, color={255,127,0}));
  connect(uRetDam, gai8.u) annotation (Line(points={{-460,290},{-368,290},{-368,
          -70},{-302,-70}}, color={0,0,127}));
  connect(gai8.y, yRetDam) annotation (Line(points={{-278,-70},{-60,-70},{-60,20},
          {380,20},{380,70},{460,70}}, color={0,0,127}));
  connect(uOutDam, gai9.u) annotation (Line(points={{-460,570},{-410,570},{-410,
          -120},{-302,-120}}, color={0,0,127}));
  connect(gai9.y, yOutDam) annotation (Line(points={{-278,-120},{260,-120},{260,
          -60},{380,-60},{380,-10},{460,-10}}, color={0,0,127}));
  connect(uSupFan, gai10.u) annotation (Line(points={{-460,-148},{-360,-148},{-360,
          -180},{-302,-180}}, color={0,0,127}));
  connect(gai10.y, ySupFan) annotation (Line(points={{-278,-180},{360,-180},{360,
          -140},{460,-140}}, color={0,0,127}));
  connect(uRetFan, gai11.u) annotation (Line(points={{-460,-268},{-360,-268},{-360,
          -300},{-302,-300}}, color={0,0,127}));
  connect(gai11.y, yRetFan) annotation (Line(points={{-278,-300},{360,-300},{360,
          -260},{460,-260}}, color={0,0,127}));
  connect(uRelFan, gai12.u) annotation (Line(points={{-460,-388},{-360,-388},{-360,
          -430},{-302,-430}}, color={0,0,127}));
  connect(gai12.y, yRelFan) annotation (Line(points={{-278,-430},{360,-430},{360,
          -380},{460,-380}}, color={0,0,127}));
  connect(uCooCoi, gai13.u) annotation (Line(points={{-460,-468},{-360,-468},{-360,
          -500},{-302,-500}}, color={0,0,127}));
  connect(gai13.y, yCooCoi) annotation (Line(points={{-278,-500},{360,-500},{360,
          -460},{460,-460}}, color={0,0,127}));
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
          visible=freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
               and have_frePro),
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
          textString="TAirSup",
          visible=have_frePro),
        Text(
          extent={{-100,-120},{-50,-136}},
          textColor={0,0,127},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uRelFan"),
        Text(
          extent={{-100,-70},{-50,-86}},
          textColor={0,0,127},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="uRetFan"),
        Text(
          extent={{-98,-20},{-50,-36}},
          textColor={0,0,127},
          textString="uSupFan"),
        Text(
          extent={{-96,-182},{-66,-198}},
          textColor={0,0,127},
          visible=have_hotWatCoi and have_frePro,
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
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
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
          extent={{-94,32},{-32,8}},
          textColor={255,0,255},
          visible=(freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
               or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
               and have_frePro,
          textString="u1SofSwiRes"),
        Text(
          extent={{24,202},{96,182}},
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
          extent={{-96,2},{-54,-18}},
          textColor={255,0,255},
          visible=not freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
          textString="u1SupFan"),
        Text(
          extent={{-96,-48},{-54,-68}},
          textColor={255,0,255},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
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
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="y1RetFan"),
        Text(
          extent={{54,-20},{96,-40}},
          textColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="y1RelFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-720},{440,720}}),
          graphics={
        Text(
          extent={{-332,212},{-238,192}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,410},{-236,390}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,712},{-248,692}},
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
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
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
