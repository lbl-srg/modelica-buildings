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
    annotation (Placement(transformation(extent={{60,-158},{80,-138}})));
  parameter Data.PumpMultiple datPumMul(
    final typ=pumMul.typ,
    final nPum=pumMul.nPum,
    m_flow_nominal=fill(1, datPumMul.nPum),
    dp_nominal=fill(1E5, datPumMul.nPum))
    "Multiple pump parameters"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
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
    annotation (Placement(transformation(extent={{0,-188},{20,-168}})));
  Buildings.Templates.Components.Pumps.Single pum2(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=Medium,
    final dat=datPum) "Single variable speed pump"
    annotation (Placement(transformation(extent={{0,-148},{20,-128}})));
  Fluid.FixedResistances.Junction junInl(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal) * {1,-1,-1},
    final dp_nominal=fill(0,3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,-168},{-10,-188}})));
  Fluid.FixedResistances.Junction junOut(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal) * {1,-1,1},
    final dp_nominal=fill(0,3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,-168},{50,-188}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pum1.m_flow_nominal + pum2.m_flow_nominal,
    final dp_nominal=pum1.dp_nominal - pum1.dpValChe_nominal)
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,-188},{90,-168}})));

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
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y(k=1) "Pump speed command"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium, nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-198})));
  Fluid.Sources.Boundary_pT bou1(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-80})));
  Buildings.Templates.Components.Pumps.Multiple pumMulCst(
    have_var=false,
    final energyDynamics=energyDynamics,
    redeclare final package Medium = Medium,
    nPum=2,
    final dat=datPumMul) "Two constant speed pumps in parallel"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Fluid.FixedResistances.Junction junInl2(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,70},{-10,50}})));
  Fluid.FixedResistances.Junction junOut2(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,70},{50,50}})));
  Fluid.FixedResistances.PressureDrop resMulCst(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(pumMulCst.m_flow_nominal),
    final dp_nominal=max(pumMulCst.dp_nominal .- pumMulCst.dpValChe_nominal))
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Fluid.Sources.Boundary_pT bou2(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,40})));
  Buildings.Templates.Components.Pumps.Multiple pumMulDed(
    have_varCom=false,
    final energyDynamics=energyDynamics,
    redeclare final package Medium = Medium,
    nPum=2,
    final dat=datPumMul)
    "Two variable speed pumps in parallel with dedicated speed command signal"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Fluid.FixedResistances.Junction junInl3(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{-30,170},{-10,150}})));
  Fluid.FixedResistances.Junction junOut3(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=sum(datPumMul.m_flow_nominal)*{1,-1,1},
    final dp_nominal=fill(0, 3))
    "Fluid junction"
    annotation (Placement(transformation(extent={{30,170},{50,150}})));
  Fluid.FixedResistances.PressureDrop resMulDed(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(pumMulDed.m_flow_nominal),
    final dp_nominal=max(pumMulDed.dp_nominal .- pumMulDed.dpValChe_nominal))
    "Fixed flow resistance"
    annotation (Placement(transformation(extent={{70,150},{90,170}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = Medium,
      nPorts=1)
    "Pressure boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,140})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDed[pumMulDed.nPum](each k
      =1) "Pump speed command"
    annotation (Placement(transformation(extent={{-130,160},{-110,180}})));
protected
  Interfaces.Bus bus "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-188},{-40,-148}}),
                                         iconTransformation(extent={{-318,-118},
            {-278,-78}})));
  Interfaces.Bus bus1 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-148},{-40,-108}}),
                                        iconTransformation(extent={{-26,-20},{14,
            20}})));
  Interfaces.Bus bus2 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,-70},{-40,-30}}),
                                       iconTransformation(extent={{-318,-118},{-278,
            -78}})));
  Interfaces.Bus bus3 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,50},{-40,90}}), iconTransformation(extent={{-318,-118},{-278,
            -78}})));
  Interfaces.Bus bus4 "Pump control bus" annotation (Placement(transformation(
          extent={{-80,150},{-40,190}}),
                                       iconTransformation(extent={{-318,-118},{-278,
            -78}})));
equation
  connect(pum1.port_b, junOut.port_1)
    annotation (Line(points={{20,-178},{30,-178}}, color={0,127,255}));
  connect(junInl.port_2, pum1.port_a)
    annotation (Line(points={{-10,-178},{0,-178}}, color={0,127,255}));
  connect(junInl.port_3, pum2.port_a) annotation (Line(points={{-20,-168},{-20,
          -138},{0,-138}}, color={0,127,255}));
  connect(pum2.port_b, junOut.port_3) annotation (Line(points={{20,-138},{40,
          -138},{40,-168}},
                      color={0,127,255}));
  connect(junOut.port_2, res.port_a)
    annotation (Line(points={{50,-178},{70,-178}}, color={0,127,255}));
  connect(res.port_b, junInl.port_1) annotation (Line(points={{90,-178},{100,
          -178},{100,-118},{-40,-118},{-40,-178},{-30,-178}},
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
          {20,-30},{40,-30},{40,-50}},
                                color={0,127,255}));
  connect(junInl1.port_3, pumMul.ports_a[2]) annotation (Line(points={{-20,-50},
          {-20,-30},{0,-30},{0,-59}},
                                  color={0,127,255}));
  connect(resMul.port_b, junInl1.port_1) annotation (Line(points={{90,-60},{100,
          -60},{100,0},{-40,0},{-40,-60},{-30,-60}}, color={0,127,255}));
  connect(bus1, pum2.bus) annotation (Line(
      points={{-60,-128},{10,-128}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[2], bus1.y1) annotation (Line(points={{-108,-40},{-80,-40},{-80,
          -128},{-60,-128}},
                      color={255,0,255}));
  connect(y.y, bus1.y) annotation (Line(points={{-108,-80},{-100,-80},{-100,
          -128},{-60,-128}},
                 color={0,0,127}));
  connect(y1.y[1], bus.y1) annotation (Line(points={{-108,-40},{-80,-40},{-80,
          -168},{-60,-168}},
                      color={255,0,255}));
  connect(y.y, bus.y) annotation (Line(points={{-108,-80},{-100,-80},{-100,-168},
          {-60,-168}},
                 color={0,0,127}));
  connect(bus, pum1.bus) annotation (Line(
      points={{-60,-168},{10,-168}},
      color={255,204,51},
      thickness=0.5));
  connect(bus2, pumMul.bus) annotation (Line(
      points={{-60,-50},{10,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1:2], bus2.y1) annotation (Line(points={{-108,-40},{-80,-40},{
          -80,-50},{-60,-50}},
                color={255,0,255}));
  connect(y.y, bus2.y) annotation (Line(points={{-108,-80},{-100,-80},{-100,-50},
          {-60,-50}},
                color={0,0,127}));
  connect(bou.ports[1], junInl.port_1) annotation (Line(points={{-40,-188},{-40,
          -178},{-30,-178}},
                      color={0,127,255}));
  connect(bou1.ports[1], junInl1.port_1)
    annotation (Line(points={{-40,-70},{-40,-60},{-30,-60}},
                                                          color={0,127,255}));
  connect(junOut2.port_2, resMulCst.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(junInl2.port_2, pumMulCst.ports_a[1]) annotation (Line(points={{-10,
          60},{-6,60},{-6,59},{0,59}}, color={0,127,255}));
  connect(pumMulCst.ports_b[1], junOut2.port_1) annotation (Line(points={{20,59},
          {26,59},{26,60},{30,60}}, color={0,127,255}));
  connect(pumMulCst.ports_b[2], junOut2.port_3) annotation (Line(points={{20,61},
          {20,90},{40,90},{40,70}}, color={0,127,255}));
  connect(junInl2.port_3, pumMulCst.ports_a[2]) annotation (Line(points={{-20,
          70},{-20,90},{0,90},{0,61}}, color={0,127,255}));
  connect(resMulCst.port_b, junInl2.port_1) annotation (Line(points={{90,60},{
          100,60},{100,120},{-40,120},{-40,60},{-30,60}}, color={0,127,255}));
  connect(bus3, pumMulCst.bus) annotation (Line(
      points={{-60,70},{10,70}},
      color={255,204,51},
      thickness=0.5));
  connect(bou2.ports[1],junInl2. port_1)
    annotation (Line(points={{-40,50},{-40,60},{-30,60}}, color={0,127,255}));
  connect(y1.y[1:2], bus3.y1) annotation (Line(points={{-108,-40},{-80,-40},{
          -80,70},{-60,70}}, color={255,0,255}));
  connect(junOut3.port_2, resMulDed.port_a)
    annotation (Line(points={{50,160},{70,160}}, color={0,127,255}));
  connect(junInl3.port_2, pumMulDed.ports_a[1]) annotation (Line(points={{-10,
          160},{-6,160},{-6,159},{0,159}}, color={0,127,255}));
  connect(pumMulDed.ports_b[1], junOut3.port_1) annotation (Line(points={{20,
          159},{26,159},{26,160},{30,160}}, color={0,127,255}));
  connect(pumMulDed.ports_b[2], junOut3.port_3) annotation (Line(points={{20,
          161},{20,190},{40,190},{40,170}}, color={0,127,255}));
  connect(junInl3.port_3, pumMulDed.ports_a[2]) annotation (Line(points={{-20,
          170},{-20,190},{0,190},{0,161}}, color={0,127,255}));
  connect(resMulDed.port_b, junInl3.port_1) annotation (Line(points={{90,160},{
          100,160},{100,220},{-40,220},{-40,160},{-30,160}}, color={0,127,255}));
  connect(bus4, pumMulDed.bus) annotation (Line(
      points={{-60,170},{10,170}},
      color={255,204,51},
      thickness=0.5));
  connect(bou3.ports[1],junInl3. port_1)
    annotation (Line(points={{-40,150},{-40,160},{-30,160}},
                                                          color={0,127,255}));
  connect(y1.y, bus4.y1) annotation (Line(points={{-108,-40},{-80,-40},{-80,170},
          {-60,170}}, color={255,0,255}));
  connect(yDed.y, bus4.y)
    annotation (Line(points={{-108,170},{-60,170}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Pumps.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=300),
    Diagram(coordinateSystem(extent={{-140,-240},{140,240}})));
end Pumps;
