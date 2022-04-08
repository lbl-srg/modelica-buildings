within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block FreezeProtection
  "Freeze protection sequence for multizone air handling unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection minOADes
    "Design of minimum outdoor air and economizer function";
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has heating coil";
  parameter Boolean have_freSta=false
    "True: the system has a physical freeze stat";
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
    annotation (Placement(transformation(extent={{-480,440},{-440,480}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-480,400},{-440,440}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{-480,320},{-440,360}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{-480,240},{-440,280}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1MinOutDamPos
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{-480,200},{-440,240}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer return air damper position"
    annotation (Placement(transformation(extent={{-480,70},{-440,110}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,30},{-440,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreSta if have_freSta
    "Freeze protection stat signal"
    annotation (Placement(transformation(extent={{-480,-110},{-440,-70}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreStaRes if have_freSta
    "Freeze protection stat reset signal"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSofSwiRes if not have_freSta
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,-200},{-440,-160}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-480,-278},{-440,-238}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns "Return fan speed"
    annotation (Placement(transformation(extent={{-480,-318},{-440,-278}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefs "Relief fan speed"
    annotation (Placement(transformation(extent={{-480,-358},{-440,-318}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil position"
    annotation (Placement(transformation(extent={{-480,-398},{-440,-358}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-456},{-440,-416}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage index"
    annotation (Placement(transformation(extent={{440,10},{480,50}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{440,-50},{480,-10}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{440,-110},{480,-70}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{440,-150},{480,-110}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{440,-190},{480,-150}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1MinOutDamPos
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{440,-230},{480,-190}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{440,-270},{480,-230}}),
        iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{440,-310},{480,-270}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefs
    "Relief fan speed"
    annotation (Placement(transformation(extent={{440,-350},{480,-310}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil position"
    annotation (Placement(transformation(extent={{440,-390},{480,-350}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi
    "Heating coil position setpoint"
    annotation (Placement(transformation(extent={{440,-460},{480,-420}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-510},{480,-470}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla "Alarm level"
    annotation (Placement(transformation(extent={{440,-560},{480,-520}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4.4,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,510},{-340,530}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,510},{-280,530}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq if have_hotWatCoi
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,502},{80,522}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,530},{0,550}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,430},{80,450}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,380},{-300,400}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1 if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,360},{140,380}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys)
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,300},{-360,320}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,502},{-40,522}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,300},{-300,320}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,292},{-240,312}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3.3,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,160},{-360,180}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,160},{-320,180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0)
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,152},{-280,172}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,310},{60,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam2 if minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{120,240},{140,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,108},{140,128}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3)
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_hotWatCoi
    "Zero request"
    annotation (Placement(transformation(extent={{-20,480},{0,500}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,-20},{-280,0}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,-60},{-340,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,-60},{-280,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-220,-68},{-200,-48}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not have_freSta
    "Constant false"
    annotation (Placement(transformation(extent={{-300,-120},{-280,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,-68},{-120,-48}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-260},{140,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-300},{140,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan if have_reliefs
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-340},{140,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,-140},{340,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-380},{140,-360}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3 if have_hotWatCoi
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-500},{340,-480}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_hotWatCoi
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-492},{-120,-472}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if have_hotWatCoi
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-440},{-280,-420}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_hotWatCoi
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-410},{60,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_hotWatCoi
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-410},{-120,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_hotWatCoi
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-450},{340,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-550},{340,-530}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-542},{-120,-522}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,-68},{400,-48}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{120,-68},{140,-48}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,152},{400,172}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{120,152},{140,172}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600)
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam if minOADes ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{320,-180},{340,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,-12},{60,8}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,152},{-160,172}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,112},{-200,132}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-100,502},{-80,522}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,-100},{340,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_hotWatCoi
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,380},{-360,400}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Alarm level"
    annotation (Placement(transformation(extent={{380,20},{400,40}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
    "Alarm level"
    annotation (Placement(transformation(extent={{320,270},{340,290}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2)
    "Stage 2 freeze protection"
    annotation (Placement(transformation(extent={{160,320},{180,340}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Alarm level"
    annotation (Placement(transformation(extent={{260,460},{280,480}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 freeze protection"
    annotation (Placement(transformation(extent={{140,530},{160,550}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=0)
    "Stage 0 freeze protection"
    annotation (Placement(transformation(extent={{140,430},{160,450}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam3
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=false)
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "False"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minOutDam1
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on position"
    annotation (Placement(transformation(extent={{320,-220},{340,-200}})));

protected
  parameter Boolean have_common=
    minOADes ==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.SingleDamper
    "True: have common damper";
  parameter Boolean have_returns=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir or
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "True: have return fan to control building pressure";
  parameter Boolean have_reliefs=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "True: have relief fan to control building pressure";

equation
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-338,520},{-302,520}}, color={255,0,255}));
  connect(TSup, lesThr.u) annotation (Line(points={{-460,50},{-420,50},{-420,520},
          {-362,520}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,540},{40,540},{
          40,520},{58,520}}, color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,460},{0,460},
          {0,448},{58,448}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,390},{-322,390}}, color={0,0,127}));
  connect(TSup, heaCoiCon1.u_m) annotation (Line(points={{-460,50},{-420,50},{-420,
          360},{-310,360},{-310,378}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,390},{0,390},
          {0,378},{118,378}}, color={0,0,127}));
  connect(TSup, greThr.u) annotation (Line(points={{-460,50},{-420,50},{-420,310},
          {-382,310}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,310},{-322,310}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,302},{-262,302}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,302},{-70,302},{-70,
          506},{-62,506}}, color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,512},{58,512}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,512},{20,512},{20,440},
          {58,440}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,512},{20,512},{20,370},
          {118,370}}, color={255,0,255}));
  connect(TSup, lesThr1.u) annotation (Line(points={{-460,50},{-420,50},{-420,170},
          {-382,170}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,170},{-342,170}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,162},{-302,162}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,320},{80,320},{80,308},
          {118,308}}, color={0,0,127}));
  connect(con.y, minOutDam2.u1) annotation (Line(points={{62,320},{80,320},{80,258},
          {118,258}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-58,30},{-20,30},{-20,126},
          {118,126}}, color={0,0,127}));
  connect(uRetDamPos, retDam2.u3) annotation (Line(points={{-460,90},{-120,90},{
          -120,110},{118,110}},  color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,60},{100,60},{100,
          38},{118,38}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,170},{-350,170},{-350,
          -10},{-302,-10}}, color={255,0,255}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-338,-50},{-302,-50}},   color={255,0,255}));
  connect(TSup, lesThr2.u) annotation (Line(points={{-460,50},{-420,50},{-420,-50},
          {-362,-50}},  color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,-18},{-240,-18},{-240,
          -50},{-222,-50}},   color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,-58},{-222,-58}},   color={255,0,255}));
  connect(uFreSta, or3.u3) annotation (Line(points={{-460,-90},{-240,-90},{-240,
          -66},{-222,-66}},   color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,-110},{-240,-110},{-240,
          -66},{-222,-66}},   color={255,0,255}));
  connect(or3.y, lat1.u)
    annotation (Line(points={{-198,-58},{-142,-58}},   color={255,0,255}));
  connect(uFreStaRes, lat1.clr) annotation (Line(points={{-460,-140},{-160,-140},
          {-160,-64},{-142,-64}},   color={255,0,255}));
  connect(uSofSwiRes, lat1.clr) annotation (Line(points={{-460,-180},{-160,-180},
          {-160,-64},{-142,-64}},   color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-250},
          {118,-250}},       color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-290},
          {118,-290}},       color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-330},
          {118,-330}},       color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,-220},{40,-220},{40,
          -242},{118,-242}}, color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,-220},{40,-220},{40,
          -282},{118,-282}}, color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,-220},{40,-220},{40,
          -322},{118,-322}}, color={0,0,127}));
  connect(uSupFanSpe, supFan.u3) annotation (Line(points={{-460,-258},{118,-258}},
          color={0,0,127}));
  connect(uRetFanSpe, retFan.u3) annotation (Line(points={{-460,-298},{118,-298}},
          color={0,0,127}));
  connect(uRelFanSpe, relFan.u3) annotation (Line(points={{-460,-338},{118,-338}},
          color={0,0,127}));
  connect(supFan.y, ySupFanSpe)
    annotation (Line(points={{142,-250},{460,-250}}, color={0,0,127}));
  connect(relFan.y, yRelFanSpe)
    annotation (Line(points={{142,-330},{460,-330}}, color={0,0,127}));
  connect(retFan.y, yRetFanSpe)
    annotation (Line(points={{142,-290},{460,-290}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,-220},{40,-220},{40,
          -122},{318,-122}}, color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-130},
          {318,-130}},       color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-378},{118,-378}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-370},
          {118,-370}},       color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-58,30},{-20,30},{-20,-362},
          {118,-362}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-482},{318,-482}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,-58},{20,-58},
          {20,-490},{318,-490}}, color={255,0,255}));
  connect(TMix, max1.u2) annotation (Line(points={{-460,-436},{-302,-436}},
          color={0,0,127}));
  connect(TSup, max1.u1) annotation (Line(points={{-460,50},{-420,50},{-420,-424},
          {-302,-424}}, color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-430},{50,-430},
          {50,-412}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-400},{38,-400}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-400},{100,-400},
          {100,-432},{318,-432}}, color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,-58},{20,-58},{20,
          -440},{318,-440}},    color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-540},
          {318,-540}},       color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-532},{318,-532}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,-58},{118,-58}},   color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{142,-58},{378,-58}},   color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,162},{378,162}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,162},{-270,162},{-270,
          130},{-262,130}}, color={255,0,255}));
  connect(lat1.y, minOutDam.u2) annotation (Line(points={{-118,-58},{20,-58},{20,
          -170},{318,-170}},    color={255,0,255}));
  connect(con3.y, minOutDam.u1) annotation (Line(points={{-118,-220},{40,-220},{
          40,-162},{318,-162}}, color={0,0,127}));
  connect(uOutDamPos, minVen.u3) annotation (Line(points={{-460,420},{0,420},{0,
          432},{58,432}}, color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,440},{100,440},{100,
          292},{118,292}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,300},{270,300},{270,
          -138},{318,-138}}, color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,490},{40,490},
          {40,504},{58,504}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,-2},{100,-2},{100,
          22},{118,22}},   color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,30},{210,30},{210,
          -548},{318,-548}}, color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-540},{460,-540}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,512},{230,
          512},{230,-498},{318,-498}}, color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-490},{460,-490}}, color={255,127,0}));
  connect(minOutDam2.y, minOutDam.u3) annotation (Line(points={{142,250},{220,250},
          {220,-178},{318,-178}}, color={0,0,127}));
  connect(minOutDam.y, yMinOutDamPos)
    annotation (Line(points={{342,-170},{460,-170}}, color={0,0,127}));
  connect(uMinOutDamPos, minOutDam2.u3) annotation (Line(points={{-460,260},{60,
          260},{60,242},{118,242}}, color={0,0,127}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,340},{0,340},{0,362},
          {118,362}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,370},{280,370},
          {280,-448},{318,-448}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-440},{460,-440}}, color={0,0,127}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,162},{-182,162}}, color={255,0,255}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,122},{-222,122}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,122},{-190,122},
          {-190,156},{-182,156}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,162},{20,162},{20,300},
          {118,300}}, color={255,0,255}));
  connect(lat2.y, minOutDam2.u2) annotation (Line(points={{-158,162},{20,162},{20,
          250},{118,250}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,162},{118,162}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,162},{20,162},{20,118},
          {118,118}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,162},{20,162},{20,30},
          {118,30}},  color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,512},{-102,512}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-78,512},{-62,512}}, color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-90},
          {318,-90}},        color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,-220},{40,-220},{40,
          -82},{318,-82}},   color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,118},{260,118},{260,
          -98},{318,-98}},   color={0,0,127}));
  connect(retDam.y, yRetDamPos)
    annotation (Line(points={{342,-90},{460,-90}},   color={0,0,127}));
  connect(lat1.y, yEneCHWPum) annotation (Line(points={{-118,-58},{20,-58},{20,-30},
          {460,-30}}, color={255,0,255}));
  connect(outDam.y, yOutDamPos)
    annotation (Line(points={{342,-130},{460,-130}}, color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-370},{460,-370}}, color={0,0,127}));
  connect(conInt1.y, intSwi2.u1) annotation (Line(points={{62,60},{290,60},{290,
          38},{378,38}}, color={255,127,0}));
  connect(lat1.y, intSwi2.u2) annotation (Line(points={{-118,-58},{20,-58},{20,-30},
          {292,-30},{292,30},{378,30}}, color={255,0,255}));
  connect(lat2.y, intSwi4.u2) annotation (Line(points={{-158,162},{20,162},{20,280},
          {318,280}}, color={255,0,255}));
  connect(conInt6.y, intSwi4.u1) annotation (Line(points={{182,330},{290,330},{290,
          288},{318,288}}, color={255,127,0}));
  connect(intSwi4.y, intSwi2.u3) annotation (Line(points={{342,280},{360,280},{360,
          22},{378,22}}, color={255,127,0}));
  connect(lat.y, intSwi5.u2) annotation (Line(points={{-38,512},{20,512},{20,470},
          {258,470}}, color={255,0,255}));
  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{282,470},{300,470},{300,
          272},{318,272}}, color={255,127,0}));
  connect(conInt7.y, intSwi5.u1) annotation (Line(points={{162,540},{240,540},{240,
          478},{258,478}}, color={255,127,0}));
  connect(intSwi2.y, yFreProSta)
    annotation (Line(points={{402,30},{460,30}}, color={255,127,0}));

  connect(conInt8.y, intSwi5.u3) annotation (Line(points={{162,440},{200,440},{200,
          462},{258,462}}, color={255,127,0}));
  connect(endStaTwo.y, or2.u2) annotation (Line(points={{-198,122},{-190,122},{-190,
          504},{-102,504}},      color={255,0,255}));
  connect(u1MinOutDamPos, minOutDam3.u3) annotation (Line(points={{-460,220},{-20,
          220},{-20,212},{118,212}}, color={255,0,255}));
  connect(lat2.y, minOutDam3.u2) annotation (Line(points={{-158,162},{20,162},{20,
          220},{118,220}}, color={255,0,255}));
  connect(con5.y, minOutDam3.u1) annotation (Line(points={{-18,240},{0,240},{0,228},
          {118,228}}, color={255,0,255}));
  connect(lat1.y, minOutDam1.u2) annotation (Line(points={{-118,-58},{20,-58},{20,
          -210},{318,-210}}, color={255,0,255}));
  connect(minOutDam1.y, y1MinOutDamPos)
    annotation (Line(points={{342,-210},{460,-210}}, color={255,0,255}));
  connect(minOutDam3.y, minOutDam1.u3) annotation (Line(points={{142,220},{200,220},
          {200,-218},{318,-218}}, color={255,0,255}));
  connect(con5.y, minOutDam1.u1) annotation (Line(points={{-18,240},{0,240},{0,-202},
          {318,-202}}, color={255,0,255}));
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
          extent={{-96,32},{-54,12}},
          lineColor={255,0,255},
          textString="uFreSta",
          visible=have_freSta),
        Text(
          extent={{-96,178},{-32,162}},
          lineColor={0,0,127},
          textString="uOutDamPos"),
        Text(
          extent={{-98,150},{-52,134}},
          lineColor={0,0,127},
          textString="uHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,120},{-20,102}},
          lineColor={0,0,127},
          textString="uMinOutDamPos",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow),
        Text(
          extent={{-96,78},{-32,62}},
          lineColor={0,0,127},
          textString="uRetDamPos"),
        Text(
          extent={{-98,60},{-68,44}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{-96,-120},{-32,-136}},
          lineColor={0,0,127},
          textString="uRelFanSpe",
          visible=have_reliefs),
        Text(
          extent={{-96,-90},{-32,-106}},
          lineColor={0,0,127},
          textString="uRetFanSpe",
          visible=have_returns),
        Text(
          extent={{-96,-62},{-32,-78}},
          lineColor={0,0,127},
          textString="uSupFanSpe"),
        Text(
          extent={{-94,-182},{-70,-198}},
          lineColor={0,0,127},
          textString="TMix",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,-150},{-54,-166}},
          lineColor={0,0,127},
          textString="uCooCoi"),
        Text(
          extent={{30,160},{94,144}},
          lineColor={0,0,127},
          textString="yRetDamPos"),
        Text(
          extent={{32,120},{96,104}},
          lineColor={0,0,127},
          textString="yOutDamPos"),
        Text(
          extent={{20,80},{98,62}},
          lineColor={0,0,127},
          textString="yMinOutDamPos",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersAirflow),
        Text(
          extent={{32,20},{96,4}},
          lineColor={0,0,127},
          textString="ySupFanSpe"),
        Text(
          extent={{34,-10},{98,-26}},
          lineColor={0,0,127},
          textString="yRetFanSpe",
          visible=have_returns),
        Text(
          extent={{34,-40},{98,-56}},
          lineColor={0,0,127},
          textString="yRelFanSpe",
          visible=have_reliefs),
        Text(
          extent={{52,-80},{96,-96}},
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
          extent={{-96,2},{-36,-24}},
          lineColor={255,0,255},
          textString="uFreStaRes",
          visible=have_freSta),
        Text(
          extent={{-96,-28},{-34,-52}},
          lineColor={255,0,255},
          textString="uSofSwiRes",
          visible=not have_freSta),
        Text(
          extent={{24,200},{96,180}},
          lineColor={255,0,255},
          textString="yEneCHWPum"),
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
          extent={{16,62},{96,42}},
          lineColor={255,0,255},
          textString="y1MinOutDamPos",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-560},{440,560}}),
          graphics={
        Text(
          extent={{-332,32},{-238,12}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,210},{-236,190}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,562},{-248,542}},
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
If the supply air temperature <code>TSup</code> drops below 4.4 &deg;C (40 &deg;F)
for 5 minutes, send two (or more, as required to ensure that heating plant is active,
<code>minHotWatReq</code>) heating hot-water plant requests, override the outdoor
air damper to the minimum position, and modulate the heating coil to maintain a suppy
air temperature of at least 6 &deg;C (42 &deg;F).
Disable this function when supply air temperature rises above 7 &deg;C (45 &deg;F) for
5 minutes.
</li>
<li>
If the supply air temperature <code>TSup</code> drops below 3.3 &deg;C (38 &deg;F)
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
Upon signal from the freeze-stat (if installed, <code>have_freSta=true</code>),
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
