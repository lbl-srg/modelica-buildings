within Buildings.Templates.ZoneEquipment.Components.Controls;
block Guideline36
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialSingleDuct(
      final typ=Buildings.Templates.ZoneEquipment.Types.Controller.Guideline36);

  parameter Boolean have_occSen=false
    "Set to true if zones have occupancy sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));

  parameter Boolean have_winSen=false
    "Set to true if zones have window status sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));

  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal=
    dat.getReal(varName=id + ".mechanical.mAir_flow_nominal.value") / 1.2
    "Volume flow rate"
    annotation (Dialog(group="Nominal condition"));

  /*
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
  */

  parameter Modelica.Units.SI.Time samplePeriod = 120
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

  parameter Real VDisCooSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=V_flow_nominal
    "Maximum cooling airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisSetMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".control.VDisSetMin_flow.value")
    "Minimum airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisHeaSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".control.VDisHeaSetMax_flow.value")
    "Maximum heating airflow setpoint"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real VDisConMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".control.VDisConMin_flow.value")
    "Minimum controllable airflow"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));

  parameter Real CO2Set=
    dat.getReal(varName=id + ".control.CO2Set.value")
    "CO2 setpoint in ppm"
    annotation (Dialog(tab="Airflow setpoint", group="Nominal conditions"));

  parameter Real dTDisZonSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=
    dat.getReal(varName=id + ".control.dTDisZonSetMax.value")
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Dialog(tab="Damper and valve", group="Parameters"));

  parameter Real TDisMin(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC")=
    dat.getReal(varName=id + ".control.TDisMin.value")
    "Lowest discharge air temperature"
    annotation (Dialog(tab="Damper and valve", group="Parameters"));

  // FIXME: bind with have_souHea
  parameter Boolean have_heaPla = false
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

  // FIXME: See issue documented in linkage_g36_sequence.md
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
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonCooOnMax.value")
    "Maximum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonCooOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonCooOnMin.value")
    "Minimum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonHeaOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonHeaOnMax.value")
    "Maximum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonHeaOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonHeaOnMin.value")
    "Minimum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Real TZonCooSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonCooSetWinOpe.value")
    "Cooling setpoint when window is open"
    annotation(Dialog(group="Setpoints limits setting", enable=have_winSen));
  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TZonHeaSetWinOpe.value")
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
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
  */

  parameter Real VOutPerAre_flow(final unit = "m3/(s.m2)")=
      dat.getReal(varName=
        id + ".control.VOutPerAre_flow.value")
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));

  parameter Real VOutPerPer_flow(final unit="m3/s")=
     dat.getReal(varName=
      id + ".control.VOutPerPer_flow.value")
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));

  parameter Real AFlo(final unit="m2")=
     dat.getReal(varName=id + ".control.AFlo.value")
    "Floor area of each zone"
    annotation(Dialog(group="Nominal condition"));

  parameter Real occDen(final unit = "1/m2")=
     dat.getReal(varName=id + ".control.occDen.value")
    "Default number of person per unit area";

  parameter Real zonDisEffHea(final unit = "1")=
     dat.getReal(varName=id + ".control.zonDisEffHea.value")
    "Zone air distribution effectiveness during heating";

  parameter Real zonDisEffCoo(final unit = "1")=
     dat.getReal(varName=id + ".control.zonDisEffCoo.value")
    "Zone air distribution effectiveness during cooling";

  parameter Real desZonDisEff(final unit = "1") = zonDisEffCoo
    "Design zone air distribution effectiveness"
    annotation(Dialog(group="Nominal condition"));

  parameter Real minZonPriFlo(final unit="m3/s")=
     dat.getReal(varName=id + ".control.minZonPriFlo.value")
    "Minimum expected zone primary flow rate"
    annotation(Dialog(group="Nominal condition"));

  /*
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus
  */

  parameter Real THeaSetOcc(
    final unit="K",
    displayUnit="degC")=
      dat.getReal(varName=id + ".control.THeaSetOcc.value")
    "Occupied heating setpoint";

  parameter Real THeaSetUno(
    final unit="K",
    displayUnit="degC")=
      dat.getReal(varName=id + ".control.THeaSetUno.value")
    "Unoccupied heating setpoint";

  parameter Real TCooSetOcc(
    final unit="K",
    displayUnit="degC")=
      dat.getReal(varName=id + ".control.TCooSetOcc.value")
    "Occupied cooling setpoint";

  parameter Real TCooSetUno(
    final unit="K",
    displayUnit="degC")=
      dat.getReal(varName=id + ".control.TCooSetUno.value")
    "Unoccupied cooling setpoint";

  /*
  *  Final parameters
  */
  final parameter Boolean have_heaWatCoi=
    coiHea.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating
    "Flag, true if there is a hot water coil"
    annotation (Dialog(tab="System requests", group="Parameters"));

  final parameter Real desZonPop(
    min=0,
    final unit = "1") = occDen * AFlo
    "Design zone population during peak occupancy";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller ctr(
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
    final durTimDisAir=durTimDisAir) "Terminal unit controller"
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
    annotation (Placement(transformation(extent={{-60,-14},{-40,14}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME(k=1)
    "nOcc should be Boolean"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zonOutAirSet(
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo,
    final desZonDisEff=desZonDisEff,
    final desZonPop=desZonPop,
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta(
    final THeaSetOcc=THeaSetOcc,
    final THeaSetUno=THeaSetUno,
    final TCooSetOcc=TCooSetOcc,
    final TCooSetUno=TCooSetUno,
    final have_winSen=have_winSen)
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{120,-48},{140,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME2(k=1) "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME3(k=1800)
    "Optimal start using global outdoor air temperature not associated with any AHU"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));

equation
  /* Control point connection - start */
  connect(ctr.yDam, bus.damVAV.y);
  connect(ctr.yVal, bus.coiHea.y);

  connect(bus.VAirDis_flow, zonOutAirSet.VDis_flow);
  connect(bus.TAirDis, ctr.TDis);
  connect(bus.VAirDis_flow, ctr.VDis_flow);
  connect(bus.damVAV.y_actual, ctr.yDam_actual);

  connect(bus.ppmCO2, ctr.ppmCO2);
  connect(bus.uWin, ctr.uWin);
  connect(bus.TAirZon, ctr.TZon);
  connect(FIXME.y, ctr.nOcc);

  connect(bus.uOcc, TZonSet.uOccSen);
  connect(bus.uWin, TZonSet.uWinSta);

  connect(FIXME2.y, zonOutAirSet.nOcc);
  connect(bus.uWin, zonOutAirSet.uWin);
  connect(bus.TAirZon, zonOutAirSet.TZon);
  connect(bus.TAirDis, zonOutAirSet.TDis);
  connect(bus.uWin, zonSta.uWin);
  connect(bus.TAirZon, zonSta.TZon);

  connect(FIXME3.y, zonSta.cooDowTim);
  connect(FIXME3.y, zonSta.warUpTim);

  connect(bus.TAirSupSet, ctr.TSupAHU);
  connect(bus.yOpeMod, ctr.uOpeMod);
  connect(TZonSet.TZonCooSet, ctr.TZonCooSet);
  connect(TZonSet.TZonHeaSet, ctr.TZonHeaSet);
  connect(bus.yOpeMod, TZonSet.uOpeMod);
  connect(bus.TZonCooOccSet, TZonSet.TZonCooSetOcc);
  connect(bus.TZonCooUnoSet, TZonSet.TZonCooSetUno);
  connect(bus.TZonHeaOccSet, TZonSet.TZonHeaSetOcc);
  connect(bus.TZonHeaUnoSet, TZonSet.TZonHeaSetUno);
  connect(bus.dTSetAdj, TZonSet.setAdj);
  connect(bus.dTHeaSetAdj, TZonSet.heaSetAdj);
  connect(bus.uCooDemLimLev, TZonSet.uCooDemLimLev);
  connect(bus.uHeaDemLimLev, TZonSet.uHeaDemLimLev);

  connect(ctr.yZonTemResReq, bus.yReqZonTemRes);
  connect(ctr.yZonPreResReq, bus.yReqZonPreRes);
  connect(bus.yReqOutAir, zonOutAirSet.uReqOutAir);
  connect(bus.VDesUncOutAir_flow, zonOutAirSet.VUncOut_flow_nominal);

  connect(zonOutAirSet.yDesZonPeaOcc, bus.yDesZonPeaOcc);
  connect(zonOutAirSet.VDesPopBreZon_flow, bus.VDesPopBreZon_flow);
  connect(zonOutAirSet.VDesAreBreZon_flow, bus.VDesAreBreZon_flow);
  connect(zonOutAirSet.yDesPriOutAirFra, bus.yDesPriOutAirFra);
  connect(zonOutAirSet.VUncOutAir_flow, bus.VUncOutAir_flow);
  connect(zonOutAirSet.yPriOutAirFra, bus.yPriOutAirFra);
  connect(zonOutAirSet.VPriAir_flow, bus.VPriAir_flow);

  connect(zonSta.yCooTim, bus.yCooTim);
  connect(zonSta.yWarTim, bus.yWarTim);
  connect(zonSta.THeaSetOn, bus.THeaSetOn);
  connect(zonSta.yOccHeaHig, bus.yOccHeaHig);
  connect(zonSta.TCooSetOn, bus.TCooSetOn);
  connect(zonSta.yHigOccCoo, bus.yHigOccCoo);
  connect(zonSta.THeaSetOff, bus.THeaSetOff);
  connect(zonSta.yUnoHeaHig, bus.yUnoHeaHig);
  connect(zonSta.yEndSetBac, bus.yEndSetBac);
  connect(zonSta.TCooSetOff, bus.TCooSetOff);
  connect(zonSta.yHigUnoCoo, bus.yHigUnoCoo);
  connect(zonSta.yEndSetUp, bus.yEndSetUp);
  /* Control point connection - end */

  annotation (
    defaultComponentName="conTer",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-140,-20},{66,-74}},
          lineColor={238,46,47},
          textString=
              "Todo: subset indices for different Boolean values (such as have_occSen)")}));
end Guideline36;
