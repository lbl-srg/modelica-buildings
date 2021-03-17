within Buildings.Templates.TerminalUnits.Controls;
block Guideline36
  extends Buildings.Templates.Interfaces.ControllerTerminalUnit;

  parameter Modelica.SIunits.Time samplePeriod=
    dat.getReal(varName=id + ".Controller.Sample period")
    "Sample period of trim and respond for pressure reset request";
  parameter Modelica.SIunits.Area AFlo=
    dat.getReal(varName=id + ".Zone floor area")
    "Zone floor area";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal=
    dat.getReal(varName=id + ".Supply air mass flow rate") / 1.2
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(tab="Airflow setpoint", group="Zone sensors"));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conTerUni(
    final samplePeriod=samplePeriod,
    final V_flow_nominal=V_flow_nominal,
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_CO2Sen=have_CO2Sen)
    "Terminal unit controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet(
      final have_occSen=have_occSen,
      final have_winSen=have_winSen)
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
  connect(busTer.sof.uOpeMod,conTerUni. uOpeMod) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(TZonSet.TZonCooSet,conTerUni. TZonCooSet) annotation (Line(points={{-38,
          -32},{-22,-32},{-22,8},{-12,8}}, color={0,0,127}));
  connect(TZonSet.TZonHeaSet,conTerUni. TZonHeaSet) annotation (Line(points={{-38,
          -40},{-24,-40},{-24,10},{-12,10}}, color={0,0,127}));
  connect(busTer.sof.uOpeMod, TZonSet.uOpeMod) annotation (Line(
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
        coordinateSystem(preserveAspectRatio=false)));
end Guideline36;
