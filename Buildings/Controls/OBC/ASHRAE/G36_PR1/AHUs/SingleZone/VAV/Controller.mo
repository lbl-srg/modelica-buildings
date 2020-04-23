within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block Controller
  "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"
  parameter Real TZonHeaOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=293.15
    "Heating setpoint during on"
    annotation (Dialog(group="Zone setpoints"));
  parameter Real TZonHeaOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Heating setpoint during off"
    annotation (Dialog(group="Zone setpoints"));
  parameter Real TZonCooOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Cooling setpoint during on"
    annotation (Dialog(group="Zone setpoints"));
  parameter Real TZonCooOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=303.15
    "Cooling setpoint during off"
    annotation (Dialog(group="Zone setpoints"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Cooling loop signal"));
  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal"));
  parameter Real TiCoo(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(
    final unit="s",
    final quantity="Time")=0.1
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
  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(group="Heating loop signal",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
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
  parameter Real TiCooCoil(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoil(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(group="Cooling coil loop signal",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TSupSetMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="VAV Setpoints",group="Temperature limits"));
  parameter Real TSupSetMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="VAV Setpoints",group="Temperature limits"));
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
  parameter Real VOutPerPer_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Real AFlo(final unit="m2", final quantity="Area")
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
  parameter Real delTOutHis(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Economizer", group="Advanced"));
  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
     annotation(Dialog(tab="Economizer", group="Advanced", enable = use_enthalpy));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Real TiMod(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(
    final unit="s",
    final quantity="Time")=0.1
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
  parameter Real TiFre(
    final unit="s",
    final quantity="Time")=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
     "Time constant of derivative block for freeze protection"
     annotation (Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix and
           (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TFreSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_minSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_minSpe(
    final min=yDam_VOutMin_minSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air (OA) damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
        iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Economizer high limit cutoff. Fixed dry bulb or differential dry bulb temeprature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
        iconTransformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection if use_TMix is true"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") if
       have_occSen "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Economizer enthalpy high limit cutoff. Fixed enthalpy or differential enthalpy"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if
       use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if
       use_G36FrePro
    "Freeze protection status, used if use_G36FrePro=true"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
        iconTransformation(extent={{-240,-260},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{200,230},{220,250}}),
        iconTransformation(extent={{200,200},{240,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,170},{220,190}}),
        iconTransformation(extent={{200,150},{240,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{200,110},{220,130}}),
        iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
        iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")  "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}}),
        iconTransformation(extent={{200,-80},{240,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil control signal"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}}),
        iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-190},{220,-170}}),
        iconTransformation(extent={{200,-190},{240,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,-250},{220,-230}}),
        iconTransformation(extent={{200,-240},{240,-200}})));

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
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final yMax=1,
    final yMin=0) "Zone heating control signal"
    annotation (Placement(transformation(extent={{-50,210},{-30,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    "Average of zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
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
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
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
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState zonSta "Zone state"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-110,-240},{-90,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints modSetPoi(
    final TZonHeaOn=TZonHeaOn,
    final TZonHeaOff=TZonHeaOff,
    final TZonCooOn=TZonCooOn,
    final TZonCooOff=TZonCooOff)
    "Output zone setpoint with operation mode selection"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil cooCoi(
    final controllerTypeCooCoi=controllerTypeCooCoi, kCooCoi=kCooCoi)
    "Controller for cooling coil valve"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-182,199},{-192,
          199},{-192,200},{-220,200}},      color={0,0,127}));
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-78,200},{-10,200},
          {-10,191.667},{38,191.667}}, color={0,0,127}));
  connect(TCut, conEco.TCut) annotation (Line(points={{-220,80},{-90,80},{-90,-32.2},
          {119,-32.2}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{119,-38.6},{-4,-38.6},{-4,
          40},{-220,40}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{62,195},
          {92,195},{92,-40.2},{119,-40.2}},   color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{62,185},{86,
          185},{86,-43},{119,-43}}, color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{0,0},{0,-44.4},{
          119,-44.4}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{62,195},{
          160,195},{160,240},{210,240}},  color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{62,190},{140,190},
          {140,180},{210,180}}, color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{62,185},{120,185},{120,
          120},{210,120}}, color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{141,-40},{168,
          -40},{168,-240},{210,-240}},   color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{141,-44},{160,
          -44},{160,-180},{210,-180}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{38,57},{-4,57},{-4,
          40},{-220,40}},      color={0,0,127}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{119,-41.6},{108,-41.6},{108,60},{62,60}},
                                                       color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{10,240},{
          10,185},{38,185}}, color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{119,-30.6},{10,
          -30.6},{10,185},{38,185}},
                                   color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{80,
          140},{80,-48.2},{119,-48.2}},
                                    color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-138,-230},{-130,-230},
          {-130,-238},{-112,-238}},color={255,127,0}));
  connect(intEqu.y, switch.u) annotation (Line(points={{-88,-230},{-82,-230}}, color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-158,190},{-130,
          190},{-130,194},{-102,194}},     color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-158,190},{
          -130,190},{-130,220},{-52,220}},  color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-158,197},{
          -114,197},{-114,160},{-52,160}},color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{38,64},{8,64},{8,-80},
          {-220,-80}},      color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-182,196.025},{-186,196.025},
          {-186,120},{-220,120}},          color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,160},{-192,160},{
          -192,193},{-182,193}},  color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,160},{-120,160},{-120,
          140},{-40,140},{-40,148}}, color={0,0,127}));
  connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-40},{4,-40},{
          4,68},{38,68}},  color={0,0,127}));
  connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-240},{-180,
          -240},{-180,-180},{40,-180},{40,-49.6},{119,-49.6}},
                                   color={255,127,0}));
  connect(conEco.hOut, hOut) annotation (Line(points={{119,-35.4},{100,-35.4},{100,
          -120},{-220,-120}},
                        color={0,0,127}));
  connect(conEco.hCut, hCut) annotation (Line(points={{119,-37},{102,-37},{102,-160},
          {-220,-160}}, color={0,0,127}));
  connect(conEco.TRet, TRet) annotation (Line(points={{119,-33.8},{102,-33.8},{102,
          -200},{-220,-200}},
                        color={0,0,127}));
  connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{141,-36},{174,-36},
          {174,-60},{210,-60}}, color={0,0,127}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-158,183},
          {-152,183},{-152,-47},{119,-47}}, color={255,127,0}));
  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-158,190},
          {-130,190},{-130,100},{160,100},{160,60},{210,60}}, color={0,0,127}));
  connect(cooCoi.yCooCoi, yCooCoi)
    annotation (Line(points={{142,-120},{210,-120}}, color={0,0,127}));
  connect(switch.y, cooCoi.uSupFan) annotation (Line(points={{-58,-230},{110,-230},
          {110,-128},{118,-128}}, color={255,0,255}));
  connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{61,140},{74,
          140},{74,-124},{118,-124}}, color={255,127,0}));
  connect(cooCoi.TSup, TSup) annotation (Line(points={{118,-116},{-4,-116},{-4,
          40},{-220,40}},
                      color={0,0,127}));
  connect(switch.y, outAirSetPoi.uSupFan) annotation (Line(points={{-58,-230},{-20,
          -230},{-20,54},{38,54}}, color={255,0,255}));
  connect(switch.y, conEco.uSupFan) annotation (Line(points={{-58,-230},{60,-230},
          {60,-45.6},{119,-45.6}},
                               color={255,0,255}));
  connect(switch.y, setPoiVAV.uFan) annotation (Line(points={{-58,-230},{28,
          -230},{28,181.667},{38,181.667}},
                              color={255,0,255}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-28,220},{0,220},{
          0,198.333},{38,198.333}},
                               color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-28,220},{0,220},{0,144},
          {38,144}},      color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-28,160},{-20,160},
          {-20,195},{38,195}}, color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-28,160},{-20,160},{-20,
          136},{38,136}}, color={0,0,127}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-58,-230},{-48,-230},
          {-48,80},{-60,80},{-60,190},{-46,190},{-46,208}}, color={255,0,255}));
  connect(switch.y, cooPI.trigger) annotation (Line(points={{-58,-230},{-46,-230},
          {-46,148}}, color={255,0,255}));
  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-158,197},
          {-114,197},{-114,108},{120,108},{120,0},{210,0}}, color={0,0,127}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-220,160},{-120,160},{-120,
          180},{-40,180},{-40,208}}, color={0,0,127}));
  connect(intEqu.u1, modSetPoi.yOpeMod) annotation (Line(points={{-112,-230},{-120,
          -230},{-120,-60},{-152,-60},{-152,183},{-158,183}},      color={255,
          127,0}));
  connect(setPoiVAV.TSupCoo, cooCoi.TSupCoo) annotation (Line(points={{62,190},{
          80,190},{80,-112},{118,-112}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-158,197},{-114,
          197},{-114,206},{-102,206}}, color={0,0,127}));
  connect(TZon, setPoiVAV.TZon) annotation (Line(points={{-220,160},{-120,160},
          {-120,180},{-40,180},{-40,188.333},{38,188.333}},color={0,0,127}));
  connect(TZon, outAirSetPoi.TZon) annotation (Line(points={{-220,160},{-120,160},
          {-120,140},{-40,140},{-40,60},{38,60}}, color={0,0,127}));
  connect(modSetPoi.yOpeMod, outAirSetPoi.uOpeMod) annotation (Line(points={{-158,
          183},{-152,183},{-152,51},{38,51}}, color={255,127,0}));

annotation (defaultComponentName="conVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,
            260}}),
        graphics={Rectangle(
        extent={{-200,-260},{200,260}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,312},{152,272}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-192,262},{-138,224}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-194,218},{-140,180}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-192,180},{-138,142}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-192,140},{-138,102}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-192,102},{-138,64}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCut"),
        Text(
          extent={{-192,62},{-138,24}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          visible=use_TMix,
          extent={{-192,20},{-138,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TMix"),
        Text(
          visible=have_occSen,
          extent={{-192,-56},{-138,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="nOcc"),
        Text(
          extent={{-192,-58},{-138,-96}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          visible=use_enthalpy,
          extent={{-192,-136},{-138,-174}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hCut"),
        Text(
          visible=use_enthalpy,
          extent={{-192,-98},{-138,-136}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hOut"),
        Text(
          visible=use_fixed_plus_differential_drybulb,
          extent={{-192,-180},{-138,-218}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TRet"),
        Text(
          visible=use_G36FrePro,
          extent={{-192,-218},{-138,-256}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFreProSta"),
        Text(
          extent={{132,242},{186,204}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEco"),
        Text(
          extent={{136,190},{190,152}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCoo"),
        Text(
          extent={{136,140},{190,102}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan"),
        Text(
          extent={{136,82},{190,44}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{140,22},{194,-16}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{140,-40},{194,-78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi"),
        Text(
          extent={{140,-100},{194,-138}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{138,-150},{192,-188}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{140,-200},{194,-238}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
Documentation(info="<html>
<p>
Block for single zone VAV control. It outputs supply fan speed, supply air temperature
setpoints for heating, economizer and cooling, zone air heating and cooling setpoints,
outdoor and return air damper positions, and valve positions of heating and cooling coils.
</p>
<p>
It is implemented according to the ASHRAE Guideline 36, Part 5.18.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART 5.18.4. It outputs
the control signal <code>yFan</code> to adjust the speed of the supply fan.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoints</h4>
<p>
The supply air temperature setpoints control sequences are implemented based on PART 5.18.4.
They are implemented in the same control block as the supply fan speed control. The supply air temperature setpoint
for heating and economizer is the same; while the supply air temperature setpoint for cooling has
a separate control loop. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Economizer control</h4>
<p>
The Economizer control block outputs outdoor and return air damper position, i.e. <code>yOutDamPos</code> and
<code>yRetDamPos</code>, as well as control signal for heating coil <code>yHeaCoi</code>.
Optionally, there is also an override for freeze protection, which is not part of Guideline 36.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow</h4>
<p>
Control sequences are implemented to compute the minimum outdoor airflow
setpoint, which is used as an input for the economizer control. More detailed
information can be found at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
Zone air heating and cooling setpoints as well as system operation modes are detailed at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 10, 2020, by Jianjun Hu:<br/>
Replaced the block for calculating the operation mode and setpoint temperature with the one
from the terminal unit package. The new block does not have vector-valued calculations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
</li>
<li>
August 3, 2019, by David Blum &amp; Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
