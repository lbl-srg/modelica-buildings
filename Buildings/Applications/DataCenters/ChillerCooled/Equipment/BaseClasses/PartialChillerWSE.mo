within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialChillerWSE
  "Partial model for chiller and WSE package"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSEInterface(
     final num=numChi+1);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.FourPortResistanceChillerWSE(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialControllerInterface(
     final reverseActing=false);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ValvesParameters(
     numVal=4,
     final deltaM=deltaM1);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.SignalFilterParameters(
     final numFil=1,
     final yValve_start={yValWSE_start});
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ThreeWayValveParameters(
     final activate_ThrWayVal=use_controller);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  //Chiller
  parameter Integer numChi(min=1) "Number of chillers"
    annotation(Dialog(group="Chiller"));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi[numChi]
    "Performance data for chillers"
    annotation (choicesAllMatching=true,Dialog(group="Chiller"),
                Placement(transformation(extent={{70,78},{90,98}})));
  parameter Real[2] lValChi(each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Two-way valve"));
  parameter Real[numChi] yValChi_start=fill(0,numChi)
    "Initial value of output from on/off valves in chillers"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_inputFilter));

  //WSE
  parameter Modelica.Units.SI.Efficiency eta(
    min=0,
    max=1) = 0.8 "Heat exchange effectiveness"
    annotation (Dialog(group="Waterside economizer"));

  parameter Real[2] lValWSE(each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Two-way valve"));
  parameter Real yValWSE_start=0
    "Initial value of output from on/off valve in WSE"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_inputFilter));
  parameter Real yThrWayValWSE_start=0
    "Initial value of output from three-way bypass valve in WSE"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=
          use_controller and use_strokeTime));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tauChi1=30
    "Time constant at nominal flow in chillers" annotation (Dialog(
      tab="Dynamics",
      group="Chiller",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Units.SI.Time tauChi2=30
    "Time constant at nominal flow in chillers" annotation (Dialog(
      tab="Dynamics",
      group="Chiller",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Units.SI.Time tauWSE=10
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Waterside economizer",
      enable=use_controller and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1",
                enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1",
                enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1",
               enable=Medium1.nC > 0));
  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2",
                enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2",
                enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2",
               enable=Medium2.nC > 0));

  // Temperature sensor
  parameter Modelica.Units.SI.Time tauSenT=1 "Time constant at nominal flow rate (use tau=0 for steady-state sensor,
    but see user guide for potential problems)" annotation (Dialog(
      tab="Dynamics",
      group="Temperature Sensor",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Blocks.Types.Init initTSenor = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization of the temperature sensor (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(tab="Dynamics", group="Temperature Sensor"));

  Modelica.Blocks.Interfaces.RealOutput TCHWSupWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200,
    start=T2_start)
    "Chilled water supply temperature in the waterside economizer"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
                iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput powChi[numChi](
    each final quantity="Power",
    each final unit="W")
    "Electric power consumed by chiller compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel chiPar(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final num=numChi,
    final per=perChi,
    final homotopyInitialization=homotopyInitialization,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final initValve=initValve,
    final m1_flow_nominal=m1_flow_chi_nominal,
    final m2_flow_nominal=m2_flow_chi_nominal,
    final dp1_nominal=dp1_chi_nominal,
    final tau1=tauChi1,
    final tau2=tauChi2,
    final energyDynamics=energyDynamics,
    final p1_start=p1_start,
    final T1_start=T1_start,
    final X1_start=X1_start,
    final C1_start=C1_start,
    final C1_nominal=C1_nominal,
    final p2_start=p2_start,
    final T2_start=T2_start,
    final X2_start=X2_start,
    final C2_start=C2_start,
    final C2_nominal=C2_nominal,
    final l=lValChi,
    final dp2_nominal=dp2_chi_nominal,
    final dpValve_nominal=dpValve_nominal[1:2],
    final rhoStd=rhoStd[1:2],
    final yValve_start=yValChi_start)
    "Chillers with identical nominal parameters but different performance curves"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer
    wse(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_wse_nominal,
    final m2_flow_nominal=m2_flow_wse_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final from_dp1=from_dp1,
    final dp1_nominal=dp1_wse_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final dp2_nominal=dp2_wse_nominal,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization,
    final l=lValWSE,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final initValve=initValve,
    final energyDynamics=energyDynamics,
    final p_start=p2_start,
    final T_start=T2_start,
    final X_start=X2_start,
    final C_start=C2_start,
    final C_nominal=C2_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final yCon_start=yCon_start,
    final reset=reset,
    final y_reset=y_reset,
    final eta=eta,
    final fraK_ThrWayVal=fraK_ThrWayVal,
    final l_ThrWayVal=l_ThrWayVal,
    final R=R,
    final delta0=delta0,
    final dpValve_nominal=dpValve_nominal[3:4],
    final rhoStd=rhoStd[3:4],
    final yThrWayVal_start=yThrWayValWSE_start,
    final yValWSE_start=yValWSE_start,
    final tauThrWayVal=tauWSE,
    final use_controller=use_controller,
    final reverseActing=reverseActing,
    final show_T=show_T,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3) "Waterside economizer"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final replaceable package Medium = Medium2,
    final m_flow_nominal=m2_flow_wse_nominal,
    final tau=tauSenT,
    final initType=initTSenor,
    final T_start=T2_start,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{28,14},{8,34}})));

  Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={numChi*m1_flow_chi_nominal,-m1_flow_wse_nominal,-numChi*
        m1_flow_chi_nominal},
    dp_nominal={0,0,0}) "Splitter"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={numChi*m1_flow_chi_nominal,-numChi*m1_flow_chi_nominal,
        m1_flow_wse_nominal},
    dp_nominal={0,0,0}) "Junction"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  for i in 1:numChi loop
  connect(chiPar.on[i], on[i])
    annotation (Line(points={{-62,34},{-92,34},{-92,72},{-120,72}},
                color={255,0,255}));
  end for;
  connect(on[numChi+1], wse.on[1])
    annotation (Line(points={{-120,72},{-120,72},{30,72},{30,34},{38,34}},
                color={255,0,255}));
  connect(chiPar.TSet, TSet)
    annotation (Line(points={{-62,30},{-84,30},{-84,104},{-120,104}},
                color={0,0,127}));
  connect(TSet, wse.TSet)
    annotation (Line(points={{-120,104},{-84,104},{-84,80},
          {26,80},{26,30},{38,30}}, color={0,0,127}));
  connect(y_reset_in, wse.y_reset_in)
    annotation (Line(points={{-90,-100},{-90,-100},{-90,10},{40,10},{40,20}},
                color={0,0,127}));
  connect(trigger, wse.trigger)
    annotation (Line(points={{-60,-100},{-60,-100},{-60,-80},{-88,-80},{-88,8},
          {44,8},{44,20}},              color={255,0,255}));
  connect(senTem.T,TCHWSupWSE)
    annotation (Line(points={{18,35},{18,46},{86,46},{86,40},{110,40}},
                           color={0,0,127}));
  connect(wse.port_b2, senTem.port_a)
    annotation (Line(points={{40,24},{34,24},{28,24}}, color={0,127,255}));
  connect(chiPar.P, powChi) annotation (Line(points={{-39,32},{-6,32},{-6,48},{
          90,48},{90,0},{110,0}}, color={0,0,127}));
  connect(port_a1, spl1.port_1) annotation (Line(points={{-100,60},{-88,60},{
          -88,56},{-80,56}}, color={0,127,255}));
  connect(spl1.port_3, chiPar.port_a1)
    annotation (Line(points={{-70,46},{-70,36},{-60,36}}, color={0,127,255}));
  connect(spl1.port_2, wse.port_a1) annotation (Line(points={{-60,56},{36,56},{
          36,36},{40,36}}, color={0,127,255}));
  connect(port_b1, jun1.port_2)
    annotation (Line(points={{100,60},{90,60}}, color={0,127,255}));
  connect(jun1.port_3, wse.port_b1)
    annotation (Line(points={{80,50},{80,36},{60,36}}, color={0,127,255}));
  connect(chiPar.port_b1, jun1.port_1) annotation (Line(points={{-40,36},{-30,
          36},{-30,60},{70,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{24,2},{64,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,2},{-24,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          radius=45),
        Rectangle(
          extent={{-66,14},{-62,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,14},{-58,14},{-64,20},{-70,14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,26},{-58,26},{-64,20},{-70,26}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,38},{-62,26}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,40},{-58,40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,26},{-32,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-36,38},{-32,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,14},{-28,14},{-34,26},{-40,14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-72,42},{-24,38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward,
          radius=45),
        Rectangle(
          extent={{-36,26},{-32,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{8,20},{14,6}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{24,40},{64,38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,42},{32,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,42},{34,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,44},{38,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,44},{42,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,44},{46,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,44},{50,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,44},{54,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,42},{56,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,42},{58,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,4},{58,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,4},{34,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,4},{32,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,4},{56,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{6,16},{16,8}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="T"),
        Line(points={{-90,60},{-76,60},{-76,40},{-72,40}}, color={28,108,200}),
        Line(points={{-76,60},{20,60},{20,40}}, color={28,108,200}),
        Line(points={{20,40},{24,40}}, color={28,108,200}),
        Line(points={{64,40},{76,40},{76,60},{90,60}}, color={28,108,200}),
        Line(points={{-24,40},{6,40},{6,54},{76,54}}, color={28,108,200}),
        Line(points={{24,0},{12,0},{12,6}}, color={28,108,200}),
        Line(points={{12,20}}, color={28,108,200}),
        Line(points={{12,20},{12,20},{12,48},{86,48},{86,40},{102,40}}, color={
              0,0,127})}),    Documentation(info="<html>
<p>
Partial model that can be extended to different configurations
inclduing chillers and integrated/non-integrated water-side economizers.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 3, 2022, by Michael Wetter:<br/>
Moved <code>massDynamics</code> to <code>Advanced</code> tab,
added assertion and changed type from <code>record</code> to <code>block</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
April 26, 2021, by Kathryn Hinkelman:<br/>
Removed <code>kFixed</code> redundancies. See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1472\">IBPSA, #1472</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialChillerWSE;
