within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block Controller "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Cooling loop signal"));

  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal"));

  parameter Modelica.SIunits.Time TiCoo=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdCoo=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(group="Cooling loop signal",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Heating loop signal"));
  parameter Real kHea(final unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(group="Heating loop signal"));

  parameter Modelica.SIunits.Time TiHea=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(group="Heating loop signal",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdHea=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(group="Heating loop signal",
      enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Temperature TSupSetMax
    "Maximum supply air temperature for heating"
    annotation (Evaluate=true,
      Dialog(tab="VAV Setpoints",group="Temperature limits"));
  parameter Modelica.SIunits.Temperature TSupSetMin
    "Minimum supply air temperature for cooling"
    annotation (Evaluate=true,
      Dialog(tab="VAV Setpoints",group="Temperature limits"));
  parameter Real yHeaMax(min=0, max=1, unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));
  parameter Real yMin(min=0, max=1, unit="1")
    "Minimum fan speed"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));
  parameter Real yCooMax(min=0, max=1, unit="1") = 1
    "Maximum fan speed for cooling"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));

  parameter Real VOutPerAre_flow(final unit="m3/(s.m2)") = 3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VOutPerPer_flow = 2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Modelica.SIunits.Area AFlo
    "Floor area"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Boolean have_occSen
    "Set to true if zones have occupancy sensor"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real occDen(final unit="1/m2") = 0.05
    "Default number of person in unit area"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real zonDisEffHea(final unit="1") = 0.8
    "Zone air distribution effectiveness during heating"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real zonDisEffCoo(final unit="1") = 1.0
    "Zone air distribution effectiveness during cooling"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real uLow(final unit="K",
    quantity="ThermodynamicTemperature") = -0.5
    "If zone space temperature minus supply air temperature is less than uLow,
     then it should use heating supply air distribution effectiveness"
    annotation(Dialog(tab="Outside Air Flow", group="Advanced"));
  parameter Real uHig(final unit="K",
    quantity="ThermodynamicTemperature") = 0.5
    "If zone space temperature minus supply air temperature is more than uHig,
     then it should use cooling supply air distribution effectiveness"
    annotation(Dialog(tab="Outside Air Flow", group="Advanced"));
  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Boolean use_G36FrePro=false
    "Set to true if G36 freeze protection is implemented"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Economizer", group="Advanced"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
     annotation(Dialog(tab="Economizer", group="Advanced", enable = use_enthalpy));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Modelica.SIunits.Time TiMod=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdMod=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1
    "Lower limit of controller output uTSup at which the dampers are at their limits"
    annotation(Dialog(tab="Economizer", group="General"));

  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 0.9
    "Upper limit of controller output uTSup at which the dampers are at their limits"
    annotation(Dialog(tab="Economizer", group="General"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

  parameter Modelica.SIunits.Time TiFre=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

   parameter Modelica.SIunits.Time TdFre=0.1
     "Time constant of derivative block for freeze protection"
     annotation (Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix and
           (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

  parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
    "Calculated design outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real minVOutMinFansSpePos(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_minSpe(
    final min=minVOutMinFansSpePos,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air (OA) damper"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));

  ModeAndSetPoints
    modSetPoi
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(TSupSetMax=TSupSetMax, TSupSetMin=TSupSetMin,
    yHeaMax=yHeaMax,
    yMin=yMin,
    yCooMax=yCooMax)
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID cooPI(                                                                     reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    controllerType=controllerTypeCoo,
    k=kCoo,
    Ti=TiCoo,
    Td=TdCoo,
    yMax=1,
    yMin=0)
    annotation (Placement(transformation(extent={{-30,160},{-10,180}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(                                                                     reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    controllerType=controllerTypeHea,
    k=kHea,
    Ti=TiHea,
    Td=TdHea,
    yMax=1,
    yMin=0)
    annotation (Placement(transformation(extent={{-30,200},{-10,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    annotation (Placement(transformation(extent={{-70,180},{-50,200}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    conEco(
    use_TMix=use_TMix,
    use_G36FrePro=use_G36FrePro,
    delTOutHis=delTOutHis,
    delEntHis=delEntHis,
    controllerTypeMod=controllerTypeMod,
    kMod=kMod,
    TiMod=TiMod,
    TdMod=TdMod,
    uMin=uMin,
    uMax=uMax,
    controllerTypeFre=controllerTypeFre,
    kFre=kFre,
    TiFre=TiFre,
    TdFre=TdFre,
    TFreSet=TFreSet,
    yFanMin=yFanMin,
    yFanMax=yFanMax,
    VOutMin_flow=VOutMin_flow,
    VOutDes_flow=VOutDes_flow,
    minVOutMinFansSpePos=minVOutMinFansSpePos,
    yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
    outDamPhyPosMax=outDamPhyPosMax,
    outDamPhyPosMin=outDamPhyPosMin,
    retDamPhyPosMax=retDamPhyPosMax,
    retDamPhyPosMin=retDamPhyPosMin,
    use_enthalpy=use_enthalpy)
           annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet
    "Measured return air temperature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{200,230},{220,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan "Fan speed"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
    outAirSetPoi(AFlo=AFlo, have_occSen=have_occSen,
    VOutPerAre_flow=VOutPerAre_flow,
    VOutPerPer_flow=VOutPerPer_flow,
    occDen=occDen,
    zonDisEffHea=zonDisEffHea,
    zonDisEffCoo=zonDisEffCoo,
    uLow=uLow,
    uHig=uHig)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}})));
  ZoneState zonSta
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-110,-240},{-90,-220}})));
  CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  CDL.Interfaces.IntegerInput uFreProSta if use_G36FrePro
   "Freeze protection status, used if use_G36FrePro=true" annotation (
     Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-240,-218},{-202,-180}})));
  CDL.Interfaces.RealInput hOut if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}})));
  CDL.Interfaces.RealInput hRet if use_enthalpy "Return air enthalpy"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}})));
  CDL.Interfaces.RealOutput yHeaCoi "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-161,198},{-190,
          198},{-190,200},{-220,200}},      color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-9,170},{0,170},{0,
          194},{38,194}},            color={0,0,127}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-9,210},{0,210},{0,
          198},{38,198}},            color={0,0,127}));
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-49,190.2},{-14,190.2},
          {-14,190},{38,190}},         color={0,0,127}));
  connect(TRet, conEco.TOutCut) annotation (Line(points={{-220,80},{-90,80},{
          -90,120},{119,120}},  color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{119,114},{-4,114},{-4,40},
          {-220,40}},     color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{61,196},
          {92,196},{92,112},{119,112}},       color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{61,184},{86,
          184},{86,108},{119,108}},
                                  color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{0,0},{0,106},{
          119,106}},      color={0,0,127}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-139,187},
          {-130,187},{-130,188},{-120,188},{-120,102},{119,102}},
                                                color={255,127,0}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{61,196},{160,
          196},{160,240},{210,240}},      color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{61,190},{166,190},
          {166,200},{210,200}},      color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{61,184},{166,184},{166,160},
          {210,160}},      color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{141,110},{180,
          110},{180,80},{210,80}},       color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{141,106},{160,
          106},{160,40},{210,40}},     color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{39,80},{-4,80},{-4,
          40},{-220,40}},      color={0,0,127}));
  connect(outAirSetPoi.uOpeMod, conEco.uOpeMod) annotation (Line(points={{39,72},
          {-120,72},{-120,102},{119,102}},    color={255,127,0}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{119,110},{108,110},{108,80},{61,80}},
                                                       color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{10,240},{10,
          182},{38,182}},    color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{119,122},{10,122},
          {10,182},{38,182}},      color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-9,170},{18,170},{18,136},
          {38,136}},      color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-9,210},{0,210},{0,198},
          {14,198},{14,172},{20,172},{20,144},{38,144}},      color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{80,
          140},{80,100},{119,100}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-139,-230},{-130,-230},
          {-130,-238},{-112,-238}},color={255,127,0}));
  connect(intEqu.u1, conEco.uOpeMod) annotation (Line(points={{-112,-230},{-120,
          -230},{-120,102},{119,102}},                      color={255,127,0}));
  connect(intEqu.y, switch.u)
    annotation (Line(points={{-89,-230},{-82,-230}}, color={255,0,255}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-59,-230},{-36,-230},
          {-36,184},{-28,184},{-28,198}},       color={255,0,255}));
  connect(cooPI.trigger, heaPI.trigger) annotation (Line(points={{-28,158},{-28,
          140},{-36,140},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(conEco.uSupFan, heaPI.trigger) annotation (Line(points={{119,104},{
          -36,104},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(outAirSetPoi.uSupFan, heaPI.trigger) annotation (Line(points={{39,74},
          {-36,74},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-139,193},{
          -100,193},{-100,184},{-72,184}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-139,193},
          {-100,193},{-100,210},{-32,210}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-139,197},{
          -80,197},{-80,196},{-72,196}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-139,197},
          {-80,197},{-80,170},{-32,170}}, color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{39,76},{8,76},{8,-80},
          {-220,-80}},      color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-161,186.025},{-166,
          186.025},{-166,120},{-220,120}}, color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,160},{-180,160},
          {-180,195},{-161,195}}, color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,160},{-180,160},{-180,
          150},{-20,150},{-20,158}}, color={0,0,127}));
  connect(setPoiVAV.TZon, cooPI.u_m) annotation (Line(points={{38,186},{6,186},{
          6,150},{-20,150},{-20,158}},  color={0,0,127}));
  connect(outAirSetPoi.TZon, cooPI.u_m)
    annotation (Line(points={{39,84},{-20,84},{-20,158}}, color={0,0,127}));
  connect(heaPI.u_m, cooPI.u_m) annotation (Line(points={{-20,198},{-20,186},{
          -40,186},{-40,150},{-20,150},{-20,158}}, color={0,0,127}));
  connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-40},{4,-40},{
          4,88},{39,88}},  color={0,0,127}));
  connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-200},{80,
          -200},{80,98},{119,98}}, color={255,127,0}));
  connect(conEco.hOut, hOut) annotation (Line(points={{119,118},{100,118},{100,-120},
          {-220,-120}}, color={0,0,127}));
  connect(conEco.hOutCut, hRet) annotation (Line(points={{119,116},{104,116},{104,
          -160},{-220,-160}}, color={0,0,127}));
  connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{141,114},{180,114},
          {180,120},{210,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -240},{200,240}}), graphics={
                           Rectangle(
        extent={{-200,-240},{200,240}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-240},{200,240}}),
        graphics={
        Rectangle(
          extent={{-190,90},{-170,70}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,80},{-146,50}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Adjust based on climate zone"),
        Text(
          extent={{22,78},{86,48}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Consider if havOccSen and havWinSen"),
        Text(
          extent={{112,106},{156,80}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="To Do: Add if hOut",
          textStyle={TextStyle.Bold}),
        Rectangle(
          extent={{-190,-150},{-170,-170}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,-160},{-146,-190}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Adjust based on climate zone")}));
end Controller;
