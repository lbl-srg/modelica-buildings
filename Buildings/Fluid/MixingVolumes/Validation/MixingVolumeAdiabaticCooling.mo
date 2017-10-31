within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeAdiabaticCooling
  "Validation model for mixing volume with adiabatic cooling"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";
  MixingVolumeMoistAir volSim(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    V=1,
    final simplify_mWat_flow=true,
    nPorts=1)
    "Mixing volume with water vapor input and simplified water balance"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  MixingVolumeMoistAir volExa(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    V=1,
    final simplify_mWat_flow=false,
    nPorts=1) "Mixing volume with water vapor input and exact water balance"
    annotation (Placement(transformation(extent={{20,-38},{40,-18}})));
  Modelica.Blocks.Sources.Constant mWatFlo(k=0.001) "Water mass flow rate "
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.RealExpression relErr(
    y=(volSim.heatPort.T - 20)
      /(if abs(volExa.heatPort.T - 20) < 1E-5 then 1 else (volExa.heatPort.T - 20)))
    "Relative error in the temperature difference"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Sources.FixedBoundary bou(redeclare package Medium = Medium, nPorts=2)
    "Fixed pressure boundary condition"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
equation
  connect(volSim.mWat_flow, mWatFlo.y) annotation (Line(points={{18,28},{18,28},
          {-16,28},{-16,80},{-39,80}}, color={0,0,127}));
  connect(volExa.mWat_flow, mWatFlo.y) annotation (Line(points={{18,-20},{18,
          -20},{-16,-20},{-16,80},{-39,80}},
                                        color={0,0,127}));
  connect(bou.ports[1], volSim.ports[1])
    annotation (Line(points={{70,2},{30,2},{30,10}}, color={0,127,255}));
  connect(bou.ports[2], volExa.ports[1]) annotation (Line(points={{70,-2},{66,-2},
          {66,-2},{58,-2},{58,-48},{30,-48},{30,-38}}, color={0,127,255}));
annotation (Documentation(
        info="<html>
<p>
This model validates the use of the mixing volume with adiabatic cooling.
Water in liquid form at room temperature is added to the volume,
which decreases its temperature.
The instance <code>volSim</code> uses a simplified implementation of the
mass balance that ignores the mass of the water added to the volume,
whereas the instance <code>volExa</code> uses the exact formulation.
The output of the instance <code>relErr</code>
shows that the relative error on the temperature difference between these
two options is less than <i>0.1%</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeAdiabaticCooling.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=10));
end MixingVolumeAdiabaticCooling;
