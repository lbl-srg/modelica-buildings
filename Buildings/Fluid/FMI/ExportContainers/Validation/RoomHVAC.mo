within Buildings.Fluid.FMI.ExportContainers.Validation;
model RoomHVAC
  "Validation model for connected single thermal zone and HVAC system"
 extends Modelica.Icons.Example;

  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone hvaCon(
    redeclare Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
      use_Q_flow_nominal=true,
      Q_flow_nominal=hvaCon.QCoiC_flow_nominal,
      T_a1_nominal=hvaCon.TWSup_nominal,
      T_a2_nominal=hvaCon.THeaRecLvg,
      w_a2_nominal=hvaCon.wHeaRecLvg,
      dp1_nominal=6000,
      dp2_nominal=200,
      show_T=true,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      allowFlowReversal1=hvaCon.allowFlowReversal,
      allowFlowReversal2=hvaCon.allowFlowReversal))
    "Block that encapsulates the HVAC system"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone rooCon
    "Block that encapsulates the thermal zone"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  BaseCase baseCase
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Examples.FMUs.HVACZones hvaCon2(
    redeclare Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
      use_Q_flow_nominal=true,
      Q_flow_nominal=hvaCon2.QCoiC_flow_nominal,
      T_a1_nominal=hvaCon2.TWSup_nominal,
      T_a2_nominal=hvaCon2.THeaRecLvg,
      w_a2_nominal=hvaCon2.wHeaRecLvg,
      dp1_nominal=6000,
      dp2_nominal=200,
      show_T=true,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      allowFlowReversal1=hvaCon2.allowFlowReversal,
      allowFlowReversal2=hvaCon2.allowFlowReversal),
    UA = 20E3,
    QRooInt_flow = 2000,
    fan2(constantMassFlowRate=0))
    "Block that encapsulates the HVAC system"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  TwoRooms rooCon2 "Model with two rooms" annotation (Placement(transformation(
          extent={{20,-40},{40,-20}})));

protected
    model BaseCase "Base case model used for the validation of the FMI interfaces"
    extends Buildings.Examples.Tutorial.SpaceCooling.System3(
      vol(energyDynamics=
      Modelica.Fluid.Types.Dynamics.FixedInitial),
      fan(nominalValuesDefineDefaultPressureCurve=true),
      hex(dp1_nominal=200 + 10,
          dp2_nominal=200 + 200));
    annotation (Documentation(info="<html>
<p>
This example is the base case model which is used to validate
the coupling of a convective thermal zone with an air-based HVAC system.
</p>
<p>
It is based on
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
and it assign some parameters to have the same configuration as
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone</a>.
</p>
<p>
The model which is validated using this model is
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC\">
Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC
</a>.
</p>
</html>"), Icon(graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-72,-14},{56,-24}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Ellipse(
            extent={{-56,-2},{-22,-36}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-72,190},{70,84}},
            textColor={0,0,255},
            textString="%name"),
          Polygon(
            points={{-28,-6},{-56,-18},{-28,-32},{-28,-6}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,54},{-20,32},{70,32},{26,54}},
            lineColor={95,95,95},
            smooth=Smooth.None,
            fillPattern=FillPattern.Solid,
            fillColor={95,95,95}),
          Rectangle(
            extent={{-12,32},{62,-30}},
            lineColor={150,150,150},
            fillPattern=FillPattern.Solid,
            fillColor={150,150,150}),
          Rectangle(
            extent={{-2,-4},{20,26}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{34,-4},{54,26}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,24},{-12,16}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Ellipse(
            extent={{-58,36},{-24,2}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-52,32},{-24,20},{-52,6},{-52,32}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
    end BaseCase;

  model TwoRooms "Model with two simple thermal zones, each having three air flow paths"
    extends
      Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZones;

    annotation (Documentation(info="<html>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZones\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZones</a>
to implement two simple thermal zones.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2016, by Thierry S. Nouidui:<br/>
Revised implementation.
</li>
<li>
September 14, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end TwoRooms;

equation

  connect(hvaCon.fluPor, rooCon.fluPor) annotation (Line(points={{-39.375,38.75},
          {19.375,38.75}},                                color={0,0,255}));
  connect(hvaCon2.fluPor, rooCon2.fluPor) annotation (Line(points={{-39.375,
          -22.3529},{-10,-22.3529},{-10,-21.25},{19.375,-21.25}},
                            color={0,0,255}));
  connect(rooCon.TRad, hvaCon.TRadZon) annotation (Line(points={{19.375,28.75},
          {-20,28.75},{-20,33.8125},{-39.3125,33.8125}}, color={0,0,127}));
  connect(rooCon2.TRad1, hvaCon2.TRadZon[1]) annotation (Line(points={{19.375,
          -30},{-20,-30},{-20,-26.9412},{-39.375,-26.9412}}, color={0,0,127}));
  connect(rooCon2.TRad2, hvaCon2.TRadZon[2]) annotation (Line(points={{19.375,
          -32.5},{-20,-32.5},{-20,-26.9412},{-39.375,-26.9412}}, color={0,0,127}));
    annotation (
    Documentation(info="<html>
<p>
This example validates the coupling of convective thermal zones with air-based HVAC systems.
The model has the following three parts:
<ul>
<li>
The block <code>baseCase</code> is the base case model, which is adapted from
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>
to have the same flow resistances as the models that are here validated.
</li>
<li>
The blocks <code>hvaCon</code> and <code>rooCon</code> are FMU containers
that contain an HVAC system for a single zone, and a thermal model of a single
zone. Both models have the same configuration as <code>baseCase</code>,
but they are implemented such that the HVAC system and the thermal zone
are in separate blocks.
These blocks could be exported as an FMU, but here they are connected to each
other to validate whether they indeed give the same response as the base case
<code>baseCase</code>.
</li>
<li>
The blocks <code>hvaCon2</code> and <code>rooCon2</code> are again containers
for HVAC and room models, but the models that they encapsulate are an HVAC system
that serves two rooms, and a model of two thermal zones.
Hence, this case tests whether the FMU containers for multiple HVAC systems, and
for multiple thermal zones, are implemented correctly.
</li>
</ul>
<p>
When the model is simulated, one sees that the air temperatures and the water
vapor mass fraction in all four room models are the same.
Note, however, that in Dymola 2017, the base case <code>basCas</code>
reaches in the last cooling cylce of the day not quite the set point, and hence
switches the cooling on time less than the other models.
We attribute this to numerical approximation errors that causes a slightly different
temperature trajectory.
With Dymola 2017, we obtain the trajectories shown below.
</p>
<p align=\"center\">
<img alt=\"Simulation results\" src=\"modelica://Buildings/Resources/Images/Fluid/FMI/ExportContainers/Validation/RoomConvectiveHVACConvective.png\" border=\"1\" />
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2021 by David Blum:<br/>
Use design conditions for UA parameterization in cooling coil.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Removed wrong usage of <code>each</code> keyword.
</li>
<li>
May 03, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/RoomHVAC.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=1.56384e+07, Tolerance=1e-7));
end RoomHVAC;
