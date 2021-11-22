within Buildings.Fluid.Chillers.Examples;
model ElectricEIR_AirCooled
  "Test model for chiller electric EIR with air-cooled condenser"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric_AirCooled(
      P_nominal=-per.QEva_flow_nominal/per.COP_nominal,
      mEva_flow_nominal=per.mEva_flow_nominal,
      mCon_flow_nominal=per.mCon_flow_nominal,
    sou1(nPorts=1),
    sou2(nPorts=1));

  parameter Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    per "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
       redeclare package Medium1 = Medium1,
       redeclare package Medium2 = Medium2,
       per=per,
       energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
       dp1_nominal=6000,
       dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, res1.port_a) annotation (Line(
      points={{20,16},{26,16},{26,40},{32,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b2, res2.port_a) annotation (Line(
      points={{0,4},{-10,4},{-10,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.on, greaterThreshold.y) annotation (Line(
      points={{-2,13},{-10,13},{-10,90},{-19,90}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chi.TSet, TSet.y) annotation (Line(
      points={{-2,7},{-30,7},{-30,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(
      StartTime=17020800,
      StopTime=17064000,
      Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricEIR_AirCooled.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a chiller whose efficiency is computed based on the
condenser entering and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the chiller part load performance.
This example is for an air-cooled chiller.
</p>
</html>", revisions="<html>
<ul>
<li>
November 19, 2021 by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ElectricEIR_AirCooled;
