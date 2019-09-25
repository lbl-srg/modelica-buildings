within Buildings.Fluid.HeatPumps.Validation;
model EquationFitReversible_EnergyPlus "Validation with EnergyPlus model"

   package Medium = Buildings.Media.Water "Medium model";

   parameter Data.EquationFitReversible.EnergyPlus perEP
   "EnergyPlus heat pump performance"
    annotation (Placement(transformation(extent={{82,-88},{102,-68}})));
   parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=perEP.hea.mSou_flow
   "Source heat exchanger nominal mass flow rate";
   parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=perEP.hea.mLoa_flow
   "Load heat exchanger nominal mass flow rate";
   Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
     redeclare package Medium1 = Medium,
     redeclare package Medium2 = Medium,
     per=perEP,
     energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
     massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Water to Water heat pump"
     annotation (Placement(transformation(extent={{34,-10},{54,10}})));
   Sources.MassFlowSource_T loaPum(
     redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.89,
    T=328.15,
     nPorts=1,
     use_T_in=true) "Load water pump"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=180,
       origin={-10,70})));
   Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.89,
    T=280.65,
     nPorts=1,
     use_T_in=true) "Source side water pump"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
       origin={92,-50})));
   Modelica.Fluid.Sources.FixedBoundary cooVol(
     redeclare package Medium = Medium, nPorts=1)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-18,-80},{2,-60}})));
   Modelica.Fluid.Sources.FixedBoundary heaVol(
     redeclare package Medium = Medium, nPorts=1)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{102,60},{82,80}})));

    Modelica.Blocks.Math.RealToInteger reaToInt
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings//Resources/Data/Fluid/HeatPumps/Validation/EquationFitReversible_EnergyPlus/modelica.csv"),
    columns=2:15,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for energy plus example results"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

    Modelica.Blocks.Sources.Constant uMod(k=1) "Heat pump operational mode"
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    "Block that converts temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC1
    "Block that converts temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC2
    "Block that converts temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.RealExpression QSou_flow_EP(y=datRea.y[9])
    "EnergyPlus results: source side heat flow rate"
    annotation (Placement(transformation(extent={{-108,-62},{-88,-42}})));

  Modelica.Blocks.Sources.RealExpression QLoa_flow_EP(y=-1*datRea.y[10])
    "EnergyPlus results: load side heat flow rate"
    annotation (Placement(transformation(extent={{-108,-80},{-88,-60}})));
  Modelica.Blocks.Sources.RealExpression P_EP(y=datRea.y[8])
    "EnergyPlus results: load side heat flow rate"
    annotation (Placement(transformation(extent={{-108,-96},{-88,-76}})));
equation
  connect(heaPum.port_a1,loaPum. ports[1])
  annotation (Line(points={{34,6},{26,6},{26,70},{-1.77636e-15,70}},
                                                           color={0,127,255}));
  connect(souPum.ports[1], heaPum.port_a2)
  annotation (Line(points={{82,-50},{60,-50},{60,-6},{54,-6}}, color={0,127,255}));
  connect(heaPum.uMod, reaToInt.y)
  annotation (Line(points={{33,0},{-39,0}},color={255,127,0}));
  connect(cooVol.ports[1], heaPum.port_b2) annotation (Line(points={{2,-70},{28,
          -70},{28,-6},{34,-6}}, color={0,127,255}));
  connect(heaPum.port_b1, heaVol.ports[1]) annotation (Line(points={{54,6},{62,
          6},{62,70},{82,70}},
                            color={0,127,255}));
  connect(reaToInt.u, uMod.y) annotation (Line(points={{-62,0},{-93,0}}, color={0,0,127}));
  connect(loaPum.T_in, from_degC.y) annotation (Line(points={{-22,66},{-30,66},
          {-30,60},{-39,60}},   color={0,0,127}));
  connect(from_degC1.y,souPum. T_in) annotation (Line(points={{-39,-30},{114,
          -30},{114,-54},{104,-54}},  color={0,0,127}));
  connect(from_degC2.y, heaPum.TSet) annotation (Line(points={{-39,30},{20,30},
          {20,9},{32.6,9}},color={0,0,127}));
  connect(datRea.y[12], from_degC.u) annotation (Line(points={{-79,70},{-70,70},
          {-70,60},{-62,60}}, color={0,0,127}));
  connect(datRea.y[11], from_degC2.u)
    annotation (Line(points={{-79,70},{-72,70},{-72,30},{-62,30}},
                                                 color={0,0,127}));
  connect(datRea.y[14], from_degC1.u) annotation (Line(points={{-79,70},{-72,70},
          {-72,-30},{-62,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {120,100}}),
               graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/EquationFitReversible_EnergyPlus.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=86400),
Documentation(info="<html>
<p>
This model implements a comparative model validation of the model
<a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>
against results obtained using EnergyPlus 9.1.
<p>
The EnergyPlus results were generated using the example file GSHPSimple-GLHE-ReverseHeatPump.IDF
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and
nominal heating capacity of <i>39040</i> Watts.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitReversible_EnergyPlus;
