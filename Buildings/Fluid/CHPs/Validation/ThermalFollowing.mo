within Buildings.Fluid.CHPs.Validation;
model ThermalFollowing "Validate model ThermalElectricalFollowing"

  package Medium = Buildings.Media.Water;

  Buildings.Fluid.CHPs.ThermalElectricalFollowing theFol(
    redeclare package Medium = Medium,
    m_flow_nominal=0.4,
    redeclare Data.Senertech5_5kW per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    TEngIni=273.15 + 69.55,
    waitTime=0)
    "CHP unit with the thermal demand priority"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Blocks.Sources.BooleanTable avaSig(
    startValue=true,
    table={172800})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa"),
    nPorts=1)
    "Cooling water sink"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T cooWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Cooling water source"
    annotation (Placement(transformation(extent={{-62,0},{-42,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dPEleNet(
    final k2=-1)
    "Absolute error for electric power generaton"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dQWat(
    final k2=-1)
    "Absolute error for heat transfer to water control volume"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTWatOut(
    final k2=-1)
    "Absolute error for water outlet temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Modelica.Blocks.Sources.RealExpression PEleNet(
    final y=theFol.PEleNet)
    "Electric power generation"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Sources.RealExpression QWat(
    final y=theFol.QWat_flow)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.RealExpression TWatOut(
    final y=theFol.vol.T)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  HeatTransfer.Sources.PrescribedTemperature preTem
    "Variable temperature boundary condition in Kelvin"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTEng(
    final k2=-1) "Absolute error for engine temperature"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Modelica.Blocks.Sources.RealExpression TEng(
    final y=theFol.eng.TEng)
    "Engine temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dQLos(
    final k2=-1)
    "Absolute error for heat loss to the surroundings"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Modelica.Blocks.Sources.RealExpression QLos(
    final y=theFol.QLos.Q_flow)
    "Heat loss to the surrounding"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dQGen(
    final k2=-1) "Absolute error for heat generaton"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Modelica.Blocks.Sources.RealExpression QGen(
    final y=theFol.eneCon.QGen_flow)
    "Heat generation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.CombiTimeTable valDat(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit={"W","kg/s","degC","degC","W","W","W","W","W","degC","degC","degC"}),
    offset={0,0,0,0,0,0,0,0,0,0,0,0},
    columns={2,3,4,5,6,7,8,9,10,11,12,13},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/CHPs/Validation/MicroCogeneration.mos"))
    "Validation data from EnergyPlus simulation"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TRoo
    "Convert zone temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatIn
    "Convert cooling water inlet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatOutSet
    "Convert outlet water setpoint temperature from degC to kelvin "
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TEngVal
    "Convert engine temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatOutVal
    "Convert cooling water outplet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

protected
  Modelica.Blocks.Sources.BooleanExpression theFolSig(
    final y=true)
    "Signal for thermal following, set to false if electrical following"
    annotation (Placement(transformation(extent={{-60,32},{-40,48}})));

equation
  connect(theFol.port_b, sin.ports[1]) annotation (Line(points={{0,10},{20,10}},
          color={0,127,255}));
  connect(avaSig.y,theFol. avaSig) annotation (Line(points={{-79,-30},{-34,-30},
          {-34,19},{-22,19}},
                            color={255,0,255}));
  connect(cooWat.ports[1],theFol. port_a) annotation (Line(points={{-42,10},
          {-20,10}}, color={0,127,255}));
  connect(PEleNet.y, dPEleNet.u1) annotation (Line(points={{121,10},{128,10},{128,
          16},{138,16}}, color={0,0,127}));
  connect(QWat.y, dQWat.u1) annotation (Line(points={{121,-50},{128,-50},{128,-44},
          {138,-44}}, color={0,0,127}));
  connect(theFolSig.y,theFol. theFol) annotation (Line(points={{-39,40},{-34,40},
          {-34,17},{-22,17}}, color={255,0,255}));
  connect(preTem.port, theFol.TRoo) annotation (Line(points={{-40,-70},{-30,-70},
          {-30,3},{-20,3}}, color={191,0,0}));
  connect(QLos.y,dQLos. u1) annotation (Line(points={{121,-80},{128,-80},{128,-74},
          {138,-74}}, color={0,0,127}));
  connect(QGen.y,dQGen. u1) annotation (Line(points={{121,-20},{128,-20},{128,-14},
          {138,-14}}, color={0,0,127}));
  connect(valDat.y[2], cooWat.m_flow_in) annotation (Line(points={{-139,80},{-70,
          80},{-70,18},{-64,18}}, color={0,0,127}));
  connect(valDat.y[3], TWatIn.u) annotation (Line(points={{-139,80},{-120,80},{-120,
          10},{-102,10}}, color={0,0,127}));
  connect(TWatIn.y, cooWat.T_in) annotation (Line(points={{-78,10},{-70,10},{-70,
          14},{-64,14}}, color={0,0,127}));
  connect(valDat.y[4], TRoo.u) annotation (Line(points={{-139,80},{-120,80},{-120,
          -70},{-102,-70}}, color={0,0,127}));
  connect(TRoo.y, preTem.T) annotation (Line(points={{-78,-70},{-62,-70}},
          color={0,0,127}));
  connect(valDat.y[12], TWatOutSet.u) annotation (Line(points={{-139,80},{-120,80},
          {-120,50},{-102,50}}, color={0,0,127}));
  connect(TWatOutSet.y,theFol. TWatOutSet) annotation (Line(points={{-78,50},{
          -30,50},{-30,15},{-22,15}},
                                  color={0,0,127}));
  connect(TWatOutVal.y, dTWatOut.u2) annotation (Line(points={{82,60},{130,60},{
          130,64},{138,64}}, color={0,0,127}));
  connect(TWatOut.y, dTWatOut.u1) annotation (Line(points={{121,70},{130,70},{130,
          76},{138,76}}, color={0,0,127}));
  connect(TEng.y, dTEng.u1) annotation (Line(points={{121,40},{130,40},{130,46},
          {138,46}}, color={0,0,127}));
  connect(TEngVal.y, dTEng.u2) annotation (Line(points={{82,30},{130,30},{130,34},
          {138,34}}, color={0,0,127}));
  connect(valDat.y[10], TWatOutVal.u) annotation (Line(points={{-139,80},{50,80},
          {50,60},{58,60}}, color={0,0,127}));
  connect(valDat.y[11], TEngVal.u) annotation (Line(points={{-139,80},{50,80},{50,
          30},{58,30}}, color={0,0,127}));
  connect(valDat.y[5], dPEleNet.u2) annotation (Line(points={{-139,80},{50,80},{
          50,4},{138,4}}, color={0,0,127}));
  connect(valDat.y[7], dQGen.u2) annotation (Line(points={{-139,80},{50,80},{50,
          -26},{138,-26}}, color={0,0,127}));
  connect(valDat.y[8], dQWat.u2) annotation (Line(points={{-139,80},{50,80},{50,
          -56},{138,-56}}, color={0,0,127}));
  connect(valDat.y[9], dQLos.u2) annotation (Line(points={{-139,80},{50,80},{50,
          -86},{138,-86}}, color={0,0,127}));
  connect(valDat.y[1],theFol. PEleDem) annotation (Line(points={{-139,80},{-26,
          80},{-26,13},{-22,13}},
                              color={0,0,127}));

annotation (
  experiment(StopTime=10000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Validation/ThermalFollowing.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.ThermalElectricalFollowing\">
Buildings.Fluid.CHPs.ThermalElectricalFollowing</a>
for the CHP unit simulation with the thermal demand priority. 
</p>
</html>", revisions="<html>
<ul>
<li>
December 04, 2019, by Jianjun Hu:<br/>
Refactored implementation. 
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-180,-100},{180,100}}),
            graphics={
                  Rectangle(
          extent={{40,100},{180,-100}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{86,98},{132,84}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing")}));
end ThermalFollowing;
