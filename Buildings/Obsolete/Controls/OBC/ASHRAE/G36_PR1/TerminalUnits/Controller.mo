within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block Controller "Controller for room VAV box"

  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Volume flow rate of this thermal zone";
  parameter Real AFlo(
    final unit="m2",
    final quantity="Area") "Area of the zone";

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

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Valve"));

  parameter Real kVal=0.5
    "Gain of controller for valve control"
    annotation (Dialog(group="Valve"));

  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Damper"));

  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation (Dialog(group="Damper"));

  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Real VDisCooSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=V_flow_nominal
    "Zone maximum cooling airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisSetMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.15*V_flow_nominal
    "Zone minimum airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisHeaSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.3*V_flow_nominal
    "Zone maximum heating airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisConMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.1*V_flow_nominal
    "VAV box controllable minimum"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VOutPerAre_flow(final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VOutPerPer_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.5e-3
    "Outdoor air rate per person"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real CO2Set=894 "CO2 setpoint in ppm"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real dTDisZonSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Dialog(tab="Damper and valve", group="Parameters"));
  parameter Real TDisMin(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")=283.15
    "Lowest discharge air temperature"
    annotation (Dialog(tab="Damper and valve", group="Parameters"));
  parameter Boolean have_heaWatCoi=true
    "Flag, true if there is a hot water coil"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Boolean have_heaPla=false
    "Flag, true if there is a boiler plant"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Real errTZonCoo_1(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=2.8
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 3 cooling SAT reset requests"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Real errTZonCoo_2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1.7
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 2 cooling SAT reset requests"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Real errTDis_1(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Real errTDis_2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests"
    annotation (Dialog(tab="System requests", group="Parameters"));
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Dialog(tab="System requests", group="Duration times"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration times"));
  parameter Real durTimDisAir(
    final unit="s",
    final quantity="Time")=300
    "Duration time of discharge air temperature is less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-180,140},{-140,180}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-180,-34},{-140,6}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAHU(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Measured CO2 concentration"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-180,-190},{-140,-150}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yDam_actual
    "Actual VAV damper position"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1")
    "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1")
    "Signal for VAV damper"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
        iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq if have_heaWatCoi
    "Hot water temperature reset requests"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaPlaReq if (have_heaWatCoi and have_heaPla)
    "Heating plant request"
    annotation (Placement(transformation(extent={{140,-180},{180,-140}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet(
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_CO2Sen=have_CO2Sen,
    final VDisCooSetMax_flow=VDisCooSetMax_flow,
    final VDisSetMin_flow=VDisSetMin_flow,
    final VDisHeaSetMax_flow=VDisHeaSetMax_flow,
    final VDisConMin_flow=VDisConMin_flow,
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final CO2Set=CO2Set) "Active airflow rate setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
    damVal(
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTDisZonSetMax=dTDisZonSetMax,
    final TDisMin=TDisMin,
    V_flow_nominal=max(VDisCooSetMax_flow, VDisHeaSetMax_flow))
    "Damper and valve controller"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
    sysReq(
    final samplePeriod=samplePeriod,
    final have_heaWatCoi=have_heaWatCoi,
    final have_heaPla=have_heaPla,
    final errTZonCoo_1=errTZonCoo_1,
    final errTZonCoo_2=errTZonCoo_2,
    final errTDis_1=errTDis_1,
    final errTDis_2=errTDis_2,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final durTimDisAir=durTimDisAir) "Number of system requests"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conHeaLoo(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final yMax=1,
    final yMin=0) "Heating loop signal"
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conCooLoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0,
    reverseActing=false) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Output true if unoccupied"
    annotation (Placement(transformation(extent={{-18,-160},{2,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntUn(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not isNotUn
  "Output true if not unoccupied"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

equation
  connect(sysReq.TZonCooSet, TZonCooSet)
    annotation (Line(points={{78,-82},{-120,-82},{-120,120},{-160,120}},
      color={0,0,127}));
  connect(sysReq.TZon, TZon)
    annotation (Line(points={{78,-84},{0,-84},{0,-14},{-160,-14}},
      color={0,0,127}));
  connect(sysReq.VDisSet_flow, damVal.VDisSet_flow)
    annotation (Line(points={{78,-88},{64,-88},{64,-2},{42,-2}},
      color={0,0,127}));
  connect(sysReq.VDis_flow, VDis_flow)
    annotation (Line(points={{78,-90},{34,-90},{34,-50},{-160,-50}},
      color={0,0,127}));
  connect(sysReq.TDisHeaSet, damVal.TDisHeaSet)
    annotation (Line(points={{78,-94},{58,-94},{58,-18},{42,-18}},
      color={0,0,127}));
  connect(damVal.yDam, yDam)
    annotation (Line(points={{42,-6},{110,-6},{110,80},{160,80}},
      color={0,0,127}));
  connect(damVal.yHeaVal, yVal)
    annotation (Line(points={{42,-14},{120,-14},{120,0},{160,0}},
      color={0,0,127}));
  connect(damVal.VDis_flow, VDis_flow)
    annotation (Line(points={{34,-22},{34,-50},{-160,-50}},color={0,0,127}));
  connect(damVal.TDis, TDis)
    annotation (Line(points={{26,-22},{26,-110},{-160,-110}},
                                                           color={0,0,127}));
  connect(sysReq.TDis, TDis)
    annotation (Line(points={{78,-96},{26,-96},{26,-110},{-160,-110}},
      color={0,0,127}));
  connect(damVal.yHeaVal, sysReq.uHeaVal)
    annotation (Line(points={{42,-14},{50,-14},{50,-98},{78,-98}},
                                                             color={0,0,127}));
  connect(TZon, damVal.TZon) annotation (Line(points={{-160,-14},{18,-14}},
                   color={0,0,127}));
  connect(damVal.TSup, TSupAHU) annotation (Line(points={{18,-8},{-80,-8},{-80,-140},
          {-160,-140}},color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow) annotation (Line(points={{-18,78},
          {0,78},{0,-4},{18,-4}},      color={0,0,127}));
  connect(actAirSet.VActCooMin_flow, damVal.VActCooMin_flow) annotation (Line(points={{-18,75},
          {-2,75},{-2,-2},{18,-2}},      color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow) annotation (Line(points={{-18,72},
          {-4,72},{-4,-6},{18,-6}}, color={0,0,127}));
  connect(actAirSet.VActHeaMin_flow, damVal.VActHeaMin_flow) annotation (Line(points={{-18,69},
          {-6,69},{-6,-16},{18,-16}},  color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damVal.VActHeaMax_flow) annotation (Line(points={{-18,66},
          {-8,66},{-8,-18},{18,-18}},  color={0,0,127}));
  connect(damVal.THeaSet, TZonHeaSet)
    annotation (Line(points={{18,-10},{-124,-10},{-124,160},{-160,160}},
      color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow)
    annotation (Line(points={{-18,78},{0,78},{0,-4},{18,-4}},
      color={0,0,127}));
  connect(actAirSet.VActCooMin_flow, damVal.VActCooMin_flow)
    annotation (Line(points={{-18,75},{-2,75},{-2,-2},{18,-2}},
      color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow)
    annotation (Line(points={{-18,72},{-4,72},{-4,-6},{18,-6}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMin_flow, damVal.VActHeaMin_flow)
    annotation (Line(points={{-18,69},{-6,69},{-6,-16},{18,-16}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damVal.VActHeaMax_flow)
    annotation (Line(points={{-18,66},{-8,66},{-8,-18},{18,-18}},
      color={0,0,127}));
  connect(actAirSet.uOpeMod, uOpeMod)
    annotation (Line(points={{-42,78},{-112,78},{-112,-170},{-160,-170}},
      color={255,127,0}));
  connect(sysReq.yZonTemResReq, yZonTemResReq)
    annotation (Line(points={{102,-83},{110,-83},{110,-40},{160,-40}},
      color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq)
    annotation (Line(points={{102,-88},{120,-88},{120,-80},{160,-80}},
      color={255,127,0}));
  connect(actAirSet.ppmCO2, ppmCO2)
    annotation (Line(points={{-42,74},{-60,74},{-60,80},{-160,80}},
      color={0,0,127}));
  connect(actAirSet.nOcc, nOcc)
    annotation (Line(points={{-42,66},{-60,66},{-60,50},{-160,50}},
      color={0,0,127}));
  connect(actAirSet.uWin, uWin)
    annotation (Line(points={{-42,62},{-56,62},{-56,20},{-160,20}},
      color={255,0,255}));
  connect(TZonHeaSet, conHeaLoo.u_s)
    annotation (Line(points={{-160,160},{-112,160}}, color={0,0,127}));
  connect(TZonCooSet, conCooLoo.u_s)
    annotation (Line(points={{-160,120},{-112,120}}, color={0,0,127}));
  connect(TZon, conHeaLoo.u_m)
    annotation (Line(points={{-160,-14},{-122,-14},{-122,140},{-100,140},{-100,148}},
                   color={0,0,127}));
  connect(TZon, conCooLoo.u_m)
    annotation (Line(points={{-160,-14},{-122,-14},{-122,100},{-100,100},{-100,108}},
                   color={0,0,127}));
  connect(conCooLoo.y, damVal.uCoo)
    annotation (Line(points={{-88,120},{8,120},{8,0},{18,0}},
      color={0,0,127}));
  connect(conHeaLoo.y, damVal.uHea)
    annotation (Line(points={{-88,160},{12,160},{12,-12},{18,-12}},
      color={0,0,127}));
  connect(conCooLoo.y, sysReq.uCoo)
    annotation (Line(points={{-88,120},{8,120},{8,-86},{78,-86}},
      color={0,0,127}));
  connect(damVal.uOpeMod, uOpeMod) annotation (Line(points={{18,-20},{-112,-20},
          {-112,-170},{-160,-170}},
                                  color={255,127,0}));
  connect(conIntUn.y, isUnOcc.u1)
    annotation (Line(points={{-38,-150},{-20,-150}}, color={255,127,0}));
  connect(uOpeMod, isUnOcc.u2) annotation (Line(points={{-160,-170},{-32,-170},{
          -32,-158},{-20,-158}}, color={255,127,0}));
  connect(isUnOcc.y, isNotUn.u)
    annotation (Line(points={{4,-150},{18,-150}},   color={255,0,255}));
  connect(isNotUn.y, conCooLoo.trigger) annotation (Line(points={{42,-150},{60,-150},
          {60,-120},{-116,-120},{-116,104},{-106,104},{-106,108}}, color={255,0,
          255}));
  connect(isNotUn.y, conHeaLoo.trigger) annotation (Line(points={{42,-150},{60,-150},
          {60,-120},{-116,-120},{-116,142},{-106,142},{-106,148}}, color={255,0,
          255}));
  connect(sysReq.yDam_actual,yDam_actual)  annotation (Line(points={{78,-92},{-124,
          -92},{-124,-80},{-160,-80}}, color={0,0,127}));

  connect(sysReq.yHeaValResReq, yHeaValResReq) annotation (Line(points={{102,-94},
          {120,-94},{120,-120},{160,-120}}, color={255,127,0}));
  connect(sysReq.yHeaPlaReq, yHeaPlaReq) annotation (Line(points={{102,-99},{110,
          -99},{110,-160},{160,-160}}, color={255,127,0}));
annotation (defaultComponentName="terUniCon",
  Icon(coordinateSystem(extent={{-100,-120},{100,120}}),
      graphics={Rectangle(
        extent={{-100,-120},{100,120}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-54},{-78,-64}},
          textColor={0,0,127},
          textString="TDis"),
        Text(
          extent={{-100,-70},{-70,-82}},
          textColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{72,66},{100,52}},
          textColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{68,106},{96,92}},
          textColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-98,100},{-46,88}},
          textColor={0,0,127},
          textString="TZonHeaSet"),
        Text(
          extent={{-98,-14},{-68,-26}},
          textColor={0,0,127},
          textString="VDis_flow"),
        Text(
          extent={{-120,180},{114,128}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-96,6},{-74,-8}},
          textColor={0,0,127},
          textString="TZon"),
        Text(
          extent={{-100,84},{-46,74}},
          textColor={0,0,127},
          textString="TZonCooSet"),
        Text(
          extent={{-100,-86},{-52,-98}},
          textColor={0,0,127},
          textString="uOpeMod"),
        Text(
          visible=have_occSen,
          extent={{-100,36},{-74,26}},
          textColor={0,0,127},
          textString="nOcc"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,60},{-58,42}},
          textColor={0,0,127},
          textString="ppmCO2"),
        Text(
          visible=have_winSen,
          extent={{-100,14},{-72,4}},
          textColor={0,0,127},
          textString="uWin"),
        Text(
          extent={{22,38},{96,0}},
          textColor={0,0,127},
          textString="yZonTemResReq"),
        Text(
          extent={{24,-2},{96,-36}},
          textColor={0,0,127},
          textString="yZonPreResReq"),
        Text(
          extent={{-98,-34},{-50,-44}},
          textColor={0,0,127},
          textString="uDam_actual"),
        Text(
          extent={{24,-42},{96,-76}},
          textColor={0,0,127},
          visible = have_heaWatCoi,
          textString="yHeaValResReq"),
        Text(
          extent={{44,-84},{98,-116}},
          textColor={0,0,127},
          visible = (have_heaWatCoi and have_heaPla),
          textString="yHeaPlaReq")}),
    Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat according to ASHRAE
Guideline 36, Part 5.E. It outputs damper position <code>yDam</code>,
hot water valve position <code>yVal</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>.
</p>
<p>The sequence consists of four subsequences. </p>
<h4>a. Heating and cooling control loop</h4>
<p>
The subsequence is implementd according to Part 5.B.5. The measured zone
temperature <code>TZon</code>, zone setpoints temperatures <code>TZonHeaSet</code> and
<code>TZonCooSet</code> are inputs to the block <code>conHeaLoo</code> and
<code>conCooLoo</code> to generate the control loop signal.
</p>
<h4>b. Active airflow setpoint calculation</h4>
<p>
This sequence sets the active maximum and minimum airflow according to
Part 5.E.3-5. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to Part 5.E.6. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisHeaSet</code>. Along with the defined maximum and minimum airflow, measured
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisHeaSet</code> and discharge airflow rate setpoint <code>VDisSet_flow</code>.
See <a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Part 5.E.9, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the boiler plant reset requests
<code>yHeaPlaReq</code>. See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 5, 2021 by Karthik Devaprasad:<br/>
Added missing outputs <code>yHeaValResReq</code> and <code>yHeaPlaReq</code>
for requests to heating plant.
</li>
<li>
October 9, 2020, by Jianjun Hu:<br/>
Changed the default heating maximum airflow setpoint to 30% of the zone nominal airflow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2172\">issue 2172</a>.
</li>
<li>
April 18, 2020, by Jianjun Hu:<br/>
Added actual VAV damper position as the input for generating system request.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue 1873</a>.
</li>
<li>
March 06, 2020, by Jianjun Hu:<br/>
Added default component name.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1809\">issue 1809</a>.
</li>
<li>
November 15, 2017, by Michael Wetter:<br/>
Added integrator reset.
</li>
<li>
October 27, 2017, by Jianjun Hu:<br/>
Moved it from example package.
</li>
<li>
September 25, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
