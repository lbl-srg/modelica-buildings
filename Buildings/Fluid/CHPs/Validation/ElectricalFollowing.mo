within Buildings.Fluid.CHPs.Validation;
model ElectricalFollowing "Validate model ElectricalFollowing"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={172800})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Fluid.Sources.Boundary_pT           sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa"),
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Buildings.Fluid.CHPs.ElectricalFollowing eleFol(
    m_flow_nominal=0.4,
    redeclare Data.ValidationData3 per,
    TEngIni=273.15 + 69.55,
    waitTime=0)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Fluid.Sources.MassFlowSource_T cooWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Math.Add dPEleNet(k2=-1)
    "Absolute error for electric power generaton"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Modelica.Blocks.Math.Add dQGen(k2=-1) "Absolute error for heat generaton"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Modelica.Blocks.Math.Add dQWat(k2=-1)
    "Absolute error for heat transfer to water control volume"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Modelica.Blocks.Math.Add dQLos(k2=-1)
    "Absolute error for heat loss to the surroundings"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Modelica.Blocks.Math.Add dTWatOut(k2=-1)
    "Absolute error for water outlet temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Modelica.Blocks.Math.Add dTEng(k2=-1) "Absolute error for engine temperature"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Modelica.Blocks.Sources.RealExpression PEleNet(y=eleFol.PEleNet)
    "Electric power generation"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Sources.RealExpression QGen(y=eleFol.eneCon.QGen)
    "Heat generation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.RealExpression QWat(y=eleFol.QWat)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.RealExpression QLos(y=eleFol.QLos.Q_flow)
    "Heat loss to the surrounding"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.RealExpression TWatOut(y=eleFol.vol.T)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Sources.RealExpression TEng(y=eleFol.eng.TEng)
    "Engine temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
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
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Controls.OBC.UnitConversions.From_degC TWatIn
    "Convert cooling water inlet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Controls.OBC.UnitConversions.From_degC TRoo
    "Convert zone temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Controls.OBC.UnitConversions.From_degC TWatOutVal
    "Convert cooling water outplet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Controls.OBC.UnitConversions.From_degC TEngVal
    "Convert engine temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation
  connect(eleFol.port_b, sin.ports[1]) annotation (Line(points={{0,-40},{20,-40}},
                            color={0,127,255}));
  connect(avaSig.y, eleFol.avaSig) annotation (Line(points={{-139,80},{-30,80},{
          -30,-32},{-22,-32}},
                        color={255,0,255}));
  connect(cooWat.ports[1], eleFol.port_a) annotation (Line(points={{-40,-40},{-20,
          -40}},           color={0,127,255}));
  connect(PEleNet.y, dPEleNet.u1) annotation (Line(points={{121,10},{130,10},{130,
          16},{138,16}},            color={0,0,127}));
  connect(QGen.y, dQGen.u1) annotation (Line(points={{121,-20},{130,-20},{130,-14},
          {138,-14}},          color={0,0,127}));
  connect(QWat.y, dQWat.u1) annotation (Line(points={{121,-50},{130,-50},{130,-44},
          {138,-44}},          color={0,0,127}));
  connect(QLos.y, dQLos.u1) annotation (Line(points={{121,-80},{130,-80},{130,-74},
          {138,-74}},            color={0,0,127}));
  connect(TWatOut.y, dTWatOut.u1) annotation (Line(points={{121,70},{130.55,70},
          {130.55,76},{138,76}},              color={0,0,127}));
  connect(dTEng.u1, TEng.y) annotation (Line(points={{138,46},{130,46},{130,40},
          {121,40}},              color={0,0,127}));
  connect(prescribedTemperature.port, eleFol.TRoo) annotation (Line(points={{-40,-80},
          {-30,-80},{-30,-45},{-20,-45}},   color={191,0,0}));
  connect(valDat.y[1], eleFol.PEleDem) annotation (Line(points={{-139,0},{-34,0},
          {-34,-36},{-22,-36}}, color={0,0,127}));
  connect(valDat.y[2], cooWat.m_flow_in) annotation (Line(points={{-139,0},{-70,
          0},{-70,-32},{-62,-32}}, color={0,0,127}));
  connect(valDat.y[3], TWatIn.u) annotation (Line(points={{-139,0},{-120,0},{-120,
          -40},{-102,-40}}, color={0,0,127}));
  connect(TWatIn.y, cooWat.T_in) annotation (Line(points={{-78,-40},{-70,-40},{-70,
          -36},{-62,-36}}, color={0,0,127}));
  connect(valDat.y[4], TRoo.u) annotation (Line(points={{-139,0},{-120,0},{-120,
          -80},{-102,-80}}, color={0,0,127}));
  connect(TRoo.y, prescribedTemperature.T)
    annotation (Line(points={{-78,-80},{-62,-80}}, color={0,0,127}));
  connect(valDat.y[10], TWatOutVal.u) annotation (Line(points={{-139,0},{50,0},{
          50,60},{58,60}}, color={0,0,127}));
  connect(valDat.y[11], TEngVal.u) annotation (Line(points={{-139,0},{50,0},{50,
          30},{58,30}}, color={0,0,127}));
  connect(TWatOutVal.y, dTWatOut.u2) annotation (Line(points={{82,60},{130,60},{
          130,64},{138,64}}, color={0,0,127}));
  connect(TEngVal.y, dTEng.u2) annotation (Line(points={{82,30},{130,30},{130,34},
          {138,34}}, color={0,0,127}));
  connect(valDat.y[5], dPEleNet.u2) annotation (Line(points={{-139,0},{50,0},{50,
          4},{138,4}}, color={0,0,127}));
  connect(valDat.y[7], dQGen.u2) annotation (Line(points={{-139,0},{50,0},{50,-26},
          {138,-26}}, color={0,0,127}));
  connect(valDat.y[8], dQWat.u2) annotation (Line(points={{-139,0},{50,0},{50,-56},
          {138,-56}}, color={0,0,127}));
  connect(valDat.y[9], dQLos.u2) annotation (Line(points={{-139,0},{50,0},{50,-86},
          {138,-86}}, color={0,0,127}));
  annotation (
    experiment(StopTime=10000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Validation/ElectricalFollowing.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.ElectricalFollowing\">
Buildings.Fluid.CHPs.ElectricalFollowing</a>
for the CHP unit simulation with the electricity demand priority. 
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-100},{180,100}}),
            graphics={
                  Rectangle(
          extent={{50,100},{170,-100}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{78,98},{124,84}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing")}));
end ElectricalFollowing;
