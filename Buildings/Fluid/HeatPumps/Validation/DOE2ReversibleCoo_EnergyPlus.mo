within Buildings.Fluid.HeatPumps.Validation;
model DOE2ReversibleCoo_EnergyPlus "Validation with EnergyPlus model"

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
    m_flow=0.35,
    T=328.15,
    use_T_in=true,
    nPorts=1)
    "Load water pump"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=180,
       origin={-10,100})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=0.35,
    T=280.65,
    use_T_in=true,
    nPorts=1)
    "Source side water pump"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
       origin={70,10})));
  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium, nPorts=1) "Volume for heating load"
      annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Fluid.Sources.Boundary_pT cooVol(redeclare package Medium = Medium,
      nPorts=1) "Volume for cooling load"
    annotation (Placement(transformation(extent={{100,40},{80,60}})));

  Modelica.Blocks.Sources.CombiTimeTable datReaC(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings//Resources/Data/Fluid/HeatPumps/Validation/DOE2Reversible_EnergyPlus/modelicaC.csv"),
    columns=2:18,
    tableName="modelicaC",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Modelica.Blocks.Sources.RealExpression PCoo_EP(y=datReaC.y[4])
    "EnergyPlus results: compressor power "
    annotation (Placement(transformation(extent={{-114,-54},{-94,-34}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TEvaLvgMin(k=5 + 273.15)
    "Minimum evaporator leaving water temperature "
      annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TEvaLvgMax(k=10 + 273.15)
    "Maximum evaporator leaving water temperature"
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.RealExpression QLoa_flow_EP(y=-1*datReaC.y[6])
    "EnergyPlus results: load side heat flow rate"
    annotation (Placement(transformation(extent={{-114,-72},{-94,-52}})));
  Modelica.Blocks.Math.RealToInteger realToInteger1
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression QSou_flow_EP(y=1*datReaC.y[11])
    "EnergyPlus results: source side heat flow rate"
    annotation (Placement(transformation(extent={{-114,-90},{-94,-70}})));
equation
  connect(realToInteger1.y, heaPum.uMod)
    annotation (Line(points={{-39,50},{-4,50},{-4,33},{29,33}},
                                                color={255,127,0}));
  connect(heaPum.TSouMaxLvg,TEvaLvgMax. y)
    annotation (Line(points={{29,30},{16,
          30},{16,10},{2,10}}, color={0,0,127}));
  connect(heaPum.TSouMinLvg,TEvaLvgMin. y)
    annotation (Line(points={{29,27},{18,
          27},{18,-30},{2,-30}}, color={0,0,127}));
  connect(datReaC.y[1], realToInteger1.u)
    annotation (Line(points={{-99,50},{-62,50}}, color={0,0,127}));
  connect(datReaC.y[8], loaPum.T_in) annotation (Line(points={{-99,50},{-80,50},
          {-80,96},{-22,96}}, color={0,0,127}));
  connect(datReaC.y[15], souPum.T_in) annotation (Line(points={{-99,50},{-80,50},
          {-80,-88},{102,-88},{102,6},{82,6}}, color={0,0,127}));
  connect(datReaC.y[9], heaPum.TSet) annotation (Line(points={{-99,50},{-80,50},
          {-80,76},{6,76},{6,39},{29,39}}, color={0,0,127}));
  connect(souPum.ports[1], heaPum.port_a2) annotation (Line(points={{60,10},{54,
          10},{54,24},{50,24}}, color={0,127,255}));
  connect(heaPum.port_b2, heaVol.ports[1]) annotation (Line(points={{30,24},{22,
          24},{22,-70},{0,-70}}, color={0,127,255}));
  connect(heaPum.port_b1, cooVol.ports[1]) annotation (Line(points={{50,36},{58,
          36},{58,50},{80,50}}, color={0,127,255}));
  connect(heaPum.port_a1, loaPum.ports[1]) annotation (Line(points={{30,36},{22,
          36},{22,100},{-1.77636e-15,100}}, color={0,127,255}));
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
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/DOE2_EnergyPlusCoo.mos"
        "Simulate and plot"),
    experiment(StopTime=3000, Tolerance=1e-06),
Documentation(info="<html>
<p>
This model implements a comparative model validation of
<a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a>
against results obtained using EnergyPlus 9.2.
<p>
The EnergyPlus results were generated using the example file 
<code>CentralChillerHeaterSystem_Cooling_Heating.idf</code>
from EnergyPlus 9.2, with a nominal cooling capacity of <i>12500</i> Watts.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2ReversibleCoo_EnergyPlus;
