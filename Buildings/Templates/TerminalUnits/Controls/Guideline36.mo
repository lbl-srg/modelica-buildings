within Buildings.Templates.TerminalUnits.Controls;
block Guideline36
  extends Buildings.Templates.BaseClasses.Controls.TerminalUnits.SingleDuct(
    final typ=Templates.Types.ControllerTU.Guideline36);

  /* 
  *  Parameters assigned from external file
  */

  parameter Modelica.SIunits.Area AFlo=
    dat.getReal(varName=id + ".Zone.Floor area")
    "Zone floor area";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal=
    dat.getReal(varName=id + ".Discharge air mass flow rate") / 1.2
    "Volume flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Real VOutPerAre_flow(final unit = "m3/(s.m2)")=
    dat.getReal(varName=id + ".Zone.Outdoor air volume flow rate per unit area")
    "Outdoor air volume flow rate per unit area"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VOutPerPer_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".Zone.Outdoor air volume flow rate per person")
    "Outdoor air volume flow rate per person"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));

  /* 
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller 
  */
  parameter Modelica.SIunits.Time samplePeriod = 120
    "Sample period of trim and respond for pressure reset request";

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

  /* 
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
  */

  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation(Dialog(group="Setpoint adjustable setting"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation(Dialog(group="Setpoint adjustable setting"));
  parameter Boolean sinAdj = false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation(Dialog(group="Setpoint adjustable setting",enable=not (cooAdj or heaAdj)));
  parameter Boolean ignDemLim = true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation(Dialog(group="Setpoint adjustable setting"));

  parameter Real TZonCooOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=300.15
    "Maximum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonCooOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Minimum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonHeaOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Maximum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonHeaOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Minimum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonCooSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15
    "Cooling setpoint when window is open"
    annotation(Dialog(group="Setpoints limits setting", enable=have_winSen));
  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Heating setpoint when window is open"
    annotation(Dialog(group="Setpoints limits setting", enable=have_winSen));

  parameter Real incTSetDem_1=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));
  parameter Real incTSetDem_2=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));
  parameter Real incTSetDem_3=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));
  parameter Real decTSetDem_1=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));
  parameter Real decTSetDem_2=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));
  parameter Real decTSetDem_3=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand control"));

  /* 
  *  Final parameters
  */
  final parameter Boolean have_heaWatCoi=
    coiReh.typ==Buildings.Templates.Types.Coil.WaterBased
    "Flag, true if there is a hot water coil"
    annotation (Dialog(tab="System requests", group="Parameters"));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conTerUni(
    final samplePeriod=samplePeriod,
    final AFlo=AFlo,
    final V_flow_nominal=V_flow_nominal,
    final controllerTypeCoo=controllerTypeCoo,
    final kCoo=kCoo,
    final TiCoo=TiCoo,
    final TdCoo=TdCoo,
    final controllerTypeHea=controllerTypeHea,
    final kHea=kHea,
    final TiHea=TiHea,
    final TdHea=TdHea,
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_CO2Sen=have_CO2Sen,
    final VDisCooSetMax_flow=VDisCooSetMax_flow,
    final VDisSetMin_flow=VDisSetMin_flow,
    final VDisHeaSetMax_flow=VDisHeaSetMax_flow,
    final VDisConMin_flow=VDisConMin_flow,
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final CO2Set=CO2Set,
    final dTDisZonSetMax=dTDisZonSetMax,
    final TDisMin=TDisMin,
    final have_heaWatCoi=have_heaWatCoi,
    final have_heaPla=have_heaPla,
    final errTZonCoo_1=errTZonCoo_1,
    final errTZonCoo_2=errTZonCoo_2,
    final errTDis_1=errTDis_1,
    final errTDis_2=errTDis_2,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final durTimDisAir=durTimDisAir)
    "Terminal unit controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet(
      final have_occSen=have_occSen,
      final have_winSen=have_winSen,
      final cooAdj=cooAdj,
      final heaAdj=heaAdj,
      final sinAdj=sinAdj,
      final ignDemLim=ignDemLim,
      final TZonCooOnMax=TZonCooOnMax,
      final TZonCooOnMin=TZonCooOnMin,
      final TZonHeaOnMax=TZonHeaOnMax,
      final TZonHeaOnMin=TZonHeaOnMin,
      final TZonCooSetWinOpe=TZonCooSetWinOpe,
      final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
      final incTSetDem_1=incTSetDem_1,
      final incTSetDem_2=incTSetDem_2,
      final incTSetDem_3=incTSetDem_3,
      final decTSetDem_1=decTSetDem_1,
      final decTSetDem_2=decTSetDem_2,
      final decTSetDem_3=decTSetDem_3)
    "Compute zone temperature set points"
    annotation (Placement(transformation(extent={{-60,-54},{-40,-26}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME(k=1)
    "nOcc should be Boolean"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));

protected
  BaseClasses.Connectors.SubBusOutput busOut
    "Output points"
    annotation (Placement(
        transformation(extent={{30,0},{70,40}}), iconTransformation(extent={{-10,22},
            {10,42}})));

  BaseClasses.Connectors.SubBusSoftware busSof
    "Software points"
    annotation (Placement(
        transformation(extent={{30,-40},{70,0}}), iconTransformation(extent={{-10,42},
            {10,62}})));

equation
  connect(busTer.inp.ppmCO2,conTerUni. ppmCO2) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,6},{-12,6}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin,conTerUni. uWin) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,2},{-12,2}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon,conTerUni. TZon) annotation (Line(
      points={{-200.1,0.1},{-56,0.1},{-56,0},{-12,0}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME.y,conTerUni. nOcc) annotation (Line(points={{-218,40},{-30,40},{
          -30,4},{-12,4}}, color={0,0,127}));
  connect(busTer.inp.VDis_flow,conTerUni. VDis_flow) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-2},{-12,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.yDamVAV_actual,conTerUni. yDam_actual) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-4},{-12,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TDis,conTerUni. TDis) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-6},{-12,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TSupSet,conTerUni. TSupAHU) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-8},{-12,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.yOpeMod, conTerUni.uOpeMod) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(TZonSet.TZonCooSet,conTerUni. TZonCooSet) annotation (Line(points={{-38,
          -32},{-22,-32},{-22,8},{-12,8}}, color={0,0,127}));
  connect(TZonSet.TZonHeaSet,conTerUni. TZonHeaSet) annotation (Line(points={{-38,
          -40},{-24,-40},{-24,10},{-12,10}}, color={0,0,127}));
  connect(busTer.sof.yOpeMod, TZonSet.uOpeMod) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-27},{-62,-27}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonCooOccSet, TZonSet.TZonCooSetOcc) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-31},{-62,-31}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonCooUnoSet, TZonSet.TZonCooSetUno) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-33},{-62,-33}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonHeaOccSet, TZonSet.TZonHeaSetOcc) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-36},{-62,-36}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonHeaUnoSet, TZonSet.TZonHeaSetUno) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-38},{-62,-38}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.dTSetAdj, TZonSet.setAdj) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-41},{-62,-41}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.dTHeaSetAdj, TZonSet.heaSetAdj) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-43},{-62,-43}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.uCooDemLimLev, TZonSet.uCooDemLimLev) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-46},{-62,-46}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.uHeaDemLimLev, TZonSet.uHeaDemLimLev) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-48},{-62,-48}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uOcc, TZonSet.uOccSen) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-51},{-62,-51}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, TZonSet.uWinSta) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-53},{-62,-53}},
      color={255,204,51},
      thickness=0.5));
  connect(conTerUni.yDam, busOut.yDamVAV)
    annotation (Line(points={{12,6},{16,6},{16,20},{50,20}}, color={0,0,127}));
  connect(conTerUni.yVal, busOut.yCoiReh) annotation (Line(points={{12,1},{20,1},{
          20,16},{50,16},{50,20}}, color={0,0,127}));
  connect(conTerUni.yZonTemResReq, busSof.yReqZonTemRes) annotation (Line(
        points={{12,-4},{20,-4},{20,-20},{50,-20}}, color={255,127,0}));
  connect(conTerUni.yZonPreResReq, busSof.yReqZonPreRes) annotation (Line(
        points={{12,-8},{16,-8},{16,-24},{50,-24},{50,-20}}, color={255,127,0}));
  connect(busOut, busTer.out) annotation (Line(
      points={{50,20},{80,20},{80,60},{-180,60},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busSof, busTer.sof) annotation (Line(
      points={{50,-20},{80,-20},{80,-60},{-180,-60},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="conTer",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-182,-52},{24,-106}},
          lineColor={238,46,47},
          textString=
              "Todo: subset indices for different Boolean values (such as have_occSen)")}));
end Guideline36;
