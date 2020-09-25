within Buildings.Applications.DHC.Examples.Cooling.BaseClasses;
model BuildingTimeSeriesWithETSCooling
  "Model of a building with thermal loads as time series, with an energy transfer station"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=mDis_flow_nominal,
    final m_flow_small=1E-4*m_flow_nominal,
    final allowFlowReversal=allowFlowReversalDis);

  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal on the building side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalDis = false
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.SIunits.Time perAve = 600
    "Period for time averaged variables";

  // building parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter String filNam
    "Library path of the file with thermal loads as time series"
    annotation (Dialog(group="Building"));
  final parameter Modelica.SIunits.Power Q_flow_nominal(max=-Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)Nominal heat flow rate, negative";
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=273.15 + 7
    "Minimum setpoint temperature for district return"
    annotation (Dialog(group="Building"));
  parameter Modelica.SIunits.Temperature TChiWatRet_nominal=273.15 + 16
    "Minimum setpoint temperature for district return"
    annotation (Dialog(group="Building"));

  // ETS parameters
  parameter Modelica.SIunits.Temperature TSetDisRet=TChiWatRet_nominal
    "Minimum setpoint temperature for district return"
    annotation (Dialog(group="Energy transfer station"));
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of district cooling side"
    annotation (Dialog(group="Energy transfer station"));
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)=Q_flow_nominal/(cp*(TChiWatSup_nominal - TChiWatRet_nominal))
    "Nominal mass flow rate of building cooling side"
    annotation (Dialog(group="Energy transfer station"));
  parameter Modelica.SIunits.MassFlowRate mByp_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate through the bypass segment"
    annotation (Dialog(group="Energy transfer station"));

  // IO CONNECTORS

  // COMPONENTS
  replaceable DHC.Loads.Examples.BaseClasses.BuildingTimeSeriesHE bui(
    have_watHea=true,
    deltaTAirCoo=6,
    deltaTAirHea=18,
    loa(
    columns = {2,3}, timeScale=3600, offset={0,0}),
    T_aChiWat_nominal=TChiWatSup_nominal,
    T_bChiWat_nominal=TChiWatRet_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=false,
    final filNam=filNam,
    final nPorts_aChiWat=1,
    final nPorts_bChiWat=1,
    final nPorts_aHeaWat=1,
    final nPorts_bHeaWat=1,
    final allowFlowReversal=allowFlowReversalBui)
    "Building"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  replaceable DHC.EnergyTransferStations.Cooling.CoolingDirectControlledReturn ets(
    redeclare final package Medium = Medium,
    final mDis_flow_nominal=mDis_flow_nominal,
    final mBui_flow_nominal=mBui_flow_nominal,
    final mByp_flow_nominal=mByp_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  inner Modelica.Fluid.System system
    "System properties and default values"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Sources.Constant TSetDisRet_min(k=TSetDisRet)
    "Minimum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUniHea.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Fluid.Sources.Boundary_pT           supHeaWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-50,90})));
  Fluid.Sources.Boundary_pT           sinHeaWat(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={30,90})));
  Fluid.Sensors.RelativePressure           senRelPre(redeclare package Medium =
        Medium)
    "Pressure difference measurement"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={0,20})));
  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure of port_a minus port_b"
    annotation (    Placement(transformation(extent={{200,0},{220,20}}),
        iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(y(unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Continuous.Integrator EHeaAct(y(unit="J"))
    "Actual energy used for heating"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaReq_flow(y(unit="W"),
      final delta=perAve)
    "Time average of heating load"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaAct_flow(y(unit="W"),
      final delta=perAve)
    "Time average of heating heat flow rate"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  Modelica.Blocks.Continuous.Integrator ECooReq(y(unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Modelica.Blocks.Continuous.Integrator ECooAct(y(unit="J"))
    "Actual energy used for cooling"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooReq_flow(y(unit="W"),
      final delta=perAve)
    "Time average of cooling load"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooAct_flow(y(unit="W"),
      final delta=perAve)
    "Time average of cooling heat flow rate"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{200,40},{220,60}}),
        iconTransformation(extent={{100,60},{120,80}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

equation
  connect(port_a, ets.port_a1) annotation (Line(points={{-100,0},{-40,0},{-40,-24},
          {-10,-24}}, color={0,127,255}));
  connect(ets.port_b1, bui.ports_aChiWat[1]) annotation (Line(points={{10,-24},{
          20,-24},{20,0},{-20,0},{-20,44},{-10,44}},   color={0,127,255}));
  connect(bui.ports_bChiWat[1], ets.port_a2) annotation (Line(points={{10,44},{40,
          44},{40,-36},{10,-36}}, color={0,127,255}));
  connect(ets.port_b2, port_b) annotation (Line(points={{-10,-36},{-40,-36},{-40,
          -60},{80,-60},{80,0},{100,0}}, color={0,127,255}));
  connect(TSetDisRet_min.y, ets.TSetDisRet) annotation (Line(points={{-59,-50},{
          -20,-50},{-20,-42},{-12,-42}}, color={0,0,127}));
  connect(supHeaWat.T_in,THeaWatSup. y) annotation (Line(points={{-62,94},{-66,94},
          {-66,90},{-69,90}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_aHeaWat[1]) annotation (Line(points={{-40,90},
          {-20,90},{-20,48},{-10,48}},color={0,127,255}));
  connect(bui.ports_bHeaWat[1],sinHeaWat. ports[1]) annotation (Line(points={{10,48},
          {20,48},{20,90}},                           color={0,127,255}));
  connect(senRelPre.port_b, bui.ports_bChiWat[1]) annotation (Line(points={{10,20},
          {20,20},{20,44},{10,44}},            color={0,127,255}));
  connect(senRelPre.port_a, bui.ports_aChiWat[1]) annotation (Line(points={{-10,20},
          {-20,20},{-20,44},{-10,44}},               color={0,127,255}));
  connect(senRelPre.p_rel, p_rel) annotation (Line(points={{0,11},{0,10},{210,10}},
                            color={0,0,127}));
  connect(bui.QReqHea_flow,QAveHeaReq_flow. u) annotation (Line(points={{6.66667,
          39.3333},{6.66667,34},{60,34},{60,-6},{114,-6},{114,70},{118,70}},
                                                            color={0,0,127}));
  connect(bui.QReqHea_flow,EHeaReq. u) annotation (Line(points={{6.66667,
          39.3333},{6.66667,34},{60,34},{60,-6},{114,-6},{114,30},{118,30}},
                                                 color={0,0,127}));
  connect(bui.QHea_flow,QAveHeaAct_flow. u) annotation (Line(points={{10.6667,
          58.6667},{114,58.6667},{114,56},{154,56},{154,70},{158,70}},
                                                            color={0,0,127}));
  connect(bui.QHea_flow,EHeaAct. u) annotation (Line(points={{10.6667,58.6667},
          {114,58.6667},{114,56},{154,56},{154,30},{158,30}},
                                                           color={0,0,127}));
  connect(bui.QReqCoo_flow,ECooReq. u) annotation (Line(points={{8.66667,
          39.3333},{8.66667,34},{60,34},{60,-6},{114,-6},{114,-30},{118,-30}},
                                                     color={0,0,127}));
  connect(bui.QReqCoo_flow,QAveCooReq_flow. u) annotation (Line(points={{8.66667,
          39.3333},{8.66667,36},{8,36},{8,34},{60,34},{60,-6},{114,-6},{114,-70},
          {118,-70}},                                           color={0,0,127}));
  connect(bui.QCoo_flow,ECooAct. u) annotation (Line(points={{10.6667,57.3333},
          {114,57.3333},{114,-6},{150,-6},{150,-30},{158,-30}},color={0,0,127}));
  connect(bui.QCoo_flow,QAveCooAct_flow. u) annotation (Line(points={{10.6667,
          57.3333},{114,57.3333},{114,-6},{150,-6},{150,-70},{158,-70}},
                                                                color={0,0,127}));
  connect(bui.PPum,PPum)  annotation (Line(points={{10.6667,52},{114,52},{114,
          50},{210,50}},
                   color={0,0,127}));
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-60,-34},{0,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
        Rectangle(
          extent={{-60,-34},{0,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-40},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-28},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-40,60},{40,60},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-40,60},{40,-40}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{-30,30},{-10,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,30},{30,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-30,-10},{-10,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,-10},{30,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-3},{20,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={63,-20},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-21},
          rotation=90),
        Rectangle(
          extent={{-19,-3},{19,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-57,-13},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-13},
          rotation=90)}),
    Diagram(coordinateSystem(extent={{-100,-100},{200,100}})));
end BuildingTimeSeriesWithETSCooling;
