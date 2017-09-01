within Buildings.ChillerWSE.Validation;
model WatersideEconomizer
  "Validate model Buildings.ChillerWSE.WatersideEconomizer"

  extends Buildings.ChillerWSE.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=1),
    sin1(nPorts=1),
    TSet(k=273.15 + 13.56),
    TEva_in(k=273.15 + 15.28),
    redeclare Buildings.Fluid.Sources.MassFlowSource_T sou2(
         nPorts=1, m_flow=mCHW_flow_nominal));

  Buildings.ChillerWSE.WatersideEconomizer WSE(
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
    use_Controller=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Waterside economizer"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.BooleanStep onWSE(
    startValue = true,
    startTime = 7200)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
  connect(TSet.y, WSE.TSet)
    annotation (Line(points={{-79,60},{-48,60},{-20,60},
          {-20,-38},{-12,-38}}, color={0,0,127}));
  connect(WSE.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,-32},{-22,-32},
          {-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(WSE.port_b2, TSup.port_a)
    annotation (Line(points={{-10,-44},{-20,-44},
          {-40,-44}}, color={0,127,255}));
  connect(WSE.port_b1, sin1.ports[1])
    annotation (Line(points={{10,-32},{26,-32},
          {26,-4},{80,-4}}, color={0,127,255}));
  connect(WSE.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-44},{20,-44},
          {26,-44},{26,-74},{38,-74}}, color={0,127,255}));
  connect(WSE.on[1], onWSE.y)
    annotation (Line(points={{-12,-34},{-28,-34},{-28,
          20},{-79,20}}, color={255,0,255}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/ChillerWSE/Validation/WatersideEconomizer.mos"
        "Simulate and Plot"), Documentation(info="<html>
This example demonstrates that the temperature at port_b2 is controlled by setting 
<code>use_Controller=true</code>.
</html>", revisions="<html>
<ul>
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
