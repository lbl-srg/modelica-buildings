within Buildings.Templates.ZoneEquipment.Components.Interfaces;
block ControllerG36VAVBox "Guideline 36 controller for VAV terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Interfaces.PartialControllerVAVBox;

  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_hotWatCoi=
    coiHea.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating
    "Set to true if the system has hot water coil"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Modelica.Units.SI.VolumeFlowRate VAirCooSet_flow_max=
    dat.VAirCooSet_flow_max
    "Zone maximum cooling airflow setpoint";

  final parameter Modelica.Units.SI.VolumeFlowRate VAirSet_flow_min=
    dat.VAirSet_flow_min
    "Zone minimum airflow setpoint";

  final parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_max=
    dat.VAirHeaSet_flow_max
    "Zone maximum heating airflow setpoint";

  final parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_min=
    dat.VAirHeaSet_flow_min
    "Zone minimum heating airflow setpoint";

  final parameter Modelica.Units.SI.TemperatureDifference dTAirDisHea_max(
    displayUnit="K")=
    dat.dTAirDisHea_max
    "Zone maximum discharge air temperature above heating setpoint";

  final parameter Modelica.Units.SI.VolumeFlowRate VOutMinOcc_flow(
    final min=0,
    start=1)=dat.VOutMinOcc_flow
    "Zone minimum outdoor airflow for occupants"
    annotation (Dialog(enable=
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  final parameter Modelica.Units.SI.VolumeFlowRate VOutMinAre_flow(
    final min=0,
    start=1)=dat.VOutMinAre_flow
    "Zone minimum outdoor airflow for building area"
    annotation (Dialog(enable=
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));

  final parameter Real VOutAre_flow(
    final unit = "m3/s")=
    dat.VOutAre_flow
    "Outdoor air flow rate per unit area"
    annotation (Dialog(enable=
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));

  final parameter Real VOutOcc_flow(
    final unit = "m3/s")=
    dat.VOutOcc_flow
    "Outdoor air flow rate per occupant"
    annotation (Dialog(enable=
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));

  final parameter Real effAirDisHea=
    dat.effAirDisHea
    "Zone air distribution effectiveness during heating";

  final parameter Real effAirDisCoo=
     dat.effAirDisCoo
    "Zone air distribution effectiveness during cooling";

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller ctlReh(
    final venStd=stdVen,
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_hotWatCoi=have_hotWatCoi,
    final VOccMin_flow=VOutMinOcc_flow,
    final VAreMin_flow=VOutMinAre_flow,
    final VAreBreZon_flow=VOutAre_flow,
    final VPopBreZon_flow=VOutOcc_flow,
    final VMin_flow=VAirSet_flow_min,
    final VCooMax_flow=VAirCooSet_flow_max,
    final VHeaMin_flow=VAirHeaSet_flow_min,
    final VHeaMax_flow=VAirHeaSet_flow_max,
    final dTDisZonSetMax=dTAirDisHea_max,
    final zonDisEff_cool=effAirDisCoo,
    final zonDisEff_heat=effAirDisHea) if typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Terminal unit with reheat controller"
    annotation (Placement(transformation(extent={{0,-20},{20,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller ctlCoo(
    final venStd=stdVen,
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final VOccMin_flow=VOutMinOcc_flow,
    final VAreMin_flow=VOutMinAre_flow,
    final VAreBreZon_flow=VOutAre_flow,
    final VPopBreZon_flow=VOutOcc_flow,
    final VMin_flow=VAirSet_flow_min,
    final VCooMax_flow=VAirCooSet_flow_max,
    final zonDisEff_cool=effAirDisCoo,
    final zonDisEff_heat=effAirDisHea) if typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly
    "Terminal unit cooling only controller"
    annotation (Placement(transformation(extent={{0,40},{20,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints TZonSet(
    final have_occSen=have_occSen,
    final have_winSen=have_winSen)
    "Compute zone temperature setpoints"
    annotation (Placement(transformation(extent={{-60,-20},{-40,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus zonSta(
    final have_winSen=have_winSen)
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{0,-120},{20,-92}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowWarUpTim(k=3600)
    "RFE: Optimal start (using global OA temperature not associated with any AHU) not implemented"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setAdj(k=0)
    "RFE: Setpoint adjustment by the occupant is not implemented in the template"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetAdj(k=0)
    "RFE: Setpoint adjustment by the occupant is not implemented in the template"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetAdj(k=0)
    "RFE: Setpoint adjustment by the occupant is not implemented in the template"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uCooDemLimLev(k=0)
    "RFE: Setpoint adjustment by demand limit is not implemented in the template"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uHeaDemLimLev(k=0)
    "RFE: Setpoint adjustment by demand limit is not implemented in the template"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

equation
  /* Control point connection - start */

  // Inputs from bus
  connect(bus.TZon, ctlReh.TZon);
  connect(bus.y1Win, ctlReh.u1Win);
  connect(bus.y1Occ, ctlReh.u1Occ);
  connect(bus.ppmCO2, ctlReh.ppmCO2);
  connect(bus.ppmCO2Set, ctlReh.ppmCO2Set);
  connect(bus.yOpeMod, ctlReh.uOpeMod);
  connect(bus.TAirDis, ctlReh.TDis);
  connect(bus.VAirDis_flow, ctlReh.VDis_flow);
  connect(bus.TAirSup, ctlReh.TSup);
  connect(bus.TAirSupSet, ctlReh.TSupSet);
  connect(bus.y1FanSup_actual, ctlReh.u1Fan);
  connect(bus.y1PlaHeaWat, ctlReh.u1HotPla);
  connect(bus.yOveFloSet, ctlReh.oveFloSet);
  connect(bus.yOveDamPos, ctlReh.oveDamPos);
  connect(bus.y1OveHeaOff, ctlReh.uHeaOff);

  connect(bus.TZon, ctlCoo.TZon);
  connect(bus.y1Win, ctlCoo.u1Win);
  connect(bus.y1Occ, ctlCoo.u1Occ);
  connect(bus.ppmCO2, ctlCoo.ppmCO2);
  connect(bus.ppmCO2Set, ctlCoo.ppmCO2Set);
  connect(bus.yOpeMod, ctlCoo.uOpeMod);
  connect(bus.TAirDis, ctlCoo.TDis);
  connect(bus.VAirDis_flow, ctlCoo.VDis_flow);
  connect(bus.TAirSup, ctlCoo.TSup);
  connect(bus.y1FanSup_actual, ctlCoo.u1Fan);
  connect(bus.yOveFloSet, ctlCoo.oveFloSet);
  connect(bus.yOveDamPos, ctlCoo.oveDamPos);

  connect(bus.y1Occ, TZonSet.u1Occ);
  connect(bus.y1Win, TZonSet.u1Win);

  connect(bus.y1Win, zonSta.u1Win);
  connect(bus.TZon, zonSta.TZon);
  connect(bus.TZonCooOccSet, zonSta.TOccCooSet);
  connect(bus.TZonCooUnoSet, zonSta.TUnoCooSet);
  connect(bus.TZonHeaOccSet, zonSta.TOccHeaSet);
  connect(bus.TZonHeaUnoSet, zonSta.TUnoHeaSet);

  connect(bus.yOpeMod, TZonSet.uOpeMod);
  connect(bus.dTSetAdj, TZonSet.setAdj);
  connect(bus.dTHeaSetAdj, TZonSet.heaSetAdj);
  connect(bus.uCooDemLimLev, TZonSet.uCooDemLimLev);
  connect(bus.uHeaDemLimLev, TZonSet.uHeaDemLimLev);
  connect(bus.TZonCooOccSet, TZonSet.TOccCooSet);
  connect(bus.TZonCooUnoSet, TZonSet.TUnoCooSet);
  connect(bus.TZonHeaOccSet, TZonSet.TOccHeaSet);
  connect(bus.TZonHeaUnoSet, TZonSet.TUnoHeaSet);

  // Outputs to bus
  connect(ctlReh.yDam, bus.damVAV.y);
  connect(ctlReh.yVal, bus.coiHea.y);
  connect(ctlReh.VAdjPopBreZon_flow, bus.VAdjPopBreZon_flow);
  connect(ctlReh.VAdjAreBreZon_flow, bus.VAdjAreBreZon_flow);
  connect(ctlReh.VMinOA_flow, bus.VMinOA_flow);
  connect(ctlReh.VZonAbsMin_flow, bus.VZonAbsMin_flow);
  connect(ctlReh.VZonDesMin_flow, bus.VZonDesMin_flow);
  connect(ctlReh.yCO2, bus.yCO2);

  connect(ctlReh.yZonTemResReq, bus.yReqZonTemRes);
  connect(ctlReh.yZonPreResReq, bus.yReqZonPreRes);

  connect(ctlCoo.yDam, bus.damVAV.y);
  connect(ctlCoo.VAdjPopBreZon_flow, bus.VAdjPopBreZon_flow);
  connect(ctlCoo.VAdjAreBreZon_flow, bus.VAdjAreBreZon_flow);
  connect(ctlCoo.VMinOA_flow, bus.VMinOA_flow);
  connect(ctlCoo.VZonAbsMin_flow, bus.VZonAbsMin_flow);
  connect(ctlCoo.VZonDesMin_flow, bus.VZonDesMin_flow);
  connect(ctlCoo.yCO2, bus.yCO2);

  connect(ctlCoo.yZonTemResReq, bus.yZonTemResReq);
  connect(ctlCoo.yZonPreResReq, bus.yZonPreResReq);

  connect(zonSta.yCooTim, bus.yCooTim);
  connect(zonSta.yWarTim, bus.yWarTim);
  connect(zonSta.yOccHeaHig, bus.yOccHeaHig);
  connect(zonSta.yHigOccCoo, bus.yHigOccCoo);
  connect(zonSta.yUnoHeaHig, bus.yUnoHeaHig);
  connect(zonSta.yEndSetBac, bus.yEndSetBac);
  connect(zonSta.yHigUnoCoo, bus.yHigUnoCoo);
  connect(zonSta.yEndSetUp, bus.yEndSetUp);

  /* Control point connection - end */

  connect(TZonSet.TCooSet, ctlReh.TCooSet) annotation (Line(points={{-38,8},{-22,
          8},{-22,17},{-2,17}}, color={0,0,127}));
  connect(TZonSet.THeaSet, ctlReh.THeaSet) annotation (Line(points={{-38,0},{-20,
          0},{-20,15},{-2,15}}, color={0,0,127}));
  connect(uCooDemLimLev.y, TZonSet.uCooDemLimLev) annotation (Line(points={{-98,
          180},{-70,180},{-70,-8},{-62,-8}}, color={255,127,0}));
  connect(uHeaDemLimLev.y, TZonSet.uHeaDemLimLev) annotation (Line(points={{-98,
          140},{-74,140},{-74,-11},{-62,-11}}, color={255,127,0}));
  connect(cooSetAdj.y, TZonSet.cooSetAdj) annotation (Line(points={{-138,140},{-134,
          140},{-134,-2},{-62,-2}}, color={0,0,127}));
  connect(heaSetAdj.y, TZonSet.heaSetAdj) annotation (Line(points={{-138,100},{-136,
          100},{-136,-4},{-62,-4}}, color={0,0,127}));
  connect(setAdj.y, TZonSet.setAdj) annotation (Line(points={{-138,180},{-132,180},
          {-132,0},{-62,0}}, color={0,0,127}));
  connect(TZonSet.TCooSet, ctlCoo.TCooSet) annotation (Line(points={{-38,8},{-22,
          8},{-22,76},{-2,76}}, color={0,0,127}));
  connect(TZonSet.THeaSet, ctlCoo.THeaSet) annotation (Line(points={{-38,0},{-20,
          0},{-20,74},{-2,74}}, color={0,0,127}));
  connect(cooDowWarUpTim.y, zonSta.cooDowTim) annotation (Line(points={{-38,-100},
          {-20,-100},{-20,-95},{-2,-95}}, color={0,0,127}));
  connect(cooDowWarUpTim.y, zonSta.warUpTim) annotation (Line(points={{-38,-100},
          {-20,-100},{-20,-98},{-2,-98}}, color={0,0,127}));
  annotation (
    defaultComponentName="ctl",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Description</h4>
<p>
This is an implementation of the control sequence specified in
<a href=\"#ASHRAE2021\">ASHRAE (2021)</a>
for VAV terminal units with reheat.
It contains the following components.
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller</a> or
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller</a>:
Main controller for the terminal unit
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints</a>:
Computation of the zone temperature setpoints
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus</a>:
Computation of the zone warm-up and cooldown time
</li>
</ul>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end ControllerG36VAVBox;
