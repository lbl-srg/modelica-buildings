within Buildings.Templates.Components.Validation;
model Pumps "Validation model for pump components"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Liquid medium";
  parameter Data.PumpSingle datPum(
    final typ=pum1.typ,
    m_flow_nominal=1,
    dp_nominal=1E5) "Single pump parameters"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  parameter Data.PumpMultiple datPumMul(
    final typ=pumMul.typ,
    final nPum=pumMul.nPum,
    m_flow_nominal=fill(1, datPumMul.nPum),
    dp_nominal=fill(1E5, datPumMul.nPum))
    "Multiple pump parameters"
    annotation (Placement(transformation(extent={{60,-42},{80,-22}})));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Templates.Components.Pumps.Multiple pumMul(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=Medium,
    nPum=2,
    final dat=datPumMul)
    "Two variable speed pumps in parallel with common speed command signal"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Templates.Components.Pumps.Single pum1(
    final energyDynamics=energyDynamics,
    redeclare final package Medium = Medium,
    final dat=datPum) "Single variable speed pump"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Templates.Components.Pumps.Single pum2(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=Medium,
    final dat=datPum) "Single variable speed pump"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Fluid.FixedResistances.Junction junInl(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal) * {1,-1,-1},
    final dp_nominal=fill(0,3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-190}})));
  Fluid.FixedResistances.Junction junOut(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal) * {1,-1,1},
    final dp_nominal=fill(0,3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,-170},{50,-190}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pum1.m_flow_nominal + pum2.m_flow_nominal,
    final dp_nominal=pum1.dp_nominal - pum1.dpValChe_nominal)
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,-190},{90,-170}})));

  Fluid.FixedResistances.Junction junInl1(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-70}})));
  Fluid.FixedResistances.Junction junOut1(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,-50},{50,-70}})));
  Fluid.FixedResistances.PressureDrop resMul(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(pumMul.m_flow_nominal),
    final dp_nominal=max(pumMul.dp_nominal .- pumMul.dpValChe_nominal))
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 0, 0;
      1, 1, 0;
      2, 1, 1;
      3, 0, 0],
    timeScale=100,
    period=300) "Pump enable signal"
    annotation (Placement(transformation(extent={{-130,-52},{-110,-32}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y(k=1) "Pump speed command"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium, nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-200})));
  Fluid.Sources.Boundary_pT bou1(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-82})));
  Buildings.Templates.Components.Pumps.Multiple pumMulCst(
    have_var=false,
    final energyDynamics=energyDynamics,
    redeclare final package Medium = Medium,
    nPum=2,
    final dat=datPumMul) "Two constant speed pumps in parallel"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Fluid.FixedResistances.Junction junInl2(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,50},{-10,30}})));
  Fluid.FixedResistances.Junction junOut2(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,50},{50,30}})));
  Fluid.FixedResistances.PressureDrop resMulCst(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(pumMulCst.m_flow_nominal),
    final dp_nominal=max(pumMulCst.dp_nominal .- pumMulCst.dpValChe_nominal))
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Fluid.Sources.Boundary_pT bou2(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,20})));
  Buildings.Templates.Components.Pumps.Multiple pumMulDed(
    have_varCom=false,
    final energyDynamics=energyDynamics,
    redeclare final package Medium = Medium,
    nPum=2,
    final dat=datPumMul)
    "Two variable speed pumps in parallel with dedicated speed command signal"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Fluid.FixedResistances.Junction junInl3(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,150},{-10,130}})));
  Fluid.FixedResistances.Junction junOut3(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,150},{50,130}})));
  Fluid.FixedResistances.PressureDrop resMulDed(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(pumMulDed.m_flow_nominal),
    final dp_nominal=max(pumMulDed.dp_nominal .- pumMulDed.dpValChe_nominal))
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,130},{90,150}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,120})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDed[pumMulDed.nPum](each k
      =1) "Pump speed command"
    annotation (Placement(transformation(extent={{-130,140},{-110,160}})));
protected
  Interfaces.Bus bus "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-190},{-40,-150}}),
                                         iconTransformation(extent={{-318,-118},
            {-278,-78}})));
  Interfaces.Bus bus1 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-150},{-40,-110}}),
                                        iconTransformation(extent={{-26,-20},{14,
            20}})));
  Interfaces.Bus bus2 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-70},{-40,-30}}),
                                       iconTransformation(extent={{-318,-118},{-278,
            -78}})));
  Interfaces.Bus bus3 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,30},{-40,70}}), iconTransformation(extent={{-318,-118},{-278,
            -78}})));
  Interfaces.Bus bus4 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,130},{-40,170}}),
                                       iconTransformation(extent={{-318,-118},{-278,
            -78}})));
equation
  connect(pum1.port_b, junOut.port_1)
    annotation (Line(points={{20,-180},{30,-180}}, color={0,127,255}));
  connect(junInl.port_2, pum1.port_a)
    annotation (Line(points={{-10,-180},{0,-180}}, color={0,127,255}));
  connect(junInl.port_3, pum2.port_a) annotation (Line(points={{-20,-170},{-20,
          -140},{0,-140}}, color={0,127,255}));
  connect(pum2.port_b, junOut.port_3) annotation (Line(points={{20,-140},{40,
          -140},{40,-170}},
                      color={0,127,255}));
  connect(junOut.port_2, res.port_a)
    annotation (Line(points={{50,-180},{70,-180}}, color={0,127,255}));
  connect(res.port_b, junInl.port_1) annotation (Line(points={{90,-180},{100,
          -180},{100,-120},{-40,-120},{-40,-180},{-30,-180}},
                                                  color={0,127,255}));
  connect(junOut1.port_2, resMul.port_a)
    annotation (Line(points={{50,-60},{70,-60}}, color={0,127,255}));
  connect(junInl1.port_2, pumMul.ports_a[1]) annotation (Line(points={{-10,-60},
          {-6,-60},{-6,-61},{0,-61}},
                                  color={0,127,255}));
  connect(pumMul.ports_b[1], junOut1.port_1) annotation (Line(points={{20,-61},
          {26,-61},{26,-60},{30,-60}},
                                color={0,127,255}));
  connect(pumMul.ports_b[2], junOut1.port_3) annotation (Line(points={{20,-59},
          {20,-32},{40,-32},{40,-50}},
                                color={0,127,255}));
  connect(junInl1.port_3, pumMul.ports_a[2]) annotation (Line(points={{-20,-50},
          {-20,-32},{0,-32},{0,-59}},
                                  color={0,127,255}));
  connect(resMul.port_b, junInl1.port_1) annotation (Line(points={{90,-60},{100,
          -60},{100,0},{-40,0},{-40,-60},{-30,-60}}, color={0,127,255}));
  connect(bus1, pum2.bus) annotation (Line(
      points={{-60,-130},{10,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[2], bus1.y1) annotation (Line(points={{-108,-42},{-80,-42},{-80,
          -130},{-60,-130}},
                      color={255,0,255}));
  connect(y.y, bus1.y) annotation (Line(points={{-108,-100},{-100,-100},{-100,
          -130},{-60,-130}},
                 color={0,0,127}));
  connect(y1.y[1], bus.y1) annotation (Line(points={{-108,-42},{-80,-42},{-80,
          -170},{-60,-170}},
                      color={255,0,255}));
  connect(y.y, bus.y) annotation (Line(points={{-108,-100},{-100,-100},{-100,
          -170},{-60,-170}},
                 color={0,0,127}));
  connect(bus, pum1.bus) annotation (Line(
      points={{-60,-170},{10,-170}},
      color={255,204,51},
      thickness=0.5));
  connect(bus2, pumMul.bus) annotation (Line(
      points={{-60,-50},{10,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1:2], bus2.y1) annotation (Line(points={{-108,-42},{-80,-42},{
          -80,-50},{-60,-50}},
                color={255,0,255}));
  connect(y.y, bus2.y) annotation (Line(points={{-108,-100},{-100,-100},{-100,
          -50},{-60,-50}},
                color={0,0,127}));
  connect(bou.ports[1], junInl.port_1) annotation (Line(points={{-40,-190},{-40,
          -180},{-30,-180}},
                      color={0,127,255}));
  connect(bou1.ports[1], junInl1.port_1)
    annotation (Line(points={{-40,-72},{-40,-60},{-30,-60}},
                                                          color={0,127,255}));
  connect(junOut2.port_2, resMulCst.port_a)
    annotation (Line(points={{50,40},{70,40}}, color={0,127,255}));
  connect(junInl2.port_2, pumMulCst.ports_a[1]) annotation (Line(points={{-10,40},
          {-6,40},{-6,39},{0,39}},     color={0,127,255}));
  connect(pumMulCst.ports_b[1], junOut2.port_1) annotation (Line(points={{20,39},
          {26,39},{26,40},{30,40}}, color={0,127,255}));
  connect(pumMulCst.ports_b[2], junOut2.port_3) annotation (Line(points={{20,41},
          {20,70},{40,70},{40,50}}, color={0,127,255}));
  connect(junInl2.port_3, pumMulCst.ports_a[2]) annotation (Line(points={{-20,50},
          {-20,70},{0,70},{0,41}},     color={0,127,255}));
  connect(resMulCst.port_b, junInl2.port_1) annotation (Line(points={{90,40},{
          100,40},{100,100},{-40,100},{-40,40},{-30,40}}, color={0,127,255}));
  connect(bus3, pumMulCst.bus) annotation (Line(
      points={{-60,50},{10,50}},
      color={255,204,51},
      thickness=0.5));
  connect(bou2.ports[1],junInl2. port_1)
    annotation (Line(points={{-40,30},{-40,40},{-30,40}}, color={0,127,255}));
  connect(y1.y[1:2], bus3.y1) annotation (Line(points={{-108,-42},{-80,-42},{
          -80,50},{-60,50}}, color={255,0,255}));
  connect(junOut3.port_2, resMulDed.port_a)
    annotation (Line(points={{50,140},{70,140}}, color={0,127,255}));
  connect(junInl3.port_2, pumMulDed.ports_a[1]) annotation (Line(points={{-10,140},
          {-6,140},{-6,139},{0,139}},      color={0,127,255}));
  connect(pumMulDed.ports_b[1], junOut3.port_1) annotation (Line(points={{20,139},
          {26,139},{26,140},{30,140}},      color={0,127,255}));
  connect(pumMulDed.ports_b[2], junOut3.port_3) annotation (Line(points={{20,141},
          {20,170},{40,170},{40,150}},      color={0,127,255}));
  connect(junInl3.port_3, pumMulDed.ports_a[2]) annotation (Line(points={{-20,150},
          {-20,170},{0,170},{0,141}},      color={0,127,255}));
  connect(resMulDed.port_b, junInl3.port_1) annotation (Line(points={{90,140},{
          100,140},{100,200},{-40,200},{-40,140},{-30,140}}, color={0,127,255}));
  connect(bus4, pumMulDed.bus) annotation (Line(
      points={{-60,150},{10,150}},
      color={255,204,51},
      thickness=0.5));
  connect(bou3.ports[1],junInl3. port_1)
    annotation (Line(points={{-40,130},{-40,140},{-30,140}},
                                                          color={0,127,255}));
  connect(y1.y, bus4.y1) annotation (Line(points={{-108,-42},{-80,-42},{-80,150},
          {-60,150}}, color={255,0,255}));
  connect(yDed.y, bus4.y)
    annotation (Line(points={{-108,150},{-60,150}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Pumps.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=300),
    Diagram(coordinateSystem(extent={{-140,-220},{140,220}})),
    Documentation(info="<html>
<p>
This model validates the models within
<a href=\"modelica://Buildings.Templates.Components.Pumps\">
Buildings.Templates.Components.Pumps</a>
by connecting each pump component to a water loop with a 
fixed flow resistance, which
is sized based on the pump's nominal operating point.
Two identical parallel pumps are modeled with either 
one instance of 
<a href=\"modelica://Buildings.Templates.Components.Pumps.Multiple\">
Buildings.Templates.Components.Pumps.Multiple</a>
or two instances of
<a href=\"modelica://Buildings.Templates.Components.Pumps.Single\">
Buildings.Templates.Components.Pumps.Single</a>.
The multiple pump component is configured to represent
variable speed pumps with dedicated speed command signals
(component <code>pumMulDed</code>), 
variable speed pumps with common speed command
signal (component <code>pumMul</code>) or constant speed pumps
(component <code>pumMulCst</code>).
The single pump components (<code>pum1</code> and <code>pum2</code>) 
are configured to represent variable speed pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pumps;
