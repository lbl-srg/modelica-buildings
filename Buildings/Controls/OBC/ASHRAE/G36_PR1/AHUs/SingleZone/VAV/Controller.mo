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
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller"
    annotation(Dialog(group="Cooling coil loop signal"));
  parameter Real kCooCoi(final unit="1/K")=1.0
    "Gain for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal"));

  parameter Modelica.SIunits.Time TiCooCoil=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdCooCoil=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(group="Cooling coil loop signal",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
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
  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation(Dialog(tab="Economizer", group="General", enable=not use_fixed_plus_differential_drybulb));
  parameter Boolean use_fixed_plus_differential_drybulb = false
    "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
    annotation(Dialog(tab="Economizer", group="General", enable=not use_enthalpy));
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

  parameter Modelica.SIunits.Temperature TFreSet=277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

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

  ModeAndSetPoints modSetPoi
    "Output zone setpoint with operation mode selection"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    final TSupSetMax=TSupSetMax,
    final TSupSetMin=TSupSetMin,
    final yHeaMax=yHeaMax,
    final yMin=yMin,
    final yCooMax=yCooMax)
    "Supply air set point and fan signal for single zone VAV system"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID cooPI(
    final reverseAction=true,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0) "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-30,152},{-10,172}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final yMax=1,
    final yMin=0) "Zone heating control signal"
    annotation (Placement(transformation(extent={{-30,200},{-10,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    "Average of zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    conEco(
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final controllerTypeMod=controllerTypeMod,
    final kMod=kMod,
    final TiMod=TiMod,
    final TdMod=TdMod,
    final uMin=uMin,
    final uMax=uMax,
    final controllerTypeFre=controllerTypeFre,
    final kFre=kFre,
    final TiFre=TiFre,
    final TdFre=TdFre,
    final TFreSet=TFreSet,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final minVOutMinFansSpePos=minVOutMinFansSpePos,
    final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final use_enthalpy=use_enthalpy,
    final use_fixed_plus_differential_drybulb=use_fixed_plus_differential_drybulb,
    final yFanMin=0,
    final yFanMax=1) "Economizer control sequence"
           annotation (Placement(transformation(extent={{118,-48},{138,-28}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(final unit="K", final
      quantity="ThermodynamicTemperature")
    "Economizer high limit cutoff. Fixed dry bulb or differential dry bulb temeprature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
        iconTransformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection if use_TMix is true"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{200,230},{220,250}}),
        iconTransformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,170},{220,190}}),
        iconTransformation(extent={{200,160},{220,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{200,110},{220,130}}),
        iconTransformation(extent={{200,110},{220,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,-250},{220,-230}}),
        iconTransformation(extent={{200,-230},{220,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-190},{220,-170}}),
        iconTransformation(extent={{200,-180},{220,-160}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
    outAirSetPoi(
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo)
    "Output the minimum outdoor airflow rate setpoint "
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
        iconTransformation(extent={{-240,218},{-200,258}})));
  ZoneState zonSta "Zone state"
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
     Placement(transformation(extent={{-240,-260},{-200,-220}}),
        iconTransformation(extent={{-240,-258},{-202,-220}})));
  CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  CDL.Interfaces.RealInput hCut(final unit="J/kg", final quantity="SpecificEnergy") if
       use_enthalpy
    "Economizer enthalpy high limit cutoff. Fixed enthalpy or differential enthalpy"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}}),
        iconTransformation(extent={{200,-68},{220,-48}})));
  CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil control signal" annotation (
      Placement(transformation(extent={{200,-130},{220,-110}}),
        iconTransformation(extent={{200,-130},{220,-110}})));
  CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature")  "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
        iconTransformation(extent={{200,50},{220,70}})));
  CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature")  "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{200,-10},{220,10}})));
  CDL.Interfaces.RealInput TRet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if
       use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-240,-218},{-200,-178}})));
  CoolingCoil coolingCoil(controllerTypeCooCoi=controllerTypeCooCoi, kCooCoi=
        kCooCoi)
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-161,198},{-190,
          198},{-190,200},{-220,200}},      color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-9,162},{0,162},{0,
          194},{38,194}},            color={0,0,127}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-9,210},{0,210},{0,
          198},{38,198}},            color={0,0,127}));
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-59,190.2},{-14,190.2},
          {-14,190},{38,190}},         color={0,0,127}));
  connect(TCut, conEco.TCut) annotation (Line(points={{-220,80},{-90,80},{-90,-26},
          {117,-26}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{117,-34},{-4,-34},{-4,40},
          {-220,40}},     color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{61,196},
          {92,196},{92,-36},{117,-36}},       color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{61,184},{86,
          184},{86,-40},{117,-40}},
                                  color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{0,0},{0,-42},{117,
          -42}},          color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{61,196},{160,
          196},{160,240},{210,240}},      color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{61,190},{136,190},
          {136,180},{210,180}},      color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{61,184},{120,184},{120,120},
          {210,120}},      color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{139,-38},{168,
          -38},{168,-240},{210,-240}},   color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{139,-42},{160,
          -42},{160,-180},{210,-180}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{39,50},{-4,50},{-4,
          40},{-220,40}},      color={0,0,127}));
  connect(outAirSetPoi.uOpeMod, conEco.uOpeMod) annotation (Line(points={{39,42},
          {-120,42},{-120,-46},{117,-46}},    color={255,127,0}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{117,-38},{108,-38},{108,50},{61,50}},
                                                       color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{10,240},{10,
          182},{38,182}},    color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{117,-24},{10,-24},
          {10,182},{38,182}},      color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-9,162},{18,162},{18,136},
          {38,136}},      color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-9,210},{0,210},{0,198},
          {14,198},{14,172},{20,172},{20,144},{38,144}},      color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{80,
          140},{80,-48},{117,-48}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-139,-230},{-130,-230},
          {-130,-238},{-112,-238}},color={255,127,0}));
  connect(intEqu.u1, conEco.uOpeMod) annotation (Line(points={{-112,-230},{-120,
          -230},{-120,-46},{117,-46}},                      color={255,127,0}));
  connect(intEqu.y, switch.u) annotation (Line(points={{-89,-230},{-82,-230}}, color={255,0,255}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-59,-230},{-36,-230},
          {-36,184},{-28,184},{-28,198}},       color={255,0,255}));
  connect(cooPI.trigger, heaPI.trigger) annotation (Line(points={{-28,150},{-28,
          140},{-36,140},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(conEco.uSupFan, heaPI.trigger) annotation (Line(points={{117,-44},{-36,
          -44},{-36,184},{-28,184},{-28,198}},     color={255,0,255}));
  connect(outAirSetPoi.uSupFan, heaPI.trigger) annotation (Line(points={{39,44},
          {-36,44},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-139,193},{-100,
          193},{-100,184},{-82,184}},      color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-139,193},
          {-100,193},{-100,210},{-32,210}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-139,197},{-82,
          197},{-82,196}},               color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-139,197},{
          -94,197},{-94,162},{-32,162}},  color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{39,46},{8,46},{8,-80},
          {-220,-80}},      color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-161,186.025},{-166,186.025},
          {-166,120},{-220,120}},          color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,160},{-180,160},{
          -180,195},{-161,195}},  color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,160},{-180,160},{-180,
          132},{-20,132},{-20,150}}, color={0,0,127}));
  connect(setPoiVAV.TZon, cooPI.u_m) annotation (Line(points={{38,186},{4,186},{
          4,132},{-20,132},{-20,150}},  color={0,0,127}));
  connect(outAirSetPoi.TZon, cooPI.u_m)   annotation (Line(points={{39,54},{-20,54},{-20,150}}, color={0,0,127}));
  connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-40},{4,-40},{
          4,58},{39,58}},  color={0,0,127}));
  connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-240},{-180,
          -240},{-180,-180},{40,-180},{40,-50},{117,-50}},
                                   color={255,127,0}));
  connect(conEco.hOut, hOut) annotation (Line(points={{117,-30},{100,-30},{100,-120},
          {-220,-120}}, color={0,0,127}));
  connect(conEco.hCut, hCut) annotation (Line(points={{117,-32},{102,-32},{102,-160},
          {-220,-160}}, color={0,0,127}));
  connect(conEco.TRet, TRet) annotation (Line(points={{117,-28},{102,-28},{102,-200},
          {-220,-200}}, color={0,0,127}));
  connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{139,-34},{174,-34},
          {174,-60},{210,-60}}, color={0,0,127}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-139,187},
          {-120,187},{-120,-46},{117,-46}}, color={255,127,0}));
  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-139,193},
          {-126,193},{-126,100},{142,100},{142,60},{210,60}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-139,197},
          {-110,197},{-110,108},{160,108},{160,0},{210,0}}, color={0,0,127}));
  connect(heaPI.u_m, cooPI.u_m) annotation (Line(points={{-20,198},{-20,180},{-46,
          180},{-46,132},{-20,132},{-20,150}}, color={0,0,127}));
  connect(coolingCoil.yCooCoi, yCooCoi)
    annotation (Line(points={{141,-120},{210,-120}}, color={0,0,127}));
  connect(switch.y, coolingCoil.uSupFan) annotation (Line(points={{-59,-230},{110,
          -230},{110,-128},{118,-128}}, color={255,0,255}));
  connect(zonSta.yZonSta, coolingCoil.uZonSta) annotation (Line(points={{61,140},
          {80,140},{80,-112},{118,-112}}, color={255,127,0}));
  connect(coolingCoil.TSupCoo, TSupCoo) annotation (Line(points={{118,-118},{74,
          -118},{74,190},{136,190},{136,180},{210,180}}, color={0,0,127}));
  connect(coolingCoil.TSup, TSup) annotation (Line(points={{118,-122},{-4,-122},
          {-4,40},{-220,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -240},{200,240}}), graphics={
                           Rectangle(
        extent={{-200,-240},{200,240}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-240},{200,240}})));
end Controller;
