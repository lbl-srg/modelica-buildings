within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block FreezeProtection "Freeze protection sequence for multizone air handling unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function";
  parameter Boolean have_heatingCoil=true
    "True: the AHU has heating coil";
  parameter Boolean have_freezeStat=false
    "True: the system has a physical freeze stat";
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation(Dialog(enable=have_heatingCoil));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating coil controller"
    annotation (Dialog(group="Heating coil controller", enable=have_heatingCoil));
  parameter Real k(unit="1")=1
    "Gain of coil controller"
    annotation (Dialog(group="Heating coil controller", enable=have_heatingCoil));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Heating coil controller",
                       enable=have_heatingCoil and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Heating coil controller",
                       enable=have_heatingCoil and
                              (heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              heaCoiCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Heating coil controller", enable=have_heatingCoil));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Heating coil controller", enable=have_heatingCoil));
  parameter Real Thys(unit="K")=0.25
    "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits  sequence"
    annotation (Placement(transformation(extent={{-480,400},{-440,440}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-480,360},{-440,400}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil position"
    annotation (Placement(transformation(extent={{-480,280},{-440,320}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if not have_common
    "Economizer minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{-480,200},{-440,240}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Economizer return air damper position"
    annotation (Placement(transformation(extent={{-480,80},{-440,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-480,40},{-440,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreSta if have_freezeStat
    "Freeze protection stat signal"
    annotation (Placement(transformation(extent={{-480,-100},{-440,-60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreStaRes if have_freezeStat
    "Freeze protection stat reset signal"
    annotation (Placement(transformation(extent={{-480,-150},{-440,-110}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSofSwiRes if not have_freezeStat
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-480,-190},{-440,-150}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-480,-268},{-440,-228}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{-480,-308},{-440,-268}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefs
    "Relief fan speed"
    annotation (Placement(transformation(extent={{-480,-348},{-440,-308}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil position"
    annotation (Placement(transformation(extent={{-480,-388},{-440,-348}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_heatingCoil
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-480,-446},{-440,-406}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{440,-40},{480,0}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{440,-120},{480,-80}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{440,-170},{480,-130}}),
        iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if not have_common
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{440,-220},{480,-180}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{440,-260},{480,-220}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{440,-300},{480,-260}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefs
    "Relief fan speed"
    annotation (Placement(transformation(extent={{440,-340},{480,-300}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil position"
    annotation (Placement(transformation(extent={{440,-380},{480,-340}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil position setpoint"
    annotation (Placement(transformation(extent={{440,-450},{480,-410}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_heatingCoil
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{440,-500},{480,-460}}),
        iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla
    "Alarm level"
    annotation (Placement(transformation(extent={{440,-550},{480,-510}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=273.15 + 4.4,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,470},{-340,490}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,470},{-280,490}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq if have_heatingCoil
    "Hot water plant request in stage 1 mode"
    annotation (Placement(transformation(extent={{60,462},{80,482}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=minHotWatReq) if have_heatingCoil
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-20,500},{0,520}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minVen
    "Minimum ventilation when in stage 1 mode"
    annotation (Placement(transformation(extent={{60,390},{80,410}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiCon1(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_heatingCoil
    "Heating coil control in stage 1 mode"
    annotation (Placement(transformation(extent={{-320,340},{-300,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoi1 if have_heatingCoil
    "Heating coil position"
    annotation (Placement(transformation(extent={{120,320},{140,340}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=273.15 + 7,
    final h=Thys)
    "Check if supply air temperature is greater than threshold"
    annotation (Placement(transformation(extent={{-380,260},{-360,280}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Stay in stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-60,462},{-40,482}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-320,260},{-300,280}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaOne
    "Clear the latch to end the stage 1 freeze protection"
    annotation (Placement(transformation(extent={{-260,252},{-240,272}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(
    final t=273.15 + 3.3,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-380,170},{-360,190}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-340,170},{-320,190}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holSta2(
    final trueHoldDuration=3600,
    final falseHoldDuration=0)
    "Stage in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-300,162},{-280,182}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam2
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,250},{140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Fully closed damper position"
    annotation (Placement(transformation(extent={{40,270},{60,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam2 if not have_common
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam2
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,118},{140,138}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Fully open damper or valve position"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Alarm when it is in stage 2 mode"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=3)
    "Level 3 alarm"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0) if have_heatingCoil
    "Zero request"
    annotation (Placement(transformation(extent={{-20,440},{0,460}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=900)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,-10},{-280,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2(
    final t=273.15 + 1,
    final h=Thys)
    "Check if supply air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=300)
    "Check if the supply air temperature has been lower than threshold value for sufficient long time"
    annotation (Placement(transformation(extent={{-300,-50},{-280,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it should be in stage 3 mode"
    annotation (Placement(transformation(extent={{-220,-58},{-200,-38}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not have_freezeStat
    "Constant false"
    annotation (Placement(transformation(extent={{-300,-110},{-280,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stay in stage 3 freeze protection mode"
    annotation (Placement(transformation(extent={{-140,-58},{-120,-38}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supFan
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retFan if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{120,-290},{140,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch relFan if have_reliefs
    "Relief fan speed"
    annotation (Placement(transformation(extent={{120,-330},{140,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDam
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{320,-160},{340,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooCoi
    "Cooling coil position"
    annotation (Placement(transformation(extent={{120,-370},{140,-350}})));
  Buildings.Controls.OBC.CDL.Integers.Switch hotWatPlaReq3 if have_heatingCoil
    "Hot water plant request in stage 3 mode"
    annotation (Placement(transformation(extent={{320,-490},{340,-470}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=minHotWatReq) if have_heatingCoil
    "Minimum hot-water plant requests"
    annotation (Placement(transformation(extent={{-140,-482},{-120,-462}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if have_heatingCoil
    "Higher of supply air and mixed air temperature"
    annotation (Placement(transformation(extent={{-300,-430},{-280,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.PID heaCoiMod(
    final controllerType=heaCoiCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) if have_heatingCoil
    "Heating coil control when it is in stage 3 mode"
    annotation (Placement(transformation(extent={{40,-400},{60,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 27) if have_heatingCoil
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-400},{-120,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaCoiPos if have_heatingCoil
    "Heating coil position"
    annotation (Placement(transformation(extent={{320,-440},{340,-420}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Alarm level"
    annotation (Placement(transformation(extent={{320,-540},{340,-520}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2) "Level 2 alarm"
    annotation (Placement(transformation(extent={{-140,-532},{-120,-512}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert shuDowWar(
    final message="Warning: the unit is shut down by freeze protection!")
    "Unit shut down warning"
    annotation (Placement(transformation(extent={{380,-58},{400,-38}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{120,-58},{140,-38}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert disMinVenWar(
    final message="Warning: minimum ventilation was interrupted by freeze protection!")
    "Warning of disabling minimum ventilation "
    annotation (Placement(transformation(extent={{380,162},{400,182}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{120,162},{140,182}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim5(
    final t=3600)
    "Check if it has been in stage 2 for sufficient long time"
    annotation (Placement(transformation(extent={{-260,130},{-240,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minOutDam if not have_common
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{320,-210},{340,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Level 0 alarm"
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stay in stage 2 freeze protection mode"
    annotation (Placement(transformation(extent={{-180,162},{-160,182}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endStaTwo
    "Clear the latch to end the stage 2 freeze protection"
    annotation (Placement(transformation(extent={{-220,122},{-200,142}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Start stage 1 freeze protection mode"
    annotation (Placement(transformation(extent={{-100,462},{-80,482}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Switch from stage 2 to stage 1"
    annotation (Placement(transformation(extent={{-140,430},{-120,450}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDam
    "Return air damper position"
    annotation (Placement(transformation(extent={{320,-110},{340,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supTemSet(
    final k=273.15+ 6) if have_heatingCoil
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-380,340},{-360,360}})));

protected
  parameter Boolean have_common=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
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
    annotation (Line(points={{-338,480},{-302,480}}, color={255,0,255}));
  connect(TSup, lesThr.u) annotation (Line(points={{-460,60},{-420,60},{-420,480},
          {-362,480}}, color={0,0,127}));
  connect(conInt.y, hotWatPlaReq.u1) annotation (Line(points={{2,510},{40,510},{
          40,480},{58,480}}, color={255,127,0}));
  connect(uOutDamPosMin, minVen.u1) annotation (Line(points={{-460,420},{0,420},
          {0,408},{58,408}}, color={0,0,127}));
  connect(supTemSet.y, heaCoiCon1.u_s)
    annotation (Line(points={{-358,350},{-322,350}}, color={0,0,127}));
  connect(TSup, heaCoiCon1.u_m) annotation (Line(points={{-460,60},{-420,60},{-420,
          320},{-310,320},{-310,338}}, color={0,0,127}));
  connect(heaCoiCon1.y, heaCoi1.u1) annotation (Line(points={{-298,350},{0,350},
          {0,338},{118,338}}, color={0,0,127}));
  connect(TSup, greThr.u) annotation (Line(points={{-460,60},{-420,60},{-420,270},
          {-382,270}}, color={0,0,127}));
  connect(greThr.y, tim1.u)
    annotation (Line(points={{-358,270},{-322,270}}, color={255,0,255}));
  connect(tim1.passed, endStaOne.u)
    annotation (Line(points={{-298,262},{-262,262}}, color={255,0,255}));
  connect(endStaOne.y, lat.clr) annotation (Line(points={{-238,262},{-70,262},{-70,
          466},{-62,466}}, color={255,0,255}));
  connect(lat.y, hotWatPlaReq.u2)
    annotation (Line(points={{-38,472},{58,472}}, color={255,0,255}));
  connect(lat.y, minVen.u2) annotation (Line(points={{-38,472},{20,472},{20,400},
          {58,400}}, color={255,0,255}));
  connect(lat.y, heaCoi1.u2) annotation (Line(points={{-38,472},{20,472},{20,330},
          {118,330}}, color={255,0,255}));
  connect(TSup, lesThr1.u) annotation (Line(points={{-460,60},{-420,60},{-420,180},
          {-382,180}}, color={0,0,127}));
  connect(lesThr1.y, tim2.u)
    annotation (Line(points={{-358,180},{-342,180}}, color={255,0,255}));
  connect(tim2.passed, holSta2.u)
    annotation (Line(points={{-318,172},{-302,172}}, color={255,0,255}));
  connect(con.y, outDam2.u1) annotation (Line(points={{62,280},{80,280},{80,268},
          {118,268}}, color={0,0,127}));
  connect(con.y, minOutDam2.u1) annotation (Line(points={{62,280},{80,280},{80,218},
          {118,218}}, color={0,0,127}));
  connect(con1.y, retDam2.u1) annotation (Line(points={{-58,40},{-20,40},{-20,136},
          {118,136}}, color={0,0,127}));
  connect(uRetDamPos, retDam2.u3) annotation (Line(points={{-460,100},{-120,100},
          {-120,120},{118,120}}, color={0,0,127}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{62,70},{100,70},{100,
          48},{118,48}}, color={255,127,0}));
  connect(lesThr1.y, tim3.u) annotation (Line(points={{-358,180},{-350,180},{-350,
          0},{-302,0}},     color={255,0,255}));
  connect(lesThr2.y, tim4.u)
    annotation (Line(points={{-338,-40},{-302,-40}},   color={255,0,255}));
  connect(TSup, lesThr2.u) annotation (Line(points={{-460,60},{-420,60},{-420,-40},
          {-362,-40}},  color={0,0,127}));
  connect(tim3.passed, or3.u1) annotation (Line(points={{-278,-8},{-240,-8},{-240,
          -40},{-222,-40}},   color={255,0,255}));
  connect(tim4.passed, or3.u2)
    annotation (Line(points={{-278,-48},{-222,-48}},   color={255,0,255}));
  connect(uFreSta, or3.u3) annotation (Line(points={{-460,-80},{-240,-80},{-240,
          -56},{-222,-56}},   color={255,0,255}));
  connect(con2.y, or3.u3) annotation (Line(points={{-278,-100},{-240,-100},{-240,
          -56},{-222,-56}},   color={255,0,255}));
  connect(or3.y, lat1.u)
    annotation (Line(points={{-198,-48},{-142,-48}},   color={255,0,255}));
  connect(uFreStaRes, lat1.clr) annotation (Line(points={{-460,-130},{-160,-130},
          {-160,-54},{-142,-54}},   color={255,0,255}));
  connect(uSofSwiRes, lat1.clr) annotation (Line(points={{-460,-170},{-160,-170},
          {-160,-54},{-142,-54}},   color={255,0,255}));
  connect(lat1.y, supFan.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-240},
          {118,-240}},       color={255,0,255}));
  connect(lat1.y, retFan.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-280},
          {118,-280}},       color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-320},
          {118,-320}},       color={255,0,255}));
  connect(con3.y, supFan.u1) annotation (Line(points={{-118,-210},{40,-210},{40,
          -232},{118,-232}}, color={0,0,127}));
  connect(con3.y, retFan.u1) annotation (Line(points={{-118,-210},{40,-210},{40,
          -272},{118,-272}}, color={0,0,127}));
  connect(con3.y, relFan.u1) annotation (Line(points={{-118,-210},{40,-210},{40,
          -312},{118,-312}}, color={0,0,127}));
  connect(uSupFanSpe, supFan.u3) annotation (Line(points={{-460,-248},{118,-248}},
          color={0,0,127}));
  connect(uRetFanSpe, retFan.u3) annotation (Line(points={{-460,-288},{118,-288}},
          color={0,0,127}));
  connect(uRelFanSpe, relFan.u3) annotation (Line(points={{-460,-328},{118,-328}},
          color={0,0,127}));
  connect(supFan.y, ySupFanSpe)
    annotation (Line(points={{142,-240},{460,-240}}, color={0,0,127}));
  connect(relFan.y, yRelFanSpe)
    annotation (Line(points={{142,-320},{460,-320}}, color={0,0,127}));
  connect(retFan.y, yRetFanSpe)
    annotation (Line(points={{142,-280},{460,-280}}, color={0,0,127}));
  connect(con3.y, outDam.u1) annotation (Line(points={{-118,-210},{40,-210},{40,
          -142},{318,-142}}, color={0,0,127}));
  connect(lat1.y, outDam.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-150},
          {318,-150}},       color={255,0,255}));
  connect(uCooCoi, cooCoi.u3)
    annotation (Line(points={{-460,-368},{118,-368}}, color={0,0,127}));
  connect(lat1.y, cooCoi.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-360},
          {118,-360}},       color={255,0,255}));
  connect(con1.y, cooCoi.u1) annotation (Line(points={{-58,40},{-20,40},{-20,-352},
          {118,-352}}, color={0,0,127}));
  connect(conInt3.y, hotWatPlaReq3.u1)
    annotation (Line(points={{-118,-472},{318,-472}}, color={255,127,0}));
  connect(lat1.y, hotWatPlaReq3.u2) annotation (Line(points={{-118,-48},{20,-48},
          {20,-480},{318,-480}}, color={255,0,255}));
  connect(TMix, max1.u2) annotation (Line(points={{-460,-426},{-302,-426}},
          color={0,0,127}));
  connect(TSup, max1.u1) annotation (Line(points={{-460,60},{-420,60},{-420,-414},
          {-302,-414}}, color={0,0,127}));
  connect(max1.y, heaCoiMod.u_m) annotation (Line(points={{-278,-420},{50,-420},
          {50,-402}}, color={0,0,127}));
  connect(con4.y, heaCoiMod.u_s)
    annotation (Line(points={{-118,-390},{38,-390}}, color={0,0,127}));
  connect(heaCoiMod.y, heaCoiPos.u1) annotation (Line(points={{62,-390},{100,-390},
          {100,-422},{318,-422}}, color={0,0,127}));
  connect(lat1.y, heaCoiPos.u2) annotation (Line(points={{-118,-48},{20,-48},{20,
          -430},{318,-430}},    color={255,0,255}));
  connect(lat1.y, intSwi3.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-530},
          {318,-530}},       color={255,0,255}));
  connect(conInt4.y, intSwi3.u1)
    annotation (Line(points={{-118,-522},{318,-522}}, color={255,127,0}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{-118,-48},{118,-48}},   color={255,0,255}));
  connect(not1.y, shuDowWar.u)
    annotation (Line(points={{142,-48},{378,-48}},   color={255,0,255}));
  connect(not2.y, disMinVenWar.u)
    annotation (Line(points={{142,172},{378,172}}, color={255,0,255}));
  connect(holSta2.y, tim5.u) annotation (Line(points={{-278,172},{-270,172},{-270,
          140},{-262,140}}, color={255,0,255}));
  connect(lat1.y, minOutDam.u2) annotation (Line(points={{-118,-48},{20,-48},{20,
          -200},{318,-200}},    color={255,0,255}));
  connect(con3.y, minOutDam.u1) annotation (Line(points={{-118,-210},{40,-210},{
          40,-192},{318,-192}}, color={0,0,127}));
  connect(uOutDamPos, minVen.u3) annotation (Line(points={{-460,380},{0,380},{0,
          392},{58,392}}, color={0,0,127}));
  connect(minVen.y, outDam2.u3) annotation (Line(points={{82,400},{100,400},{100,
          252},{118,252}}, color={0,0,127}));
  connect(outDam2.y, outDam.u3) annotation (Line(points={{142,260},{270,260},{270,
          -158},{318,-158}}, color={0,0,127}));
  connect(conInt2.y, hotWatPlaReq.u3) annotation (Line(points={{2,450},{40,450},
          {40,464},{58,464}}, color={255,127,0}));
  connect(conInt5.y, intSwi1.u3) annotation (Line(points={{62,8},{100,8},{100,32},
          {118,32}},       color={255,127,0}));
  connect(intSwi1.y, intSwi3.u3) annotation (Line(points={{142,40},{210,40},{210,
          -538},{318,-538}}, color={255,127,0}));
  connect(intSwi3.y, yAla)
    annotation (Line(points={{342,-530},{460,-530}}, color={255,127,0}));
  connect(hotWatPlaReq.y, hotWatPlaReq3.u3) annotation (Line(points={{82,472},{230,
          472},{230,-488},{318,-488}}, color={255,127,0}));
  connect(hotWatPlaReq3.y, yHotWatPlaReq)
    annotation (Line(points={{342,-480},{460,-480}}, color={255,127,0}));
  connect(minOutDam2.y, minOutDam.u3) annotation (Line(points={{142,210},{220,210},
          {220,-208},{318,-208}}, color={0,0,127}));
  connect(minOutDam.y, yMinOutDamPos)
    annotation (Line(points={{342,-200},{460,-200}}, color={0,0,127}));
  connect(uMinOutDamPos, minOutDam2.u3) annotation (Line(points={{-460,220},{60,
          220},{60,202},{118,202}}, color={0,0,127}));
  connect(uHeaCoi, heaCoi1.u3) annotation (Line(points={{-460,300},{0,300},{0,322},
          {118,322}}, color={0,0,127}));
  connect(heaCoi1.y, heaCoiPos.u3) annotation (Line(points={{142,330},{280,330},
          {280,-438},{318,-438}}, color={0,0,127}));
  connect(heaCoiPos.y, yHeaCoi)
    annotation (Line(points={{342,-430},{460,-430}}, color={0,0,127}));
  connect(holSta2.y, lat2.u)
    annotation (Line(points={{-278,172},{-182,172}}, color={255,0,255}));
  connect(tim5.passed, endStaTwo.u)
    annotation (Line(points={{-238,132},{-222,132}}, color={255,0,255}));
  connect(endStaTwo.y, lat2.clr) annotation (Line(points={{-198,132},{-190,132},
          {-190,166},{-182,166}}, color={255,0,255}));
  connect(lat2.y, outDam2.u2) annotation (Line(points={{-158,172},{20,172},{20,260},
          {118,260}}, color={255,0,255}));
  connect(lat2.y, minOutDam2.u2) annotation (Line(points={{-158,172},{20,172},{20,
          210},{118,210}}, color={255,0,255}));
  connect(lat2.y, not2.u)
    annotation (Line(points={{-158,172},{118,172}}, color={255,0,255}));
  connect(lat2.y, retDam2.u2) annotation (Line(points={{-158,172},{20,172},{20,128},
          {118,128}}, color={255,0,255}));
  connect(lat2.y, intSwi1.u2) annotation (Line(points={{-158,172},{20,172},{20,40},
          {118,40}},  color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-278,472},{-102,472}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-78,472},{-62,472}}, color={255,0,255}));
  connect(falEdg.y, or2.u2) annotation (Line(points={{-118,440},{-110,440},{-110,
          464},{-102,464}}, color={255,0,255}));
  connect(lat2.y, falEdg.u) annotation (Line(points={{-158,172},{-150,172},{-150,
          440},{-142,440}}, color={255,0,255}));
  connect(lat1.y, retDam.u2) annotation (Line(points={{-118,-48},{20,-48},{20,-100},
          {318,-100}},       color={255,0,255}));
  connect(con3.y, retDam.u1) annotation (Line(points={{-118,-210},{40,-210},{40,
          -92},{318,-92}},   color={0,0,127}));
  connect(retDam2.y, retDam.u3) annotation (Line(points={{142,128},{260,128},{260,
          -108},{318,-108}}, color={0,0,127}));
  connect(retDam.y, yRetDamPos)
    annotation (Line(points={{342,-100},{460,-100}}, color={0,0,127}));
  connect(lat1.y, yEneCHWPum) annotation (Line(points={{-118,-48},{20,-48},{20,-20},
          {460,-20}}, color={255,0,255}));
  connect(outDam.y, yOutDamPos)
    annotation (Line(points={{342,-150},{460,-150}}, color={0,0,127}));
  connect(cooCoi.y, yCooCoi)
    annotation (Line(points={{142,-360},{460,-360}}, color={0,0,127}));

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
          visible=have_freezeStat),
        Text(
          extent={{-96,178},{-32,162}},
          lineColor={0,0,127},
          textString="uOutDamPos"),
        Text(
          extent={{-98,150},{-52,134}},
          lineColor={0,0,127},
          textString="uHeaCoi",
          visible=have_heatingCoil),
        Text(
          extent={{-96,120},{-20,102}},
          lineColor={0,0,127},
          textString="uMinOutDamPos",
          visible=not have_common),
        Text(
          extent={{-96,88},{-32,72}},
          lineColor={0,0,127},
          textString="uRetDamPos"),
        Text(
          extent={{-96,60},{-66,44}},
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
          visible=have_heatingCoil),
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
          visible=not have_common),
        Text(
          extent={{32,40},{96,24}},
          lineColor={0,0,127},
          textString="ySupFanSpe"),
        Text(
          extent={{34,0},{98,-16}},
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
          visible=have_heatingCoil),
        Text(
          extent={{22,-150},{96,-168}},
          lineColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_heatingCoil),
        Text(
          extent={{-96,2},{-36,-24}},
          lineColor={255,0,255},
          textString="uFreStaRes",
          visible=have_freezeStat),
        Text(
          extent={{-96,-28},{-34,-52}},
          lineColor={255,0,255},
          textString="uSofSwiRes",
          visible=not have_freezeStat),
        Text(
          extent={{24,200},{96,180}},
          lineColor={255,0,255},
          textString="yEneCHWPum"),
        Text(
          extent={{70,-178},{98,-196}},
          lineColor={255,127,0},
          textString="yAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-560},{440,560}}),
          graphics={
        Text(
          extent={{-332,42},{-238,22}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 3"),
        Text(
          extent={{-330,220},{-236,200}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 2"),
        Text(
          extent={{-342,522},{-248,502}},
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
Upon signal from the freeze-stat (if installed, <code>have_freezeStat=true</code>),
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
