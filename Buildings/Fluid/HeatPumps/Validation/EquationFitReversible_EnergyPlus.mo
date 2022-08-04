within Buildings.Fluid.HeatPumps.Validation;
model EquationFitReversible_EnergyPlus "Validation with EnergyPlus model"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Data.EquationFitReversible.EnergyPlus perEP
    "EnergyPlus heat pump performance"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  parameter Modelica.Units.SI.MassFlowRate mSou_flow_nominal=perEP.hea.mSou_flow
    "Source heat exchanger nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal=perEP.hea.mLoa_flow
    "Load heat exchanger nominal mass flow rate";
  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=perEP,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Water to Water heat pump"
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sources.MassFlowSource_T loaPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.89,
    T=328.15,
    nPorts=1,
    use_T_in=true) "Load water pump"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=180,
       origin={-10,74})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.89,
    T=280.65,
    nPorts=1,
    use_T_in=true) "Source side water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
       origin={70,-20})));
  Buildings.Fluid.Sources.Boundary_pT cooVol(
    redeclare package Medium = Medium, nPorts=1)
    "Volume for cooling load"
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium, nPorts=1)
    "Volume for heating load"
      annotation (Placement(transformation(extent={{80,-4},{60,16}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
    "modelica://Buildings//Resources/Data/Fluid/HeatPumps/Validation/EquationFitReversible_EnergyPlus/GSHPSimple-GLHE-ReverseHeatPump.dat"),
    verboseRead=false,
    tableName="EnergyPlus",
    columns=2:8,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"GSHPSimple-GLHE-ReverseHeatPump.IDF\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Controls.OBC.CDL.Integers.Sources.Constant uMod(k=1)
    "Heat pump operational mode"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TLoaEnt
    "Block that converts entering water temperature of the load side"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TSouEnt
    "Block that converts entering water temperature of the source side"
      annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TSetHea
    "Block that converts set point for leaving heating water temperature "
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.RealExpression QSou_flow_EP(y=datRea.y[2])
    "EnergyPlus results: source side heat flow rate [W]"
      annotation (Placement(transformation(extent={{-90,-62},{-70,-42}})));
  Modelica.Blocks.Sources.RealExpression QLoa_flow_EP(y=-datRea.y[3])
    "EnergyPlus results: load side heat flow rate [W]"
      annotation (Placement(transformation(extent={{-90,-82},{-70,-62}})));
  Modelica.Blocks.Sources.RealExpression P_EP(y=datRea.y[1])
    "EnergyPlus results: compressr power [W]"
      annotation (Placement(transformation(extent={{-90,-102},{-70,-82}})));
equation
  connect(heaPum.port_a1,loaPum. ports[1])
    annotation (Line(points={{30,6},{20,6},{20,74},{-1.77636e-15,74}},color={0,127,255}));
  connect(souPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{60,-20},{50,-20},{50,-6}},color={0,127,255}));
  connect(cooVol.ports[1], heaPum.port_b2)
    annotation (Line(points={{0,-20},{20,-20},{20,-6},{30,-6}}, color={0,127,255}));
  connect(heaPum.port_b1, heaVol.ports[1])
    annotation (Line(points={{50,6},{60,6}},                 color={0,127,255}));
  connect(loaPum.T_in, TLoaEnt.y)
    annotation (Line(points={{-22,70},{-38,70}}, color={0,0,127}));
  connect(TSouEnt.y, souPum.T_in)
    annotation (Line(points={{-38,-40},{92,-40},{92,-24},{82,-24}}, color={0,0,127}));
  connect(TSetHea.y, heaPum.TSet) annotation (Line(points={{-38,40},{8,40},{8,9},
          {28.6,9}},    color={0,0,127}));
  connect(datRea.y[5], TLoaEnt.u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(datRea.y[4],TSetHea. u)
    annotation (Line(points={{-79,70},{-70,70},{-70,40},{-62,40}}, color={0,0,127}));
  connect(datRea.y[6], TSouEnt.u)
    annotation (Line(points={{-79,70},{-70,70},{-70,-40},{-62,-40}},
                               color={0,0,127}));
  connect(heaPum.uMod, uMod.y)
    annotation (Line(points={{29,0},{-38,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/EquationFitReversible_EnergyPlus.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=86400),
Documentation(info="<html>
<p>
This model implements a comparative model validation of
<a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>
against results obtained using EnergyPlus 9.1.
<p>
The EnergyPlus results were generated using the example file <code>GSHPSimple-GLHE-ReverseHeatPump.idf</code>
from EnergyPlus, with a nominal cooling capacity of <i>39890</i> Watts and
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
