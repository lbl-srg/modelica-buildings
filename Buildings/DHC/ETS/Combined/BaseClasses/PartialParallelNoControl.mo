within Buildings.DHC.ETS.Combined.BaseClasses;
model PartialParallelNoControl
  "Partial ETS model with district heat exchanger and parallel connection of production systems"
  extends Buildings.DHC.ETS.BaseClasses.PartialETS(
    final typ=Buildings.DHC.Types.DistrictSystemType.CombinedGeneration5,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_pum=true,
    have_eleHea=false,
    have_weaBus=false);

  parameter Buildings.DHC.ETS.Types.ConnectionConfiguration conCon=
      Buildings.DHC.ETS.Types.ConnectionConfiguration.Pump
    "District connection configuration" annotation (Evaluate=true);
  parameter Integer nSysHea
    "Number of heating systems"
    annotation (Evaluate=true);
  parameter Integer nSysCoo=nSysHea
    "Number of cooling systems"
    annotation (Evaluate=true);
  parameter Integer nSouAmb=1
    "Number of ambient sources"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValIso_nominal(displayUnit=
        "Pa") = 2E3 "Nominal pressure drop of ambient circuit isolation valves"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp1Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.PressureDifference dp2Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.MassFlowRate m1Hex_flow_nominal =
    abs(QHex_flow_nominal/4200/(T_b1Hex_nominal - T_a1Hex_nominal))
    "Design mass flow rate for heat exchanger on district side";
  parameter Real spePum1HexMin(
    final unit="1",
    min=0)=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(group="District heat exchanger",enable=not have_val1Hex));
  parameter Real spePum2HexMin(
    final unit="1",
    min=0.01)=0.1
    "Heat exchanger secondary pump minimum speed (fractional)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Volume VTanHeaWat "Heating water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length hTanHeaWat=(VTanHeaWat*16/Modelica.Constants.pi)
      ^(1/3) "Heating water tank height (assuming twice the diameter)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length dInsTanHeaWat=0.1
    "Heating water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Volume VTanChiWat "Chilled water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length hTanChiWat=(VTanChiWat*16/Modelica.Constants.pi)
      ^(1/3) "Chilled water tank height (without insulation)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length dInsTanChiWat=0.1
    "Chilled water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Integer nSegTan=3
    "Number of volume segments for tanks"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.Units.SI.TemperatureDifference dTOffSetHea(
    min=0.5,
    displayUnit="K") = 1
    "Temperature to be added to the set point in order to be slightly above what the heating load requires";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetCoo(
    max=-0.5,
    displayUnit="K") = -1
    "Temperature to be added to the set point in order to be slightly below what the cooling load requires";

  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),iconTransformation(extent={{-380,
            -60},{-300,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),iconTransformation(extent={{-380,
            -100},{-300,-20}})));
  // COMPONENTS
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal)
                          "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{70,-130},{50,-110}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal)
                         "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));

  Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger hex(
    redeclare final package Medium1=MediumSer,
    redeclare final package Medium2=MediumBui,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui,
    final conCon=conCon,
    final dp1Hex_nominal=dp1Hex_nominal,
    final dp2Hex_nominal=dp2Hex_nominal,
    final Q_flow_nominal=QHex_flow_nominal,
    final T_a1_nominal=T_a1Hex_nominal,
    final T_b1_nominal=T_b1Hex_nominal,
    final T_a2_nominal=T_a2Hex_nominal,
    final T_b2_nominal=T_b2Hex_nominal,
    final spePum1Min=spePum1HexMin,
    final spePum2Min=spePum2HexMin,
    pum2(dpMax=Modelica.Constants.inf)) "District heat exchanger"
    annotation (Placement(transformation(extent={{-10,-240},{10,-260}})));

  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanChiWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=false,
    final m_flow_nominal=colChiWat.mDis_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan) "Chilled water tank"
    annotation (Placement(transformation(extent={{200,100},{180,120}})));
  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanHeaWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=true,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan) "Heating hot water tank"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colChiWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysCoo,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal})
    "Collector/distributor for chilled water" annotation (Placement(
        transformation(
        extent={{-20,10},{20,-10}},
        rotation=180,
        origin={120,-50})));
  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colHeaWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysHea,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal})
    "Collector/distributor for heating water" annotation (Placement(
        transformation(
        extent={{20,10},{-20,-10}},
        rotation=180,
        origin={-120,-50})));
  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colAmbWat(
    redeclare final package Medium = MediumBui,
    final nCon=nSouAmb,
    mCon_flow_nominal={hex.m2_flow_nominal})
    "Collector/distributor for ambient water" annotation (Placement(
        transformation(
        extent={{20,-10},{-20,10}},
        rotation=180,
        origin={0,-106})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(nin=1)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPHea(
    nin=1)
    "Total power drawn by heating system"
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPCoo(
    nin=1)
    "Total power drawn by cooling system"
    annotation (Placement(transformation(extent={{260,10},{280,30}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare final package Medium =
        MediumBui, nPorts=1)
    "Pressure boundary condition representing expansion vessel (common to HHW and CHW)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHexBuiEnt(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=true)
    "Heat exchanger water entering temperature on building side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-210})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHexBuiLvg(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=true)
    "Heat exchanger water leaving temperature on building side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-210})));
protected
  parameter Boolean have_val1Hex=
    conCon ==Buildings.DHC.ETS.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  connect(totPPum.y,PPum)
    annotation (Line(points={{282,-60},{290,-60},{290,-40},{320,-40}},
                                                  color={0,0,127}));
  connect(valIsoEva.port_b,colAmbWat.port_bDisSup)
    annotation (Line(points={{50,-120},{30,-120},{30,-106},{20,-106}},color={0,127,255}));
  connect(valIsoCon.port_b,colAmbWat.port_aDisSup)
    annotation (Line(points={{-50,-120},{-30,-120},{-30,-106},{-20,-106}},color={0,127,255}));
  connect(valIsoEva.port_a,colChiWat.ports_aCon[1])
    annotation (Line(points={{70,-120},{90,-120},{90,-34},{106,-34},{106,-40},{
          108,-40}},                                         color={0,127,255}));
  connect(valIsoCon.port_a,colHeaWat.ports_aCon[1])
    annotation (Line(points={{-70,-120},{-90,-120},{-90,-34},{-108,-34},{-108,
          -40}},                                                color={0,127,255}));
  connect(totPHea.y,PHea)
    annotation (Line(points={{282,60},{290,60},{290,80},{320,80}},
                                                color={0,0,127}));
  connect(totPCoo.y,PCoo)
    annotation (Line(points={{282,20},{290,20},{290,40},{320,40}},
                                                color={0,0,127}));
  connect(bou.ports[1], colChiWat.port_aDisSup)
    annotation (Line(points={{180,-50},{140,-50}},            color={0,127,255}));
  connect(TChiWatSupSet, tanChiWat.TTanSet) annotation (Line(points={{-320,-60},
          {-240,-60},{-240,128},{208,128},{208,119},{201,119}},
                 color={0,0,127}));
  connect(colAmbWat.port_bDisRet, colHeaWat.ports_bCon[1]) annotation (Line(
        points={{-20,-100},{-150,-100},{-150,-34},{-132,-34},{-132,-40}}, color
        ={0,127,255}));
  connect(colAmbWat.port_aDisRet, colChiWat.ports_bCon[1]) annotation (Line(
        points={{20,-100},{154,-100},{154,-34},{132,-34},{132,-40}}, color={0,
          127,255}));
  connect(THeaWatSupSet, tanHeaWat.TTanSet) annotation (Line(points={{-320,-20},
          {-244,-20},{-244,119},{-201,119}},            color={0,0,127}));
  connect(senTHexBuiLvg.port_b, colAmbWat.ports_aCon[1]) annotation (Line(
        points={{-20,-200},{-20,-146},{12,-146},{12,-116}}, color={0,127,255}));
  connect(hex.port_b2, senTHexBuiLvg.port_a) annotation (Line(points={{-10,-244},
          {-20,-244},{-20,-220}}, color={0,127,255}));
  connect(hex.port_a2, senTHexBuiEnt.port_b) annotation (Line(points={{10,-244},
          {30,-244},{30,-220}}, color={0,127,255}));
  connect(senTHexBuiEnt.port_a, colAmbWat.ports_bCon[1]) annotation (Line(
        points={{30,-200},{30,-152},{-12,-152},{-12,-116}}, color={0,127,255}));
  connect(totPPum.u[1], hex.PPum) annotation (Line(points={{258,-60},{220,-60},
          {220,-250},{12,-250}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}}),
      graphics={
        Line(
          points={{86,92}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
    defaultComponentName="ets",
    Documentation(
      info="<html>
<p>
Revised from Buildings.DHC.ETS.Combined.BaseClasses.PartialParallel.
</p>
</html>"));
end PartialParallelNoControl;
