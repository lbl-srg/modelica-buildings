within Buildings.Examples.VAVReheat.Controls;
model AHUGuideline36
  import Buildings;

  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer hysteresis", enable = use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim = 180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer delays at disable"));
  parameter Modelica.SIunits.Time disDel = 15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Economizer delays at disable"));
  parameter Real kPMod=1 "Proportional gain of modulation controller"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Controllers"));
  parameter Real retDamConSigMinMod(
    final min=0,
    final max=1,
    final unit="1") = 0.5 "Minimum modulation control loop signal for the RA damper - maximum for the OA damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real kPDamLim=1 "Proportional gain of damper limit controller"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Modelica.SIunits.Time TiDamLim=30 "Time constant of damper limit controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real conSigMinDamLim=0 "Lower limit of damper position limits control signal output"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real conSigMaxDamLim=1 "Upper limit of damper position limits control signal output"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real retDamConSigMinDamLim(
    final min=conSigMinDamLim,
    final max=conSigMaxDamLim,
    final unit="1")=0.5
    "Minimum control signal for the RA damper position limit - maximum for the OA damper position limit"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Economizer control gains"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Ecnomizer physical damper position limits"));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    supTemSetMulVAV
    annotation (Placement(transformation(extent={{35,-54},{55,-34}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSetPoi(
    zonAre=zonAre,
    occSen=fill(false, numOfZon),
    maxSysPriFlo=maxSysPriFlo,
    minZonPriFlo=minZonPriFlo) "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq1
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  parameter Integer numZon "Total number of served zones/VAV boxes";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(unit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numOfZon]
    "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Area zonAre[numOfZon] "Area of each zone";
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    min=0,
    max=1,
    final unit="1") "Supply fan speed" annotation (Placement(transformation(
          extent={{100,50},{120,70}}), iconTransformation(extent={{100,-10},{120,
            10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller conEco(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final kPMod=kPMod,
    final TiMod=TiMod,
    final retDamConSigMinMod=retDamConSigMinMod,
    final kPDamLim=kPDamLim,
    final TiDamLim=TiDamLim,
    final conSigMinDamLim=conSigMinDamLim,
    final conSigMaxDamLim=conSigMaxDamLim,
    final retDamConSigMinDamLim=retDamConSigMinDamLim,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMim)
           "Economizer controller"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K", final
      quantity="ThermodynamicTemperature")
    "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}}),
    iconTransformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(final unit="K",
      final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(final unit="K", final
      quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(
    extent={{-120,50},{-100,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(
    extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(final unit="m3/s",
      final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(final unit="m3/s",
      final quantity="VolumeFlowRate")
    "Minimum outdoor volumetric airflow rate setpoint"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(numZon=numZon) "Supply fan controller"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReliefDamper
    relDam annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{81,-8},{92,-8},
          {92,0},{110,0}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{81,-12},{92,-12},
          {92,-70},{110,-70}}, color={0,0,127}));
  connect(conEco.uSupFan, conSupFan.ySupFan) annotation (Line(points={{59,-14},
          {40,-14},{40,57},{21,57}}, color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe) annotation (Line(points={{21,50},{
          80,50},{80,60},{110,60}}, color={0,0,127}));
end AHUGuideline36;
