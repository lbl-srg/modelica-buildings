within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model WatersideEconomizer
  "Validate model Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer"
  extends Modelica.Icons.Example;

  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=1),
    sin1(nPorts=1),
    TSet(k=273.15 + 13.56),
    TEva_in(k=273.15 + 15.28));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer WSE(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.4,
    Ti=80,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eta=0.8,
    dp1_nominal=dpCW_nominal,
    dp2_nominal=dpCHW_nominal,
    use_controller=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Waterside economizer"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.BooleanStep onWSE(
    startValue = true,
    startTime = 7200)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumCHW,
    m_flow=mCHW_flow_nominal,
    nPorts=1,
    use_T_in=true) "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-70})));
equation
  connect(TSet.y, WSE.TSet)
    annotation (Line(points={{-69,30},{-69,30},{-20,30},{-20,-38},{-12,-38}},
                                color={0,0,127}));
  connect(WSE.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,-32},{-22,-32},
          {-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(WSE.port_b2, TSup.port_a)
    annotation (Line(points={{-10,-44},{-20,-44},
          {-40,-44}}, color={0,127,255}));
  connect(WSE.port_b1, sin1.ports[1])
    annotation (Line(points={{10,-32},{26,-32},{26,-4},{70,-4}},
                            color={0,127,255}));
  connect(WSE.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-44},{20,-44},{26,-44},{26,-70},{40,-70}},
                                       color={0,127,255}));
  connect(WSE.on[1], onWSE.y)
    annotation (Line(points={{-12,-34},{-24,-34},{-24,70},{-69,70}},
                         color={255,0,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{62,-70},{62,-66}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/WatersideEconomizer.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates that the temperature at port_b2 is controlled by setting
<code>use_controller=true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2017, by Michael Wetter:<br/>
Corrected wrong use of replaceable model in the base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>.
</li>
<li>
July 10, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=14400,
      Tolerance=1e-06));
end WatersideEconomizer;
