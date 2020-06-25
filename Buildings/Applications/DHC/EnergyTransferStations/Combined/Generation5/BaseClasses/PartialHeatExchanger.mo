within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.BaseClasses;
model PartialHeatExchanger
  "Partial ETS model with district heat exchanger"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_heaWat=true,
    final have_chiWat=true,
    final have_pum=true,
    have_hotWat=false,
    have_eleHea=false,
    have_weaBus=false,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);

  parameter Boolean have_val1Hex=false
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Integer nSysHea
    "Number of heating systems"
    annotation(Evaluate=true);
  parameter Integer nSysCoo = nSysHea
    "Number of cooling systems"
    annotation(Evaluate=true);
  parameter Integer nSouAmb = 1
    "Number of ambient sources"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dpValIso_nominal(
    displayUnit="Pa") = 2E3
    "Nominal pressure drop of ambient circuit isolation valves"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.TemperatureDifference dT2HexSet[2]
    "Secondary side deltaT set-point schedule (index 1 for heat rejection)"
    annotation (Dialog(group="District heat exchanger"));

  parameter Modelica.SIunits.Volume VTanHeaWat
    "Heating water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.Length hTanHeaWat=
    (VTanHeaWat * 16 / Modelica.Constants.pi)^(1/3)
    "Heating water tank height (assuming twice the diameter)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.Length dInsTanHeaWat = 0.1
    "Heating water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.Volume VTanChiWat
    "Chilled water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.Length hTanChiWat=
    (VTanChiWat * 16 / Modelica.Constants.pi)^(1/3)
    "Chilled water tank height (without insulation)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.Length dInsTanChiWat = 0.1
    "Chilled water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Integer nSegTan = 3
    "Number of volume segments for tanks"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.SIunits.TemperatureDifference dTHys = 2
    "Temperature hysteresis for supervisory control"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band for supervisory control"
    annotation (Dialog(group="Supervisory controller"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType[nSouAmb]=
    fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI, nSouAmb)
    "Type of controller"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kHot[nSouAmb](each min=0)=fill(0.1, nSouAmb)
    "Gain of controller on hot side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kCol[nSouAmb](each min=0)=fill(0.2, nSouAmb)
    "Gain of controller on cold side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.SIunits.Time Ti[nSouAmb](
    each min=Buildings.Controls.OBC.CDL.Constants.small)=fill(300, nSouAmb)
    "Time constant of integrator block (hot and cold side)"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
      for i in 1:nSouAmb}),
      group="Supervisory controller"));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(displayUnit="degC")
    "Minimum value of heating water supply temperature set-point"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point"
    annotation (Dialog(group="Supervisory controller"));

  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"
    annotation (Placement(transformation(extent={{-340,80},{-300,120}}),
      iconTransformation(extent={{-380,40},{-300,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}}),
      iconTransformation(extent={{-380,-40},{-300, 40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),
      iconTransformation(extent={{-380,-120},{-300,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-380,-200},{-300,-120}})));

  // COMPONENTS
  Controls.Supervisory conSup(
    final nSouAmb=nSouAmb,
    final controllerType=controllerType,
    final kHot=kHot,
    final kCol=kCol,
    final Ti=Ti,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final THeaWatSupSetMin=THeaWatSupSetMin,
    final TChiWatSupSetMax=TChiWatSupSetMax)
    "Supervisory controller"
    annotation (Placement(transformation(extent={{-260,12},{-240,32}})));

  Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    use_inputFilter=false)
    "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{70,-130},{50,-110}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    use_inputFilter=false)
    "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));

  Subsystems.HeatExchanger hex(
    redeclare final package Medium1 = MediumDis,
    redeclare final package Medium2 = MediumBui,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui,
    final have_val1Hex=have_val1Hex,
    final dp1Hex_nominal=dp1Hex_nominal,
    final dp2Hex_nominal=dp2Hex_nominal,
    final QHex_flow_nominal=QHex_flow_nominal,
    final T_a1Hex_nominal=T_a1Hex_nominal,
    final T_b1Hex_nominal=T_b1Hex_nominal,
    final T_a2Hex_nominal=T_a2Hex_nominal,
    final T_b2Hex_nominal=T_b2Hex_nominal,
    final dT2HexSet=dT2HexSet)
    "District heat exchanger"
    annotation (Placement(transformation(extent={{-10,-244},{10,-264}})));

  EnergyTransferStations.BaseClasses.StratifiedTank tanChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=colChiWat.mDis_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan) "Chilled water tank"
    annotation (Placement(transformation(extent={{200,96},{220,116}})));
  EnergyTransferStations.BaseClasses.StratifiedTank tanHeaWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan) "Heating water tank"
    annotation (Placement(transformation(extent={{-220,96},{-200,116}})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colChiWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysCoo,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal})
    "Collector/distributor for chilled water"
    annotation (Placement(
      transformation(
      extent={{-20,10},{20,-10}},
      rotation=180,
      origin={120,-34})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colHeaWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysHea,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal})
    "Collector/distributor for heating water"
    annotation (Placement(
      transformation(
      extent={{20,10},{-20,-10}},
      rotation=180,
      origin={-120,-34})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colAmbWat(
    redeclare final package Medium = MediumBui,
    final nCon=nSouAmb,
    mCon_flow_nominal={hex.m2_flow_nominal})
    "Collector/distributor for ambient water"
    annotation (Placement(
      transformation(
      extent={{20,-10},{-20,10}},
      rotation=180,
      origin={0,-106})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(nin=1)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(nin=1)
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(nin=1)
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{260,10},{280,30}})));
equation
  connect(hex.PPum, totPPum.u[1])
    annotation (Line(points={{12,-254},{36,-254},{36,-60},{258,-60}},           color={0,0,127}));
  connect(THeaWatSupSet, conSup.THeaWatSupPreSet)
    annotation (Line(points={{-320, -60},{-280,-60},{-280,26},{-262,26}}, color={0,0,127}));
  connect(port_aDis,hex. port_a1)
    annotation (Line(points={{-300,-260},{-10,-260}}, color={0,127,255}));
  connect(hex.port_b1, port_bDis)
    annotation (Line(points={{10,-260},{300,-260}}, color={0,127,255}));
  connect(ports_aHeaWat[1], tanHeaWat.port_aBot) annotation (Line(points={{-300,
          260},{-280,260},{-280,100},{-220,100}}, color={0,127,255}));
  connect(tanHeaWat.port_bTop, ports_bHeaWat[1]) annotation (Line(points={{-220,
          112},{-260,112},{-260,260},{300,260}}, color={0,127,255}));
  connect(tanHeaWat.TTop, conSup.THeaWatTop) annotation (Line(points={{-199,115},
          {-182,115},{-182,82},{-274,82},{-274,24},{-262,24}}, color={0,0,127}));
  connect(tanHeaWat.TBot, conSup.THeaWatBot) annotation (Line(points={{-199,97},
          {-184,97},{-184,84},{-276,84},{-276,22},{-262,22}},  color={0,0,127}));
  connect(tanChiWat.TTop, conSup.TChiWatTop) annotation (Line(points={{221,115},
          {238,115},{238,80},{-272,80},{-272,18},{-262,18}}, color={0,0,127}));
  connect(tanChiWat.TBot, conSup.TChiWatBot) annotation (Line(points={{221,97},{
          240,97},{240,78},{-270,78},{-270,16},{-262,16}}, color={0,0,127}));
  connect(hex.port_b2, colAmbWat.ports_aCon[1]) annotation (Line(points={{-10,
          -248},{-20,-248},{-20,-160},{12,-160},{12,-116}}, color={0,127,255}));
  connect(hex.port_a2, colAmbWat.ports_bCon[1]) annotation (Line(points={{10,-248},
          {20,-248},{20,-140},{-12,-140},{-12,-116}}, color={0,127,255}));
  connect(tanChiWat.port_bBot, ports_bChiWat[1]) annotation (Line(points={{220,100},
          {290,100},{290,200},{300,200}}, color={0,127,255}));
  connect(ports_aChiWat[1], tanChiWat.port_aTop) annotation (Line(points={{-300,
          200},{280,200},{280,112},{220,112}}, color={0,127,255}));
  connect(totPPum.y, PPum) annotation (Line(points={{282,-60},{320,-60}}, color={0,0,127}));
  connect(hex.yValIso[1], valIsoCon.y_actual) annotation (Line(
      points={{-12,-251},{-40,-251},{-40,-113},{-55,-113}},
      color={0,0,127}));
  connect(hex.yValIso[2], valIsoEva.y_actual) annotation (Line(
      points={{-12,-253},{-16,-253},{-16,-240},{40,-240},{40,-113},{55,-113}},
      color={0,0,127}));
  connect(valIsoEva.port_b, colAmbWat.port_bDisSup) annotation (Line(points={{50,
          -120},{30,-120},{30,-106},{20,-106}}, color={0,127,255}));
  connect(valIsoCon.port_b, colAmbWat.port_aDisSup) annotation (Line(points={{-50,
          -120},{-30,-120},{-30,-106},{-20,-106}}, color={0,127,255}));
  connect(TChiWatSupSet, conSup.TChiWatSupPreSet) annotation (Line(points={{-320,
          -20},{-266,-20},{-266,20},{-262,20}}, color={0,0,127}));
  connect(uCoo, conSup.uCoo) annotation (Line(points={{-320,60},{-292,60},{-292,
          28},{-262,28}}, color={255,0,255}));
  connect(uHea, conSup.uHea) annotation (Line(points={{-320,100},{-290,100},{-290,
          30},{-262,30}}, color={255,0,255}));
  connect(valIsoEva.port_a, colChiWat.ports_aCon[1]) annotation (Line(points={{70,-120},
          {108,-120},{108,-24}}, color={0,127,255}));
  connect(colAmbWat.port_aDisRet, colChiWat.ports_bCon[1]) annotation (Line(
        points={{20,-100},{132,-100},{132,-24}}, color={0,127,255}));
  connect(conSup.yIsoEva, valIsoEva.y) annotation (Line(points={{-238,19},{-216,
          19},{-216,-80},{60,-80},{60,-108}}, color={0,0,127}));
  connect(conSup.yIsoCon, valIsoCon.y) annotation (Line(points={{-238,22},{-228,
          22},{-228,22},{-220,22},{-220,-84},{-60,-84},{-60,-108}}, color={0,0,127}));
  connect(conSup.yAmb[nSouAmb],hex. u) annotation (Line(points={{-238,25},{-200,
          25},{-200,-256},{-12,-256}}, color={0,0,127}));
  connect(colChiWat.port_bDisRet, tanChiWat.port_aBot) annotation (Line(points={
          {140,-40},{180,-40},{180,100},{200,100}}, color={0,127,255}));
  connect(colChiWat.port_aDisSup, tanChiWat.port_bTop) annotation (Line(points={
          {140,-34},{160,-34},{160,112},{200,112}}, color={0,127,255}));
  connect(colHeaWat.port_bDisRet, tanHeaWat.port_aTop) annotation (Line(points={
          {-140,-40},{-160,-40},{-160,112},{-200,112}}, color={0,127,255}));
  connect(tanHeaWat.port_bBot, colHeaWat.port_aDisSup) annotation (Line(points={{-200,
          100},{-180,100},{-180,-34},{-140,-34}}, color={0,127,255}));
  connect(valIsoCon.port_a, colHeaWat.ports_aCon[1]) annotation (Line(points={{-70,
          -120},{-108,-120},{-108,-24}}, color={0,127,255}));
  connect(colAmbWat.port_bDisRet, colHeaWat.ports_bCon[1]) annotation (Line(
        points={{-20,-100},{-132,-100},{-132,-24}}, color={0,127,255}));
  connect(totPHea.y, PHea)
    annotation (Line(points={{282,60},{320,60}}, color={0,0,127}));
  connect(totPCoo.y, PCoo)
    annotation (Line(points={{282,20},{320,20}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ets",
Documentation(info="<html>
<p>
connect con.yAmb[nSouAmb], int.u

colChiWat and colHeaWat connection index starts with 1 for the connection with the chiller
and ends with nConChiWat and nConHeaWat for the last connection before the buffer 
tank which corresponds to the ambient water loop. 


When extending this class 

nAuxCoo and colChiWat.mCon_flow_nominal must be updated if an additional cooling equipment is modeled,

nAuxHea and colHeaWat.mCon_flow_nominal must be updated if an additional heating equipment is modeled,

nSouAmb and colAmbWat.mCon_flow_nominal must be updated if an additional ambient source is modeled.
</p>
</html>",
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialHeatExchanger;
