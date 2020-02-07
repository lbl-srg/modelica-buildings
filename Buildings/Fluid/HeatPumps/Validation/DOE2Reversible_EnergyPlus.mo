within Buildings.Fluid.HeatPumps.Validation;
model DOE2Reversible_EnergyPlus "Validation with EnergyPlus model"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Data.DOE2Reversible.EnergyPlus perEP
    "EnergyPlus heat pump performance"
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=perEP.m1_flow_nominal
    "Load heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=perEP.m2_flow_nominal
    "Source heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.DOE2Reversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=perEP,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Water to Water heat pump"
     annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Sources.MassFlowSource_T loaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=0.346,
    T=328.15,
    nPorts=1,
    use_T_in=true)
    "Load water pump"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=180,
       origin={-10,100})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=0.35,
    T=280.65,
    nPorts=1,
    use_T_in=true)
    "Source side water pump"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
       origin={70,10})));
  Buildings.Fluid.Sources.Boundary_pT cooVol(
    redeclare package Medium = Medium, nPorts=1)
    "Volume for cooling load"
      annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium, nPorts=1)
    "Volume for heating load"
      annotation (Placement(transformation(extent={{100,40},{80,60}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
     "modelica://Buildings//Resources/Data/Fluid/HeatPumps/Validation/DOE2Reversible_EnergyPlus/modelica.csv"),
    columns=2:81,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TLoaEnt
    "Block that converts entering water temperature of the load side"
      annotation (Placement(transformation(extent={{-60,86},{-40,106}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TSouEnt
    "Block that converts entering water temperature of the source side"
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TSetCoo
    "Block that converts set point for leaving heating water temperature "
      annotation (Placement(transformation(extent={{-60,56},{-40,76}})));
  Modelica.Blocks.Sources.RealExpression P_EP(y=datRea.y[18])
    "EnergyPlus results: compressor power "
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSouLvgMin(k=35 + 273.15)
      annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSouLvgMax(k=60 + 273.15)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.RealExpression QLoa_flow_EP(y=-1*datRea.y[19])
    "EnergyPlus results: load side heat flow rate"
      annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.RealToInteger realToInteger1
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Math.Product product
      annotation (Placement(transformation(extent={{-110,0},{-90,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant cons(k=-1)
      annotation (Placement(transformation(extent={{-110,-40},{-90,-20}})));
equation
  connect(heaPum.port_a1,loaPum. ports[1])
    annotation (Line(points={{30,36},{20,36},{20,100},{-1.77636e-15,100}},
                                                                      color={0,127,255}));
  connect(souPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{60,10},{58,10},{58,24},{50,24}},
                                                        color={0,127,255}));
  connect(cooVol.ports[1], heaPum.port_b2)
    annotation (Line(points={{0,-70},{20,-70},{20,24},{30,24}}, color={0,127,255}));
  connect(heaPum.port_b1, heaVol.ports[1])
    annotation (Line(points={{50,36},{56,36},{56,50},{80,50}},
                                                             color={0,127,255}));
  connect(loaPum.T_in, TLoaEnt.y)
    annotation (Line(points={{-22,96},{-38,96}}, color={0,0,127}));
  connect(TSouEnt.y, souPum.T_in)
    annotation (Line(points={{-38,-10},{92,-10},{92,6},{82,6}},     color={0,0,127}));
  connect(TSetCoo.y, heaPum.TSet)
    annotation (Line(points={{-38,66},{16,66},{16,39},{29,39}},
                        color={0,0,127}));
  connect(datRea.y[21], TLoaEnt.u)
    annotation (Line(points={{-99,90},{-80,90},{-80,96},{-62,96}},
                                                 color={0,0,127}));
  connect(datRea.y[22],TSetCoo. u)
    annotation (Line(points={{-99,90},{-80,90},{-80,66},{-62,66}}, color={0,0,127}));
  connect(datRea.y[28], TSouEnt.u)
    annotation (Line(points={{-99,90},{-80,90},{-80,-10},{-62,-10}},
                                                                   color={0,0,127}));
  connect(realToInteger1.y, heaPum.uMod)
    annotation (Line(points={{-39,30},{-4,30},{-4,33},{29,33}},
                                                color={255,127,0}));
  connect(datRea.y[16], product.u1)
    annotation (Line(points={{-99,90},{-80,90},{
          -80,38},{-114,38},{-114,16},{-112,16}},  color={0,0,127}));
  connect(cons.y, product.u2)
    annotation (Line(points={{-88,-30},{-88,-2},{-114,
          -2},{-114,4},{-112,4}},             color={0,0,127}));
  connect(product.y, realToInteger1.u)
    annotation (Line(points={{-89,10},{-74,10},
          {-74,30},{-62,30}},     color={0,0,127}));
  connect(heaPum.TSouMaxLvg, TSouLvgMax.y)
    annotation (Line(points={{29,30},{16,
          30},{16,10},{2,10}}, color={0,0,127}));
  connect(heaPum.TSouMinLvg, TSouLvgMin.y)
    annotation (Line(points={{29,27},{18,
          27},{18,-30},{2,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {120,120}}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/DOE2_EnergyPlus.mos"
        "Simulate and plot"),
    experiment(StopTime=3000, Tolerance=1e-06),
Documentation(info="<html>
<p>
This model implements a comparative model validation of
<a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>
against results obtained using EnergyPlus 9.1.
<p>
The EnergyPlus results were generated using the example file <code>GSHPSimple-GLHE-ReverseHeatPump.idf</code>
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
end DOE2Reversible_EnergyPlus;
