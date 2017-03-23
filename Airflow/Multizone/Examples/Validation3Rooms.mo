within Buildings.Airflow.Multizone.Examples;
model Validation3Rooms
  "Model with three rooms for the validation of the multizone air exchange models"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    T_start=273.15 + 20,
    V=2.5*5*5*1,
    nPorts=5,
    m_flow_nominal=0.001)  annotation (Placement(transformation(extent={{80,-20},
            {100,0}},   rotation=0)));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{142,-90},{162,-70}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{191,-8},{211,12}},rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{141,10},{161,30}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{121,-10},{141,10}},
                                                                   rotation=0)));
  Fluid.Sources.FixedBoundary volOut(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101325,
    T=283.15) annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=0,
        origin={231,-30})));

  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{122,-70},{142,-50}},
                                                                     rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{190,-68},{210,-48}},rotation=
            0)));
  Buildings.Airflow.Multizone.MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-70,9},{-50,29}},   rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01) annotation (Placement(transformation(
        origin={-60,49},
        extent={{-10,-10},{10,10}},
        rotation=270)));

  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-70,71},{-50,91}},   rotation=
           0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    hA=3/2,
    hB=3/2,
    dp_turbulent(displayUnit="Pa") = 0.01) "Discretized door"
                               annotation (Placement(transformation(extent={{-1,-55},
            {19,-35}},       rotation=0)));
  Fluid.MixingVolumes.MixingVolume volWes(
    redeclare package Medium = Medium,
    T_start=273.15 + 25,
    nPorts=3,
    p_start=101325,
    V=2.5*5*5,
    m_flow_nominal=0.001)  annotation (Placement(transformation(extent={{-100,
            -30},{-80,-10}},
                         rotation=0)));
  Modelica.Blocks.Sources.Constant open(k=1) annotation (Placement(
        transformation(extent={{-40,-21},{-20,-1}},  rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{100,9},{120,29}},
                                                                  rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01) annotation (Placement(transformation(
        origin={110,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{100,71},{120,91}},
                                                                   rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTop(
    redeclare package Medium = Medium,
    T_start=273.15 + 20,
    V=2.5*5*10*1,
    nPorts=2,
    m_flow_nominal=0.001)  annotation (Placement(transformation(extent={{-20,120},
            {0,140}},        rotation=0)));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-180,200},{-160,220}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TTop(T=293.15)
    "Fixed temperature"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TWes(T=298.15)
    "Fixed temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TEas(T=293.15)
    "Fixed temperature"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
equation
  connect(open.y, dooOpeClo.y) annotation (Line(points={{-19,-11},{-14,-11},{
          -14,-45},{-2,-45}},  color={0,0,255}));
  connect(volWes.ports[1], dooOpeClo.port_b2) annotation (Line(
      points={{-92.6667,-30},{-92.6667,-51},{-1,-51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volWes.ports[2], dooOpeClo.port_a1) annotation (Line(
      points={{-90,-30},{-90,-39},{-1,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volWes.ports[3], colWesBot.port_b) annotation (Line(
      points={{-87.3333,-30},{-60,-30},{-60,9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesBot.port_a, oriWesTop.port_b) annotation (Line(
      points={{-60,29},{-60,39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriWesTop.port_a, colWesTop.port_b) annotation (Line(
      points={{-60,59},{-60,71}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesTop.port_a, volTop.ports[1]) annotation (Line(
      points={{-60,91},{-60,100},{-12,100},{-12,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTop.ports[2], colEasTop.port_a) annotation (Line(
      points={{-8,120},{-8,100},{110,100},{110,91}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasTop.port_b, oriEasTop.port_b) annotation (Line(
      points={{110,71},{110,59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{110,39},{110,29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_b1, volEas.ports[1]) annotation (Line(
      points={{19,-39},{86,-39},{86,-20},{86.8,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[2], dooOpeClo.port_a2) annotation (Line(
      points={{88.4,-20},{88.4,-50},{19,-50},{19,-51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_a, volEas.ports[3]) annotation (Line(
      points={{132,-50},{90,-50},{90,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[4], colEasInTop.port_b) annotation (Line(
      points={{91.6,-20},{92,-20},{92,-38},{131,-38},{131,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[5], col1EasBot.port_b) annotation (Line(
      points={{93.2,-20},{93.2,-34},{110,-34},{110,9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{131,10},{131,20},{141,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(
      points={{161,20},{201,20},{201,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, volOut.ports[1]) annotation (Line(
      points={{201,-8},{201,-28},{221,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_a, volOut.ports[2]) annotation (Line(
      points={{200,-48},{200,-32},{221,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_b, oriOutBot.port_b) annotation (Line(
      points={{200,-68},{200,-80},{162,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBot.port_a, colEasInBot.port_b) annotation (Line(
      points={{142,-80},{132,-80},{132,-70}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(TTop.port, volTop.heatPort) annotation (Line(
      points={{-60,130},{-20,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TEas.port, volEas.heatPort) annotation (Line(
      points={{60,-10},{80,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TWes.port, volWes.heatPort) annotation (Line(
      points={{-120,-20},{-100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-150},{300,
            250}}), graphics={
        Rectangle(
          extent={{8,48},{152,-100}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-160,48},{8,-100}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-160,160},{152,49}},
          lineColor={135,135,135},
          lineThickness=1)}),
experiment(StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/Validation3Rooms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a model of three rooms that exchange air among each based
on density difference between the air in the rooms and the outside.
The model implements the configuration shown below.</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Examples/3roomValidation.png\" border=\"1\" alt=\"Configuration of the three rooms.\"/>
</p>
<p>
This model has been used for a comparative model validation between CONTAM and
the <code>Buildings</code> library.
See Wetter (2006) for details of the validation.
<h4>References</h4>
<p>
Michael Wetter.
<a href=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">
Multizone Airflow Model in Modelica.</a>
Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Validation3Rooms;
