within Buildings.Fluid.CHPs.Validation;
model ElectricalFollowing "Validate model ElectricalFollowing"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  Buildings.Fluid.CHPs.ThermalElectricalFollowing eleFol(
    redeclare package Medium = Medium,
    redeclare Data.ValidationData3 per,
    m_flow_nominal=0.4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    switchThermalElectricalFollowing=false,
    TEngIni=273.15 + 69.55,
    waitTime=0) "CHP unit with the electricity demand priority"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Modelica.Blocks.Sources.BooleanTable avaSig(
    startValue=true,
    table={172800})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa"),
    nPorts=1) "Cooling water sink"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T cooWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Cooling water source"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dPEleNet
    "Absolute error for electric power generaton"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dQGen "Absolute error for heat generaton"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dQWat
    "Absolute error for heat transfer to water control volume"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dQLos
    "Absolute error for heat loss to the surroundings"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTWatOut
    "Absolute error for water outlet temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTEng
    "Absolute error for engine temperature"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Modelica.Blocks.Sources.RealExpression PEleNet(
    final y=eleFol.PEleNet)
    "Electric power generation"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Sources.RealExpression QGen(final y=eleFol.eneCon.QGen_flow)
    "Heat generation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.RealExpression QWat(
    final y=eleFol.QWat_flow)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.RealExpression QLos(
    final y=eleFol.QLos.Q_flow)
    "Heat loss to the surrounding"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.RealExpression TWatOut(
    final y=eleFol.vol.T)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Sources.RealExpression TEng(
    final y=eleFol.eng.TEng)
    "Engine temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Variable temperature boundary condition in Kelvin"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable valDat(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit={"W", "kg/s", "degC", "degC", "W", "W", "W", "W", "W", "degC", "degC", "degC"}),
    offset={0,0,0,0,0,0,0,0,0,0,0,0},
    columns={2,3,4,5,6,7,8,9,10,11,12,13},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/CHPs/Validation/MicroCogeneration.mos"))
    "Validation data from EnergyPlus simulation"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatIn
    "Convert cooling water inlet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TRoo
    "Convert zone temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatOutVal
    "Convert cooling water outplet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,54},{80,74}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TEngVal
    "Convert engine temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,24},{80,44}})));
  Modelica.Blocks.Routing.RealPassThrough PEleNetVal
    "Validation data for power output"
    annotation (Placement(transformation(extent={{60,-6},{80,14}})));
  Modelica.Blocks.Routing.RealPassThrough QGenVal_flow
    "Validation data for heat generation rate"
    annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
  Modelica.Blocks.Routing.RealPassThrough QWatVal_flow
    "Validation data for heat flow rate to water"
    annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  Modelica.Blocks.Routing.RealPassThrough QLosVal_flow
    "Validation data for heat flow rate to ambient"
    annotation (Placement(transformation(extent={{60,-96},{80,-76}})));
  Modelica.Blocks.Continuous.Integrator EEle(y(unit="J"))
    "Electrical energy generated"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Modelica.Blocks.Continuous.Integrator EThe(y(unit="J"))
    "Thermal energy recovered"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Modelica.Blocks.Continuous.Integrator EEleVal(y(unit="J"))
    "Validation data for electrical energy generated"
    annotation (Placement(transformation(extent={{98,-130},{118,-110}})));
  Modelica.Blocks.Continuous.Integrator ETheVal(y(unit="J"))
    "Validation data for thermal energy recovered"
    annotation (Placement(transformation(extent={{98,-160},{118,-140}})));
equation
  connect(eleFol.port_b, sin.ports[1]) annotation (Line(points={{0,-20},{20,-20}},
          color={0,127,255}));
  connect(avaSig.y, eleFol.avaSig) annotation (Line(points={{-139,80},{-30,80},
          {-30,-11},{-22,-11}}, color={255,0,255}));
  connect(cooWat.ports[1], eleFol.port_a) annotation (Line(points={{-40,-20},{
          -20,-20}}, color={0,127,255}));
  connect(PEleNet.y, dPEleNet.u1) annotation (Line(points={{121,10},{130,10},{130,
          16},{138,16}}, color={0,0,127}));
  connect(QGen.y, dQGen.u1) annotation (Line(points={{121,-20},{130,-20},{130,-14},
          {138,-14}}, color={0,0,127}));
  connect(QWat.y, dQWat.u1) annotation (Line(points={{121,-50},{130,-50},{130,-44},
          {138,-44}}, color={0,0,127}));
  connect(QLos.y, dQLos.u1) annotation (Line(points={{121,-80},{130,-80},{130,-74},
          {138,-74}}, color={0,0,127}));
  connect(TWatOut.y, dTWatOut.u1) annotation (Line(points={{121,70},{130.55,70},
          {130.55,76},{138,76}}, color={0,0,127}));
  connect(dTEng.u1, TEng.y) annotation (Line(points={{138,46},{130,46},{130,40},
          {121,40}}, color={0,0,127}));
  connect(preTem.port, eleFol.TRoo) annotation (Line(points={{-40,-60},{-30,-60},
          {-30,-27},{-20,-27}}, color={191,0,0}));
  connect(valDat.y[2], cooWat.m_flow_in) annotation (Line(points={{-139,30},{-70,
          30},{-70,-12},{-62,-12}},color={0,0,127}));
  connect(valDat.y[3], TWatIn.u) annotation (Line(points={{-139,30},{-120,30},{-120,
          -20},{-102,-20}}, color={0,0,127}));
  connect(TWatIn.y, cooWat.T_in) annotation (Line(points={{-78,-20},{-70,-20},{
          -70,-16},{-62,-16}}, color={0,0,127}));
  connect(valDat.y[4], TRoo.u) annotation (Line(points={{-139,30},{-120,30},{-120,
          -60},{-102,-60}}, color={0,0,127}));
  connect(TRoo.y, preTem.T) annotation (Line(points={{-78,-60},{-62,-60}},
          color={0,0,127}));
  connect(valDat.y[10], TWatOutVal.u) annotation (Line(points={{-139,30},{50,30},
          {50,64},{58,64}},color={0,0,127}));
  connect(valDat.y[11], TEngVal.u) annotation (Line(points={{-139,30},{50,30},{50,
          34},{58,34}}, color={0,0,127}));
  connect(TWatOutVal.y, dTWatOut.u2) annotation (Line(points={{82,64},{138,64}},
                             color={0,0,127}));
  connect(TEngVal.y, dTEng.u2) annotation (Line(points={{82,34},{138,34}},
                     color={0,0,127}));
  connect(valDat.y[1], eleFol.PEleDem) annotation (Line(points={{-139,30},{-26,
          30},{-26,-17},{-22,-17}}, color={0,0,127}));
  connect(QGenVal_flow.y, dQGen.u2)
    annotation (Line(points={{81,-26},{138,-26}}, color={0,0,127}));
  connect(PEleNetVal.y, dPEleNet.u2)
    annotation (Line(points={{81,4},{138,4}}, color={0,0,127}));
  connect(valDat.y[5], PEleNetVal.u) annotation (Line(points={{-139,30},{50,30},
          {50,4},{58,4}}, color={0,0,127}));
  connect(valDat.y[7], QGenVal_flow.u) annotation (Line(points={{-139,30},{50,30},
          {50,-26},{58,-26}}, color={0,0,127}));
  connect(QWatVal_flow.y, dQWat.u2)
    annotation (Line(points={{81,-56},{138,-56}}, color={0,0,127}));
  connect(valDat.y[8], QWatVal_flow.u) annotation (Line(points={{-139,30},{50,30},
          {50,-56},{58,-56}}, color={0,0,127}));
  connect(QLosVal_flow.y, dQLos.u2)
    annotation (Line(points={{81,-86},{138,-86}}, color={0,0,127}));
  connect(valDat.y[9], QLosVal_flow.u) annotation (Line(points={{-139,30},{50,30},
          {50,-86},{58,-86}}, color={0,0,127}));
  connect(eleFol.PEleNet, EEle.u) annotation (Line(points={{2,-17},{14,-17},{14,
          -120},{38,-120}}, color={0,0,127}));
  connect(eleFol.QWat_flow, EThe.u) annotation (Line(points={{2,-27},{10,-27},{10,
          -150},{38,-150}}, color={0,0,127}));
  connect(QWatVal_flow.y, ETheVal.u) annotation (Line(points={{81,-56},{86,-56},
          {86,-150},{96,-150}}, color={0,0,127}));
  connect(PEleNetVal.y, EEleVal.u) annotation (Line(points={{81,4},{88,4},{88,-120},
          {96,-120}}, color={0,0,127}));
annotation (
  experiment(StopTime=10000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Validation/ElectricalFollowing.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.ThermalElectricalFollowing\">
Buildings.Fluid.CHPs.ThermalElectricalFollowing</a>
for the CHP unit simulation with the electricity demand priority.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-180},{180,100}}),
            graphics={ Rectangle(
          extent={{40,100},{180,-180}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{78,98},{124,84}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing")}));
end ElectricalFollowing;
