within Buildings.Fluid.Chillers.Validation;
model AbsorptionIndirectSteam_EnergyPlus
  "Validation with EnergyPlus model"
  package Medium = Buildings.Media.Water "Medium model";

  parameter Data.AbsorptionIndirectSteam.Generic per(
    QEva_flow_nominal=-10000,
    P_nominal=150,
    PLRMax=1,
    PLRMin=0.15,
    mEva_flow_nominal=0.247,
    mCon_flow_nominal=1.1,
    dpEva_nominal=0,
    dpCon_nominal=0,
    capFunEva={0.690571,0.065571,-0.00289,0},
    capFunCon={0.245507,0.023614,0.0000278,0.000013},
    genHIR={0.18892,0.968044,1.119202,-0.5034},
    EIRP={1,0,0},
    genConT={0.712019,-0.00478,0.000864,-0.000013},
    genEvaT={0.995571,0.046821,-0.01099,0.000608})
     "Chiller performance data"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Fluid.Chillers.AbsorptionIndirectSteam absChi(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=per,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start=25 + 273.15,
    T2_start=10 + 273.15) "Absorption indirect chiller"
    annotation (Placement(transformation(extent={{22,-12},{42,8}})));

  Buildings.Fluid.Sources.MassFlowSource_T conPum(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=per.mCon_flow_nominal,
    use_T_in=true,
    nPorts=1)
    "Condenser water pump"
      annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,50})));

  Buildings.Fluid.Sources.MassFlowSource_T evaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=per.mEva_flow_nominal,
    nPorts=1,
    use_T_in=true)
    "Evaporator water pump"
      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-30})));

  Buildings.Fluid.Sources.Boundary_pT cooVol(
    redeclare package Medium = Medium,
    nPorts=1)
     "Volume for cooling load"
       annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium,
    nPorts=1)
     "Volume for heating load"
       annotation (Placement(transformation(extent={{120,40},{100,60}})));

  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=1)
       annotation (Placement(transformation(extent={{-60,10},{-40,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Chillers/IndirectAbsorptionChiller/modelica.csv"),
    columns=2:11,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.IDF\" energy plus example results"
      annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.RealExpression QGen_EP(y=datRea.y[10])
    "EnergyPlus results: generator heat flow rate"
    annotation (Placement(transformation(extent={{-132,-68},{-112,-48}})));
  Modelica.Blocks.Sources.RealExpression QCon_EP(y=datRea.y[6])
    "EnergyPlus results: condenser heat flow rate"
    annotation (Placement(transformation(extent={{-132,-50},{-112,-30}})));
  Modelica.Blocks.Sources.RealExpression QEva_EP(y=-1*datRea.y[2])
    "EnergyPlus results: evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-132,-34},{-112,-14}})));

equation
  connect(evaPum.ports[1], absChi.port_a2) annotation (Line(points={{60,-30},{
          50,-30},{50,-8},{42,-8}},
                                 color={0,127,255}));
  connect(absChi.on, realToBoolean.y) annotation (Line(points={{21,0},{-39,0}},
                               color={255,0,255}));
  connect(conPum.ports[1], absChi.port_a1) annotation (Line(points={{-20,50},{
          22,50},{22,4}},     color={0,127,255}));
  connect(absChi.port_b1, heaVol.ports[1]) annotation (Line(points={{42,4},{50,
          4},{50,50},{100,50}},
                             color={0,127,255}));
  connect(absChi.port_b2, cooVol.ports[1]) annotation (Line(points={{22,-8},{20,
          -8},{20,-60},{-40,-60}}, color={0,127,255}));
  connect(datRea.y[1], realToBoolean.u) annotation (Line(points={{-119,70},{
          -100,70},{-100,0},{-62,0}}, color={0,0,127}));
  connect(datRea.y[5], evaPum.m_flow_in) annotation (Line(points={{-119,70},{
          -100,70},{-100,-82},{100,-82},{100,-38},{82,-38}},       color={0,0,
          127}));
  connect(datRea.y[9], conPum.m_flow_in) annotation (Line(points={{-119,70},{
          -100,70},{-100,42},{-42,42}}, color={0,0,127}));
  connect(datRea.y[7], conPum.T_in) annotation (Line(points={{-119,70},{-50,70},
          {-50,46},{-42,46}}, color={0,0,127}));
  connect(datRea.y[4], absChi.TSet) annotation (Line(points={{-119,70},{-100,70},
          {-100,-42},{18,-42},{18,-4},{21,-4}}, color={0,0,127}));
  connect(datRea.y[3], evaPum.T_in) annotation (Line(points={{-119,70},{-100,70},
          {-100,-92},{114,-92},{114,-34},{82,-34}}, color={0,0,127}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
   Diagram(coordinateSystem(extent={{-140,-100},{120,100}})),
  __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/AbsorptionIndirectSteam_EnergyPlus.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Documentation(info="<html>
<p>
This model validates
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectSteam\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteam</a>.
<p>
The EnergyPlus results were generated using the example file <code>IndirectAbsorptionChiller.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>10000</i> Watts.
</p>
</html>", revisions="<html>
<ul>
<li>
July 4, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteam_EnergyPlus;
