within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block Controller "Controller for room VAV box"

  parameter Modelica.SIunits.Time samplePeriod
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal
    "Volume flow rate of this thermal zone";
  parameter Modelica.SIunits.Area AFlo "Area of the zone";


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

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Valve"));

  parameter Real kVal=0.5
    "Gain of controller for valve control"
    annotation (Dialog(group="Valve"));

  parameter Modelica.SIunits.Time TiVal=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdVal=0.1
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

  parameter Modelica.SIunits.Time TiDam=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdDam=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Modelica.SIunits.VolumeFlowRate VCooMax=V_flow_nominal
    "Zone maximum cooling airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMin=0.15*V_flow_nominal
    "Zone minimum airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax=V_flow_nominal
    "Zone maximum heating airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon=0.1*V_flow_nominal
    "VAV box controllable minimum"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real outAirPerAre(final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air rate per person"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real CO2Set=894 "CO2 setpoint in ppm"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.TemperatureDifference dTDisMax=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="Parameters"));
  parameter Modelica.SIunits.Temperature TDisMin=283.15
    "Lowest discharge air temperature"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="Parameters"));
  parameter Boolean have_heaWatCoi=true
    "Flag, true if there is a hot water coil"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Boolean have_heaPla=false
    "Flag, true if there is a boiler plant"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_1=2.8
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 3 cooling SAT reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_2=1.7
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 2 cooling SAT reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_1=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_2=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.Time durTimTem=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimFlo=60
    "Duration time of airflow rate less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimDisAir=300
    "Duration time of discharge air temperature is less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-180,140},{-140,180}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis(
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAHU(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-180,-150},{-140,-110}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Measured CO2 concentration"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-180,-190},{-140,-150}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    min=0,
    max=1,
    final unit="1")
    "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}}),
      iconTransformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    min=0,
    max=1,
    final unit="1")
    "Signal for VAV damper"
    annotation (Placement(transformation(extent={{140,70},{160,90}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet(
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_CO2Sen=have_CO2Sen,
    final VCooMax=VCooMax,
    final VMin=VMin,
    final VHeaMax=VHeaMax,
    final VMinCon=VMinCon,
    final outAirPerAre=outAirPerAre,
    final outAirPerPer=outAirPerPer,
    final CO2Set=CO2Set)
    "Active airflow rate setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves damVal(
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTDisMax=dTDisMax,
    final TDisMin=TDisMin,
    V_flow_nominal=max(VCooMax, VHeaMax))
                           "Damper and valve controller"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests sysReq(
    final samplePeriod=samplePeriod,
    final have_heaWatCoi=have_heaWatCoi,
    final have_heaPla=have_heaPla,
    final cooSetDif_1=cooSetDif_1,
    final cooSetDif_2=cooSetDif_2,
    final disAirSetDif_1=disAirSetDif_1,
    final disAirSetDif_2=disAirSetDif_2,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final durTimDisAir=durTimDisAir)
    "Number of system requests"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conHeaLoo(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final yMax=1,
    final yMin=0,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
                  "Heating loop signal"
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conCooLoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0,
    reverseAction=true,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
                        "Cooling loop signal"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));

protected
  CDL.Integers.Equal isUnOcc "Output true if unoccupied"
    annotation (Placement(transformation(extent={{-38,-160},{-18,-140}})));
  CDL.Integers.Sources.Constant conIntUn(final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  CDL.Logical.Not isNotUn "Output true if not unoccupied"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
equation
  connect(sysReq.TCooSet, TRooCooSet)
    annotation (Line(points={{79,-81},{-120,-81},{-120,120},{-160,120}},
      color={0,0,127}));
  connect(sysReq.TRoo, TRoo)
    annotation (Line(points={{79,-83},{0,-83},{0,-20},{-160,-20}},
      color={0,0,127}));
  connect(sysReq.VDisSet, damVal.VDisSet)
    annotation (Line(points={{79,-88},{64,-88},{64,-2},{41,-2}},
      color={0,0,127}));
  connect(sysReq.VDis, VDis)
    annotation (Line(points={{79,-90},{34,-90},{34,-60},{-160,-60}},
      color={0,0,127}));
  connect(sysReq.TDisSet, damVal.TDisSet)
    annotation (Line(points={{79,-95},{58,-95},{58,-18},{41,-18}},
      color={0,0,127}));
  connect(damVal.yDam, yDam)
    annotation (Line(points={{41,-6},{120,-6},{120,80},{150,80}},
      color={0,0,127}));
  connect(damVal.yHeaVal, yVal)
    annotation (Line(points={{41,-14},{120,-14},{120,-20},{150,-20}},
      color={0,0,127}));
  connect(damVal.VDis, VDis)
    annotation (Line(points={{34,-23},{34,-60},{-160,-60}},color={0,0,127}));
  connect(damVal.TDis, TDis)
    annotation (Line(points={{26,-23},{26,-100},{-160,-100}},
                                                           color={0,0,127}));
  connect(sysReq.TDis, TDis)
    annotation (Line(points={{79,-97},{26,-97},{26,-100},{-160,-100}},
      color={0,0,127}));
  connect(sysReq.uDam, damVal.yDam)
    annotation (Line(points={{79,-92},{62,-92},{62,-6},{41,-6}},
      color={0,0,127}));
  connect(damVal.yHeaVal, sysReq.uHeaVal)
    annotation (Line(points={{41,-14},{40,-14},{40,-99},{79,-99}},
                                                             color={0,0,127}));
  connect(TRoo, damVal.TRoo) annotation (Line(points={{-160,-20},{-40,-20},{-40,
          -19},{19,-19}},
                   color={0,0,127}));
  connect(damVal.TSup, TSupAHU) annotation (Line(points={{19,-17},{-80,-17},{
          -80,-130},{-160,-130}},
                       color={0,0,127}));
  connect(actAirSet.VActCooMax, damVal.VActCooMax) annotation (Line(points={{-19,78},
          {0,78},{0,-1},{19,-1}},      color={0,0,127}));
  connect(actAirSet.VActCooMin, damVal.VActCooMin) annotation (Line(points={{-19,75},
          {-2,75},{-2,-3},{19,-3}},      color={0,0,127}));
  connect(actAirSet.VActMin, damVal.VActMin) annotation (Line(points={{-19,72},
          {-4,72},{-4,-9},{19,-9}}, color={0,0,127}));
  connect(actAirSet.VActHeaMin, damVal.VActHeaMin) annotation (Line(points={{-19,69},
          {-6,69},{-6,-7},{19,-7}},    color={0,0,127}));
  connect(actAirSet.VActHeaMax, damVal.VActHeaMax) annotation (Line(points={{-19,66},
          {-8,66},{-8,-5},{19,-5}},    color={0,0,127}));
  connect(damVal.THeaSet, TRooHeaSet)
    annotation (Line(points={{19,-15},{-124,-15},{-124,160},{-160,160}},
      color={0,0,127}));
  connect(actAirSet.VActCooMax, damVal.VActCooMax)
    annotation (Line(points={{-19,78},{0,78},{0,-1},{19,-1}},
      color={0,0,127}));
  connect(actAirSet.VActCooMin, damVal.VActCooMin)
    annotation (Line(points={{-19,75},{-2,75},{-2,-3},{19,-3}},
      color={0,0,127}));
  connect(actAirSet.VActMin, damVal.VActMin)
    annotation (Line(points={{-19,72},{-4,72},{-4,-9},{19,-9}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMin, damVal.VActHeaMin)
    annotation (Line(points={{-19,69},{-6,69},{-6,-7},{19,-7}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMax, damVal.VActHeaMax)
    annotation (Line(points={{-19,66},{-8,66},{-8,-5},{19,-5}},
      color={0,0,127}));
  connect(actAirSet.uOpeMod, uOpeMod)
    annotation (Line(points={{-41,67},{-112,67},{-112,-170},{-160,-170}},
      color={255,127,0}));
  connect(sysReq.yZonTemResReq, yZonTemResReq)
    annotation (Line(points={{101,-83},{120,-83},{120,-80},{150,-80}},
      color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq)
    annotation (Line(points={{101,-88},{120,-88},{120,-120},{150,-120}},
      color={255,127,0}));
  connect(actAirSet.ppmCO2, ppmCO2)
    annotation (Line(points={{-41,76},{-60,76},{-60,80},{-160,80}},
      color={0,0,127}));
  connect(actAirSet.nOcc, nOcc)
    annotation (Line(points={{-41,72},{-60,72},{-60,40},{-160,40}},
      color={0,0,127}));
  connect(actAirSet.uWin, uWin)
    annotation (Line(points={{-41,63},{-56,63},{-56,10},{-160,10}},
      color={255,0,255}));
  connect(TRooHeaSet, conHeaLoo.u_s)
    annotation (Line(points={{-160,160},{-112,160}}, color={0,0,127}));
  connect(TRooCooSet, conCooLoo.u_s)
    annotation (Line(points={{-160,120},{-112,120}}, color={0,0,127}));
  connect(TRoo, conHeaLoo.u_m)
    annotation (Line(points={{-160,-20},{-122,-20},{-122,140},{-100,140},{-100,148}},
                   color={0,0,127}));
  connect(TRoo, conCooLoo.u_m)
    annotation (Line(points={{-160,-20},{-122,-20},{-122,100},{-100,100},
      {-100,108}}, color={0,0,127}));
  connect(conCooLoo.y, damVal.uCoo)
    annotation (Line(points={{-89,120},{8,120},{8,-11},{19,-11}},
      color={0,0,127}));
  connect(conHeaLoo.y, damVal.uHea)
    annotation (Line(points={{-89,160},{12,160},{12,-13},{19,-13}},
      color={0,0,127}));
  connect(conCooLoo.y, sysReq.uCoo)
    annotation (Line(points={{-89,120},{8,120},{8,-85},{79,-85}},
      color={0,0,127}));

  connect(damVal.uOpeMod, uOpeMod) annotation (Line(points={{19,-21},{-112,-21},
          {-112,-170},{-160,-170}},
                                  color={255,127,0}));
  connect(conIntUn.y, isUnOcc.u1)
    annotation (Line(points={{-59,-150},{-40,-150}}, color={255,127,0}));
  connect(uOpeMod, isUnOcc.u2) annotation (Line(points={{-160,-170},{-52,-170},{
          -52,-158},{-40,-158}}, color={255,127,0}));
  connect(isUnOcc.y, isNotUn.u)
    annotation (Line(points={{-17,-150},{-2,-150}}, color={255,0,255}));
  connect(isNotUn.y, conCooLoo.trigger) annotation (Line(points={{21,-150},{40,-150},
          {40,-122},{-116,-122},{-116,102},{-108,102},{-108,108}}, color={255,0,
          255}));
  connect(isNotUn.y, conHeaLoo.trigger) annotation (Line(points={{21,-150},{40,-150},
          {40,-120},{-116,-120},{-116,142},{-108,142},{-108,148}}, color={255,0,
          255}));
annotation (Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-26},{-70,-36}},
          lineColor={0,0,127},
          textString="TDis"),
        Text(
          extent={{-98,-46},{-68,-58}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{70,18},{98,4}},
          lineColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{68,70},{96,56}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-96,56},{-44,44}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-98,14},{-74,4}},
          lineColor={0,0,127},
          textString="VDis"),        Text(
        extent={{-120,160},{114,108}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-96,-4},{-74,-18}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-96,34},{-42,24}},
          lineColor={0,0,127},
          textString="TRooCooSet"),
        Text(
          extent={{-96,-64},{-48,-76}},
          lineColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-100,96},{-68,86}},
          lineColor={0,0,127},
          textString="nOcc"),
        Text(
          extent={{-94,78},{-56,60}},
          lineColor={0,0,127},
          textString="ppmCO2"),
        Text(
          extent={{-100,-82},{-64,-92}},
          lineColor={0,0,127},
          textString="uWin"),
        Text(
          extent={{22,-20},{96,-58}},
          lineColor={0,0,127},
          textString="yZonTemResReq"),
        Text(
          extent={{24,-62},{96,-96}},
          lineColor={0,0,127},
          textString="yZonPreResReq")}),
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
temperature <code>TRoo</code>, zone setpoints temperatures <code>TRooHeaSet</code> and
<code>TRooCooSet</code> are inputs to the block <code>conHeaLoo</code> and 
<code>conCooLoo</code> to generate the control loop signal. 
</p>
<h4>b. Active airflow setpoint calculation</h4>
<p>
This sequence sets the active maximum and minimum airflow according to
Part 5.E.3-5. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to Part 5.E.6. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisSet</code>. Along with the defined maximum and minimum airflow, measured
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VDisSet</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Part 5.E.9, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the boiler plant reset requests
<code>yHeaPlaReq</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests</a>.
</p>
</html>", revisions="<html>
<ul>
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
